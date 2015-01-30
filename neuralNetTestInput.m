function [testInputNN] = neuralNetTestInput(paramsDataset, paramsTraining, paramsQuery, paramsCells, cellPositions, queryLocations, debug)

testInputNN = [];

%% Get training kernels
trainingSet     = paramsTraining.trainingSet;
querySet        = paramsQuery.querySet;
numQueryPasses  = length(querySet);

trainingGt = getGroundTruth(paramsDataset, paramsQuery, trainingSet);
queryGt = getGroundTruth(paramsDataset, paramsQuery, querySet);

for i = 1:numQueryPasses %% CHANGE FOR ALL TRAINING PASSES
    
    paramsQuery.queryPass = querySet(i);
    [results] = getKernel(paramsDataset, paramsTraining, paramsQuery);
    kernels = results.Kernel;
    
    for k = 1:length(kernels)
        cellFrames = frameFromGroundTruth(trainingGt{k}, cellPositions);
        queryFrames = frameFromGroundTruth(queryGt{i}, queryLocations); 
        
        activations{k} = kernels{k}(queryFrames, cellFrames)';
    end
    
    % Activations. For now taking the mean after the normalization takes place.
    normCurves  = cellfun(@(x) normalizeCells(x, paramsCells, paramsCells.threshold),activations,'UniformOutput',0);
    normCurves  = cat(3,normCurves{:});
    
    activations = squeeze(mean(normCurves,3));
    
    testInputNN = [testInputNN activations];
end


end % end function neuralNetInput