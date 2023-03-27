function [h, troughValue] = histPlot(edges, bars, options)
% [h, troughValue] = histPlot(edges, bars, options)
%
% Function histPlot draws a histogram.
% Input: edges
%        bars - binned counts. You can pre-append a count of
%               non-significant values.
%        options - a structure variable with fields:
%          figName - a figure name and filename string.
%          figFolder
%          xLabel
%          yLabel
%          transparent
%          coloured
%          figSize - a figure window size.
%          saveFig - a logical for saving the figure. Default is true.
%          splitModes - a logical for marking two modes. Default is false.
%          dataScatter - data values that were used to produce the
%                        histograms. dataScatter should be supplied if the
%                        splitModes option was set to true.
% Output: h - figure handle.
%         troughValue - an x value splitting two modes of the distribution
%                       in case the option splitModes was set to true.
%                       Otherwise it is an empty array.


%% Parse user input
if nargin < 3 || ~isfield(options, 'figName') || isempty(options.figName)
  options.figName = 'countHistogram';
end
if nargin < 3 || ~isfield(options, 'figFolder') || isempty(options.figFolder)
  options.figFolder = pwd;
end
if nargin < 3 || ~isfield(options, 'xLabel') || isempty(options.xLabel)
  options.xLabel = 'X';
end
if nargin < 3 || ~isfield(options, 'yLabel') || isempty(options.yLabel)
  options.yLabel = 'Count';
end
if nargin < 3 || ~isfield(options, 'transparent') || isempty(options.transparent)
  options.transparent = false;
end
if nargin < 3 || ~isfield(options, 'coloured') || isempty(options.coloured)
  options.coloured = false;
end
if nargin < 3 || ~isfield(options, 'figSize') || isempty(options.figSize)
  options.figSize = 15;
end
if nargin < 3 || ~isfield(options, 'saveFig') || isempty(options.saveFig)
  options.saveFig = true;
end
if nargin < 3 || ~isfield(options, 'splitModes') || isempty(options.splitModes)
  options.splitModes = false;
end
if nargin < 3 || ~isfield(options, 'dataScatter') || isempty(options.dataScatter)
  options.dataScatter = [];
end


%% Draw the histogram
h = figProperties(options.figName, 'normalized', [0, .005, .97, .90], 'w', 'on');
hold on

if numel(bars) == numel(edges)
  
  % With non-signif bar
  centres = edges(2:end);
  yTick = ceil(max(bars(2:end))/2);
  if bars(1) > max(bars(2:end))
    text(1, 0.2*yTick, num2str(bars(1)), 'FontSize',25)
  else
    bar(2, bars(1), 'k');
  end
  barCount = numel(edges)-1;
  xTickStep = barCount/4;
  barPositions = zeros(1,barCount);
  for i = 2:numel(bars)
    barPositions(i-1) = 7*(round(barCount/16))+i-1;
    if options.coloured && options.transparent
      bar(barPositions(i-1), bars(i), 'EdgeColor',matlabColours(i), 'FaceColor','None');
    elseif options.coloured && ~options.transparent
      bar(barPositions(i-1), bars(i), 'EdgeColor',matlabColours(i), 'FaceColor',matlabColours(i));
    elseif ~options.coloured && options.transparent
      bar(barPositions(i-1), bars(i), 'EdgeColor','k', 'FaceColor','None');
    else
      bar(barPositions(i-1), bars(i), 'k');
    end
  end
  ax1 = axesProperties({}, 1, 'normal', 'off', 'w', 'Calibri', 25, 4/3, 2, [0.005 0], 'out',...
    'on', 'k', {options.xLabel}, [0 barPositions(end)+1], [2 barPositions(1)-0.5 barPositions(1)+xTickStep+0.5 barPositions(1)+2*xTickStep+0.5 barPositions(1)+3*xTickStep+0.5 barPositions(end)+0.5],...
    'on', 'k', {options.yLabel}, [0 yTick*2+1], 0:yTick:yTick*2);
  if edges(1) < 0
    ax1.XTickLabel = {'non-signif.',num2str(edges(1)),num2str(edges(1)/2),num2str(0),num2str(edges(end)/2),num2str(edges(end))};
  else
    ax1.XTickLabel = {'non-signif.',num2str(0),num2str(edges(end)/4),num2str(edges(end)/2),num2str(edges(end)*0.75),num2str(edges(end))};
  end
  
elseif numel(bars)+1 == numel(edges)
  
  % Without non-signif bar
  centres = edges;
  yTick = ceil(max(bars)/2);
  barCount = numel(edges)-1;
  xTickStep = (barCount-1)/4;
  barPositions = zeros(1,barCount);
  for i = 1:numel(bars)
    barPositions(i) = i;
    if options.coloured && options.transparent
      bar(barPositions(i), bars(i), 'EdgeColor',matlabColours(i), 'FaceColor','None');
    elseif options.coloured && ~options.transparent
      bar(barPositions(i), bars(i), 'EdgeColor',matlabColours(i), 'FaceColor',matlabColours(i));
    elseif ~options.coloured && options.transparent
      bar(barPositions(i), bars(i), 'EdgeColor','k', 'FaceColor','None');
    else
      bar(barPositions(i), bars(i), 'k');
    end
  end
  ax1 = axesProperties({}, 1, 'normal', 'off', 'w', 'Calibri', 25, 4/3, 2, [0.005 0], 'out',...
    'on', 'k', {options.xLabel}, [0 barPositions(end)+1], [barPositions(1)-0.5 barPositions(1)+xTickStep barPositions(1)+2*xTickStep barPositions(1)+3*xTickStep barPositions(end)+0.5],...
    'on', 'k', {options.yLabel}, [0 yTick*2+1], 0:yTick:yTick*2);
  if edges(1) < 0
    ax1.XTickLabel = {num2str(edges(1)),num2str(edges(1)/2),num2str(0),num2str(edges(end)/2),num2str(edges(end))};
  else
    ax1.XTickLabel = {num2str(0),num2str(edges(end)/4),num2str(edges(end)/2),num2str(edges(end)*0.75),num2str(edges(end))};
  end
  
else
  error('Supplied histogram edges do not correspond to the data')
end
set(h, 'Name',options.figName);


%% Split modes
if options.splitModes
  
  % Mark the split
  if numel(bars) == numel(edges)
    [peaks, peakLocs] = findpeaks(bars(2:end));
    if numel(peaks) > 1
      [~, modeLocs] = maxk(peaks, 2);
      modeLocs = peakLocs(modeLocs);
      [~, troughLoc] = min(bars(1+(min(modeLocs):max(modeLocs))));
      troughLoc = min(modeLocs) + troughLoc - 1;
      troughValue = centres(troughLoc-1);
      troughLoc = 7*(round(barCount/16))-1 + troughLoc+1;
    end
  elseif numel(bars)+1 == numel(edges)
    [peaks, peakLocs] = findpeaks(bars);
    if numel(peaks) > 1
      [~, modeLocs] = maxk(peaks, 2);
      modeLocs = peakLocs(modeLocs);
      [~, troughLoc] = min(bars(min(modeLocs):max(modeLocs)));
      troughLoc = min(modeLocs) + troughLoc - 1;
      troughValue = centres(troughLoc);
    end
  end
  if numel(peaks) > 1
    plot([troughLoc troughLoc], ylim, 'r:');
    
    % Estimate fractions of the two modes and indicate them in the figure
    if ~isempty(options.dataScatter)
      narrowSpikeUnitCount = sum(options.dataScatter <= troughValue);
      wideSpikeUnitCount = sum(options.dataScatter > troughValue);
      narrowSpikeUnitFraction = round(100*narrowSpikeUnitCount/(narrowSpikeUnitCount + wideSpikeUnitCount),1);
      wideSpikeUnitFraction = round(100*wideSpikeUnitCount/(narrowSpikeUnitCount + wideSpikeUnitCount),1);
      
      xLim = xlim;
      xAxisLength = xLim(2)-xLim(1);
      yLim = ylim;
      yAxisLength = yLim(2)-yLim(1);
      
      textStr = [num2str(narrowSpikeUnitFraction) '/' num2str(wideSpikeUnitFraction)];
      text(xLim(2)-xAxisLength*0.2, yLim(2)-yAxisLength*0.05, textStr, 'FontSize',20);
    end
  else
    troughValue = [];
  end
else
  troughValue = [];
end
hold off


%% Save the figure
if options.saveFig
  label = [4 3];
  margin = [0.7 1];
  width = 1.3*options.figSize-label(1)-margin(1);
  height = (1.3*options.figSize)-label(2)-margin(2);
  paperSize = resizeFig(h, ax1, width, height, label, margin, 0);
  hgsave(h, [options.figFolder filesep options.figName '.fig']);
  exportFig(h, [options.figFolder filesep options.figName '.png'],'-dpng','-r300', paperSize);
  close(h);
end
end