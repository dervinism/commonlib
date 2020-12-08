function ca = axesPropertiesAugmented(varargin)
% ca = axesPropertiesAugmented(ca, opt)
%
% Function controls all aspects of figure appearance.
%
% Inputs: ca - axes handle (optional). If no axes handle is supplied,
%              current axes handle is used.
%         opt - options structure variable with the following fields:
%           titleStr - figure title (string);
%           titleSzMult - title font size multiplier (scalar;
%                         titleSzMult*fontSz);
%           titleWeight - title Weight (string: 'normal', 'bold');
%           boxStr - figure border (string: 'on' or 'off');
%           colour - frame colour (colour string or vector code);
%           font - text font type;
%           fontSz - font size;
%           labelSzMult - label font size multiplier (scalar;
%                         labelSzMult*fontSz);
%           axesLineWidth - coordinate axis width;
%           tickLength;
%           tickDir - tick pointing direction: inside ('in') or outside
%                     ('out');
%           xVisible - x axis visibility (string: 'on', 'off');
%           xColour - x axis colour;
%           xLabel - x axis label string;
%           xRange - x axis range (vector);
%           xTicks - a vector indicating where to draw ticks on the x axis;
%           xTickLabel - a cell of string characters to relabel the ticks
%                        on the x-axis.
%           yVisible
%           yColour
%           yLabel
%           yRange
%           yTicks
%           yTickLabel
%
% Output: ca - a figure handle.


%% Check the input variables
if numel(varargin) > 2
  error('Too many input arguments supplied');
elseif numel(varargin) > 1
  ca = varargin{1};
  opt = varargin{2};
elseif numel(varargin) == 1
  ca = gca;
  opt = varargin{1};
else
  error('No input arguments supplied');
end

if ~isstruct(opt)
  error('The input variable opt must be a structure');
end


%% Get axes properties
if ~isfield(opt, 'titleStr'); opt.titleStr = get(ca, 'Title'); end
if ~isfield(opt, 'titleSzMult'); opt.titleSzMult = get(ca, 'TitleFontSizeMultiplier'); end
if ~isfield(opt, 'titleWeight'); opt.titleWeight = get(ca, 'TitleFontWeight'); end
if ~isfield(opt, 'boxStr'); opt.boxStr = get(ca, 'Box'); end
if ~isfield(opt, 'colour'); opt.colour = get(ca, 'Color'); end
if ~isfield(opt, 'font'); opt.font = get(ca, 'FontName'); end
if ~isfield(opt, 'fontSz'); opt.fontSz = get(ca, 'FontSize'); end
if ~isfield(opt, 'labelSzMult'); opt.labelSzMult = get(ca, 'LabelFontSizeMultiplier'); end
if ~isfield(opt, 'axesLineWidth'); opt.axesLineWidth = get(ca, 'LineWidth'); end
if ~isfield(opt, 'tickLength'); opt.tickLength = get(ca, 'TickLength'); end
if ~isfield(opt, 'tickDir'); opt.tickDir = get(ca, 'TickDir'); end
if ~isfield(opt, 'xVisible'); opt.xVisible = ca.XRuler.Axle.Visible; end
if ~isfield(opt, 'xColour'); opt.xColour = get(ca, 'XColor'); end
if ~isfield(opt, 'xLabel'); opt.xLabel = get(ca, 'XLabel'); end
if ~isfield(opt, 'xRange'); opt.xRange = get(ca, 'XLim'); end
if ~isfield(opt, 'xTicks'); opt.xTicks = get(ca, 'XTick'); end
if ~isfield(opt, 'xTickLabel'); opt.xTickLabel = get(ca, 'XTickLabel'); end
if ~isfield(opt, 'yVisible'); opt.yVisible = ca.YRuler.Axle.Visible; end
if ~isfield(opt, 'yColour'); opt.yColour = get(ca, 'YColor'); end
if ~isfield(opt, 'yLabel'); opt.yLabel = get(ca, 'YLabel'); end
if ~isfield(opt, 'yRange'); opt.yRange = get(ca, 'YLim'); end
if ~isfield(opt, 'yTicks'); opt.yTicks = get(ca, 'YTick'); end
if ~isfield(opt, 'yTickLabel'); opt.yTickLabel = get(ca, 'YTickLabel'); end


%% Set axes properties
ca = axesProperties(opt.titleStr, opt.titleSzMult, opt.titleWeight, opt.boxStr,...
  opt.colour, opt.font, opt.fontSz, opt.labelSzMult, opt.axesLineWidth, opt.tickLength,...
  opt.tickDir, opt.xVisible, opt.xColour, opt.xLabel, opt.xRange, opt.xTicks,...
  opt.yVisible, opt.yColour, opt.yLabel, opt.yRange, opt.yTicks);
ca.XTickLabel = opt.xTickLabel;
ca.YTickLabel = opt.yTickLabel;

fH = ancestor(ca, 'figure', 'toplevel');
set(fH,'color','white');