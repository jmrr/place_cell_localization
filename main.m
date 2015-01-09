% MAIN
setup;

experiment = 5;

switch experiment
    
    case 0
        
        bestMatchingFrames = getBestMatchingFrames(paramsDataset, paramsQuery, paramsCells);
        
    case 1
        [curves] = plotRawAndSmoothedTuningCurves(paramsDataset, paramsQuery, paramsCells);
        
    case 2
        
        singleCellIdx = 4;
        singleCellPlot(paramsDataset, paramsQuery, paramsCells,singleCellIdx);
        
    case 3
        singleCellSubPlots(paramsDataset, paramsQuery, paramsCells);
        
    case 4 % Multiple cells, with normalization
        
        singleCellPlots(paramsDataset, paramsQuery, paramsCells);
        thresh = input('Select a threshold\n');
        multipleCellsWithNormalization(paramsDataset, paramsQuery, paramsCells, thresh);
    
    case 5 % Multiple cells, with normalization and hardcoded threshold
        thresh = 10;
        multipleCellsWithNormalization(paramsDataset, paramsQuery, paramsCells, thresh);
end


