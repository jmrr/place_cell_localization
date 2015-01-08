% MAIN
setup;

[results, trainingSet] = getKernel(paramsDataset, paramsQuery);

kernels = results.Kernel;
queryFrame = 400;
numTopMatches = 5;

[top, topIdx] = simulateQuery(kernels, queryFrame, numTopMatches);

bestMatchingFrames = [trainingSet; topIdx(:,1)']; % First row for db pass
% second for best matching
% db frame                                                 %

%%
numCells  = 10;
queryLocs = linspace(100,700, numCells);
% queryLocs = 100:20:600;
sideSpan  = 100;
figure
for i = 1:length(queryLocs)
    
    curves{i} = getTuningCurves(queryLocs(i), kernels, paramsDataset, paramsQuery,...
        sideSpan, trainingSet);
    meanCurves(i,:) = mean(curves{i},1);
    
    [lowerBound, upperBound] = getBounds(queryLocs(i), sideSpan, size(kernels{1},1));
    
    curvesAxis(i,:) = lowerBound:upperBound;
    
    plot(curvesAxis(i,:), meanCurves(i,:))
    hold on
end

% with smoothing
figure;
for idx = 1:size(meanCurves,1)
    
    smoothedCurves = smooth(meanCurves(idx,:),40);
    plot(curvesAxis(idx,:), smoothedCurves);
    hold on
    
end

%% Single-cell plots:

% A single example:
% plotOverlappedCurvesWithMinMax(curves{6},30,0.1)

for i = 1:length(queryLocs)
    figure(1)
    subplot(4,2,i)
    plotOverlappedCurves(curves{i});
    figure(2)
    subplot(4,2,i)
    plotOverlappedCurvesWithMinMax(curves{i},30,0.1);
    
end

%% Multiple cells, with normalization
thresh = 9.5;

normCells = cellfun(@(x,y) normalizeCells(x, thresh),curves,'UniformOutput',0);

meanNormCells = cellfun(@mean, normCells,'UniformOutput',0);

meanNormCells = cat(1,meanNormCells{:});

figure;
for idx = 1:size(meanNormCells,1)
    
    plot(curvesAxis(idx,:), meanNormCells(idx,:));
    hold on
    
end

