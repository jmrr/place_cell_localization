% MAIN
setup;

experiment = 4;

switch experiment
    
    case 1
        
        bestMatchingFrames = getBestMatchingFrames(paramsDataset, paramsQuery, paramsCells);
        
    case 2
        [curves] = plotRawAndSmoothedTuningCurves(paramsDataset, paramsQuery, paramsCells);
        
    case 3
        
        singleCellPlots(paramsDataset, paramsQuery, paramsCells);
        
    case 4 % Multiple cells, with normalization
        
        singleCellPlots(paramsDataset, paramsQuery, paramsCells);
        thresh = input('Select a threshold\n');
        multipleCellsWithNormalization(paramsDataset, paramsQuery, paramsCells, thresh);
        
end


