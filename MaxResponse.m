classdef MaxResponse < NeuralNetworkRegression
    
    properties (SetAccess = private)
        Max
    end
    
    methods (Static)
        % Constructor
        function obj = MaxResponse(varargin)
            if nargin > 1
                obj.NumCells = varargin{1};
                obj.NumObservations = varargin{2};
                obj.NumQueries = varargin{3};
                obj.NormFlag = varargin{4};
            end
        end
    end
    methods
        function obj = getMaxResponse(obj, paramsDataset, paramsTraining, paramsQuery)
            trainingSet     = paramsTraining.trainingSet;
            querySet        = paramsQuery.querySet;
            numQueryPasses  = length(querySet);
            
            trainingGt = getGroundTruth(paramsDataset, paramsQuery, trainingSet);
            queryGt = getGroundTruth(paramsDataset, paramsQuery, querySet);
            
            for i = 1:numQueryPasses
                activations = [];
                paramsQuery.queryPass = querySet(i);
                [results] = getKernel(paramsDataset, paramsTraining, paramsQuery);
                kernels = results.Kernel;
                
                for k = 1:length(kernels)
                    queryFrames = frameFromGroundTruth(queryGt{i}, obj.QueryLocations);
                    
                    activations{k} = kernels{k}(queryFrames, :)';
                end
            [maxCell, idxCell]  = cellfun(@(x) max(x,[],1), activations, 'UniformOutput', 0);
            maxArray            = cell2mat(maxCell'); 
            idxArray            = cell2mat(idxCell');
            
            [~, idx1] = max(maxArray, [], 1);
            
            for j = 1:size(idxArray,2)          
                idxMaxActivations(j) = idxArray(idx1(j), j);
            end
            
            end
        end
    end
    
end