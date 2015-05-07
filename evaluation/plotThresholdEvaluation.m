function [] = plotThresholdEvaluation(t, lenCellsMetres, meanErr)

    [hAx,hLine1,hLine2] = plotyy(t,lenCellsMetres,t,meanErr);
    xlabel('Threshold value (\chi^2 score)')
    ylabel(hAx(1), 'APC width (m)')
    ylabel(hAx(2), '|\epsilon| (m)')
    legend('Avg. APC width','Mean abs. error')
    hLine1.LineWidth = 4;
    hLine2.LineWidth = 4;
    axis('tight');
    % set(hAx(1),'YTick',0:2:16)
    % set(hAx(2),'YTick',0:2:16)
    
end