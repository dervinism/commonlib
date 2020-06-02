function [yFit, slope] = fitLine(x, y, type)
% curve = BestFitLine(x, y)
%
% Function fits a line to the data y given x. It outputs the y-values of
% the curve corresponding to x, as well as the slope of the line. Currently
% supported types are linear-linear and linear-circular (linear-linear is
% default).

if nargin < 3
  type = 'linear-linear';
end

if strcmpi(type, 'linear-linear')
  coefficients = polyfit(x, y, 1);
  yFit = polyval(coefficients , x);
  slope = coefficients(1);
elseif strcmpi(type, 'linear-circular')
  beta = CircularRegression(x, y);
  yFit = beta(1).*x + beta(2);
  slope = beta(1);
else
  error([type 'is currently not supported']);
end