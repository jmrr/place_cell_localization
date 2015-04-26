function [locEstCorrected, queryLocations, err] = ...
    evaluateNeuralNet(paramsDataset, paramsQuery, paramsCells, ...
            paramsTraining)

% Neural network model

model = NeuralNetworkRegression;
model.setLocations(paramsDataset, paramsCells, paramsQuery)
model.nnTrainingInput(paramsDataset, paramsTraining, paramsQuery, paramsCells)
model.nnTestInput(paramsDataset, paramsTraining, paramsQuery, paramsCells)
model.train;

% Retrieve outputs from propagated model

locEstimate = model.propagate;        

%% Bring estimates and query ground truth to same magnitude, and do repmat if more than one query pass

locEstCorrected = locEstimate +  model.QueryLocations(round(end/2));

queryLocations = repmat(model.QueryLocations,1,length(paramsQuery.querySet));

%% Evaluate

err = abs(locEstCorrected - queryLocations);
meanErr = mean(err);
% Conversion to metres
meanErr/100

end