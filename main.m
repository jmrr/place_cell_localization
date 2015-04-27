% Place cell neural net regression main script

%% User parameters

% Load default parameters
setup;

%% Neural network model

% model = NeuralNetworkRegression;
model = NeuralNetworkRegression(16, 400, 100, 0);
model.setLocations(paramsDataset, paramsCells, paramsQuery)
model.nnTrainingInput(paramsDataset, paramsTraining, paramsQuery, paramsCells)
model.nnTestInput(paramsDataset, paramsTraining, paramsQuery, paramsCells)
model.train;

% Retrieve outputs from propagated model

locEstimate = model.propagate;

%% Bring estimates and query ground truth to same magnitude, and do repmat if more than one query pass

locEstCorrected = locEstimate +  model.QueryLocations(round(end/2));

queryLocations = repmat(model.QueryLocations,1,length(paramsQuery.querySet));

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
