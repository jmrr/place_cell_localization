function [top, topIdx] = simulateQuery(kernels, frameNumber, numTopMatches)
% SIMULATEQUERY provides a kernel numTopMatches top matches for a given query
% frame, specified by frameNumber. 
%
% Dictionary and descriptors are already created, so pre-indexing has
% already been done, and is held in the Chi^2 similarity kernel that is
% loaded from the argument line (kernels)
% 
% One COULD, of course, pass the image file-name in, but since there is a
% one-to-one correspondence between the name and the row of the Kernel
% matrix, there is really no need to do this.
%

% Calling syntax: simulateQuery(kernels, frameNumber, numTopMatches
%
% Authors: Jose Rivera-Rubio and Anil Bharath
%          {jose.rivera,a.bharath}@imperial.ac.uk
% Date: November, 2014

numKernels = size(kernels,2);
top        = zeros(numKernels,numTopMatches);
topIdx     = zeros(size(top));
for i = 1:numKernels
    
    scores{i}       = kernels{i}(frameNumber,:);
    [sortedScr idx] = sort(scores{i},'descend');
    top(i,:)        = sortedScr(1:numTopMatches);
    topIdx(i,:)     = idx(1:numTopMatches);
    
end % end for


end % end simulate Query

