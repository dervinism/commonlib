function figH = subplotFig(nRows, visibility)
% figH = subplotFig(nRows)
%
% Function creates a blank figure that may be adjusted in size in a way
% that is useful for producing subplots.
% Input: nRows - a number of subplot rows (1-4). Number 4 actually stands
%                for a maximum possible height.
%        visibility - figure visibility ('on' or 'off'), default is 'on'.
% Outptu: figH - figure handle.

if nargin < 2
  visibility = 'on';
end

fullheight = 0.63; % in normalised units
bottomMargin = 0.24;
if nRows == 1
  height = fullheight/3;
elseif nRows == 2
  height = fullheight*2/3;
elseif nRows == 3
  height = fullheight;
elseif nRows == 4
  height = 1 - bottomMargin - 0.07;
end

figH = figure('units','normalized', 'position',[0.002, .04, 1, height + bottomMargin], 'Visible',visibility);