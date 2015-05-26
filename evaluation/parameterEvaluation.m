% THRESHOLD

%% Threshold impact on cell width and mean error
t = 2:2:12;

%% Setup default parameters
setupEvaluation;

%% Evaluate

[locEstCorrected, lenCellsMetres, meanErr] = thresholdEvaluation(t, paramsDataset, ...
                                             paramsQuery, paramsCells, paramsTraining); 
%% Mean error and cell width plot
figure;
plotThresholdEvaluation(t, lenCellsMetres, meanErr)

%% NUMBER OF CELLS