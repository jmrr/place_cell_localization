%% User parameters

% Load default parameters
setup;

% Number of cells desired for the experiment
paramsCells.numCells = 8;


%% Get kernels
[results, trainingSet] = getKernel(paramsDataset, paramsQuery);

kernels = results.Kernel;

%% Divide training testing

% Leave one out for now, so can use old code.

% Get ground truth
[trainingGt, queryGt] = getGroundTruth(paramsDataset, paramsQuery, trainingSet);

% Load corridor length in centimetres.
corrLen       = queryGt(end); % Length in centimetres
numFramesCorr = length(queryGt); % Number of frames corridor

cellIntervals = linspace(0,corrLen,paramsCells.numCells);

cellPositions = linspace(paramsCells.sideSpan,numFramesCorr-paramsCells.sideSpan,paramsCells.numCells);

%% Get curves for the place fields. This means getting a curve centred at the position
% given for the cell spacing for each pass in the training set

dbPassesCellLocs = zeros(paramsCells.numCells, length(kernels));

for i = 1: paramsCells.numCells % Num of samples, or queries in the experiment. IN THIS CASE FIRST PARAMETER SHOULD BE PLACE CELL LOC
    
    [curves{i}, dbPassesCellLocs(i,:)] = getTuningCurves(cellPositions(i), ...
        kernels, paramsDataset, paramsQuery,...
        paramsCells.sideSpan, trainingSet);
end


%% Prepare data for neural net
% Input

input = cat(1,curves{:})'; % This would give a sideSpan*2 x numCells*9 size matrix.

% Target: Find the peaks of the place cells and their locations

numPasses      = length(trainingSet);       % Num of training or database passes

maxIdx         = zeros(paramsCells.numCells, numPasses);
gtPlaceCell = zeros(paramsCells.sideSpan*2,paramsCells.numCells* numPasses);

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
% % Verification plot        
%         plot(cell)
%         hold on
%         plot(maxIdx(i,j), maxPeak,'.r', 'LineWidth',4);
%         hold off;
        
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
        
        % Exact firing location
        firingLoc = span(maxIdx(i,j));
        
        % Ground Truth place cell
        gtFiringLoc = trainingGt{j}(firingLoc);
        gtPlaceCell(:,i*j) = trainingGt{j}(span) - gtFiringLoc;

    end
    
end

%% Train the network

net = newgrnn(input, gtPlaceCell);


