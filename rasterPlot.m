function fH = rasterPlot(rasterMat, time, opt)
% fH = rasterPlot(rasterMat, time, opt)
%
% Function draws a raster plot of a spiking matrix.
% Input: rasterMat - spiking matrix.
%        time - corresponding time in seconds.
%        opt - an options structure variable with the following fields:
%          title - a figure title string.
%          dividingLine - a line dividing units that are positively and
%                         negatively correlated with the pupil area.
%          xLim - range.
%          yLabel - y-axis label.
% Output: fH - raster plot figure handle.


%% Adjust the range
dt = time(2) - time(1);
if time(1) < dt
  time2add = dt - time(1);
end
if nargin == 3 && isfield(opt, 'xLim') && ~isempty(opt.xLim)
  [~, timeLimInd1] = min(abs(time - opt.xLim(1)));
  [~, timeLimInd2] = min(abs(time - opt.xLim(2)));
  rasterMat = rasterMat(:, timeLimInd1:timeLimInd2);
  time = time(timeLimInd1:timeLimInd2);
end
period = time(end) - time(1);


%% Draw the raster
fH = figure;
p = pcolor(flipud(rasterMat));
p.EdgeColor = 'none';
colormap(flipud(gray));
%colormap(flipud([0 0 0; 1 1 1]));

nUnits = size(rasterMat,1);
if nargin == 3 && isfield(opt, 'dividingLine')
  hold on
  plot(xlim, nUnits-[opt.dividingLine opt.dividingLine], '--r', 'LineWidth',2)
  hold off
end


%% Calculate axes tick positions
nXTicks = 7;
timeTicks = floor((period/(nXTicks-1))/10)*10;
timeTicks = round(time(1)) + (timeTicks:timeTicks:(nXTicks-1)*timeTicks);
xAxesTicks = round(((timeTicks - time(1) - time2add)./period).*numel(time));
xTickLabel = cell(size(xAxesTicks));
for iTick = 1:numel(xAxesTicks)
  xTickLabel{iTick} = num2str(timeTicks(iTick));
end
xAxesTicks = [1 xAxesTicks];
xTickLabel = [num2str(round(time(1))), xTickLabel];

if nUnits < 4
  unitTicks = 1;
elseif nUnits < 40
  unitTicks = round(nUnits/4);
else
  unitTicks = round((nUnits/4)/10)*10;
end
unitTicks = unitTicks:unitTicks:4*unitTicks;
yAxesTicks = unitTicks;
yTickLabel = cell(size(yAxesTicks));
for iTick = 1:numel(yAxesTicks)
  yTickLabel{iTick} = num2str(unitTicks(iTick));
end
yAxesTicks = [fliplr(nUnits - yAxesTicks + 1) nUnits];
[yAxesTicks, inds] = unique(yAxesTicks);
yTickLabel = [fliplr(yTickLabel), '0'];
yTickLabel = yTickLabel(inds);


%% Tidy the figure
if nargin < 3 || ~isfield(opt, 'title')
  figOpt.titleStr = '';
else
  figOpt.titleStr = opt.title;
end
figOpt.boxStr = 'off';
figOpt.colour = 'w';
figOpt.font = 'Calibri';
figOpt.fontSz = 20;
figOpt.axesLineWidth = 2;
figOpt.tickLength = [0.01 0.025];
figOpt.tickDir = 'out';
figOpt.xVisible = 'off';
figOpt.xColour = 'k';
figOpt.xLabel = 'Time (s)';
figOpt.xRange = xlim;
figOpt.xTicks = xAxesTicks;
figOpt.xTickLabel = xTickLabel;
figOpt.yVisible = 'off';
figOpt.yColour = 'k';
if nargin < 3 || ~isfield(opt, 'yLabel')
  figOpt.yLabel = 'Units';
else
  figOpt.yLabel = opt.yLabel;
end
figOpt.yRange = ylim;
figOpt.yTicks = yAxesTicks;
figOpt.yTickLabel = yTickLabel;
axesPropertiesAugmented(figOpt);