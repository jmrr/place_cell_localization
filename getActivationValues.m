function [activations] = getActivationValues(observations, kernels, groundTruth, trainingPass, paramsTraining, paramsCells, cellLocations)



for k = 1:length(kernels)
        
        observationsFrames = frameFromGroundTruth(groundTruth{trainingPass}, observations);
        
        cellFrames = frameFromGroundTruth(groundTruth{k}, cellLocations);

        activations{k} = kernels{k}(observationsFrames, cellFrames)';
        
end


% Activations. For now taking the mean after the normalization takes place.
% normCurves  = cellfun(@(x) normalizeCells(x, paramsCells, paramsCells.threshold),activations,'UniformOutput',0);
% normCurves  = cat(3,normCurves{:});
activations = cat(3,activations{:});
activations = squeeze(mean(activations,3));

end
