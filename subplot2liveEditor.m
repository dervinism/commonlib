function [figH, axesH] = subplot2liveEditor(fig, subplotRows)
% [figH, axesH] = subplot2liveEditor(fig, subplotRows)
%
% Function converts a traditional matlab subplot figure into a Live Editor
% figure.
% Input: fig - is either a figure handle or a figure filename.
%        subplotRows - number of subplot rows (see subplotFig for more
%                      info)
% Output figH - a figure handle of the Live Editor figure.
%        axesH - an axes handle.

if ischar(fig)
  fig = openfig(fig);
end

if ~isa(fig, 'matlab.ui.Figure')
  error('The supplied input is not a figure handle');
end

% Copy old figure to the new figure
axesH = zeros(1,numel(fig.Children));
axesCount = 0;
figH = subplotFig(subplotRows, 'on');

for child = 1:numel(fig.Children)
  if strcmp(fig.Children(child-axesCount).Type,'axes')
    set(fig.Children(child-axesCount), 'Parent',figH, 'Position',get(fig.Children(child-axesCount),'Position'));
    axesH(child) = gca;
    axesCount = axesCount + 1;
  end
end

set(figH,'color','w');
if ischar(fig)
  close(fig);
end