function [r, pval] = corrSimple(vec1, vec2, type)
% Run correlation analyses on two row vectors. Supported correlation
% analysis types are 'Pearson', 'Kendall', 'Spearman', 'circular',
% 'circularnp' (non-parametric circular), 'circlinear', and 'circlinearnp'
% (non-parametric circlinear). Default is Pearson. The first output is a
% correlation coefficient, whereas the second output is a corresponding
% p-value. If you are interested in circular-linear correlation, vec1 is
% expected to be circular while vec2 is linear. The function depends on the
% Circular Statistics Toolbox.

if nargin < 3
  type = 'Pearson';
end

if strcmpi(type,'circular')
  [r, pval] = circ_corrcc(vec1(~isnan(vec1) & ~isnan(vec2)), vec2(~isnan(vec1) & ~isnan(vec2)));
elseif strcmpi(type,'circularnp')
  [r, pval] = circ_corrccnp(vec1(~isnan(vec1) & ~isnan(vec2)), vec2(~isnan(vec1) & ~isnan(vec2)));
elseif strcmpi(type,'circlinear')
  [r, pval] = circ_corrcl(vec1(~isnan(vec1) & ~isnan(vec2)), vec2(~isnan(vec1) & ~isnan(vec2)));
elseif strcmpi(type,'circlinearnp')
  [r, pval] = circ_corrclnp(vec1(~isnan(vec1) & ~isnan(vec2)), vec2(~isnan(vec1) & ~isnan(vec2)));
else
  if sum(vec1(~isnan(vec1) & ~isnan(vec2))) && sum(vec2(~isnan(vec1) & ~isnan(vec2)))
    [r, pval] = corr([vec1(~isnan(vec1) & ~isnan(vec2))' vec2(~isnan(vec1) & ~isnan(vec2))'], 'Type',type);
    r = r(2);
    pval = pval(2);
  else
    r = 0;
    pval = 1;
  end
end