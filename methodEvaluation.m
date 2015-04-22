methods = {'DSIFT', 'SF_GABOR', 'ST_GABOR', 'ST_GAUSS'};

%% User parameters

% Number of cells desired for the experiment
paramsCells.numCells = 20;

% Number of observations
numObservations  = 400;

% Number of queries and range of frames to consider
numQueries = 100;

% Flags

debugFlag = 0; % 0: No plots;
normFlag  = 0; % 0: No normalization

% BATCH

for i = 1:length(methods)
   method = methods{i};
   
   paramsDataset.descriptor = method;
   
   [locEstCorrected, queryLocations]= evaluateNeuralNet(paramsDataset, ...
       paramsQuery, paramsCells, paramsTraining, numObservations, numQueries, normFlag);
   
    subplot(2,2,i)
    plot(locEstCorrected/100, '.', 'MarkerSize', 15);
    hold on;
    plot(queryLocations/100,'.', 'MarkerSize', 15);
    ylabel('Position (m)');
    xlabel('Query frame index');
    legend([method ' Estimate'],'Ground Truth');
    
end