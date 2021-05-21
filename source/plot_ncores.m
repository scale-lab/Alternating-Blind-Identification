
function f = plot_ncores(data, num_cores, p)
    % Plot thermal per cluster, total power, and power per cluster in three
    % subplots
    % :inputs:
    % data: original data from <filein>, contains power and thermal data
    % num_cores: int of number of cores
    % p: matrix result from BPI prediction
    f = gcf;
    f.WindowState = 'maximized';
    LineWidth=ones(1, num_cores);
    Colors = ['k','g','b','r','m','c','y',[.5 0 .5],[.3 .4 .2],[.85, .33,.1]];
    st=1;
    ed=length(data)-100;
    % Plotting thermal traces
    subplot(3,1,1);
    for i =1 : num_cores
        plot(data(st:ed,i+1)/1000,Colors(i), 'LineWidth',LineWidth(i))
        hold on
    end
    leg_temp = []; % form legend of variable length
    for i = 1 : num_cores
        leg_temp = [leg_temp ; 't_{' num2str(i) '}'];
    end
    leg_final=cell(1,num_cores);
    for i = 1 : num_cores
       leg_final{i} = leg_temp(i,:);
    end
    warning('off', 'MATLAB:legend:IgnoringExtraEntries');
    lgd=legend(leg_final,'Orientation','horizontal');
    lgd.FontSize = 14;
    lgd.Location='best';
    xlim([0 ed-st]);
    set(gca, 'fontsize', 16);
    ylabel('Temp. per core (\circC)','fontsize',18,'fontweight','normal')
    grid on

    h=10;

    for i = 1 : floor(size(data(:,1),1)/h)
        if(i < floor(size(data(:,1),1)/h))
            Power_avg((i-1)*h+1:i*h)=mean(data((i-1)*h+1:i*h,1));
        else
            Power_avg((i-1)*h+1:i*h-1)=mean(data((i-1)*h+1:i*h-1,1));
        end
    end

    % Plotting total power
    subplot(3,1,2);
    IDLE_POWER=1.1215;
    plot(Power_avg(st:ed)*12/1000-IDLE_POWER, 'LineWidth',2);
    ylabel('Total power (W)','fontsize',18,'fontweight','normal');
    ylim([0 max(max(Power_avg(:)))*12/1000+1]);
    % ylim([3 8])
    xlim([0 ed-st])
    %xlim([0 max(size(Power_avg(:)))])
    set(gca, 'fontsize', 16);
    grid on

    % Calculating and plotting the average power per core for more readability
    h=10;
    for i = 1 : floor(size(p,1)/h)
        if(i < floor(size(p,1)/h))
            for j=1:num_cores
                p_avg((i-1)*h+1:i*h,j)=mean(p((i-1)*h+1:i*h,j));
            end
        else
            for j=1:num_cores
                p_avg((i-1)*h+1:i*h-1,j)=mean(p((i-1)*h+1:i*h-1,j));
            end
        end
    end
    %p_avg=p;

    subplot(3,1,3);
    for i =1 : num_cores
        plot(p_avg(st:ed,i),Colors(i), 'LineWidth',LineWidth(i))
        hold on
    end
    leg_temp = []; % form legend of variable length
    for i = 1 : num_cores
        leg_temp = [leg_temp ; 'p_{' num2str(i) '}'];
    end
    leg_final=cell(1, num_cores);
    for i = 1 : num_cores
       leg_final{i} = leg_temp(i,:);
    end
    lgd=legend(leg_final,'Orientation','horizontal');
    lgd.FontSize = 14;
    lgd.Location='best';
    ylim([0 max(max(p_avg))]);
    xlim([0 ed-st]);
    %xlim([0 max(size(p))])
    xlabel('Timestamp','fontsize',18,'fontweight','normal');
    ylabel('Power per core (W)','fontsize',18,'fontweight','normal');
    set(gca, 'fontsize', 16);
    grid on
end