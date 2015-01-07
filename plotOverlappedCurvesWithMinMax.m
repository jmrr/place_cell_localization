function plotOverlappedCurvesWithMinMax(curves,varargin)

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
    
    hCurves = plot(curves(i,:),'.','Color',rgbColor);

end % end for

xCoord      = [1:lenCurves, lenCurves:-1:1];
maxBoundary = max(curves,[],1);
minBoundary = min(curves,[],1);
meanCurve   = mean(curves,1);
hMean = plot(mean(curves,1),'LineWidth',4,'Color',rgbColor);
hFill = fill(xCoord,[maxBoundary fliplr(minBoundary)],rgbColor,'FaceAlpha', varargin{2});

legend([hCurves, hMean, hFill], {'Individual Tuning Curves', 'Mean', 'Variability'});


end % end function