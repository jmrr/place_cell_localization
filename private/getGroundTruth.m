function [groundTruth] = getGroundTruth(paramsDataset, paramsQuery, passes)
% GETGROUNDTRUTH reads the ground truth data from a CSV file. It can
% operate over one or more sequences (passes of RSM dataset) .
%
% More info on the RSM dataset http://rsm.bicv.org

% Authors: Jose Rivera-Rubio
%          {jose.rivera}@imperial.ac.uk
% Date: April, 2015

groundTruthStr = 'ground_truth_C%d_P%d.csv';

% Get training ground truth
j = 1;

for i = passes
    gtFname = sprintf(groundTruthStr,paramsQuery.queryCorridor, i);
    groundTruth{j} = csvread(fullfile(paramsDataset.groundTruthPath,gtFname), 1, 1);
    j = j+1;
end % end for

end % end function getGroundTruth