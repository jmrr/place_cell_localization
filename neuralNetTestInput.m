function [testInputNN] = neuralNetTestInput(paramsDataset, paramsTraining, paramsQuery, paramsCells, cellPositions, queryFrames, debug)

testInputNN = [];

%% Get training kernels
trainingSet     = paramsTraining.trainingSet;
querySet        = paramsTraining.querySet;
numQueryPasses  = length(querySet);

for i = 1:numQueryPasses %% CHANGE FOR ALL TRAINING PASSES
    
    paramsQuery.queryPass = querySet(i);
    [results] = getKernel(paramsDataset, paramsTraining, paramsQuery);
    kernels = results.Kernel;
    
    %% Compute tuning curves for the whole length of the corridor
    
    for c = 1:length(cellPositions)
        
        [scores{c}, ~] = getResponseScores(cellPositions(c), kernels, paramsDataset, ...
            paramsQuery, trainingSet);
        
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
    
    for c = 1:length(queryFrames)
        
        lengthCurve = size(completeTuningCurves,2);
        
        [lowerBound, upperBound] = getBounds(queryFrames(c), ... % frameLocations{c}(i) denotes the position corresponding to the ground truth in the
            paramsCells.sideSpan, lengthCurve);                         % complete response of the training pass.
        
        cells{c} = completeTuningCurves(:,lowerBound:upperBound);
        
    end
    
testInputNN = [testInputNN cat(2,cells{:})];

end


end % end function neuralNetInput