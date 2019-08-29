function [r, pval] = corrSimple(vec1, vec2, type)
% Run correlation analyses on two row vectors. Supported correlation
% analysis types are 'Pearson', 'Kendall', 'Spearman', and 'circular'.
% Default is Pearson. The first output is a correlation coefficient,
% whereas the second output is a corresponding p-value.

if nargin < 3
  type = 'Pearson';
end

if strcmpi(type,'circular')
  [r, pval] = circ_corrcc(vec1(~isnan(vec1) & ~isnan(vec2)), vec2(~isnan(vec1) & ~isnan(vec2)));
else
  [r, pval] = corr([vec1(~isnan(vec1) & ~isnan(vec2))' vec2(~isnan(vec1) & ~isnan(vec2))'], 'Type',type);
  r = r(2);
  pval = pval(2);
end