%
%
%

% User input file. Column 1 contains power data, the remaining columns
% contains thermal data for each cluster.
filein = '../input/eval_BPIFINAL_SAMPLE.csv';

%% LOAD DATA
disp('(1/9) Loading data...');
data = csvread(filein);
num_cores = size(data,2) - 1;

%% CAPTURE TRANSIENT TRACES
disp('(2/9) Finding transient states initial guess...');
reference_cluster = 2;         % reference core to find transients
gaussian_window_p = 80;        % tune this smoothening window size
filter_thresh_p = 100000000000; % tune sensitivity of finding peaks in data
transient_offset_l = 50;       % tune transient offset (left)
transient_offset_r = 150;      % tune transient offset (right)

transient_indices = transients_get_indices( ...
    data,reference_cluster,gaussian_window_p, filter_thresh_p,transient_offset_l, transient_offset_r);

while true
    disp(print_indices(transient_indices));
    visualize_indices(transient_indices, data, reference_cluster);
    num_traces = size(transient_indices,1)/2;
    status = input(['Confirm ' num2str(num_traces) ...
        ' transient states? [Y] Yes, [A] Add transient, [R] Remove transient [C] Change initial guess: '], 's');
    if status == 'Y'
        break
        
    elseif status == 'A'
        ind = input('Add base value of missing transients (refer to figure): ', 'S');
        ind = split(ind);
        for i = 1 : size(ind,1)
            transient_indices = [transient_indices; str2double(string(ind(i)));...
                str2double(string(ind(i)))+transient_offset_l+transient_offset_r];
        end
        
    elseif status == 'R'
        ind = input('Base value of extra transient (refer to figure): ', 'S');
        ind = split(ind);
        for i = 1 : size(ind,1)
            ind_t = find(transient_indices==str2double(string(ind(i))));
            transient_indices(ind_t) = []; transient_indices(ind_t) = [];
        end
        
    elseif status == 'C'
        ind = input(['Change [1] Transient detection sensitivity (' num2str(filter_thresh_p) ')' ...
            '[2] Degree of Gaussian smoothing (' num2str(gaussian_window_p) ')' ...
            '\n       [3] Left offset (' num2str(transient_offset_l) ')' ...
            '[4] Right offset (' num2str(transient_offset_r) '):\n']);
        if ind == 1
            ind = input(['Transient detection sensitivity (' num2str(filter_thresh_p) '): ']);
            filter_thresh_p = ind;
        elseif ind == 2
            ind = input(['Degree of Gaussian smoothing (' num2str(gaussian_window_p) '): ']);
            gaussian_window_p = ind;
        elseif ind == 3
            ind = input(['Left offset (' num2str(transient_offset_l) '): ']);
            transient_offset_l = ind;
        elseif ind == 4
            ind = input(['Right offset (' num2str(transient_offset_r) '): ']);
            transient_offset_l = ind;
        end
        transient_indices = transients_get_indices( ...
            data,reference_cluster,gaussian_window_p, filter_thresh_p,transient_offset_l, transient_offset_r);
    end
end
close all

%% SAVE TRANSIENT TRACES as .CSV
c = clock;
dir = [num2str(c(2)) '-' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %month-day_hour_min_sec
mkdir(['../output/' dir]);
disp(['(3/9) Generating ' num2str(num_traces) 'files for EM-BPI in ' pwd '..\output\' dir '...']);

% Generate transients for all cores
for i = 1 : num_cores 
    s(i).transients = transients_extract(data(:,1+i), transient_indices);
%     fname = sprintf('%s%d%s', pre_fname, i,'.csv');      
end

% Process one .csv for one transient state. Each file includes all cores' data
% i.e. Given 8 cores and 5 transient states, there should be 5
% transient_<i>.csv files, each containing 8 columns one for each core
for i = 1 : num_traces
    temp = [];
    for ii = 1 : num_cores
        temp = [temp s(ii).transients(:,i)];
    end
    fname_trans = sprintf('%s%d%s', 'transient_', i,'.csv');
    writematrix(temp, ['../output/' dir '/' fname_trans]);
end

%% BPI
%find matrix A : T[k]=AT[k-1]+Bp[k]
disp(['(4/9) BPI: Finding matrix A... ' datestr(now)]);
A = find_A(['../output/' dir '/transient_'], num_traces-1, 0, num_cores);

% find matrix B : T[k]=AT[k-1]+Bp[k]
disp(['(5/9) BPI: Finding initial B matrix... ' datestr(now)]);
R=(ones(num_cores,num_cores)+eye(num_cores,num_cores))/3;
B=(eye(num_cores,num_cores)-A)*R;

% TT matrix needed for the Maximization step
disp(['(6/9) BPI: TT matrix... ' datestr(now)]);
% E=csvread('865HDK_8cores/eval_BPIFINAL_ALL.csv'); delete line if works
E=csvread(filein);
T= E(:, 2:num_cores+1);
T=T/1000;
T=T';
TT = T(:,2:end)-A*T(:,1:end-1);

%% EM-Steps
disp(['(7/9) BPI: EM-Steps... ' datestr(now)]);
warning('off', 'optim:quadprog:HessianNotSym');
for i=1:num_cores
    disp(['Step ' num2str(i) '/' num2str(num_cores) ' ' datestr(now)]);
    p=eval_runtime(filein, A, B, num_cores);
    B=TT/p;
end

%% After finding the B matrix we detrmine the power of each cluster 
disp(['(8/9) BPI: determine power for each cluster... ' datestr(now)]);
p=eval_runtime(filein, A, B, num_cores);
p=p';
beep

%% Plot power per core
disp(['(9/9) Plotting power usage for all ' num2str(num_cores) ' cores...']);
f = plot_ncores(data, num_cores, p);

% save plot
print(f, ['../output/' dir '/Power_fig.png'], '-dpng', '-r300');
% if errors, make sure figure window is open

% save variables to save time from retraining
save(['../output/' dir '/variables.mat'], 'A', 'B', 'p', 'data', 'filein', 'transient_indices', 'num_cores');

