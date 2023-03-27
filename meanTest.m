function stats = meanTest(colMat, testType, display)
% stats = meanTest(colMat, testType, display)
%
% Function meanTest performs mean comparison statistical tests for data
% columns.
% Input: colMat - data column matrix;
%        testType - type of statistical test. Available ones are
%                   'KruskalWallisRM' (default) and 'ANOVARM'.
%        display - 'on' or 'off' to display test statistics. Default is
%                  'off'.
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
% In the case where there are more than two data columns, the first entry
% of the stats output variable would correspond to a combined test rather
% than a specific comparison. The following entries would correspond to
% comparisons regarding specific data columns indicated by column indices
% iCol1 and iCol2.


%% Parse user input
if isempty(colMat)
  stats = [];
  return
end
if nargin < 3 || isempty(display)
  display = 'off';
end
if nargin < 2 || isempty(testType)
  testType = 'KruskalWallisRM';
elseif ~strcmpi(testType, 'KruskalWallisRM') && ~strcmpi(testType, 'ANOVARM')
  error('The function meanTest currently supports repeated measures design only.');
end


%% Group stats
nCol = size(colMat,2);
if nCol > 2
  combo0 = 1;
  if strcmpi(testType, 'ANOVARM')
    [p,statsAll] = anova_rm(colMat, display);
    p = p(1);
  elseif strcmpi(testType, 'KruskalWallisRM')
    [p, statsAll] = kruskalwallis(colMat,[],display);
  end
  stats(combo0).iCol1 = NaN;
  stats(combo0).iCol2 = NaN;
  stats(combo0).mean1 = NaN;
  stats(combo0).mean2 = NaN;
  stats(combo0).CI1 = NaN;
  stats(combo0).CI2 = NaN;
  stats(combo0).std1 = NaN;
  stats(combo0).std2 = NaN;
  stats(combo0).p = p;
  stats(combo0).fstat = statsAll{2,5};
  stats(combo0).df = statsAll{2,3};
else
  combo0 = 0;
end


%% Individual comparison stats
combos = nchoosek(1:nCol,2);
[dataMean, dataCI95] = datamean(colMat);
if isempty(dataCI95)
  dataCI95 = zeros(size(dataMean));
else
  dataCI95 = dataCI95(2,:);
end
for iCombo = 1:size(combos,1)
  if strcmpi(testType, 'ANOVARM')
    [~,stats(iCombo+combo0).p,~,statsCombo] = ttest(colMat(:,combos(iCombo,1)), colMat(:,combos(iCombo,2)));
    stats(iCombo+combo0).fstat = statsCombo.tstat;
    stats(iCombo+combo0).df = statsCombo.df;
  elseif strcmpi(testType, 'KruskalWallisRM')
%     [stats(iCombo+combo0).p,~,statsCombo] = signtest(colMat(:,combos(iCombo,1)), colMat(:,combos(iCombo,2)));
%     stats(iCombo+combo0).fstat = statsCombo.sign;
    [stats(iCombo+combo0).p,~,statsCombo] = signrank(colMat(:,combos(iCombo,1)), colMat(:,combos(iCombo,2)));
    stats(iCombo+combo0).fstat = statsCombo.signedrank;
    stats(iCombo+combo0).df = [];
  end
  stats(iCombo+combo0).iCol1 = combos(iCombo,1); %#ok<*AGROW>
  stats(iCombo+combo0).iCol2 = combos(iCombo,2);
  stats(iCombo+combo0).mean1 = dataMean(combos(iCombo,1));
  stats(iCombo+combo0).mean2 = dataMean(combos(iCombo,2));
  stats(iCombo+combo0).CI1 = dataCI95(combos(iCombo,1));
  stats(iCombo+combo0).CI2 = dataCI95(combos(iCombo,2));
  stats(iCombo+combo0).std1 = std(colMat(:,combos(iCombo,1)), 'omitnan');
  stats(iCombo+combo0).std2 = std(colMat(:,combos(iCombo,2)), 'omitnan');
end

%close all