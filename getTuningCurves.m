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
   curves(i,1:sideSpan) = scores{i}(fr-sideSpan+1:fr);
   curves(i,sideSpan+1:end) = scores{i}(fr+1:fr+sideSpan);
end

end % end getTuningCurves