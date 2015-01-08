function bestMatchingFrames = getBestMatchingFrames(paramsDataset, paramsQuery, paramsCells)


[results, trainingSet] = getKernel(paramsDataset, paramsQuery);

kernels = results.Kernel;

queryFrame    = paramsCells.queryFrame;
numTopMatches = paramsCells.numTopMatches;

[top, topIdx] = simulateQuery(kernels, queryFrame, numTopMatches);

bestMatchingFrames = [trainingSet; topIdx(:,1)']; % First row for db pass

end