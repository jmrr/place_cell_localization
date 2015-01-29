function [target] = neuralNetTarget(paramsDataset, paramsQuery, paramsTraining,...
    paramsCells, cellPositions, normFlag)

target = [];

numTrainingPasses = length(paramsTraining.trainingSet);

groundTruthStr = 'ground_truth_C%d_P%d.csv';


for i = 1:numTrainingPasses
    
    gtFname = sprintf(groundTruthStr,paramsQuery.queryCorridor,i);
    groundTruth = csvread(fullfile(paramsDataset.groundTruthPath,gtFname),1,1);
    
    for j = 1:length(cellPositions)
    
        [~, gtFrame] = min(abs(groundTruth-cellPositions(j)));
        
        gtCell(j,:) = groundTruth((gtFrame-paramsCells.sideSpan):(gtFrame+paramsCells.sideSpan-1));
        
        if normFlag
            gtCell(j,:) = gtCell(j,:) - groundTruth(gtFrame);
        end
    end
    
    target = [target reshape(gtCell',1,numel(gtCell))./100]; % Convert to cm, and remember, reshape works column-wise!!
    
end % end for numTrainingPasses

end % end neuralNetTarget

 