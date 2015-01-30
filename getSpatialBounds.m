function [lowerBound, upperBound] = getSpatialBounds(cellLocation, sideSpan, groundTruth)

lengthCurve = groundTruth(end);
sideSpanCm  = sideSpan*lengthCurve/length(groundTruth);

lowerBound = cellLocation-sideSpanCm+1;
upperBound = cellLocation+sideSpanCm;

if lowerBound < 1 && upperBound < lengthCurve
    
    upperBound = upperBound - lowerBound + 1; % lowerBound < 0 upperBound shifted to the right
    lowerBound = 1;
    
elseif lowerBound > 0 && upperBound > lengthCurve
    
    lowerBound = lowerBound - (upperBound - lengthCurve);
    upperBound = lengthCurve;
end


end  % end function