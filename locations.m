function [observations, cellLocations, queryLocations] = locations(...
    paramsDataset, paramsCells, paramsQuery, numObservations, numQueries)
% Of the 10 passes, paramsTraining.trainingSet have been used for creating the dictionary,
% and the queries must come from one, or more of the remaining passes that
% have NOT been used for creating the dictionary.

% Get ground truth
[allGroundTruth] = getGroundTruth(paramsDataset, paramsQuery, paramsDataset.passes);

% Load corridor length in centimetres.
corrLengths         = cellfun(@(x) max(x),allGroundTruth);
[corrLen, shortest] = min(corrLengths); % The minimum length will be the final length of the corridor

cmPerFrame = corrLen/length(allGroundTruth{shortest});

sideSpanCm = paramsCells.sideSpan*cmPerFrame;

cellLocations = linspace(sideSpanCm,...        % Position of place cells in cm
    corrLen -(sideSpanCm),paramsCells.numCells);

observations = linspace(sideSpanCm,...          % Position of training observations in cm
    corrLen - (sideSpanCm), numObservations);

queryLocations = linspace(sideSpanCm,...        % Position of queries used for testing
    corrLen - (sideSpanCm), numQueries);

end % end function locations