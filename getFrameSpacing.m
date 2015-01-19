function [sampleFrameSpacing, numSamples] = getFrameSpacing(experiment, corrLen, numFramesCorr)

posSpacing = 0:experiment.sampleSpacingInMetres*100:corrLen;

frameSpacing = experiment.sampleSpacingInMetres*100*numFramesCorr/corrLen;
sampleFrameSpacing = 1:frameSpacing:numFramesCorr;

numSamples = length(sampleFrameSpacing);

end % end getFrameSpacing