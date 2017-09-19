function gui_plot_freq(h,name)
    ax=figure;    hold on; %stiffness figure
    ax.Name = [name,' >> Natural Frequency'];
    
    % STAGE 0
    x=[1:6]-.1;
    y=h.stage0.results.Freq';
%     y_ub = h.ub_freq-y;
%     y_lb = y-h.lb_freq;
    plot(x,y,'o');
    leg = "initial";
    
    for i=1:h.N
        x=[1:6]+.1*(i-1);
        y=h.stage(i).results.Freq
        y_ub = h.stage(i).ub_freq-y
        y_lb = y-h.stage(i).lb_freq
        errorbar(x,y,y_lb,y_ub,'o');
        leg = [leg;string(['Stage ',num2str(i),' >> ',h.stage(i).type])];
    end
    
    ylim([0 30])
    xlim([0 7])
    
    xticks([1 2 3 4 5 6])
    xticklabels({'Longitudinal','Lateral','Bounce','Roll','Pitch','Yaw'})    
    xtickangle(45)
    legend(leg);
end