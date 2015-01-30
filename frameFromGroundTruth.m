function [frameLoc] = frameFromGroundTruth(groundTruth, location)

frameLoc = zeros(size(location));

for i = 1:length(location)
    [~, frameLoc(i)] = min(abs(groundTruth-location(i)));
end


end