function [fH, rCoef, pval, model] = corrPlot(var1, var2, options)
% [fH, rCoef, pval, model] = corrPlot(var1, var2, options)
%
% Function correlates two data vectors and produces a correlation graphs
% displaying r coefficient and p values, as well as, the number of
% values that are not NaN simultaneously in the two vectors out of the
% total number of elements.
% Input: var1 - data vector one.
%        var2 - data vector two.
%        options - a structure field with the follwoing options:
%          corrType - type of correlation with choices being 'Pearson',
%                     'Spearman', 'circular', 'circularnp', 'circlinear',
%                     and 'circlinearnp'. The default is 'Pearson'.
%          figTitle
%          figName - figrue name and figure file name
%          figFolder - folder for saving figures
%          xLim
%          xLabel
%          xTicks
%          yLim
%          yLabel
%          yTicks
%          axesType - a string defining axes type: 'semilogx', 'semilogy',
%                     'loglog', 'regular'. Default is regular.
%          diagonal - true if you need to plot a diagonal line. Default is
%                     false.
%          figSize
%          saveFig - true if you want to save the figure. Default is false.
%          fitLine - true or false (default) for fitting a line to the
%                    data.
%          fitLineDisplay - 'on' or 'off' (default) for displaying a fitted
%                           line to the data.
%          colourVector - a vector with different numbers corresponding to
%                         different colours. If no colour codes are
%                         supplied, the matlabColours function will be used
%                         to determine the colour with unique elements of
%                         the vector used as inputs to matlabColours
%                         function (default). Otherwise, colours will be
%                         determined by reference to the colourCodes field.
%                         If left empty, all data points will have the same
%                         colour (default). The number of elements in the
%                         colourVector field has to be the same as in the
%                         data vectors.
%          colourCodes - a three column row matrix with each row
%                        corresponding to an RGB colour code. These rows
%                        are referenced by the colourVector field. If left
%                        empty, matlabColours function will be used to pick
%                        up colour codes (default).
%          edgeColourVector - same as colourVector but applies only to the
%                             marker edge.
%          edgeColourCodes - same as colourCodes but applies only to the
%                            marker edge.
%          faceColourVector - a three-column RGB colour code matrix with
%                             rows corresponding to individual data points.
% Output: fH - figure handle.
%         rCoef - correlation coefficient.
%         pval - correlation p value.
%         model - coefficients of the fitted line in case when the fit was
%                 requested: model(1) is the slope of the line while
%                 model(2) is the intercept.


%% Parse user input
if isempty(var1) || isempty(var2)
  fH = []; rCoef = []; pval = []; model = [];
  return
end
if nargin < 3 || ~isfield(options, 'corrType') || isempty(options.corrType)
  options.corrType = 'Pearson';
end
if nargin < 3 || ~isfield(options, 'figTitle')
  options.figTitle = [];
end
if nargin < 3 || ~isfield(options, 'figName')
  options.figName = [];
end
if nargin < 3 || ~isfield(options, 'figFolder') || isempty(options.figFolder)
  options.figFolder = pwd;
end
if nargin < 3 || ~isfield(options, 'xLim')
  options.xLim = [];
end
if nargin < 3 || ~isfield(options, 'xLabel')
  options.xLabel = 'x';
end
if nargin < 3 || ~isfield(options, 'xTicks')
  options.xTicks = [];
end
if nargin < 3 || ~isfield(options, 'yLim')
  options.yLim = [];
end
if nargin < 3 || ~isfield(options, 'yLabel')
  options.yLabel = 'y';
end
if nargin < 3 || ~isfield(options, 'yTicks')
  options.yTicks = [];
end
if nargin < 3 || ~isfield(options, 'axesType') || isempty(options.axesType)
  options.axesType = 'regular';
end
if nargin < 3 || ~isfield(options, 'diagonal') || isempty(options.diagonal)
  options.diagonal = false;
end
if nargin < 3 || ~isfield(options, 'figSize') || isempty(options.figSize)
  options.figSize = 15;
end
if nargin < 3 || ~isfield(options, 'saveFig') || isempty(options.saveFig)
  options.saveFig = false;
end
if nargin < 3 || ~isfield(options, 'fitLine') || isempty(options.fitLine)
  options.fitLine = false;
end
if nargin < 3 || ~isfield(options, 'fitLineDisplay') || isempty(options.fitLineDisplay)
  options.fitLineDisplay = 'off';
end
if nargin < 3 || ~isfield(options, 'colourVector')
  options.colourVector = [];
end
if nargin < 3 || ~isfield(options, 'colourCodes')
  options.colourCodes = [];
end
if nargin < 3 || ~isfield(options, 'edgeColourVector')
  options.edgeColourVector = [];
end
if nargin < 3 || ~isfield(options, 'edgeColourVector')
  options.edgeColourVector = [];
end
if nargin < 3 || ~isfield(options, 'faceColourVector')
  options.faceColourVector = [];
end


%% Correlation analysis
inds = ~isnan(var1) & ~isnan(var2);
var1 = torow(var1(inds));
var2 = torow(var2(inds));
if strcmpi(options.corrType,'circlinearnp')
  [rCoef, pval] = corrMulti(var2, var1, options.corrType);
else
  [rCoef, pval] = corrMulti(var1, var2, options.corrType);
end


%% Figure name and data
fH = figure;
if isempty(options.faceColourVector) && isempty(options.colourVector)
  n.significant = sum(inds);
  n.total = numel(inds);
  if strcmpi(options.axesType, 'regular')
    plot(var1, var2, '.', 'MarkerSize',5);
  elseif strcmpi(options.axesType, 'semilogx')
    semilogx(var1, var2, '.', 'MarkerSize',5);
  elseif strcmpi(options.axesType, 'semilogy')
    semilogy(var1, var2, '.', 'MarkerSize',5);
  elseif strcmpi(options.axesType, 'loglog')
    loglog(var1, var2, '.', 'MarkerSize',5);
  end
  hold on
else
  if isempty(options.faceColourVector)
    n.significant = sum(inds);
    n.total = numel(inds);
    options.colourVector = options.colourVector(inds);
    colourRefs = unique(options.colourVector);
    for iColour = 1:numel(colourRefs)
      colourInds = false(size(options.colourVector));
      colourInds(options.colourVector == colourRefs(iColour)) = true;
      if isempty(options.colourCodes)
        colourCode = matlabColours(colourRefs(iColour));
      else
        colourCode = options.colourCodes(colourRefs(iColour),:);
      end
      if strcmpi(options.axesType, 'regular')
        plot(var1(colourInds), var2(colourInds), '.', 'MarkerSize',5, 'Color',colourCode);
      elseif strcmpi(options.axesType, 'semilogx')
        semilogx(var1(colourInds), var2(colourInds), '.', 'MarkerSize',5, 'Color',colourCode);
      elseif strcmpi(options.axesType, 'semilogy')
        semilogy(var1(colourInds), var2(colourInds), '.', 'MarkerSize',5, 'Color',colourCode);
      elseif strcmpi(options.axesType, 'loglog')
        loglog(var1(colourInds), var2(colourInds), '.', 'MarkerSize',5, 'Color',colourCode);
      end
      if iColour == 1
        hold on
      end
    end
  else
    options.faceColourVector = options.faceColourVector(inds,:);
    indsNonSignif = ismember(options.faceColourVector, [1 1 1], 'rows');
    n.significant = sum(~indsNonSignif);
    n.total = numel(inds);
    p = zeros(numel(options.edgeColourVector),1);
    for iData = 1:size(options.faceColourVector,1)
      if strcmpi(options.axesType, 'regular')
        p(iData) = plot(var1(iData), var2(iData), 'o', 'MarkerSize',5, 'MarkerFaceColor',options.faceColourVector(iData,:),...
          'MarkerEdgeColor',options.edgeColourCodes(options.edgeColourVector(iData),:));
      elseif strcmpi(options.axesType, 'semilogx')
        p(iData) = semilogx(var1(iData), var2(iData), 'o', 'MarkerSize',5, 'MarkerFaceColor',options.faceColourVector(iData,:),...
          'MarkerEdgeColor',options.edgeColourCodes(options.edgeColourVector(iData),:));
      elseif strcmpi(options.axesType, 'semilogy')
        p(iData) = semilogy(var1(iData), var2(iData), 'o', 'MarkerSize',5, 'MarkerFaceColor',options.faceColourVector(iData,:),...
          'MarkerEdgeColor',options.edgeColourCodes(options.edgeColourVector(iData),:));
      elseif strcmpi(options.axesType, 'loglog')
        p(iData) = loglog(var1(iData), var2(iData), 'o', 'MarkerSize',5, 'MarkerFaceColor',options.faceColourVector(iData,:),...
          'MarkerEdgeColor',options.edgeColourCodes(options.edgeColourVector(iData),:));
      end
      if iData == 1
        hold on
      end
    end
    if sum(indsNonSignif)
      uistack(p(indsNonSignif), 'bottom');
    end
  end
end
figTitle = [options.figTitle...
  ' r=' num2str(rCoef) ' p=' num2str(pval)...
  ' n=' num2str(n.significant) '/' num2str(n.total)];
title(figTitle);
set(fH, 'Name',options.figName);
figName = [options.figFolder filesep options.figName];
figName = strrep(figName, ' ', '_');
figName = strrep(figName, '.', 'p');


%% Figure text and axes limits
xLim = xlim;
if isfield(options, 'xLim') && ~isempty(options.xLim)
  if xLim(1) < 0
    xLim(1) = max([options.xLim(1)*1.05 xLim(1)]);
  else
    xLim(1) = max([options.xLim(1)*0.95 xLim(1)]);
  end
  if xLim(2) < 0
    xLim(2) = min([options.xLim(2)*0.95 xLim(2)]);
  else
    xLim(2) = min([options.xLim(2)*1.05 xLim(2)]);
  end
end
xAxisLength = xLim(2)-xLim(1);
xLimLog = log10(xLim);
xAxisLengthLog = xLimLog(2)-xLimLog(1);
yLim = ylim;
if isfield(options, 'yLim') && ~isempty(options.yLim)
  if yLim(1) < 0
    yLim(1) = max([options.yLim(1)*1.05 yLim(1)]);
  else
    yLim(1) = max([options.yLim(1)*0.95 yLim(1)]);
  end
  if yLim(2) < 0
    yLim(2) = min([options.yLim(2)*0.95 yLim(2)]);
  else
    yLim(2) = min([options.yLim(2)*1.05 yLim(2)]);
  end
end
yAxisLength = yLim(2)-yLim(1);
yLimLog = log10(yLim);
yAxisLengthLog = yLimLog(2)-yLimLog(1);
if strcmpi(options.axesType, 'regular')
  text(xLim(2)-xAxisLength*0.3, yLim(1)+yAxisLength*0.2, ['r=' num2str(rCoef)], 'FontSize',16);
  text(xLim(2)-xAxisLength*0.3, yLim(1)+yAxisLength*0.1, ['p=' num2str(pval)], 'FontSize',16);
  text(xLim(1)+xAxisLength*0.025, yLim(2)-yAxisLength*0.05,...
    ['n=' num2str(n.significant) '/' num2str(n.total)], 'FontSize',16);
elseif strcmpi(options.axesType, 'semilogx')
  text(10^(xLimLog(1)+xAxisLengthLog*0.7), yLim(1)+yAxisLength*0.2, ['r=' num2str(rCoef)], 'FontSize',16);
  text(10^(xLimLog(1)+xAxisLengthLog*0.7), yLim(1)+yAxisLength*0.1, ['p=' num2str(pval)], 'FontSize',16);
  text(10^(xLimLog(1)+xAxisLengthLog*0.025), yLim(2)-yAxisLength*0.05,...
    ['n=' num2str(n.significant) '/' num2str(n.total)], 'FontSize',16);
elseif strcmpi(options.axesType, 'semilogy')
  text(xLim(2)-xAxisLength*0.3, 10^(yLimLog(1)+yAxisLengthLog*0.2), ['r=' num2str(rCoef)], 'FontSize',16);
  text(xLim(2)-xAxisLength*0.3, 10^(yLimLog(1)+yAxisLengthLog*0.1), ['p=' num2str(pval)], 'FontSize',16);
  text(xLim(1)+xAxisLength*0.025, 10^(yLimLog(1)+yAxisLengthLog*0.95),...
    ['n=' num2str(n.significant) '/' num2str(n.total)], 'FontSize',16);
elseif strcmpi(options.axesType, 'loglog')
  text(10^(xLimLog(1)+xAxisLengthLog*0.7), 10^(yLimLog(1)+yAxisLengthLog*0.2), ['r=' num2str(rCoef)], 'FontSize',16);
  text(10^(xLimLog(1)+xAxisLengthLog*0.7), 10^(yLimLog(1)+yAxisLengthLog*0.1), ['p=' num2str(pval)], 'FontSize',16);
  text(10^(xLimLog(1)+xAxisLengthLog*0.025), 10^(yLimLog(1)+yAxisLengthLog*0.95),...
    ['n=' num2str(n.significant) '/' num2str(n.total)], 'FontSize',16);
end


%% Diagonal line
if isfield(options, 'diagonal') && options.diagonal
  diagStart = max([xLim(1) xLim(1)]);
  diagStop = min([xLim(2) xLim(2)]);
  xAxisLength = diagStop-diagStart;
  xAxisStep = xAxisLength/10000;
  xDiag = diagStart:xAxisStep:diagStop;
  yDiag = xDiag;
  p = plot(xDiag, yDiag, ':k');
  uistack(p, 'bottom');
end
hold off
xlim(xLim);
ylim(yLim);


%% Line fit
if options.fitLine
  [~, slope, model] = fitLine(var1, var2);
  if strcmpi(options.fitLineDisplay, 'on')
    hold on
    %[~, sortedOrder] = sort(var1, 'ascend');
    %plot(var1(sortedOrder), yFit(sortedOrder), 'k:');
    xAxisLength = xLim(2)-xLim(1);
    xAxisStep = xAxisLength/10000;
    x = xLim(1):xAxisStep:xLim(2);
    yFit = x.*slope + model(2);
    if strcmpi(options.axesType, 'regular')
      p = plot(x, yFit, 'k--');
    elseif strcmpi(options.axesType, 'semilogx')
      p = semilogx(x, yFit, 'k--');
    elseif strcmpi(options.axesType, 'semilogy')
      p = semilogy(x, yFit, 'k--');
    elseif strcmpi(options.axesType, 'loglog')
      p = loglog(x, yFit, 'k--');
    end
    uistack(p, 'bottom');
    hold off
  end
end


%% Figure axes labels
if ~isfield(options, 'xTicks') || isempty(options.xTicks)
  xTicks = xticks;
else
  xTicks = options.xTicks;
end
if ~isfield(options, 'yTicks') || isempty(options.yTicks)
  yTicks = yticks;
else
  yTicks = options.yTicks;
end
ax1 = axesProperties({}, 1, 'normal', 'off', 'w', 'Calibri', 12, 4/3, 2, [0.005 0], 'out',...
  'on', 'k', options.xLabel, xLim, xTicks,...
  'on', 'k', options.yLabel, yLim, yTicks);


%% Save the figure
label = [2 1.6];
margin = [0.3 0.55];
width = 1*options.figSize-label(1)-margin(1);
height = 1*options.figSize-label(2)-margin(2);
paperSize = resizeFig(fH, ax1, width, height, label, margin, 0);
if options.saveFig
  exportFig(fH, [figName '.png'],'-dpng','-r300', paperSize);
  hgsave(fH, [figName '.fig']);
  close(fH);
end