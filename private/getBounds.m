function [lowerBound, upperBound] = getBounds(fr, sideSpan, lengthCurve)
% GETBOUNDS (deprecated, to be removed in next version). Given a central
% frame fr, the side span of a place cell and the length of the complete
% sequence, calculate the lower and upper bounds for an interval of length
% 2*sideSpan that does not go beyond the bounds of the sequence.
%

% Authors: Jose Rivera-Rubio
%          {jose.rivera}@imperial.ac.uk
% Date: April, 2015

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