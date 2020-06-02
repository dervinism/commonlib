function [r, pval] = corrMulti(vecOrMat, mat, type)
% Run correlation analyses on rows of matrices. In case the first input is
% a row vector, analyses are performed on this vector and all rows of the
% second input matrix. Supported correlation analysis types are 'Pearson',
% 'Kendall', 'Spearman', 'circular', 'circularnp' (non-parametric circular),
% 'circlinear', and 'circlinearnp' (non-parametric circlinear). Default is
% Pearson. The first output is a row vector with correlation coefficients,
% whereas the second output is a row vector with corresponding p-values. In
% the case of circular-linear correlation, vecOrMat is expected to be
% circular while mat is linear. The function depends on the Circular
% Statistics Toolbox.

if nargin < 3
  type = 'Pearson';
end

r = zeros(1,size(mat,1));
pval = zeros(1,size(mat,1));
for iRow = 1:size(mat,1)
  ind1 = isnan(vecOrMat(min([iRow size(vecOrMat,1)]),:));
  ind2 = isnan(mat(iRow,:));
  ind = ~(ind1 + ind2);
  if sum(ind)
    if size(vecOrMat,1) == size(mat,1)
      [r(iRow), pval(iRow)] = corrSimple(vecOrMat(iRow,ind), mat(iRow,ind), type);
    else
      [r(iRow), pval(iRow)] = corrSimple(vecOrMat(1,ind), mat(iRow,ind), type);
    end
  else
    r(iRow) = NaN;
    pval(iRow) = NaN;
  end
end