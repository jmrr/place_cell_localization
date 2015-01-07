function [lowerBound, upperBound] = getBounds(fr, sideSpan, lengthCurve)

lowerBound = fr-sideSpan+1;
upperBound = fr+sideSpan;

if lowerBound < 1 && upperBound < lengthCurve
    
    upperBound = upperBound - lowerBound + 1; % lowerBound < 0 upperBound shifted to the right
    lowerBound = 1;
    
elseif lowerBound > 0 && upperBound > lengthCurve
    
    lowerBound = lowerBound - (upperBound - lengthCurve);
    upperBound = lengthCurve;
end

end