function activeValues = getNeuralNetInput(paramsDataset, paramsQuery, paramsCells, kernels, trainingSet, queryLocs, debug)





% Compute tuning curves

for i = 1:length(queryLocs)
    
%     curves{i} = getTuningCurves(queryLocs(i), kernels, paramsDataset, paramsQuery,...
%         paramsCells.sideSpan, trainingSet);
%     [lowerBound, upperBound] = getBounds(round(queryLocs(i)), paramsCells.sideSpan, size(kernels{1},1));
%     
%     curvesAxis(i,:) = lowerBound:upperBound;
    
    scores{i} = getResponseScores(round(queryLocs(i)), kernels, paramsDataset, ...
    paramsQuery, trainingSet);
       
end




normCells = cellfun(@(x,y) normalizeCells(x, paramsCells, paramsCells.threshold),scores,'UniformOutput',0);

meanNormCells = cellfun(@mean, normCells,'UniformOutput',0);

meanNormCells = cat(1,meanNormCells{:});



figure;
for idx = 1:size(meanNormCells,1)
    
    plot(meanNormCells(idx,:),'LineWidth',2.5);
    hold on
    
end

% maximum upper bound

maxUpperBound = max(curvesAxis(:));

% Declare matrix storing all the signals in sequence

allTuningCurvesMat = zeros(paramsCells.numCells, maxUpperBound);

for idx = 1:size(meanNormCells,1)
    allTuningCurvesMat(idx,curvesAxis(idx,:)) = meanNormCells(idx,:);
    plot(meanNormCells(idx,:));
    hold on;
end

activeValues = allTuningCurvesMat(:,round(queryLocs));

if sum(isnan(activeValues(:))) > 0
    error('Normalization error: Some of the tuning curves were below the threshold. It must be decreased.');
end

activationMat = activeValues > 0; 



% Plots if debug flag is on.

if debug
    
    figure;
    for idx = 1:size(meanNormCells,1)
        
        plot(curvesAxis(idx,:), meanNormCells(idx,:),'LineWidth',2.5);
        hold on
    end
   
end

end % end getNeuralNetInput function