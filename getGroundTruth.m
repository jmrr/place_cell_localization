function [groundTruth, queryGt] = getGroundTruth(paramsDataset, paramsQuery, trainingSet)

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

end % end function getGroundTruth