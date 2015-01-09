function normCell = normalizeCells(currCell, paramsCells, thresh)
% thresh is a heuristic from eye-ball inspection

% First threshold to a min

for i = 1:size(currCell,1)
    smCurves(i,:) = smooth(currCell(i,:), paramsCells.smoothFac);
    smCurves(i,smCurves(i,:) < thresh) = thresh;
end

% Find max

totalMax = max(smCurves(:));

% Produce normalization [0,1]

normCell = arrayfun(@(x) (x-thresh)/(totalMax-thresh), smCurves);

end %end function

