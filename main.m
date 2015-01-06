% MAIN

[results, trainingSet] = getKernel(paramsDataset, paramsQuery);

kernels = results.Kernel;
queryFrame = 400;
numTopMatches = 5;

[top, topIdx] = simulateQuery(kernels, queryFrame, numTopMatches);

bestMatchingFrames = [trainingSet; topIdx(:,1)']; % First row for db pass
                                                 % second for best matching
                                                 % db frame                                                 % 

queryLoc = 500;
sideSpan = 75;
curves = getTuningCurves(queryLoc, kernels, paramsDataset, paramsQuery,...
    sideSpan, trainingSet);

