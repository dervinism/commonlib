function [yFit, slope, coefficients] = fitLine(x, y, type)
% [yFit, slope, coefficients] = fitLine(x, y, type)
%
% Function fits a line to the data y given x. It outputs the y-values of
% the curve corresponding to x, as well as the slope of the line. Full set
% of coefficients is contained within the coefficients variable. Currently
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
  coefficients = CircularRegression(x, y);
  yFit = coefficients(1).*x + coefficients(2);
  slope = coefficients(1);
else
  error([type 'is currently not supported']);
end