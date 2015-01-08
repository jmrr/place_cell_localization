function [curves] = plotRawAndSmoothedTuningCurves(paramsDataset, paramsQuery, paramsCells)


% Get kernels
[results, trainingSet] = getKernel(paramsDataset, paramsQuery);

kernels = results.Kernel;

% Cell Parameters
numCells   = paramsCells.numCells;
lenJourney = size(kernels{1},1);
queryLocs  = linspace(100,lenJourney, numCells);
sideSpan   = paramsCells.sideSpan;

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

end % end function