function [results, trainingSet] = getKernel(paramsDataset, paramsTraining, paramsQuery)

trainingSet = paramsTraining.trainingSet;
trainingSetStr = sprintf('%d',trainingSet);

kernelPath     = sprintf(paramsDataset.kernelPath,paramsDataset.encoding, ...
    paramsDataset.descriptor,paramsQuery.queryCorridor);
kernelFname = sprintf(paramsQuery.kernelStr,paramsQuery.queryCorridor,paramsDataset.encoding,...
    paramsDataset.kernel,trainingSetStr,paramsQuery.queryPass);

results = load(fullfile(kernelPath,kernelFname));

end

