%% Load default parameters

setup;

%% load map image and map trajectory

map = imread('map/map.png');

load('map/C2_trajectory_coordinates.mat');

lenCorrMap = size(c2Coords,1);



%% Get kernels
[results, trainingSet] = getKernel(paramsDataset, paramsQuery);

kernels = results.Kernel;

%% Load corridor length in metres.

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

corrLen = queryGt(end); % Length in centimetres
numFramesCorr = length(queryGt); % Number of frames corridor

%% Number of cells desired for the experiment [TO MOVE TO USER PARAMETER SECTION]
paramsCells.numCells = 8;

cellIntervals = linspace(0,corrLen,paramsCells.numCells);
%% Cell width (sensitivity);

paramsCells.sideSpan = round(numFramesCorr/paramsCells.numCells/2);

%% Sample spacing [TO MOVE TO USER PARAMETER SECTION]

experiment.sampleSpacingInMetres = 1; % [TO MOVE TO USER PARAMETER SECTION]

posSpacing = 0:experiment.sampleSpacingInMetres*100:corrLen;

frameSpacing = experiment.sampleSpacingInMetres*100*numFramesCorr/corrLen;
sampleFrameSpacing = 1:frameSpacing:numFramesCorr;

numSamples = length(sampleFrameSpacing);


%% Get curves

thresh = 5.5;
dbPassesCellLocs = zeros(numSamples, length(kernels));
for i = 1: numSamples
    
    [curves{i} dbPassesCellLocs(i,:)] = getTuningCurves(sampleFrameSpacing(i), kernels, paramsDataset, paramsQuery,...
        paramsCells.sideSpan, trainingSet);
end


% normCells = cellfun(@(x,y) normalizeCells(x, paramsCells, thresh),curves,'UniformOutput',0);

%% Find the peaks and their locations

numPasses = length(trainingSet);
maxLoc = zeros(numSamples, numPasses);
for i = 1:numSamples
    
    for j = 1:numPasses
        
        cell = curves{i}(j,:);
        [pks, locs] = findpeaks(cell);
        try
            [maxPeak, maxLoc(i,j)] = max(pks);
        catch
            [maxPeak, maxLoc(i,j)] = max(cell);
        end
        
        [lowerBound, upperBound] = getBounds(dbPassesCellLocs(i,j), paramsCells.sideSpan, size(kernels{numPasses},2));
        
        span = lowerBound:upperBound;
        firingLocs(i,j) = span(maxLoc(i,j));
        firingLocsInCm(i,j) = groundTruth{j}(firingLocs(i,j));
    end
    
end

%%

% Position of circles in the map figure

circlePosOnMap = round(firingLocsInCm.*(lenCorrMap/corrLen));
radius = 5; % Radius in pixels

pad = ceil(numPasses/2);

% Plot

figure;
imshow(map);

cmap = get(gca,'ColorOrder');

% cmapIndices = linspace(1,256,32);
for i = 1:size(circlePosOnMap,1)
    
    for j = 1:numPasses
        try
            xPos = c2Coords(circlePosOnMap(i,j),1);
        catch
            xPos = c2Coords(end,1);
        end
        
        try
            yPos = c2Coords(circlePosOnMap(i,j),2);
        catch
            yPos = c2Coords(end,2);
        end
        
        if yPos > 64 && xPos <= 384 % [CHANGE HARD CODED VALUES]
            
            xPos = xPos + 5*j - pad;
            
        else
            
            yPos = yPos + 5*j - pad;
            
        end
        
        % Choose color [GET THIS OUT OF HERE]
        
        [~, idxColor] = min(abs(firingLocsInCm(i,j) - cellIntervals))
        if idxColor == 8
            idxColor = 1;
        end
        h = circles(xPos,yPos,radius,'Color',cmap(idxColor,:));
        
        %     set(h,'Color',cmap(i,:));
        hold on;
    end
    
end %end for

%% Experiment stats

experiment.corridorLength = corrLen/100;
experiment.numFramesCorridor = numFramesCorr;
experiment.numCells = paramsCells.numCells;
experiment.spanCellsInMetres = experiment.corridorLength/experiment.numCells;