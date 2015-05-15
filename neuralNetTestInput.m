function [testInputNN] = neuralNetTestInput(paramsDataset, paramsTraining, paramsQuery, paramsCells, cellLocations, queryLocations, normFlag)
% NEURALNETESTINPUT constructs the RxT matrix of query vectors for the propagation of a generalized regression
% neural network.
%
% Inputs: 
%   - parameters: paramsX, X: [Dataset, Training, Query, Cells]
%   - cellLocations: vector of L place cell locations
%   - queryLocations: vector of M query locations.
%   - normFlag: normalization flag (experimental)
%
% Output:
%   - testInputNN: RxT matrix of T query vectors, or "activations"
%
% See also NEWGRNN, NEURALNETTRAININGINPUT


testInputNN = [];

%% Get training kernels
trainingSet     = paramsTraining.trainingSet;
querySet        = paramsQuery.querySet;
numQueryPasses  = length(querySet);

trainingGt = getGroundTruth(paramsDataset, paramsQuery, trainingSet);
queryGt = getGroundTruth(paramsDataset, paramsQuery, querySet);

for i = 1:numQueryPasses 
    activations = [];
    paramsQuery.queryPass = querySet(i);
    [results] = getKernel(paramsDataset, paramsTraining, paramsQuery);
    kernels = results.Kernel;
    
    queryFrames = frameFromGroundTruth(queryGt{i}, queryLocations);
    
    for k = 1:length(kernels)
        cellFrames  = frameFromGroundTruth(trainingGt{k}, cellLocations);
        activations{k} = kernels{k}(queryFrames, cellFrames)';
    end
    
    % Activations. For now taking the mean after the normalization takes place.
    %     normCurves  = cellfun(@(x) normalizeCells(x, paramsCells, paramsCells.threshold),activations,'UniformOutput',0);
    %     normCurves  = cat(3,normCurves{:});
    
    activations = cat(3,activations{:});
    activations = squeeze(mean(activations,3));
    
    testInputNN = [testInputNN activations];
end

testInputNN = double(testInputNN);

%% Normalization/thresholding/scaling

if (~normFlag)
    % Thresholding
    testInputNN(testInputNN <= paramsCells.threshold) = paramsCells.threshold;
elseif (normFlag == 1)
    % Thresholding and scaling
    testInputNN(testInputNN <= paramsCells.threshold) = paramsCells.threshold;
    totalMax = max(testInputNN(:));
    testInputNN = testInputNN./totalMax;
elseif (normFlag > 1)
    % [0-1] normalization
    totalMax = max(testInputNN(:));
    testInputNN = (testInputNN - paramsCells.threshold)/(totalMax - paramsCells.threshold);
end

end % end function neuralNetTestInput