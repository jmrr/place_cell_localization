function [locEstCorrected, queryLocations, err] = ...
    evaluateNeuralNet(paramsDataset, paramsQuery, paramsCells, ...
            paramsTraining, numObservations, numQueries, normFlag)

%% Divide training testing and obtain locations where the place cells will be defined

[observations, ~, queryLocations] = locations(...
    paramsDataset, paramsCells, paramsQuery, numObservations, numQueries);

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