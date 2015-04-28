t = 0:0.5:10;
setup;

for i = 1:length(t)
    paramsCells.threshold = t(i)
    [locEstCorrected, queryLocations, model, err, meanErr(i)] = ...
    evaluateNeuralNet(paramsDataset, paramsQuery, paramsCells, ...
            paramsTraining); 
        
    %% avg length cell
    
    placeCells = model.Input;
    
    thresPlCells = placeCells > paramsCells.threshold;
    
    lenCells = sum(thresPlCells(:))/(model.NumCells*length(paramsQuery.querySet)*length(paramsTraining.trainingSet))
    %queryLocations(1) = sideSpanCm
    metresPerFrame = ((queryLocations(1)/(paramsCells.sideSpan))/100)
    lenCellsMetres(i) = lenCells*metresPerFrame;
end

%%
figure;
len2 = lenCellsMetres-lenCellsMetres/2;
plotyy(t,meanErr,t,len2)
xlabel('Threshold value')
ylabel('meters')
legend('mean abs. error', 'mean place cell width')