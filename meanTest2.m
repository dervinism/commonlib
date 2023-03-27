function stats = meanTest2(colMat, testType)
% stats = meanTest2(colMat, testType)
%
% Function meanTest2 performs independent samples t-test (or a
%   non-parametric equivalent) mean to mean comparison statistical tests
%   for data columns or cells.
% Input: colMat - data column matrix or a cell array;
%        testType - type of statistical test. Available ones are
%                   'ranksum' (default) and 'ttest'.
% Output: stats - a structure variable with the following fields:
%                 iCol1 - column index of the first member of the
%                         comparison pair;
%                 iCol2 - column index of the second member of the
%                         comparison pair;
%                 mean1 and mean2 - means of the two comparison columns;
%                 var1 and var2 - variances of the two comparison columns;
%                 std1 and std2 - standard deviations of the two comparison
%                                 columns;
%                 p - p-values for a specific comparison;
%                 fstat - statistic values for a specific comparison;
%                 df - degrees of freedom for a specific comparison.


%% Parse user input
if isempty(colMat)
  stats = [];
  return
end
if nargin < 2 || isempty(testType)
  testType = 'ranksum';
elseif ~strcmpi(testType, 'ranksum') && ~strcmpi(testType, 'ttest')
  error('The function meanTestZero currently does not support your test type.');
end


%% Individual comparison stats
if iscell(colMat)
  data = colMat;
  colMat = [];
  for iCol = 1:numel(data)
    colMat = concatenateMat(colMat, torow(data{iCol})', 'horizontalnan');
  end
end
combos = nchoosek(1:size(colMat,2),2);
[dataMean, dataCI95] = datamean(colMat);
if isempty(dataCI95)
  dataCI95 = zeros(size(dataMean));
else
  dataCI95 = dataCI95(2,:);
end
for iCombo = 1:size(combos,1)
  if strcmpi(testType, 'ttest')
    [~,stats(iCombo).p,~,statsCombo] = ttest2(colMat(~isnan(colMat(:,combos(iCombo,1))),combos(iCombo,1)),...
      colMat(~isnan(colMat(:,combos(iCombo,2))),combos(iCombo,2)));
    stats(iCombo).fstat = statsCombo.tstat;
    stats(iCombo).df = statsCombo.df;
  elseif strcmpi(testType, 'ranksum')
    [stats(iCombo).p,~,statsCombo] = ranksum(colMat(~isnan(colMat(:,combos(iCombo,1))),combos(iCombo,1)),...
      colMat(~isnan(colMat(:,combos(iCombo,2))),combos(iCombo,2)));
    stats(iCombo).fstat = statsCombo.ranksum;
    stats(iCombo).df = [];
  end
  stats(iCombo).iCol1 = combos(iCombo,1); %#ok<*AGROW>
  stats(iCombo).iCol2 = combos(iCombo,2);
  stats(iCombo).mean1 = dataMean(combos(iCombo,1));
  stats(iCombo).mean2 = dataMean(combos(iCombo,2));
  stats(iCombo).CI1 = dataCI95(combos(iCombo,1));
  stats(iCombo).CI2 = dataCI95(combos(iCombo,2));
  stats(iCombo).std1 = std(colMat(:,combos(iCombo,1)), 'omitnan');
  stats(iCombo).std2 = std(colMat(:,combos(iCombo,2)), 'omitnan');
end