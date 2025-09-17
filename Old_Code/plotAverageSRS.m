function plotAverageSRS(filename)

    [CH_f,CH_X_avg,CH_Y_avg,CH_Z_avg] = loadSRSDataFile(filename)

    % Create figure
    figure('OuterPosition',[-971 -117.4 703.2 916]);
    
    % Create axes
    axes1 = axes;
    hold(axes1,'on');
    
    loglog(CH_f,CH_X_avg,'LineWidth',2,'DisplayName','X axis',...
        'Color',[0.0745098039215686 0.623529411764706 1]);
    loglog(CH_f,CH_Y_avg,'LineWidth',2,'DisplayName','Y axis',...
        'Color',[1 0.411764705882353 0.16078431372549]);
    loglog(CH_f,CH_Z_avg,'LineWidth',2,'DisplayName','Z axis',...
        'Color',[0.392156862745098 0.831372549019608 0.0745098039215686]);
    
    % Plot the spec SRS + tolerance bands
    
    spec_freq = [100,1000,10000];
    spec_SRS = [10,350,350];
    
    loglog(spec_freq,spec_SRS,'k','linewidth',1,'DisplayName','Target');
    %  loglog(spec_freq,spec_SRS*sqrt(2),'--g','linewidth',2)
    loglog(spec_freq,spec_SRS/sqrt(2),'-.k','linewidth',1,'DisplayName','-3 dB','LineStyle','-.');
    loglog(spec_freq,spec_SRS*2,'--k','linewidth',1,'DisplayName','+6 dB','LineStyle','--');
    
    % Create zlabel
    zlabel('ZLabel');
    
    % Create ylabel
    ylabel({'Peak Acceleration (g)'},'HorizontalAlignment','center');
    
    % Create xlabel
    xlabel({'Frequency (Hz)'},'HorizontalAlignment','center');
    
    % Create title
    title('Acceleration Shock Response Spectrum Q=10',...
        'HorizontalAlignment','center',...
        'FontWeight','bold');
    
    % Uncomment the following line to preserve the X-limits of the axes
    xlim(axes1,[100 10000]);
    % Uncomment the following line to preserve the Y-limits of the axes
    ylim(axes1,[1 10000]);
    grid(axes1,'on');
    hold(axes1,'off');
    % Set the remaining axes properties
    set(axes1,'GridLineStyle',':','MinorGridLineStyle','--','XMinorTick','on',...
        'XScale','log','YMinorTick','on','YScale','log');
    % Create legend
    legend(axes1,'show');
    
    disp([filename,'_SRS_avg.png']);
    saveas(gcf,strcat(filename,'_SRS_avg.png'),'png');
end




