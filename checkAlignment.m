%% Setup

paramsDataset = struct(...
    'descriptor',    'DSIFT',...  % SIFT, DSIFT, SF_GABOR, ST_GABOR, ST_GAUSS,
    'corridors',     1:6,... % Corridors to run [1:6] (RSM v6.0)
    'passes',        1:10,... % Passes to run [1:10] (RSM v6.0)
    'datasetDir',    '/home/jose/PhD/Data/VISUAL_PATHS/v6.0',...   % The root path of the RSM dataset
    'frameDir',      'C%d/videos/%d/frames_resized_w208p',... % Folder name where all the frames have been extracted.
    'descrDir',  ...
    '/media/Data/localisation_from_visual_paths_data/descriptors', ...
    'dictionarySize', 4000, ...
    'dictPath',       './dictionaries', ...
    'encoding', 'HA', ... % 'HA', 'VLAD'
    'kernel', 'chi2', ... % 'chi2', 'Hellinger'
    'kernelPath', '../kernels/%s/%s/C%d', ...
    'metric', 'max', ...
    'groundTruthPath', '/home/jose/PhD/Data/VISUAL_PATHS/v6.0/ground_truth', ...
    'debug', 1 ... % 1 shows waitbars, 0 does not.
    );

paramsQuery = struct(...
    'queryCorridor',     2,... % query corridor [1:6] (RSM v6.0)
    'queryPass',        1,... % query pass [1:10] (RSM v6.0)
    'kernelStr', 'C%d_kernel_%s_%s_P%s_%d.mat', ...
    'kernelPath', '../kernels/%s/%s/C%d' ...
    );

queryLocs = [40, 245, 455, 675, 1000, 1200, 1400, 1600];

%% Get kernels

[results, trainingSet] = getKernel(paramsDataset, paramsQuery);
kernels = results.Kernel;

for q = queryLocs
    %% Get frameLocations for a given query
    
    numKernels = size(kernels,2);
    groundTruthStr = 'ground_truth_C%d_P%d.csv';
    
    % Get training ground truth
    j = 1;
    
    for i = trainingSet
        gtFname = sprintf(groundTruthStr,paramsQuery.queryCorridor,i);
        groundTruth{j} = csvread(fullfile(paramsDataset.groundTruthPath,gtFname),1,1);
        j = j+1;
    end % end for
    
    % Get query ground truth
    queryGtFname = sprintf(groundTruthStr,paramsQuery.queryCorridor,paramsQuery.queryPass);
    queryGt = csvread(fullfile(paramsDataset.groundTruthPath,queryGtFname),1,1);
    
    posQueryLoc = queryGt(round(q));
    [m cellLocs]   = cellfun(@(x) min(abs(x-posQueryLoc)),groundTruth,'UniformOutput',0);
    frameLocations = cell2mat(cellLocs)
    
    %% Get filename and display
    
    displayFrameLocs = [q frameLocations]
    
    filenameStr = fullfile(paramsDataset.datasetDir,paramsDataset.frameDir,'%05d.jpg');
    
    hfig =figure
    scrsz = get(0,'ScreenSize');
    set(hfig,'Position',[scrsz(1) scrsz(2) scrsz(3) scrsz(4)])
    rows = 2;
    for idx = 1:length(displayFrameLocs)
        
        filename = sprintf(filenameStr,paramsQuery.queryCorridor,idx,displayFrameLocs(idx));
        img = imread(filename);
        subplot(rows, length(displayFrameLocs)/rows,idx)
        imagesc(img);
        if (idx == 1)
            title(['Query frame #' num2str(displayFrameLocs(idx))]);
        else
            title(['Db' num2str(trainingSet(idx-1)) ' frame #' num2str(displayFrameLocs(idx))]);
        end
    end
    
    pause
end