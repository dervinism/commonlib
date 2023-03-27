function [y, skewedgaussianHandle] = skewedgaussian(x, alpha, xi, omega, omega2)
% y = skewedgaussian(x, alpha, xi, omega)
%
% This function generates a skewed Gaussian function given x, alpha (shape
% parameter), xi (location parameter), omega (scale parameter), and omega2
% (second direct scale parameter).
% Input: x - vector with x values.
%        alpha, xi, omega, omega2 - scalars.
% Output: y, skewedgaussianHandle.


gaussian = @(x,xi,omega) (1/sqrt((2*pi)).*exp(-(((x - xi)./omega).^2)./2));
skewedgaussianHandle = @(x,alpha,xi,omega,omega2) omega2.*(2/omega)*gaussian(x,xi,omega).*normcdf(alpha.*((x - xi)./omega));
y = skewedgaussianHandle(x, alpha, xi, omega, omega2);