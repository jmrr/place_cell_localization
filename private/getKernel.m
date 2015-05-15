function [results] = getKernel(paramsDataset, paramsTraining, paramsQuery)
% GETKERNEL retrieves the bag of visual words kernelized representation of
% histogram distances. It takes the parameters of the dataset, training
% and query sets
%
% Usage:
% [results] = getKernel(paramsDataset, paramsTraining, paramsQuery)
% kernels = results.Kernel;


% Authors: Jose Rivera-Rubio
%          {jose.rivera}@imperial.ac.uk
% Date: April, 2015

dictionarySet = paramsTraining.dictionarySet;
dictionarySetStr = sprintf('%d',dictionarySet);

kernelPath     = sprintf(paramsDataset.kernelPath,paramsDataset.encoding, ...
    paramsDataset.descriptor,paramsQuery.queryCorridor);
kernelFname = sprintf(paramsQuery.kernelStr,paramsQuery.queryCorridor,paramsDataset.encoding,...
    paramsDataset.kernel,dictionarySetStr,paramsQuery.queryPass);

results = load(fullfile(kernelPath,kernelFname));

end

