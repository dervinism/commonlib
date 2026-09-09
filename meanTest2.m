function stats = meanTest2(colMat, testType)
% stats = meanTest2(colMat, testType)
%
% Function meanTest2 performs independent samples t-test (or a
%   non-parametric equivalent) mean to mean comparison statistical tests
%   for data columns or cells. Circular parametric equivalent has also been
%   added.
% Input: colMat - data column matrix or a cell array;
%        testType - type of statistical test. Available ones are
%                   'ranksum' (default), 'ttest', 'wwtest' (circular
%                   parametric), 'cmtest' (circular non-parametric test for
%                   medians).
% Output: stats - a structure variable with the following fields:
%                 iCol1 - column index of the first member of the
%                         comparison pair;
%                 iCol2 - column index of the second member of the
%                         comparison pair;
%                 mean1 and mean2 - means of the two comparison columns (or
%                                   med1 and med2);
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
elseif ~strcmpi(testType, 'ranksum') && ~strcmpi(testType, 'ttest') && ...
    ~strcmpi(testType, 'wwtest') && ~strcmpi(testType, 'cmtest')
  error('The function meanTestZero currently does not support your test type.');
end


%% Individual comparison stats
if iscell(colMat)
  data = colMat;
  colMat = [];
  for iCol = 1:numel(data)
    if isempty(data{iCol})
      entry = nan(2,1);
    else
      entry = torow(data{iCol})';
    end
    colMat = concatenateMat(colMat, entry, 'horizontalnan');
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
    stats(iCombo).mean1 = dataMean(combos(iCombo,1));
    stats(iCombo).mean2 = dataMean(combos(iCombo,2));
  elseif strcmpi(testType, 'ranksum')
    [stats(iCombo).p,~,statsCombo] = ranksum(colMat(~isnan(colMat(:,combos(iCombo,1))),combos(iCombo,1)),...
      colMat(~isnan(colMat(:,combos(iCombo,2))),combos(iCombo,2)));
    stats(iCombo).fstat = statsCombo.ranksum;
    stats(iCombo).df = [];
    stats(iCombo).med1 = median(combos(iCombo,1), 'omitnan');
    stats(iCombo).med2 = median(combos(iCombo,2), 'omitnan');
  elseif strcmpi(testType, 'wwtest')
    entry1 = colMat(~isnan(colMat(:,combos(iCombo,1))),combos(iCombo,1));
    entry2 = colMat(~isnan(colMat(:,combos(iCombo,2))),combos(iCombo,2));
    if isempty(entry1) || isempty(entry2)
      stats(iCombo).p = 1;
      stats(iCombo).fstat = [];
      stats(iCombo).df = [];
      stats(iCombo).iCol1 = combos(iCombo,1);
      stats(iCombo).iCol2 = combos(iCombo,2);
      stats(iCombo).mean1 = [];
      stats(iCombo).mean2 = [];
      stats(iCombo).CI1 = [];
      stats(iCombo).CI2 = [];
      stats(iCombo).std1 = [];
      stats(iCombo).std2 = [];
    else
      [stats(iCombo).p,statsCombo] = circ_wwtest(entry1, entry2);
      stats(iCombo).fstat = statsCombo{2,5};
      stats(iCombo).df = [statsCombo{2,2} statsCombo{3,2}];
      stats(iCombo).mean1 = datamean(entry1, 'circular');
      stats(iCombo).mean2 = datamean(entry2, 'circular');
    end
  elseif strcmpi(testType, 'cmtest')
    entry1 = colMat(~isnan(colMat(:,combos(iCombo,1))),combos(iCombo,1));
    entry2 = colMat(~isnan(colMat(:,combos(iCombo,2))),combos(iCombo,2));
    if isempty(entry1) || isempty(entry2)
      stats(iCombo).p = [];
      stats(iCombo).fstat = [];
      stats(iCombo).df = [];
      stats(iCombo).iCol1 = combos(iCombo,1);
      stats(iCombo).iCol2 = combos(iCombo,2);
      stats(iCombo).med1 = [];
      stats(iCombo).med2 = [];
      stats(iCombo).CI1 = [];
      stats(iCombo).CI2 = [];
      stats(iCombo).std1 = [];
      stats(iCombo).std2 = [];
    else
      [stats(iCombo).p, ~, statsCombo] = circ_cmtest(entry1, entry2);
      stats(iCombo).fstat = statsCombo;
      stats(iCombo).df = [];
      stats(iCombo).med1 = circ_median(entry1(~isnan(entry1)));
      stats(iCombo).med2 = circ_median(entry2(~isnan(entry2)));
    end
  end
  stats(iCombo).iCol1 = combos(iCombo,1); %#ok<*AGROW>
  stats(iCombo).iCol2 = combos(iCombo,2);
  stats(iCombo).CI1 = dataCI95(combos(iCombo,1));
  stats(iCombo).CI2 = dataCI95(combos(iCombo,2));
  stats(iCombo).std1 = std(colMat(:,combos(iCombo,1)), 'omitnan');
  stats(iCombo).std2 = std(colMat(:,combos(iCombo,2)), 'omitnan');
end