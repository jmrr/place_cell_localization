% MAIN

[results, trainingSet] = getKernel(paramsDataset, paramsQuery);

kernels = results.Kernel;
queryFrame = 400;
numTopMatches = 5;

[top, topIdx] = simulateQuery(kernels, queryFrame, numTopMatches);

bestMatchingFrames = [trainingSet; topIdx(:,1)']; % First row for db pass
                                                 % second for best matching
                                                 % db frame                                                 % 

%%
queryLoc = 600;
sideSpan = 150;
curves = getTuningCurves(queryLoc, kernels, paramsDataset, paramsQuery,...
    sideSpan, trainingSet);

