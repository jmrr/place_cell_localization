paramsDataset = struct(...
    'descriptor',    'SIFT',...  % SIFT, DSIFT, SF_GABOR, ST_GABOR, ST_GAUSS,
    'corridors',     1:6,... % Corridors to run [1:6] (RSM v6.0)
    'passes',        1:10,... % Passes to run [1:10] (RSM v6.0)
    'datasetDir',    '/home/jose/PhD/Data/VISUAL_PATHS/v6.0',...   % The root path of the RSM dataset
    'frameDir',      'frames_resized_w208p',... % Folder name where all the frames have been extracted.
    'descrDir',  ...
    '/home/jose/Code/localisation-from-visual-paths/descriptors', ...
    'dictionarySize', 4000, ...
    'dictPath',       './dictionaries', ...
    'encoding', 'HA', ... % 'HA', 'VLAD'
    'kernel', 'chi2', ... % 'chi2', 'Hellinger'
    'kernelPath', '/media/bg-angel/datasets/RSM/kernels/%s/%s/C%d', ... %../kernels/%s/%s/C%d', ... % '/media/bg-angel/datasets/RSM/kernels/%s/%s/C%d', ...
    'metric', 'max', ...
    'groundTruthPath', '/media/PictureThis/VISUAL_PATHS/v6.0/ground_truth', ... % ../ground_truth
    'debug', 0 ... % 1 shows waitbars, plots, etc. 0 does not.
    );

paramsQuery = struct(...
    'queryCorridor',     2,... % query corridor [1:6] (RSM v6.0)
    'querySet', [4], ...
    'kernelStr', 'C%d_kernel_%s_%s_P%s_%d.mat', ...
    'kernelPath', '../kernels/%s/%s/C%d' ...
    );

paramsTraining = struct(...
    'dictionarySet', [1:3,5], ...  % Passes that have been used to build dictionary.
    'trainingSet',   [1:3,5], ... 
    'numExamplesPerCell', 200 ... 
    );

%TODO, integrate with object properties
paramsCells = struct(...
    'numCells', 16, ...
    'sideSpan', 75, ...
    'smoothFac', 20, ... % 20 normal, 60 for generic plots 
    'threshold', 0.28 ... % 6 w/o normalization (DSIFT, SF_GABOR), 0.28 with norm
    );