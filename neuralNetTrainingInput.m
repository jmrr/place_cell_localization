function [inputNN, target] = neuralNetTrainingInput(observations, paramsDataset, paramsTraining, paramsQuery, paramsCells, cellLocations, normFlag)

% Declare inputNN

inputNN = [];


%% Get training kernels
queriesForTraining = paramsQuery;
trainingSet        = paramsTraining.trainingSet;
numTrainingPasses  = length(trainingSet);

trainingGt = getGroundTruth(paramsDataset,paramsQuery,trainingSet);


for i = 1:numTrainingPasses
    
    queriesForTraining.queryPass = trainingSet(i);
    [results] = getKernel(paramsDataset, paramsTraining, queriesForTraining);
    kernels = results.Kernel;
    
    [activations] = getActivationValues(observations, kernels, trainingGt, i, paramsTraining, paramsCells, cellLocations);
    
    inputNN = [inputNN activations];
    
end

% Thresholding

inputNN(inputNN <= paramsCells.threshold) = paramsCells.threshold;

% Normalization

if (normFlag)
    
    totalMax = max(inputNN(:));
    inputNN = (inputNN - paramsCells.threshold)/(totalMax - paramsCells.threshold);
    
end

%% Target

target = observations - observations(round(end/2));

target = repmat(target(1,:),1,numTrainingPasses);

%% Output

inputNN = double(inputNN);

%% Plots if debug

if paramsDataset.debug
    
    for k = 1:numTrainingPasses
        figure;
        hold on;
        for i = 1:length(cellLocations)
            startIdx = (k-1)*length(observations)+1;
            endIdx   = k*length(observations);
            smInput = smooth(inputNN(i,startIdx:endIdx),paramsCells.smoothFac);
            plot(target(startIdx:endIdx), smInput, 'LineWidth', 1.5);
            legStr{i} = ['chan ' num2str(i)];
        end
        axis tight;
        xlabel('Target: shifted ground truth location (cm)');
        ylabel('Thresholded chi2 score.');
        title(['Place cells responses to training observations on training pass ' num2str(k)]);
        legend(legStr);

    end
end

end % end function neuralNetInput