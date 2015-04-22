function [locEstCorrected, queryLocations, err] = ...
    evaluateNeuralNet(paramsDataset, paramsQuery, paramsCells, ...
            paramsTraining, numObservations, numQueries, normFlag)

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

cellPositions = linspace(sideSpanCm,...        % REVISE HERE THE STARTING AND END POINTS SIDESPAN/2
    corrLen -(sideSpanCm),paramsCells.numCells);

observations = linspace(sideSpanCm,...
    corrLen - (sideSpanCm), numObservations);

queryLocations = linspace(sideSpanCm,...
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

%% Evaluate

err = abs(locEstCorrected - queryLocations);
meanErr = mean(err);
% Conversion to metres
meanErr/100

end