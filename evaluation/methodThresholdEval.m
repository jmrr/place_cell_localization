%  evaluation
% Methods
methods = {'SIFT','DSIFT', 'SF_GABOR', 'ST_GABOR', 'ST_GAUSS'};
% Threshold
t = 2:0.5:12;

%% Initialize setup
setup;

%% User parameters

model = NeuralNetworkRegression;

% BATCH

for m = 1:length(methods)
    
    method = methods{m};
    
    paramsDataset.descriptor = method;   
    
    [locEstCorrected, lenCellsMetres, meanErr] = thresholdEvaluation(t, paramsDataset, ...
        paramsQuery, paramsCells, paramsTraining);

    %% Mean error and cell width plot
    subplot(length(methods), 1, m) ;
    plotThresholdEvaluation(t, lenCellsMetres, meanErr)
    title(method)
end