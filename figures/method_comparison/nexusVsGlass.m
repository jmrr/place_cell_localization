figure
plot(estStack(:,1),'LineWidth',2)
hold on
plot(queryLocations(1:100)/100,'LineWidth', 1.5)
plotOverlappedCurvesWithMinMax(curves',1,0.3)