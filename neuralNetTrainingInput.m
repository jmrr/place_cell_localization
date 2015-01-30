function [inputNN, target] = neuralNetTrainingInput(observations, paramsDataset, paramsTraining, paramsQuery, paramsCells, cellLocations, debug)

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

target = observations - observations(round(end/2));

target = repmat(target(1,:),1,numTrainingPasses);

end % end function neuralNetInput