function [results] = getKernel(paramsDataset, paramsTraining, paramsQuery)

dictionarySet = paramsTraining.dictionarySet;
dictionarySetStr = sprintf('%d',dictionarySet);

kernelPath     = sprintf(paramsDataset.kernelPath,paramsDataset.encoding, ...
    paramsDataset.descriptor,paramsQuery.queryCorridor);
kernelFname = sprintf(paramsQuery.kernelStr,paramsQuery.queryCorridor,paramsDataset.encoding,...
    paramsDataset.kernel,dictionarySetStr,paramsQuery.queryPass);

results = load(fullfile(kernelPath,kernelFname));

end

