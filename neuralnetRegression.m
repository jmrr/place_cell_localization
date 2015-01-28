%% User parameters

% Load default parameters
setup;

% Number of cells desired for the experiment
paramsCells.numCells = 16;




%% Divide training testing

% Leave one out for now, so can use old code.
% Of the 10 passes, 5 have been used for training, and the queries must be
% from one of the 5 remaining passes that have NOT been used for training.

% Get ground truth
[trainingGt, queryGt] = getGroundTruth(paramsDataset, queriesForTraining, paramsTraining.trainingSet);

% Load corridor length in centimetres.
corrLen       = queryGt(end); % Length in centimetres
numFramesCorr = length(queryGt); % Number of frames corridor

cellIntervals = linspace(0,corrLen,paramsCells.numCells);

cellPositions = linspace(paramsCells.sideSpan,numFramesCorr-paramsCells.sideSpan,paramsCells.numCells);

% REVISE HERE, AS I'M TAKING THE MEAN AND NOT THE MULTIPLE TRAINING PASSES.
%% Neural net input:

inputNN = getNeuralNetInput(paramsDataset, paramsQuery, paramsCells, kernels, trainingSet, cellPositions, 1);


%% Neural net target

target = queryGt(round(cellPositions))';

%% Train the network

net = newgrnn(inputNN, target);


%% Neural net query

[results, trainingSet] = getKernel(paramsDataset, paramsTraining, paramsQuery);
queryKernels = results.Kernel;

queryNN = getNeuralNetInput(paramsDataset, paramsQuery, paramsCells, queryKernels, trainingSet, cellPositions, 1);

locEstimate = sim(net, queryNN);


%%  Test (simulate)

locEstimate = sim(net, queryNN);
