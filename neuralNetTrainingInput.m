function [inputNN, target] = neuralNetTrainingInput(paramsDataset, paramsTraining, paramsQuery, paramsCells, observations, cellLocations, normFlag)
% NEURALNETTRAININGINPUT constructs the RxQ matrix of input vectos and SxQ
% matrix of target vectors for the training of a generalized regression
% neural network.
%
% Inputs: 
%   - parameters: paramsX, X: [Dataset, Training, Query, Cells]
%   - observations: vector of N observation locations. R = Q if only one
%   group of examples, otherwise R = N x m, where m is the number of examples. i.e.,
%   number of training passes.
%   - cellLocations: vector of R place cell locations
%   - normFlag: normalization flag (experimental)
%
% Outputs:
%   - inputNN: RxQ matrix of Q input vectors "training activations"
%   - target: SxQ matrix of Q target vectors
%
% See also NEWGRNN, NEURALNETTESTINPUT

% Authors: Jose Rivera-Rubio
%          {jose.rivera}@imperial.ac.uk
% Date: April, 2015
% Declare inputNN

inputNN = [];


%% Get training kernels
queriesForTraining = paramsQuery; % Copying the paramsQuery struct  but reuising it to retrieve the NN training kernels.
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

target = observations - observations(round(end/2)); % Observations locations to be restricted between +/- lastObservation/2
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

end % end function neuralNetTrainingInput