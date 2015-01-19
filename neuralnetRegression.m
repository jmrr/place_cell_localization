%% User parameters

% Load default parameters
setup;

% Number of cells desired for the experiment
paramsCells.numCells = 8;


%% Get kernels
[results, trainingSet] = getKernel(paramsDataset, paramsQuery);

kernels = results.Kernel;

%% Divide training testing

% Leave one out for now, so can use old code.

% Get ground truth
[trainingGt, queryGt] = getGroundTruth(paramsDataset, paramsQuery, trainingSet);

% Load corridor length in centimetres.
corrLen       = queryGt(end); % Length in centimetres
numFramesCorr = length(queryGt); % Number of frames corridor

cellIntervals = linspace(0,corrLen,paramsCells.numCells);

cellPositions = linspace(paramsCells.sideSpan,numFramesCorr-paramsCells.sideSpan,paramsCells.numCells);

%% Get curves for the place fields. This means getting a curve centred at the position
% given for the cell spacing for each pass in the training set

dbPassesCellLocs = zeros(paramsCells.numCells, length(kernels));

for i = 1: paramsCells.numCells % Num of samples, or queries in the experiment. IN THIS CASE FIRST PARAMETER SHOULD BE PLACE CELL LOC
    
    [curves{i}, dbPassesCellLocs(i,:)] = getTuningCurves(cellPositions(i), ...
        kernels, paramsDataset, paramsQuery,...
        paramsCells.sideSpan, trainingSet);
end

%% Prepare data for neural net

input = zeros(8,8*9);

for i = 1:paramsCells.numCells
   
    
    
    
end

