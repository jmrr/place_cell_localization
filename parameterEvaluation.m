t = 2:0.5:12;
setup;

for i = 1:length(t)
    paramsCells.threshold = t(i);
    [locEstCorrected, queryLocations, model, err, meanErr(i)] = ...
    evaluateNeuralNet(paramsDataset, paramsQuery, paramsCells, ...
            paramsTraining); 
        
    %% avg length cell
    
    placeCells = model.Input;
    
    thresPlCells = placeCells > paramsCells.threshold;
    
    lenCells = sum(thresPlCells(:))/...
        (model.NumCells*length(paramsQuery.querySet)*length(paramsTraining.trainingSet));
    %queryLocations(1) = sideSpanCm
    metresPerFrame = ((queryLocations(1)/(paramsCells.sideSpan))/100);
    lenCellsMetres(i) = lenCells*metresPerFrame;
end

%% Mean error and cell width plot
figure;
[hAx,hLine1,hLine2] = plotyy(t,lenCellsMetres,t,meanErr);
xlabel('Threshold value (\chi^2 score)')
ylabel(hAx(1), 'place cell width (m)')
ylabel(hAx(2), '|\epsilon| (m)')
legend('Avg. place cell width','Mean abs. error')
hLine1.LineWidth = 4;
hLine2.LineWidth = 4;
% set(hAx(1),'YTick',0:2:16)
% set(hAx(2),'YTick',0:2:16)