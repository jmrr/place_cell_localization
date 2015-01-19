% MAIN
setup;

experiment = 4;

switch experiment
    
    case 0
        bestMatchingFrames = getBestMatchingFrames(paramsDataset, paramsCells.queryFrame, paramsCells);
        
    case 1
        [curves] = plotRawAndSmoothedTuningCurves(paramsDataset, paramsQuery, paramsCells);
        
    case 2
        
        singleCellIdx = 4;
        singleCellPlot(paramsDataset, paramsQuery, paramsCells,singleCellIdx);
        
    case 3
        singleCellSubPlots(paramsDataset, paramsQuery, paramsCells);
        
    case 4 % Multiple cells, with normalization
        
        singleCellSubPlots(paramsDataset, paramsQuery, paramsCells);
        thresh = input('Select a threshold\n');
        multipleCellsWithNormalization(paramsDataset, paramsQuery, paramsCells, thresh);
        
    case 5 % Multiple cells, with normalization and hardcoded threshold
        thresh = 10.5;
        multipleCellsWithNormalization(paramsDataset, paramsQuery, paramsCells, thresh);
        
    % Spatial firing of place cells
    
    case 6 % Map plot, grouping the "queries" by their ground truth just to
           % show that they WOULD fall in the detection region of certain place cells
        spatialFiring;
        
    case 7 % Map plot with real location estimation
        spatialFiringWithDetection;
end


