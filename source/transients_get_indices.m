
function [change_ind_trans] = transients_get_indices(data, cluster, gaus_window, filter_thresh, trans_offset_l, trans_offset_r)
% transient function to find indices of transient states
% :inputs:
% data : matrix of original data after alignment. thermal data for transients
% cluster : int - reference cluster to find transient indices
% gaus_window : int - hyperparam for gaussian filter window size
% filter_thresh : int - hyperparam for sensitivity when detecting sudden changes
% trans_offset : int - offset from index of sudden change for where the transient
%                   state will be captured
% :returns:
% change_ind_trans : list of indices, where every two indices signifies the
%                       interval to capture transient state from original
%                       data

    current_state = data(:,cluster);
    size_curr = size(current_state,1);
    xc = linspace(1, size_curr, size_curr);
    f = figure;
    subplot(2,1,1);
    plot(xc, current_state); title("Original Thermal Data");
    
    current_state_s = current_state;
    current_state_s = smoothdata(current_state, 'gaussian', gaus_window);

    change_trans = ischange(current_state_s, 'linear','Threshold',filter_thresh);
    change_ind_trans_temp = find(change_trans == 1);
    change_ind_trans = double.empty;

    % Comment out for loop if manually editing transient indices, but still
    % visualize plots.
    % edit change_ind_p in workspace if there are unwanted indices
    for i = 1 : size(change_ind_trans_temp,1) % apply offset to locations of sudden change
                                              % we assume power = 0, only take decreasing transients
        if (current_state_s(change_ind_trans_temp(i)+trans_offset_r) < ...
            current_state_s(change_ind_trans_temp(i)-trans_offset_l))
                change_ind_trans = [change_ind_trans; change_ind_trans_temp(i)-trans_offset_l; ...
                                change_ind_trans_temp(i)+trans_offset_r];
        end
    end

    subplot(2,1,2);
    plot(xc, current_state_s(:)); title("Filtered with Transient State Indices");
    hold on
    for i = 1 : size(change_ind_trans,1)            % visualize transient ranges
        xline(change_ind_trans(i), 'Color', 'r');   % interval of transient
    end
    for i = 1 : size(change_ind_trans_temp,1)
        xline(change_ind_trans_temp(i), 'Color', 'k');  % location of sudden change 
    end
%     b = uicontrol('Parent',f,'Style','slider','Position',[81,54,419,23],...
%               'value',filter_thresh, 'min',0, 'max',60000000000);
%     bgcolor = f.Color;
%     bl1 = uicontrol('Parent',f,'Style','text','Position',[50,54,23,23],...
%                     'String','0','BackgroundColor',bgcolor);
%     bl2 = uicontrol('Parent',f,'Style','text','Position',[500,54,23,23],...
%                     'String','1','BackgroundColor',bgcolor);
%     bl3 = uicontrol('Parent',f,'Style','text','Position',[240,25,100,23],...
%                     'String','Damping Ratio','BackgroundColor',bgcolor);
%     b.Callback = @(es,ed) updateSystem(); 
end