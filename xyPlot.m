function figPhase = xyPlot(x, y, FOI, xStr, yStr, visibility)
% Plot x data relative to y data. x and y data can be two matrices of equal
% dimensions. In the latter case multiple figures are produced
% corresponding to the matrix columns. This function is intended to be used
% to visualise correlations for different frequencies of interest.
% Input: x and y are data column vectors or matrices.
%        FOI is a vector with corresponding (i.e., columns of matrices)
%          frequencies of interest.
%        xStr is the x-axis label.
%        yStr is the y-axis label.
%        (figure) visibility is either true or false.

for iF = 1:numel(FOI)
  figPhase(iF) = figure('units', 'normalized', 'position', [0.002, .04, 1/2, .88/1.04], 'Visible', visibility); %#ok<*AGROW>
  if sum(sum(~isnan(x))) && sum(sum(~isnan(y)))
    plot(x(~isnan(x),iF),y(~isnan(y),iF), '.', 'MarkerSize',10);
  end
  xlabel(xStr)
  ylabel(yStr)
end