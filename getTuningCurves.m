function [curves, varargout] = getTuningCurves(queryLoc, kernels, paramsDataset, ...
    paramsQuery, sideSpan, trainingSet)

numKernels = size(kernels,2);

[groundTruth, queryGt] = getGroundTruth(paramsDataset, paramsQuery, trainingSet);

posQueryLoc = queryGt(round(queryLoc));

[~, cellLocs]   = cellfun(@(x) min(abs(x-posQueryLoc)),groundTruth,'UniformOutput',0);

frameLocations = cell2mat(cellLocs);

if nargout > 1

    varargout{1} = frameLocations;
    
end

%% Extraction of  tuning curves

for i = 1:numKernels
    
    scores{i} = kernels{i}(:,frameLocations(i))'; % Get the vertical line 
                                                  % in the kernel
                                                  % corresponding to the
                                                  % g.t. location
end

lengthCurve = size(scores{1},2); % Length of query frames axis.

%% get curves with a fixed span around desired location

curves  = zeros(numKernels,sideSpan*2);

for i = 1:numKernels
    
    fr = round(queryLoc); % In  the tuning curve, take the centre frame as
                          % the one corresponding to the g.t. in the query
                          % frames axis.
    
    % Prevent tuning curve out of bounds
    
    [lowerBound, upperBound] = getBounds(fr, sideSpan, lengthCurve);
    
    c1 = scores{i}(lowerBound:fr);
    c2 = scores{i}(fr+1:upperBound);
    
    curves(i,:)  = [c1 c2];
    
end

end % end getTuningCurves