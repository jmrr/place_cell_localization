function locEstCorrected = correctLocEstimates(locEstimate, model)

    if model.NormFlag == 0
        locEstCorrected = locEstimate +  model.QueryLocations(round(end/2));
    else
        locEstCorrected = locEstimate.*(max(model.Observations));
    end

end