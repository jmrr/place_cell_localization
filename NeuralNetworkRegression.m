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
        NormFlag  = 0; % 0: Thresholding only, 1: thresholding and scaling, 2: thresholding and [0:1] normalization.
        
        % Observations locations
        Observations;
        % Cell locations
        CellLocations;
        % Query frames locations
        QueryLocations;
        % Number of frames in the corridor
        FramesCorr;
        
        % Training input
        Input;
        % Target labels (positions)
        Target;
        
        % Query inputs
        Query;
        
        % location estimates
        LocEstimate;
        
    end
    properties (SetAccess = private)
        % neural net (doesn't get inherited)
        Net;
        % RBF spread
        Spread = 0.1;
    end
    methods (Static)
        % Constructor
        function obj = NeuralNetworkRegression(varargin)
            if nargin > 1 && nargin <= 4
                obj.NumCells        = varargin{1};
                obj.NumObservations = varargin{2};
                obj.NumQueries      = varargin{3};
                obj.NormFlag        = varargin{4};
            elseif nargin > 4
                obj.NumCells = varargin{1};
                obj.NumObservations = varargin{2};
                obj.NumQueries      = varargin{3};
                obj.NormFlag        = varargin{4};
                obj.Spread          = varargin{5};
            end
        end
    end
    methods
        function setLocations(obj, paramsDataset, paramsCells, paramsQuery)
            
            numObservations = obj.NumObservations;
            numQueries      = obj.NumQueries;
            paramsCells.numCells = obj.NumCells;
            [obj.Observations, obj.CellLocations, obj.QueryLocations, obj.FramesCorr] =...
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
            obj.Net = newgrnn(obj.Input, obj.Target, obj.Spread);
        end
        function locEstimate = propagate(obj)
            locEstimate     = sim(obj.Net, obj.Query);
            obj.LocEstimate = locEstimate;
        end
        function plotTuningCurves(obj, paramsCells, paramsDataset, paramsQuery, paramsTraining)
            activations     = reshape(obj.Input, obj.NumCells, obj.NumObservations, []);
            meanActivations = squeeze(mean(activations, 3));
            midPoint        = round(length(meanActivations))/2;
            if paramsCells.sideSpan < obj.NumObservations/2;
                sideSpan = paramsCells.sideSpan;
            else
                sideSpan = round(obj.NumObservations/2);
            end
            trainingGt      = getGroundTruth(paramsDataset,paramsQuery,paramsTraining.trainingSet);
            cellFrames      = frameFromGroundTruth(trainingGt{1}, obj.CellLocations);

            for i = 1:obj.NumCells
                [lb, ub] = getBounds(cellFrames(i), sideSpan, obj.FramesCorr); % Lower and upper boundaries for cell support
                [lbA, ubA] = getBounds(midPoint, sideSpan, obj.NumObservations); % Lower and upper boundaries for cell values
                plot(lb:ub, smooth(meanActivations(i,lbA:ubA),paramsCells.smoothFac),'LineWidth',2);
                legendStr{i} = ['APC' num2str(i)];
                hold on; axis tight;
            end
            ylabel('APC Responses (A.U.)')
            xlabel('Distance from origin (m)')
            newLabels = trainingGt{1}(get(gca,'XTick'));
            set(gca,'XTickLabel',round(newLabels/100));
            legend(legendStr)
        end
    end
end