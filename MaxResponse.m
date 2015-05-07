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
        function locEstimate = getMaxResponse(obj, paramsDataset, paramsTraining, paramsQuery)
            trainingSet     = randi(length(paramsTraining.trainingSet)); % TODO: Change to more than one training pass -> trainingSet = paramsTraining.trainingSet
            querySet        = paramsQuery.querySet;
            numQueryPasses  = length(querySet);
            
            trainingGt = getGroundTruth(paramsDataset, paramsQuery, trainingSet);
            queryGt = getGroundTruth(paramsDataset, paramsQuery, querySet);
            
            for i = 1:numQueryPasses
                activations = [];
                paramsQuery.queryPass = querySet(i);
                [results] = getKernel(paramsDataset, paramsTraining, paramsQuery);
                kernels = results.Kernel;
                
                queryFrames = frameFromGroundTruth(queryGt{i}, obj.QueryLocations);
                
%                 % ToDo. Correct kernels with ground truth
%                 for k = 1:length(trainingSet)          
%                     activations{k} = kernels{k}(queryFrames, :)';
%                 end
                
                     activations{1} = kernels{trainingSet}(queryFrames, :)';

                [maxCell, idxCell]  = cellfun(@(x) max(x,[],1), activations, 'UniformOutput', 0);
                maxArray            = cell2mat(maxCell');
                idxArray            = cell2mat(idxCell');
                
                [~, idx1] = max(maxArray, [], 1);
                
                for j = 1:size(idxArray,2)
                    idxMaxActivations(j) = idxArray(idx1(j), j);
                    locEstimate(j) = queryGt{1}(idxMaxActivations(j));
                end
                
                
            end
        end
    end
    
end