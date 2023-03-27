function stats = meanTestZero(colMat, testType)
% stats = meanTestZero(colMat, testType)
%
% Function meanTestZero performs mean to zero comparison statistical tests
% for data columns or cells.
% Input: colMat - data column matrix or a cell array;
%        testType - type of statistical test. Available ones are
%                   'signtest' (default), signrank, and 'ttest'.
% Output: stats - a structure variable with the following fields:
%                 p - p-values for a specific column;
%                 fstat - statistic values for a specific column;
%                 df - degrees of freedom for a specific column.


%% Parse user input
if isempty(colMat)
  stats = [];
  return
end
if nargin < 2 || isempty(testType)
  testType = 'signtest';
elseif ~strcmpi(testType, 'signtest') && ~strcmpi(testType, 'ttest')
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
for iCol = 1:size(colMat,2)
  if strcmpi(testType, 'ttest')
    [~,stats(iCol).p,~,statsCol] = ttest(colMat(~isnan(colMat(:,iCol)),iCol)); %#ok<*AGROW>
    stats(iCol).fstat = statsCol.tstat;
    stats(iCol).df = statsCol.df;
  elseif strcmpi(testType, 'signtest')
    [stats(iCol).p,~,statsCol] = signtest(colMat(~isnan(colMat(:,iCol)),iCol));
    stats(iCol).fstat = statsCol.sign;
    stats(iCol).df = [];
  elseif strcmpi(testType, 'signrank')
    [stats(iCol).p,~,statsCol] = signrank(colMat(~isnan(colMat(:,iCol)),iCol));
    stats(iCol).fstat = statsCol.signedrank;
    stats(iCol).df = [];
  end
end