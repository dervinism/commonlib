function [r, pval] = corrMulti(vecOrMat, mat, type)
% Run correlation analyses on rows of matrices. In case the first input is
% a row vector, analyses are performed on this vector and all rows of the
% second input matrix. Supported correlation analysis types are 'Pearson',
% 'Kendall', 'Spearman', and 'circular'. Default is Pearson. The first
% output is a row vector with correlation coefficients, whereas the second
% output is a row vector with corresponding p-values.

if nargin < 3
  type = 'Pearson';
end

r = zeros(1,size(mat,1));
pval = zeros(1,size(mat,1));
for iRow = 1:size(mat,1)
  if size(vecOrMat,1) == size(mat,1)
    [r(iRow), pval(iRow)] = corrSimple(vecOrMat(iRow,:), mat(iRow,:), type);
  else
    [r(iRow), pval(iRow)] = corrSimple(vecOrMat(1,:), mat(iRow,:), type);
  end
end