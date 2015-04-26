function queryGt = getQueryGroundTruth(paramsTraining, paramsCells, queryFrames, allGroundTruth, normFlag)

% Query ground truth
queryGt = [];

for i = 1:length(paramsTraining.querySet)
    
    for q = 1:length(queryFrames)
   
        gt(q,:) = allGroundTruth{paramsTraining.querySet(i)}(queryFrames(q)-paramsCells.sideSpan:queryFrames(q)+paramsCells.sideSpan-1);
        
        if normFlag
            gt(q,:) = gt(q,:) - allGroundTruth{paramsTraining.querySet(i)}(queryFrames(q));
        end
    
    end
    queryGt = [queryGt reshape(gt',1,numel(gt))./100];
end

end % end function