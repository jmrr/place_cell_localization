function [locEstCorrected, lenCellsMetres, meanErr] = thresholdEvaluation(t, ...
                                                      paramsDataset, paramsQuery, ...
                                                      paramsCells, paramsTraining)

numTrials      = length(t);
meanErr        = zeros(numTrials, 1);
lenCellsMetres = zeros(numTrials, 1);

for i = 1:numTrials
    paramsCells.threshold = t(i);
    [locEstCorrected, queryLocations, model, ~, meanErr(i)] = ...
    evaluateNeuralNet(paramsDataset, paramsQuery, paramsCells, ...
            paramsTraining); 
        
    %% avg length cell
    
    placeCells = model.Input;
    
    thresPlCells = placeCells > paramsCells.threshold;
    
    lenCells = sum(thresPlCells(:))/...
        (model.NumCells*length(paramsQuery.querySet)*length(paramsTraining.trainingSet));

    metresPerFrame = ((queryLocations(1)/(paramsCells.sideSpan))/100);
    lenCellsMetres(i) = lenCells*metresPerFrame;
end


end