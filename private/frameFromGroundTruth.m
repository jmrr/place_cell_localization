function [frameLoc] = frameFromGroundTruth(groundTruth, location)
% FRAMEFROMGROUNDTRUTH retrieves the corresponding frame location within a
% sequence given the ground truth positions vector and the physical
% location of that frame.

% Authors: Jose Rivera-Rubio
%          {jose.rivera}@imperial.ac.uk
% Date: April, 2015

frameLoc = zeros(size(location));

for i = 1:length(location)
    [~, frameLoc(i)] = min(abs(groundTruth-location(i)));
end

end