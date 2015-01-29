%% User parameters

% Load default parameters
setup;

% Number of cells desired for the experiment
paramsCells.numCells = 16;

% Number of queries and range of frames to consider
numQueries = 16;
startQueryFrame = 250;
endQueryFrame = 650;


debugFlag   = 1; % 0 = No plots;

%% Divide training testing and obtain locations where the place cells will be defined

% Of the 10 passes, 5 have been used for training, and the queries must be
% from one of the 5 remaining passes that have NOT been used for training.

% Get ground truth
[allGroundTruth, ~] = getGroundTruth(paramsDataset, paramsQuery, paramsDataset.passes);

% Load corridor length in centimetres.
corrLengths        = cellfun(@(x) max(x),allGroundTruth);
[corrLen shortest] = min(corrLengths); % The minimum length will be the final length of the corridor

cmPerFrame = corrLen/length(allGroundTruth{shortest});

sideSpanCm = paramsCells.sideSpan*cmPerFrame;

cellPositions = linspace(sideSpanCm,...                                 % REVISE HERE THE STARTING AND END POINTS SIDESPAN/2
    corrLen -(sideSpanCm),paramsCells.numCells);

% REVISE HERE, AS I'M TAKING THE MEAN AND NOT THE MULTIPLE TRAINING PASSES.
%% Neural net training input:

inputNN = neuralNetTrainingInput(paramsDataset, paramsTraining, paramsQuery, paramsCells, cellPositions, debugFlag);

%% Neural net target

target = neuralNetTarget(paramsDataset, paramsQuery, paramsTraining,...
    paramsCells, cellPositions);

%% Train the network

net = newgrnn(inputNN, target);


%% Neural net query

queryFrames = round(linspace(startQueryFrame,endQueryFrame,numQueries));
queryNN = neuralNetTestInput(paramsDataset, paramsTraining, paramsQuery, paramsCells, cellPositions, queryFrames, debugFlag);

%%  Test (simulate)

locEstimate = sim(net, queryNN);

%% Evaluation

% Ground truth
queryGt = [];

for i = 1:length(paramsTraining.querySet)
    
    for q = 1:length(queryFrames)
   
        gt(q,:) = allGroundTruth{paramsTraining.querySet(i)}(queryFrames(q)-paramsCells.sideSpan:queryFrames(q)+paramsCells.sideSpan-1) - ...
            allGroundTruth{paramsTraining.querySet(i)}(queryFrames(q));
    
    end
    queryGt = [queryGt reshape(gt',1,numel(gt))./100];
end


%%
figure
plot(locEstimate); hold on; plot(queryGt)
