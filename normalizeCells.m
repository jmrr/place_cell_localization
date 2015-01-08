function normCell = normalizeCells(currCell, thresh)
% thresh is a heuristic from eye-ball inspection

% An example with cell id = 6

% First threshold to a min

for i = 1:size(currCell,1)
    smCurves(i,:) = smooth(currCell(i,:),30);
    smCurves(i,smCurves(i,:) < thresh) = thresh;
end

% Find max

totalMax = max(smCurves(:));

% Produce normalization [0,1]

% normalizedCurves = cellfun(@(x) (x-thresh)/totalMax,curves,'UniformOutput',false);

normCell = arrayfun(@(x) (x-thresh)/totalMax, smCurves);

end %end function

