function [inputNN, target, exampleFrames] = neuralNetTrainingInput(paramsDataset, paramsTraining, paramsQuery, paramsCells, cellLocations, debug)

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
    
    [activations exampleLocs, exampleFrames] = getActivationValues(kernels, trainingGt, i, paramsTraining, paramsCells, cellLocations);
    
    inputNN = [inputNN activations]; 
   
end

cellLocsMat = repmat(cellLocations', 1, paramsTraining.numExamplesPerCell);

temp = exampleLocs - cellLocsMat;

target = repmat(temp(1,:),1,numTrainingPasses);

end % end function neuralNetInput