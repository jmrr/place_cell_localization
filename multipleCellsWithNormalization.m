function multipleCellsWithNormalization(paramsDataset, paramsTraining, paramsQuery, paramsCells, thresh)


% Get kernels
[results, trainingSet] = getKernel(paramsDataset, paramsTraining, paramsQuery);

kernels = results.Kernel;

% Cell Parameters
numCells   = paramsCells.numCells;
lenJourney = size(kernels{1},1);
sideSpan   = paramsCells.sideSpan;
queryLocs  = linspace(sideSpan,lenJourney-sideSpan, numCells);

for i = 1:length(queryLocs)
    
    curves{i} = getTuningCurves(queryLocs(i), kernels, paramsDataset, paramsQuery,...
        sideSpan, trainingSet);
    [lowerBound, upperBound] = getBounds(queryLocs(i), sideSpan, size(kernels{1},1));
    
    curvesAxis(i,:) = lowerBound:upperBound;
    
    
end


normCells = cellfun(@(x,y) normalizeCells(x, paramsCells, thresh),curves,'UniformOutput',0);

meanNormCells = cellfun(@mean, normCells,'UniformOutput',0);

meanNormCells = cat(1,meanNormCells{:});

figure;
for idx = 1:size(meanNormCells,1)
    
    plot(curvesAxis(idx,:), meanNormCells(idx,:),'LineWidth',2.5);
    hold on
    
end

end % end function