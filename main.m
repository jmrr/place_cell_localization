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
numCells  = 8;
queryLocs = linspace(100,700, numCells);
% queryLocs = 100:20:600;
sideSpan  = 50;
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