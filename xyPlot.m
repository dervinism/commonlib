function figPhase = xyPlot(x, y, FOI, xStr, yStr, visibility, xZero, yZero, bestFitLine)
% Plot x data relative to y data. x and y data can be two matrices of equal
% dimensions. In the latter case multiple figures are produced
% corresponding to the matrix columns. This function is intended to be used
% to visualise correlations for different frequencies of interest.
% Input: x and y are data column vectors or matrices.
%        FOI is a vector with corresponding (i.e., columns of matrices)
%          frequencies of interest.
%        xStr is the x-axis label.
%        yStr is the y-axis label.
%        (figure) visibility is either 'on' or 'off'. Default is 'on'.
%        xZero - true if you want to indicate the origin of the x-axis.
%          Default is false.
%        yZero - true if you want to indicate the origin of the y-axis.
%          Default is false.
%        bestFitLine - 'linear-linear', 'linear-cricular' or 'none'.
%          Default is none.

if nargin < 9
  bestFitLine = 'none';
end
if nargin < 8
  yZero = false;
end
if nargin < 7 
  xZero = false;
end
if nargin < 6
  visibility = 'on';
end

for iF = 1:numel(FOI)
  figPhase(iF) = figure('units', 'normalized', 'position', [0.002, .04, 1/2, .88/1.04], 'Visible', visibility); %#ok<*AGROW>
  
  % Plot the data
  if sum(sum(~isnan(x))) && sum(sum(~isnan(y)))
    plot(x(~isnan(x(:,iF)) & ~isnan(y(:,iF)), iF), y(~isnan(x(:,iF)) & ~isnan(y(:,iF)), iF), '.', 'MarkerSize',10);
  end
  hold on
  
  % Mark the origins of axes
  if xZero
    plot([0 0], ylim, 'k:');
  end
  if yZero
    plot(xlim, [0 0], 'k:');
  end
  
  % Draw the best fit line
  if ~strcmpi(bestFitLine, 'none')
    yFit = fitLine(x(~isnan(x(:,iF)) & ~isnan(y(:,iF)), iF), y(~isnan(x(:,iF)) & ~isnan(y(:,iF)), iF), bestFitLine);
    plot(x(~isnan(x(:,iF)) & ~isnan(y(:,iF)), iF), yFit, 'r-');
  end
  hold off
  
  % Label axes
  xlabel(xStr, 'Interpreter','tex')
  ylabel(yStr, 'Interpreter','tex')
end