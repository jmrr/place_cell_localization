function [testInputNN] = neuralNetTestInput(paramsDataset, paramsTraining, paramsQuery, paramsCells, cellPositions, queryFrames, exampleFrames, debug)

testInputNN = [];

%% Get training kernels
trainingSet     = paramsTraining.trainingSet;
querySet        = paramsQuery.querySet;
numQueryPasses  = length(querySet);

for i = 1:numQueryPasses %% CHANGE FOR ALL TRAINING PASSES
    
    paramsQuery.queryPass = querySet(i);
    [results] = getKernel(paramsDataset, paramsTraining, paramsQuery);
    kernels = results.Kernel;
    
    for k = 1:length(kernels)
        for c = 1:length(cellPositions)
            for q = 1:length(queryFrames)
                act(q,:,k,i) = kernels{k}(queryFrames(q),exampleFrames{k}(c,round(length(cellPositions)/2)));
                activation{c} = act;
            end
        end
    end
    
end

testInputNN = activation;

end % end function neuralNetInput