function singleCellPlots(paramsDataset, paramsQuery, paramsCells)


% Get kernels
[results, trainingSet] = getKernel(paramsDataset, paramsQuery);

kernels = results.Kernel;

% Cell Parameters
numCells   = paramsCells.numCells;
lenJourney = size(kernels{1},1);
queryLocs  = linspace(100,lenJourney, numCells);
sideSpan   = paramsCells.sideSpan;

for i = 1:length(queryLocs)
    
    curves{i} = getTuningCurves(queryLocs(i), kernels, paramsDataset, paramsQuery,...
        sideSpan, trainingSet);
    
end


%% Single-cell plots:

% A single example:
% plotOverlappedCurvesWithMinMax(curves{6},30,0.1)

fprintf('You have %d cells. Your sublot will have...\n',numCells)
rows = input('How many rows?\n');
cols = input('How many columns?\n');

for i = 1:length(queryLocs)
    figure(1);
    subplot(rows,cols,i)
    plotOverlappedCurves(curves{i});

    figure(2);
    subplot(rows,cols,i)
    plotOverlappedCurvesWithMinMax(curves{i},30,0.1);
    if numCells > 8
        legend off
    end
end

end % end function

