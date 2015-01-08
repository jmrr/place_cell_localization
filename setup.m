paramsDataset = struct(...
    'descriptor',    'DSIFT',...  % SIFT, DSIFT, SF_GABOR, ST_GABOR, ST_GAUSS,
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
    'kernelPath', '../kernels/%s/%s/C%d', ...
    'metric', 'max', ...
    'groundTruthPath', '../ground_truth', ...
    'debug', 1 ... % 1 shows waitbars, 0 does not.
    );

paramsQuery = struct(...
    'queryCorridor',     1,... % query corridor [1:6] (RSM v6.0)
    'queryPass',        2,... % query pass [1:10] (RSM v6.0)
    'kernelStr', 'C%d_kernel_%s_%s_P%s_%d.mat', ...
    'kernelPath', '../kernels/%s/%s/C%d' ...
    );
