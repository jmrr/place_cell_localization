classdef NeuralNetworkRegression < handle
    %NEURALNETWORKREGRESSION Neural network regression class for place cell localization
    
    properties
        % Number of cells desired for the experiment
        NumCells = 20; % 40 % 16
        
        % Number of observations
        NumObservations  = 400;
        
        % Number of queries and range of frames to consider
        NumQueries = 100 ; % 100
        
        % Flags
        NormFlag  = 0; % 0: No normalization
        
        % Locations
        Observations;
        CellLocations;
        QueryLocations;
        
        % inputs
        Input;
        Target;
        
        % query
        Query;
        
        % location estimate
        LocEstimate;
        
    end
    properties (SetAccess = private)
        % neural net (doesn't get inherited)
        Net;
    end
    methods (Static)
        % Constructor
        function obj = NeuralNetworkRegression(varargin)
            if nargin > 1
                obj.NumCells = varargin{1};
                obj.NumObservations = varargin{2};
                obj.NumQueries = varargin{3};
                obj.NormFlag = varargin{4};
            end
        end
    end
    methods
        function setLocations(obj, paramsDataset, paramsCells, paramsQuery)
            
            numObservations = obj.NumObservations;
            numQueries = obj.NumQueries;
            paramsCells.numCells = obj.NumCells;
            [obj.Observations, obj.CellLocations, obj.QueryLocations] =...
                locations(paramsDataset, paramsCells, paramsQuery, numObservations, numQueries);
            
        end
        
        function nnTrainingInput(obj, paramsDataset, paramsTraining, paramsQuery, paramsCells)
            
            paramsCells.numCells = obj.NumCells;
            [obj.Input, obj.Target] = neuralNetTrainingInput(...
                paramsDataset, paramsTraining, paramsQuery, paramsCells,...
                obj.Observations, obj.CellLocations, obj.NormFlag);
        end
        function nnTestInput(obj, paramsDataset, paramsTraining, paramsQuery, paramsCells)
            obj.Query = neuralNetTestInput(paramsDataset, paramsTraining, ...
                paramsQuery, paramsCells, obj.CellLocations, ...
                obj.QueryLocations, obj.NormFlag);
        end
        function train(obj)
            obj.Net = newgrnn(obj.Input, obj.Target);
        end
        function locEstimate = propagate(obj)
            locEstimate = sim(obj.Net, obj.Query);
            obj.LocEstimate = locEstimate;
        end
    end
end