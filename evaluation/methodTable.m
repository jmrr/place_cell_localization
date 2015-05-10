%  evaluation table for max() and neural net regressor
methods = {'SIFT', 'DSIFT', 'SF_GABOR', 'ST_GABOR', 'ST_GAUSS'};
corrSet = 1:6;
passSet = [4,6:10];

%% Initialize setup
initialize;
setup;

numMaxResponses = 40;
tic;

for i = 1:length(methods)
    for c = corrSet
        for p = passSet
            method = methods{i};
            paramsQuery.queryCorridor = c;
            paramsQuery.querySet = p;
            paramsDataset.descriptor = method;
            
            [~, ~, model, errNN, meanErrNN(i,c,p)] = evaluateNeuralNet(...
                paramsDataset, paramsQuery, paramsCells, paramsTraining);
            
            [~, ~, mr, errMax, meanErrMax(i,c,p)] = ...
                evaluateMaxMethod(paramsDataset, paramsQuery, paramsCells, ...
                paramsTraining, numMaxResponses);
            stdNN(i,c,p)  = std(errNN);
            stdMax(i,c,p) = std(errMax);
        end     
    end
end
toc