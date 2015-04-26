function [locEstimate, queryLocations] = neuralNetRegression(paramsDataset,...
            paramsTraining, paramsCells, paramsQuery, ...
            numObservations, numQueries, normFlag)

%% Divide training testing and obtain locations where the place cells will be defined

[observations, cellLocations, queryLocations] = locations(...
    paramsDataset, paramsCells, paramsQuery, numObservations, numQueries);

% REVISE HERE, AS I'M TAKING THE MEAN AND NOT THE MULTIPLE TRAINING PASSES.
%% Neural net training input and target:

[inputNN, target] = neuralNetTrainingInput(paramsDataset, paramsTraining, paramsQuery, paramsCells, observations, cellLocations, normFlag);

%% Train the network

net = newgrnn(inputNN, target);

%% Neural net query

queryNN = neuralNetTestInput(paramsDataset, paramsTraining, paramsQuery, paramsCells, cellLocations, queryLocations, normFlag);

%%  Test (simulate)

locEstimate = sim(net, queryNN);

