%  evaluation
methods = {'DSIFT', 'SF_GABOR', 'ST_GABOR', 'ST_GAUSS'};

numCells = 5:50;

%% Initialize setup
initialize;
setupEvaluation;

numMaxResponses = 40;
tic;

for i = 1
    for c = 1:length(numCells)
        method = methods{i};
        paramsDataset.descriptor = method;
        paramsCells.numCells = numCells(c);
        [~, ~, model, errNN, meanErrNN(i,c)] = evaluateNeuralNet(...
            paramsDataset, paramsQuery, paramsCells, paramsTraining);
        
        [~, ~, mr, errMax, meanErrMax(i,c)] = ...
            evaluateMaxMethod(paramsDataset, paramsQuery, paramsCells, ...
            paramsTraining, numMaxResponses);
        stdNN(i,c)  = std(errNN);
        stdMax(i,c) = std(errMax);
    end
end
toc