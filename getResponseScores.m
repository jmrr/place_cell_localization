function [scores, varargout] = getResponseScores(posQueryLoc, kernels, paramsDataset, ...
    paramsQuery, paramsCells trainingSet)

% numKernels = size(kernels,2);
% 
% [groundTruth, queryGt] = getGroundTruth(paramsDataset, paramsQuery, trainingSet);
% 
% [~, cellLocs]   = cellfun(@(x) min(abs(x-posQueryLoc)),groundTruth,'UniformOutput',0);
% 
% frameLocations = cell2mat(cellLocs);
% 
% if nargout > 1
% 
%     varargout{1} = frameLocations;
%     
% end



%% Extraction of  tuning curves

for i = 1:numKernels

    % Get the vertical line in the kernel corresponding to the  g.t. location AND
    % sideSpan*2 samples around it
    
    [lowerBound, upperBound] = getBounds(frameLocations(i), paramsCells.sideSpan, size(kernels{i},2))
    scores{i} = kernels{i}(:,lowerBound:upperBound)';                                  
end

% lengthCurve = size(scores{1},2); % Length of query frames axis.

% Convert to array
scores = cat(1,scores{:});

end