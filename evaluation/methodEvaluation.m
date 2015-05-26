%  evaluation
methods = {'DSIFT', 'SF_GABOR', 'ST_GABOR', 'ST_GAUSS'};

%% Initialize setup
setupEvaluation;

%% User parameters

model = NeuralNetworkRegression;

% BATCH

for i = 1:length(methods)
   method = methods{i};
   
   paramsDataset.descriptor = method;
   
   [locEstCorrected, queryLocations, model, err, meanErr(i)] = evaluateNeuralNet(...
       paramsDataset, paramsQuery, paramsCells, paramsTraining);
   
    subplot(2,2,i)
    plot(locEstCorrected/100, '.', 'MarkerSize', 15);
    hold on;
    plot(queryLocations/100,'.', 'MarkerSize', 15);
    ylabel('Position (m)');
    xlabel('Query frame index');
    legend([method ' Estimate'],'Ground Truth');
    
end