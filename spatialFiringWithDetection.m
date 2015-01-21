%% spatialFiringWithDetection
% 1) Predefined N number of cells, linearly spaced along a corridor.
% 2) Laid out Q number of queries with 1 m between each other...
% 3) Using the kernels, I select the cell that is closest (in phyiscal distance) to the best match (max) 
% 4) Plot the results.


%% User parameters

% Load default parameters
setup;

% Number of cells desired for the experiment
paramsCells.numCells = 7;

% Sample spacing
experiment.sampleSpacingInMetres = 0.6;

% Tuning curve chi2 score threshold
thresh = 10.5;      % NOT USED YET

%% Load map image and map trajectory

map = imread('map/map.png');

load('map/C2_trajectory_coordinates.mat');

lenCorrMap = size(c2Coords,1);

%% Place fields:

% Get kernels
[results, trainingSet] = getKernel(paramsDataset, paramsQuery);

kernels = results.Kernel;

% Get ground truth
[trainingGt, queryGt] = getGroundTruth(paramsDataset, paramsQuery, trainingSet);

% Load corridor length in centimetres.
corrLen       = queryGt(end); % Length in centimetres
numFramesCorr = length(queryGt); % Number of frames corridor

cellIntervals = linspace(0,corrLen,paramsCells.numCells);

cellPositions = linspace(paramsCells.sideSpan,numFramesCorr-paramsCells.sideSpan,paramsCells.numCells);

% Cell width (sensitivity); [EXPLORE THE VALIDITY OF THIS. DISABLED FOR
% NOW!
% paramsCells.sideSpan = round(numFramesCorr/paramsCells.numCells/2);

%% Sample spacing
[sampleFrameSpacing, numSamples] = getFrameSpacing(experiment,corrLen, numFramesCorr);

%% Get curves for the place fields. This means getting a curve centred at the position
% given for the cell spacing for each pass in the training set

dbPassesCellLocs = zeros(paramsCells.numCells, length(kernels));

for i = 1: paramsCells.numCells % Num of samples, or queries in the experiment. IN THIS CASE FIRST PARAMETER SHOULD BE PLACE CELL LOC
    
    [curves{i}, dbPassesCellLocs(i,:)] = getTuningCurves(cellPositions(i), ...
        kernels, paramsDataset, paramsQuery,...
        paramsCells.sideSpan, trainingSet);
end

%% Find the peaks of the place cells and their locations

numPasses      = length(trainingSet);       % Num of training or database passes

maxIdx         = zeros(paramsCells.numCells, numPasses);
firingLocs     = zeros(size(maxIdx));
firingLocsInCm = zeros(size(maxIdx));

for i = 1:paramsCells.numCells
    
    for j = 1:numPasses
        
        cell = curves{i}(j,:);  % Get the cell, i.e. the tuning curve
        [pks, locs] = findpeaks(cell);  % Find the peak and its locations
        
        % If max of the peaks is the first or last sample take the max
        try
            [maxPeak, maxPeakIdx] = max(pks);
            maxIdx(i,j) = locs(maxPeakIdx);
        catch
            [maxPeak, maxIdx(i,j)] = max(cell);
        end
        
        % In this case we input the g.t. locations in the DB axis as we're
        % testing and shouln't know the g.t. position of the query.
        
        % This bit here is to retrieve the actual frame positions of the
        % tuning curves in the whole kernel response for that particular
        % location.
        
        [lowerBound, upperBound] = getBounds(dbPassesCellLocs(i,j), ...
            paramsCells.sideSpan, size(kernels{j},2)); % Choosing size(kernels{j},2)
        % as frame limit because a conversion
        % to actual distance taking place later
        
        span = lowerBound:upperBound;
        cellBoundaries(i,:) = [span(1) span(end)];
        
        % Exact firing locations of the 9 tuning curves
        firingLocs(i,j)     = span(maxIdx(i,j));
        firingLocsInCm(i,j) = trainingGt{j}(firingLocs(i,j));
    end
    
end


%% Get the position with the maximum accuracy for every query

% Retrieve the best match for a given  query and the kernels

for idx = 1:length(sampleFrameSpacing)
    [~, topIdx] = simulateQuery(kernels, round(sampleFrameSpacing(idx)), 1);
    bestMatchingFrameOnEachPass(idx,:) = topIdx';
end


% get location estimation in cm

for i = 1:numSamples
    for j = 1:numPasses
        locationEstimationOnEachPass(i,j) = trainingGt{j}(bestMatchingFrameOnEachPass(i,j));
    end
end

%% Get closest place cell for that location estimate

whichPass = zeros(numSamples, numPasses);
whichCell = zeros(size(whichPass));

for i = 1:numSamples
    for j = 1:numPasses
        
        locEst = locationEstimationOnEachPass(i,j);
        locEstMat = repmat(locEst,paramsCells.numCells,numPasses);
        
        distEstimateCells = abs(locEstMat - firingLocsInCm);
        [m, whichPlaceField] = min(distEstimateCells,[],1);
        [~, whichPass(i,j)] = min(m);                     % This will represent the parallel line with the best estimate (not displayed)
        whichCell(i,j) = whichPlaceField(whichPass(i,j)); % This will represent the color
    end
end

%% Position of circles in the map figure

circlePosOnMap = round(locationEstimationOnEachPass.*(lenCorrMap/corrLen));
radius         = 5; % Radius in pixels

pad = ceil(numPasses/2);

% Plot

figure;
imshow(map);

if paramsCells.numCells <= 7
    cmap = get(gca,'ColorOrder'); % Choose parula if 7 or less colors
else
    addpath('distinguishable_colors/');
    cmap = distinguishable_colors(paramsCells.numCells);
end

for i = 1:numSamples
    
    for j = 1:numPasses
        try
            xPos = c2Coords(circlePosOnMap(i,j),1);
            yPos = c2Coords(circlePosOnMap(i,j),2);
        catch
            if circlePosOnMap(i,j) == 0
                yPos = c2Coords(1,2);
                xPos = c2Coords(1,1);
            else
                yPos = c2Coords(end,2);
                xPos = c2Coords(end,1);
            end
        end
        
        % "corner" coordinates, 64 (y) and 384 (x)
        trajectoryLims = min(c2Coords);
        
        if yPos > trajectoryLims(2) && xPos <= trajectoryLims(1)
            xPos = xPos + pad*j - pad;
        else
            yPos = yPos + pad*j - pad;
        end
        
        % Choose color
        idxColor = whichCell(i,j);
        h = circles(xPos,yPos,radius,'Color',cmap(idxColor,:));
        
        hold on;
    end
    
end %end for
