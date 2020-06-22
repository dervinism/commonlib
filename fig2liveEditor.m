function [figH, axes] = fig2liveEditor(fig, xLim, yLim, legendPosition)
% [figH, axes] = fig2liveEditor(fig, xLim, yLim, legendPosition)
%
% Function converts a traditional matlab figure into a Live Editor figure.
% Input: fig - is either a figure handle or a figure filename.
%        xLim - x-axis limits (optional).
%        yLim - y-axis limits (optional).
%        legendPosition - legend position string (optional).
% Output figH - a figure handle of the Live Editor figure.
%        axes - an axes handle.

if nargin < 4
  legendPosition = [];
end

if nargin < 3
  yLim = [];
end

if nargin < 2
  xLim = [];
end

if ischar(fig)
  fig = openfig(fig);
end

if ~isa(fig, 'matlab.ui.Figure')
  error('The supplied input is not a figure handle');
end

% Copy old figure to the new figure
figH = figure;
for child = 1:numel(fig.Children)
  if strcmp(fig.Children(child).Type,'axes')
    set(fig.Children(child), 'Parent',figH);
    axes = gca;
    remainingAxes = numel(fig.Children);
    if remainingAxes <= child
      break
    end
  end
end

% Adjust the new figure
if ~isempty(xLim)
  xlim(xLim);
end

if ~isempty(yLim)
  ylim(yLim);
end

if ~isempty(legendPosition)
  for child = 1:numel(figH.Children)
    if strcmp(figH.Children(child).Type,'legend')
      set(figH.Children(child), 'Location',legendPosition);
      return
    end
  end
end

if ischar(fig)
  close(fig);
end