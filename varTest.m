function stats = varTest(colMat, testType, display)
% stats = varTest(colMat, testType, display)
%
% Function varTest performs variance comparison statistical tests for data
% columns.
% Input: colMat - data column matrix;
%        testType - type of statistical test. Available ones are
%                   'Bartlett', 'LeveneQuadratic' (default),
%                   'LeveneAbsolute', 'BrownForsythe', and 'OBrien'.
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
%                 df - degrees of freedom for a specific comparison;
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
  testType = 'LeveneQuadratic';
end


%% Group stats
nCol = size(colMat,2);
if nCol > 2
  combo0 = 1;
  [p,statsAll] = vartestn(colMat, 'TestType',testType, 'Display',display);
  stats(combo0).iCol1 = NaN;
  stats(combo0).iCol2 = NaN;
  stats(combo0).mean1 = NaN;
  stats(combo0).mean2 = NaN;
  stats(combo0).var1 = NaN;
  stats(combo0).var2 = NaN;
  stats(combo0).std1 = NaN;
  stats(combo0).std2 = NaN;
  stats(combo0).p = p;
  stats(combo0).fstat = statsAll.fstat;
  stats(combo0).df = statsAll.df;
else
  combo0 = 0;
end


%% Individual comparison stats
combos = nchoosek(1:nCol,2);
for iCombo = 1:size(combos,1)
  [p,statsCombo] = vartestn(colMat(:,combos(iCombo,:)), 'TestType',testType, 'Display',display);
  stats(iCombo+combo0).iCol1 = combos(iCombo,1); %#ok<*AGROW>
  stats(iCombo+combo0).iCol2 = combos(iCombo,2);
  stats(iCombo+combo0).mean1 = mean(colMat(:,combos(iCombo,1)), 'omitnan');
  stats(iCombo+combo0).mean2 = mean(colMat(:,combos(iCombo,2)), 'omitnan');
  stats(iCombo+combo0).var1 = var(colMat(:,combos(iCombo,1)), 'omitnan');
  stats(iCombo+combo0).var2 = var(colMat(:,combos(iCombo,2)), 'omitnan');
  stats(iCombo+combo0).std1 = std(colMat(:,combos(iCombo,1)), 'omitnan');
  stats(iCombo+combo0).std2 = std(colMat(:,combos(iCombo,2)), 'omitnan');
  stats(iCombo+combo0).p = p;
  stats(iCombo+combo0).fstat = statsCombo.fstat;
  stats(iCombo+combo0).df = statsCombo.df;
end