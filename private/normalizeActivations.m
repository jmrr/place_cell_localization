function activations = normalizeActivations(activations, paramsCells, normFlag)

if (~normFlag)
    % Thresholding
    activations(activations <= paramsCells.threshold) = paramsCells.threshold;
elseif (normFlag == 1)
    % Thresholding and scaling
    activations(activations <= paramsCells.threshold) = paramsCells.threshold;
    totalMax = max(activations(:));
    activations = activations./totalMax;
elseif (normFlag > 1)
    % [0-1] normalization
    activations(activations <= paramsCells.threshold) = paramsCells.threshold;
    
    totalMax = max(activations(:));
    activations = (activations - paramsCells.threshold)/(totalMax - paramsCells.threshold);
end

% Output

activations = double(activations);  

end % function normalizeActivations