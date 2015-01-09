function singleCellPlot(paramsDataset, paramsQuery, paramsCells,singleCellIdx)


% Get kernels
[results, trainingSet] = getKernel(paramsDataset, paramsQuery);

kernels = results.Kernel;

% Cell Parameters
numCells   = paramsCells.numCells;
lenJourney = size(kernels{1},1);
sideSpan   = paramsCells.sideSpan;
bound     = round(sideSpan/2);
queryLocs  = linspace(bound,lenJourney-bound, numCells);

for i = 1:length(queryLocs)
    
    curves{i} = getTuningCurves(queryLocs(i), kernels, paramsDataset, paramsQuery,...
        sideSpan, trainingSet);
    
end


%% Single-cell plots:

figure;
plotOverlappedCurves(curves{singleCellIdx});

figure;
plotOverlappedCurvesWithMinMax(curves{singleCellIdx},paramsCells.smoothFac,0.1);


end % end function

