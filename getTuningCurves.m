function curves = getTuningCurves(queryLoc, kernels, paramsDataset, ...
    paramsQuery, sideSpan, trainingSet)

numKernels = size(kernels,2);
groundTruthStr = 'ground_truth_C%d_P%d.csv';
j = 1;

for i = trainingSet
    gtFname = sprintf(groundTruthStr,paramsQuery.queryCorridor,i);
    groundTruth{j} = csvread(fullfile(paramsDataset.groundTruthPath,gtFname),1,1);
    j = j+1;
end % end for


[m cellLocs]   = cellfun(@(x) min(abs(x-queryLoc)),groundTruth,'UniformOutput',0);
frameLocations = cell2mat(cellLocs);
%%
for i = 1:numKernels
    scores{i}       = kernels{i}(frameLocations(paramsQuery.queryPass),:);
    lengthCurves(i) = size(scores{i},2);
end
%% get curves around desired location


curves  = zeros(numKernels,sideSpan*2);

for i = 1:numKernels
    fr = frameLocations(i);
    
    % Prevent tuning curve out of bounds
    
    lowerBound = fr-sideSpan+1;
    upperBound = fr+sideSpan;
    
    if lowerBound < 1 && upperBound < lengthCurves(i)
        
        upperBound = upperBound - lowerBound + 1; % lowerBound < 0 upperBound shifted to the right
        lowerBound = 1;
        
    elseif lowerBound > 0 && upperBound > lengthCurves(i)
        
        lowerBound = lowerBound - (upperBound - lengthCurves(i));
        upperBound = lengthCurves(i);
    end
    
    c1 = scores{i}(lowerBound:fr);
    c2 = scores{i}(fr+1:upperBound);
    
    curves(i,:)  = [c1 c2];
end

end % end getTuningCurves