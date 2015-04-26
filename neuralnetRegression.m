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

%% Divide training testing and obtain locations where the place cells will be defined

% Of the 10 passes, paramsTraining.trainingSet have been used for creating the dictionary,
% and the queries must come from one, or more of the remaining passes that
% have NOT been used for creating the dictionary.

% Get ground truth
[allGroundTruth] = getGroundTruth(paramsDataset, paramsQuery, paramsDataset.passes);

% Load corridor length in centimetres.
corrLengths         = cellfun(@(x) max(x),allGroundTruth);
[corrLen, shortest] = min(corrLengths); % The minimum length will be the final length of the corridor

cmPerFrame = corrLen/length(allGroundTruth{shortest});

sideSpanCm = paramsCells.sideSpan*cmPerFrame;

cellPositions = linspace(sideSpanCm,...        % Position of place cells in cm
    corrLen -(sideSpanCm),paramsCells.numCells);

observations = linspace(sideSpanCm,...          % Position of training observations in cm
    corrLen - (sideSpanCm), numObservations);

queryLocations = linspace(sideSpanCm,...        % Position of queries used for testing
    corrLen - (sideSpanCm), numQueries);

% REVISE HERE, AS I'M TAKING THE MEAN AND NOT THE MULTIPLE TRAINING PASSES.
%% Neural net training input and target:

[inputNN, target] = neuralNetTrainingInput(observations, paramsDataset, paramsTraining, paramsQuery, paramsCells, cellPositions, normFlag);

%% Train the network

net = newgrnn(inputNN, target);


%% Neural net query

queryNN = neuralNetTestInput(paramsDataset, paramsTraining, paramsQuery, paramsCells, cellPositions, queryLocations, normFlag);

%%  Test (simulate)

locEstimate = sim(net, queryNN);

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
