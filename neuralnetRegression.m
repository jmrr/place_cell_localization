%% User parameters

% Load default parameters
setup;

% Number of cells desired for the experiment
paramsCells.numCells = 16;


%% Get training kernels
queriesForTraining = paramsQuery;

for i = 1 %% CHANGE FOR ALL TRAINING PASSES
    
    queriesForTraining.queryPass = i;
    [results, trainingSet] = getKernel(paramsDataset, paramsTraining, queriesForTraining);
    kernels = results.Kernel;
    
end

%% Divide training testing

% Leave one out for now, so can use old code.
% Of the 10 passes, 5 have been used for training, and the queries must be
% from one of the 5 remaining passes that have NOT been used for training.

% Get ground truth
[trainingGt, queryGt] = getGroundTruth(paramsDataset, queriesForTraining, paramsTraining.trainingSet);

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
concatExperiments = cellfun(@(x) reshape(x,numel(x),1),curves,'UniformOutput',0);
input = cell2mat(concatExperiments)'; % This would give a numCells*(lengthCells*numPasses)
% size matrix.

% Target: Find the peaks of the place cells and their locations

numPasses      = length(trainingSet);       % Num of training or database passes

gtPlaceCell = zeros(paramsCells.numCells, paramsCells.sideSpan*2*numPasses);

for i = 1:paramsCells.numCells
    
    for j = 1:numPasses
        
        % This bit here is to retrieve the actual frame positions of the
        % tuning curves in the whole kernel response for that particular
        % location.
        
        [lowerBound, upperBound] = getBounds(dbPassesCellLocs(i,j), ...
            paramsCells.sideSpan, size(kernels{j},2)); % Choosing size(kernels{j},2)
        % as frame limit because a conversion
        % to actual distance taking place later
        
        span = lowerBound:upperBound;
        
        % Ground Truth place cell
        startIdx = paramsCells.sideSpan*2*(j-1)+1;
        endIdx   = paramsCells.sideSpan*2*(j);
        gtPlaceCell(i,startIdx:endIdx) = ...
            trainingGt{j}(span) - trainingGt{j}(dbPassesCellLocs(i,j));
    end
    
end

%% Train the network

net = newgrnn(input, gtPlaceCell);


%% Obtain test data

% Query locations

bound     = round( paramsCells.sideSpan/2);
queryLocs  = linspace(bound,numFramesCorr-bound, paramsCells.numCells);
posQueryLoc = queryGt(round(queryLocs));

% Query kernel and data

kernelPath     = sprintf(paramsDataset.kernelPath,paramsDataset.encoding, ...
    paramsDataset.descriptor,paramsQuery.queryCorridor);
queryKernelFname = sprintf(paramsQuery.kernelStr,paramsQuery.queryCorridor,paramsDataset.encoding,...
    paramsDataset.kernel,num2str(paramsQuery.queryPass),paramsQuery.queryPass);

queryResults = load(fullfile(kernelPath,queryKernelFname));

queryKernel = queryResults.Kernel;
%%

for i = 1:length(queryLocs)
    
    scores = queryKernel{1}(:,round(queryLocs(i)));
    
    
    fr = round(queryLocs(i)); % In  the tuning curve, take the centre frame as
    % the one corresponding to the g.t. in the query
    % frames axis.
    
    % Prevent tuning curve out of bounds
    
    [lowerBound, upperBound] = getBounds(fr, paramsCells.sideSpan, numFramesCorr);
    
    c1 = scores(lowerBound:fr);
    c2 = scores(fr+1:upperBound);
    
    queryCurves(:,i)  = [c1; c2];
    
end

%%

% query gt

maxQueryIdx         = zeros(paramsCells.numCells,1);
queryGtPositions = zeros(paramsCells.sideSpan*2,paramsCells.numCells);

for i = 1:paramsCells.numCells
    
    queryTuningCurve = queryCurves(:,i); % Get the tuning curve for the query
    [pks, locs] = findpeaks(double(queryTuningCurve));  % Find the peak and its locations
    
    % If max of the peaks is the first or last sample take the max
    try
        [maxPeak, maxPeakIdx] = max(pks);
        maxQueryIdx(i) = locs(maxPeakIdx);
    catch
        [maxPeak, maxQueryIdx(i)] = max(queryTuningCurve);
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
    
    [lowerBound, upperBound] = getBounds(round(queryLocs(i)), ...
        paramsCells.sideSpan, numFramesCorr);
    
    span = lowerBound:upperBound;
    
    % Exact firing location
    qFiringLoc = span(maxQueryIdx(i));
    
    % Ground Truth query cell
    qGtFiringLoc = queryGt(qFiringLoc);
    queryGtPositions(:,i) = queryGt(span) - qGtFiringLoc;
    
    
end

%%  Test (simulate)

locEstimate = sim(net, queryCurves');

errorInMetres = abs(locEstimate - queryGtPositions')/100;

