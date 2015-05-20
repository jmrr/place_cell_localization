function locEstCorrected = correctLocEstimates(locEstimate, model)

if model.NormFlag > 0
    locEstCorrected = locEstimate.*(max(model.Observations));
else
    locEstCorrected = locEstimate +  model.QueryLocations(round(end/2));
end

end