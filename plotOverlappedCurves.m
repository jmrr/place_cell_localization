function plotOverlappedCurves(curves,varargin)

if nargin > 1 % Parse multiple inputs
    withSmoothing = 1;
end

numCurves = size(curves,1);
lenCurves = size(curves,2);
figure;
rgbColor = [0 0.447 0.741];
hold on
for i = 1:numCurves
    
    if withSmoothing
        curves(i,:) = smooth(curves(i,:),varargin{1});
    end
    
    plot(curves(i,:),'.','Color',rgbColor);
end % end for
    
    plot(mean(curves,1),'LineWidth',4,'Color',rgbColor);

end % end function