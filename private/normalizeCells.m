function normCell = normalizeCells(currCell, paramsCells, thresh)
% NORMALIZECELLS produces a normalization of a place cell with thresholding
% and optional smoothing. The normalization follows the formula (after
% thresholding:
%   normX = (x - thresh)/(max-thresh)
% This produces a [0,1] normalizations

% thresh is a heuristic from eye-ball inspection

% Authors: Jose Rivera-Rubio
%          {jose.rivera}@imperial.ac.uk
% Date: April, 2015


% First threshold to a min

if paramsCells.smoothFac > 0
    
    for i = 1:size(currCell,1)
        smCurves(i,:) = smooth(currCell(i,:), paramsCells.smoothFac);
        smCurves(i,smCurves(i,:) < thresh) = thresh;
    end
else
    
    smCurves = currCell;
    smCurves(smCurves < thresh) = thresh;
end


% Find max

totalMax = max(smCurves(:));

% Produce normalization [0,1]

normCell = arrayfun(@(x) (x-thresh)/(totalMax-thresh), smCurves);

end %end function

