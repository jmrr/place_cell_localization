% MAIN

paramsDataset = struct(...
    'descriptor',    'SF_GABOR',...  % SIFT, DSIFT, SF_GABOR, ST_GABOR, ST_GAUSS,
    'corridors',     1:6,... % Corridors to run [1:6] (RSM v6.0)
    'passes',        1:10,... % Passes to run [1:10] (RSM v6.0)
    'datasetDir',    '/media/PictureThis/VISUAL_PATHS/v6.0',...   % The root path of the RSM dataset
    'frameDir',      'frames_resized_w208p',... % Folder name where all the frames have been extracted.
    'descrDir',  ...
    '/media/Data/localisation_from_visual_paths_data/descriptors', ...
    'dictionarySize', 4000, ...
    'dictPath',       './dictionaries', ...
    'encoding', 'HA', ... % 'HA', 'VLAD'
    'kernel', 'chi2', ... % 'chi2', 'Hellinger'
    'kernelPath', '/media/Data/localisation_from_visual_paths_data/kernels/%s/%s/C%d', ...
    'metric', 'max', ...
    'groundTruthPath', '/media/PictureThis/VISUAL_PATHS/v6.0/ground_truth', ...
    'debug', 1 ... % 1 shows waitbars, 0 does not.
    );

paramsQuery = struct(...
    'queryCorridor',     2,... % query corridor [1:6] (RSM v6.0)
    'queryPass',        2,... % query pass [1:10] (RSM v6.0)
    'kernelStr', 'C%d_kernel_%s_%s_P%s_%d.mat', ...
    'kernelPath', '/media/Data/localisation_from_visual_paths_data/kernels/%s/%s/C%d' ...
    );

[results, trainingSet] = getKernel(paramsDataset, paramsQuery);

kernels = results.Kernel;
queryFrame = 400;
numTopMatches = 5;

[top, topIdx] = simulateQuery(kernels, queryFrame, numTopMatches);

bestMatchingFrames = [trainingSet; topIdx(:,1)']; % First row for db pass
                                                 % second for best matching
                                                 % db frame                                                 % 

queryLoc = 500;
sideSpan = 75;
curves = getTuningCurves(queryLoc, kernels, paramsDataset, paramsQuery,...
    sideSpan, trainingSet);

