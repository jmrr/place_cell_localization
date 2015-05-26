function target = normalizeTargets(observations, normFlag, numTrainingPasses)

if (normFlag > 0)
    target = observations./max(observations);
else  
    target = observations - observations(round(end/2)); % Observations locations to be restricted between +/- lastObservation/2
end
target = repmat(target(1,:),1,numTrainingPasses);

end % end normalizeTargets