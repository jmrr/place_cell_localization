function bestMatchingFrames = getBestMatchingFrames(paramsDataset, queryFrame, paramsCells)


[results, trainingSet] = getKernel(paramsDataset, paramsQuery);

kernels = results.Kernel;

numTopMatches = paramsCells.numTopMatches;

[top, topIdx] = simulateQuery(kernels, queryFrame, numTopMatches);

bestMatchingFrames = [trainingSet; topIdx(:,1)']; % First row for db pass

end