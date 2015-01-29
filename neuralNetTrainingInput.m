function [inputNN] = neuralNetTrainingInput(paramsDataset, paramsTraining, paramsQuery, paramsCells, queryLocs, debug)

% Declare inputNN

inputNN = [];

%% Get training kernels
queriesForTraining = paramsQuery;
trainingSet        = paramsTraining.trainingSet;
numTrainingPasses  = length(trainingSet);

for i = 1:numTrainingPasses
    
    queriesForTraining.queryPass = trainingSet(i);
    [results] = getKernel(paramsDataset, paramsTraining, queriesForTraining);
    kernels = results.Kernel;
    
    %% Compute tuning curves for the whole length of the corridor
    
    for c = 1:length(queryLocs)
        
        [scores{c} frameLocations{c}] = getResponseScores(queryLocs(c), kernels, paramsDataset, ...
            queriesForTraining, trainingSet);
        
    end
    
    normCurves = cellfun(@(x,y) normalizeCells(x, paramsCells, paramsCells.threshold),scores,'UniformOutput',0);
    
    meanNormCurves = cellfun(@mean, normCurves,'UniformOutput',0);
    
    completeTuningCurves = cat(1,meanNormCurves{:});
    
    if (debug)
        figure;
        for idx = 1:size(completeTuningCurves,1)
            
            plot(completeTuningCurves(idx,:),'LineWidth',2.5);
            hold on
            
        end
    end
    
    %% Retrieve cell (sensors) responses
    
    for c = 1:length(frameLocations)
        
        lengthCurve = size(completeTuningCurves,2);
        
        [lowerBound, upperBound] = getBounds(frameLocations{c}(i), ... % frameLocations{c}(i) denotes the position corresponding to the ground truth in the
            paramsCells.sideSpan, lengthCurve);                         % complete response of the training pass.
        
        cells{c} = completeTuningCurves(:,lowerBound:upperBound);
        
    end
    
    inputNN = [inputNN cat(2,cells{:})];
    
end


end % end function neuralNetInput