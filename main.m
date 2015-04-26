% Place cell neural net regression main script

%% User parameters

% Load default parameters
setup;

% Number of cells desired for the experiment
paramsCells.numCells = 20; % 40 % 16

% Number of observations
numObservations  = 400;

% Number of queries and range of frames to consider
numQueries = 100 ; % 100

% Flags

debugFlag = 1; % 0: No plots;
normFlag  = 0; % 0: No normalization
paramsDataset.debug = debugFlag;

%% Neural network model

[locEstimate, queryLocations] = neuralNetRegression(paramsDataset, paramsTraining, paramsCells, paramsQuery, ...
            numObservations, numQueries, normFlag);

%% Bring estimates and query ground truth to same magnitude, and do repmat if more than one query pass

locEstCorrected = locEstimate +  queryLocations(round(end/2));

queryLocations = repmat(queryLocations,1,length(paramsQuery.querySet));

%% Plots (with conversion to metres)
if(paramsDataset.debug)
    figure
    plot(locEstCorrected/100, '.', 'MarkerSize', 15);
    hold on;
    plot(queryLocations/100,'.', 'MarkerSize', 15);
    ylabel('Position (m)');
    xlabel('Query frame index');
    legend('Location Estimate','Ground Truth');
end

%% Evaluate

err = abs(locEstCorrected - queryLocations);
meanErr = mean(err);
% Conversion to metres
meanErr/100

%Plot
if(paramsDataset.debug)
    figure
    plot(err/100,':o')
    ylabel('Absolute positional error (m)');
    xlabel('Query frame index');
end
