function [curves, varargout] = getTuningCurves(queryLoc, kernels, paramsDataset, ...
    paramsQuery, sideSpan, trainingSet)

numKernels = size(kernels,2);
groundTruthStr = 'ground_truth_C%d_P%d.csv';

% Get training ground truth
j = 1;

for i = trainingSet
    gtFname = sprintf(groundTruthStr,paramsQuery.queryCorridor,i);
    groundTruth{j} = csvread(fullfile(paramsDataset.groundTruthPath,gtFname),1,1);
    j = j+1;
end % end for

% Get query ground truth
queryGtFname = sprintf(groundTruthStr,paramsQuery.queryCorridor,paramsQuery.queryPass);
queryGt = csvread(fullfile(paramsDataset.groundTruthPath,queryGtFname),1,1);

posQueryLoc = queryGt(round(queryLoc));
[m cellLocs]   = cellfun(@(x) min(abs(x-posQueryLoc)),groundTruth,'UniformOutput',0);

frameLocations = cell2mat(cellLocs);

if nargout > 1

    varargout{1} = frameLocations;
    
end
%%
for i = 1:numKernels
    scores{i}       = kernels{i}(:,frameLocations(i))';
end

lengthCurve = size(scores{1},2);

%% get curves around desired location


curves  = zeros(numKernels,sideSpan*2);

for i = 1:numKernels
    fr = round(queryLoc);
    
    % Prevent tuning curve out of bounds
    
    [lowerBound, upperBound] = getBounds(fr, sideSpan, lengthCurve);
    
    c1 = scores{i}(lowerBound:fr);
    c2 = scores{i}(fr+1:upperBound);
    
    curves(i,:)  = [c1 c2];
    
end

end % end getTuningCurves