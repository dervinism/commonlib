% A script to test circ_confmeanFisher function. The example is taken from
% p. 146 of Mardia (1972) and tested against Fisher & Lewis (1983).
%
% References:
%   Mardia, K. V. (1972). Statistics of Directional Data. London: Academic
%   Press.
%   Fisher, N. I. & Lewis, T. (1983). Estimating the common mean direction
%   of several circular or spherical distributions with differing
%   dispersions. Biometrika 70, 333-41.

angularDataDeg = [85 135 135 140 145 150 150 150 160 185 200 210 220 225 270];
angularDataRad = deg2rad(angularDataDeg);
n = numel(angularDataRad);
dataMeanRad = circmean(angularDataRad(~isnan(angularDataRad)));
dataMeanDeg = rad2deg(dataMeanRad);
R = circ_r(angularDataRad,[],[],2);

tRad = circ_confmeanFisher(angularDataRad, 0.05, 2);
tDeg = rad2deg(tRad);