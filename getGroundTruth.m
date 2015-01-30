function [groundTruth] = getGroundTruth(paramsDataset, paramsQuery, passes)

groundTruthStr = 'ground_truth_C%d_P%d.csv';

% Get training ground truth
j = 1;

for i = passes
    gtFname = sprintf(groundTruthStr,paramsQuery.queryCorridor,i);
    groundTruth{j} = csvread(fullfile(paramsDataset.groundTruthPath,gtFname),1,1);
    j = j+1;
end % end for

end % end function getGroundTruth