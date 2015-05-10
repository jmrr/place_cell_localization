function [locEstimate, queryLocations, mr, err, meanErr] = ...
    evaluateMaxMethod(paramsDataset, paramsQuery, paramsCells, ...
            paramsTraining, numMaxResponses)

% Max response method model

mr = MaxResponse(numMaxResponses);
mr.setLocations(paramsDataset, paramsCells, paramsQuery)
mr.nnTestInput(paramsDataset, paramsTraining, paramsQuery, paramsCells)
locEstimate = mr.getMaxResponse(paramsDataset, paramsTraining, paramsQuery);


%Evaluate 

queryLocations = repmat(mr.QueryLocations,1,length(paramsQuery.querySet));


err = abs(locEstimate - queryLocations);
meanErr = mean(err);
% Conversion to metres
meanErr = meanErr/100;

end