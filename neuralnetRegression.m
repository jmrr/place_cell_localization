%% User parameters

% Load default parameters
setup;

% Number of cells desired for the experiment
paramsCells.numCells = 16;

% Number of observations
numObservations  = 100;

% Number of queries and range of frames to consider
numQueries = 30;
startQueryFrame = 200;
endQueryFrame = 700;

% Flags

debugFlag = 1; % 0: No plots;
normFlag  = 1; % 0: No normalization

%% Divide training testing and obtain locations where the place cells will be defined

% Of the 10 passes, 5 have been used for training, and the queries must be
% from one of the 5 remaining passes that have NOT been used for training.

% Get ground truth
[allGroundTruth] = getGroundTruth(paramsDataset, paramsQuery, paramsDataset.passes);

% Load corridor length in centimetres.
corrLengths        = cellfun(@(x) max(x),allGroundTruth);
[corrLen, shortest] = min(corrLengths); % The minimum length will be the final length of the corridor

cmPerFrame = corrLen/length(allGroundTruth{shortest});

sideSpanCm = paramsCells.sideSpan*cmPerFrame;

cellPositions = linspace(sideSpanCm,...                                 % REVISE HERE THE STARTING AND END POINTS SIDESPAN/2
    corrLen -(sideSpanCm),paramsCells.numCells);

observations = linspace(sideSpanCm,...
    corrLen - (sideSpanCm),numObservations);

queryLocations = linspace(sideSpanCm,...
    corrLen - (sideSpanCm),numQueries);

% REVISE HERE, AS I'M TAKING THE MEAN AND NOT THE MULTIPLE TRAINING PASSES.
%% Neural net training input:

[inputNN, target] = neuralNetTrainingInput(observations, paramsDataset, paramsTraining, paramsQuery, paramsCells, cellPositions, debugFlag);

%% Neural net target
% 
% target = neuralNetTarget(paramsDataset, paramsQuery, paramsTraining,...
%     paramsCells, cellPositions, normFlag);

%% Train the network

net = newgrnn(inputNN, target);


%% Neural net query

% queryFrames = round(linspace(startQueryFrame,endQueryFrame,numQueries));
queryNN = neuralNetTestInput(paramsDataset, paramsTraining, paramsQuery, paramsCells, cellPositions, queryLocations, debugFlag);

%%  Test (simulate)

locEstimate = sim(net, queryNN);

%% Query ground truth

% queryGt = getQueryGroundTruth(paramsTraining, paramsCells, queryFrames, allGroundTruth, normFlag);

%% Plots
figure
plot(locEstimate); hold on; plot(queryGt)

%% Evaluate

err = abs(locEstimate - queryGt);

meanErr = mean(err);