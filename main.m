% Place cell neural net regression main script

%% User parameters

% Load default parameters
setup;

%% Neural network model

% model = NeuralNetworkRegression;
model = NeuralNetworkRegression(16, 200, 400, 2);
model.setLocations(paramsDataset, paramsCells, paramsQuery)
model.nnTrainingInput(paramsDataset, paramsTraining, paramsQuery, paramsCells)
model.nnTestInput(paramsDataset, paramsTraining, paramsQuery, paramsCells)
model.train;
% Plot all tuning curves
figure;model.plotTuningCurves(paramsCells, paramsDataset, paramsQuery, paramsTraining)

% Retrieve outputs from propagated model

locEstimate = model.propagate;

%% Bring estimates and query ground truth to same magnitude, and do repmat if more than one query pass

locEstCorrected = correctLocEstimates(locEstimate, model);

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
fprintf('Mean error in m')
meanErr/100

%Plot
if(paramsDataset.debug)
    figure
    plot(err/100,':o')
    ylabel('Absolute positional error (m)');
    xlabel('Query frame index');
end

%% Max

mr = MaxResponse(40, 200, 400, 0);
mr.setLocations(paramsDataset, paramsCells, paramsQuery)
mr.nnTestInput(paramsDataset, paramsTraining, paramsQuery, paramsCells)
locEstimate = mr.getMaxResponse(paramsDataset, paramsTraining, paramsQuery);

%Evaluate 

queryLocations = repmat(mr.QueryLocations,1,length(paramsQuery.querySet));


% Plots (with conversion to metres)
if(paramsDataset.debug)
    figure
    plot(locEstimate/100, '.', 'MarkerSize', 15);
    hold on;
    plot(queryLocations/100,'.', 'MarkerSize', 15);
    ylabel('Position (m)');
    xlabel('Query frame index');
    legend('Location Estimate','Ground Truth');
end


err = abs(locEstimate - queryLocations);
meanErr = mean(err);
% Conversion to metres
fprintf('Mean error in m')
meanErr/100

%Plot
if(paramsDataset.debug)
    figure
    plot(err/100,':o')
    ylabel('Absolute positional error (m)');
    xlabel('Query frame index');
end
