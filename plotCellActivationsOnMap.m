% Plot cell activations on map

% Position of cells (to be determined automatically)
cellPos = [40, 144, 245, 356, 455, 600, 675, 793];

lenCorr = 847; % no. of frames for that pass/corridor

%% load map image and map trajectory

map = imread('map/map.png');

load('map/C2_trajectory_coordinates.mat');

lenCorrMap = size(c2Coords,1);

% Position of circles in the map figure

circlePosOnMap = round(cellPos*lenCorrMap/lenCorr);
radius = 10; % Radius in pixels
% Plot

figure;
imshow(map);

for i = 1:length(circlePosOnMap)
    
    circles(c2Coords(circlePosOnMap(i),1),c2Coords(circlePosOnMap(i),2),radius);

end %end for