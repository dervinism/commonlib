function [meanCI95, sd, SEM, dataMean] = calc95CI(data)
% [meanCI95, sd, SEM, dataMean] = calc95CI(data)
%
% Function computes 95% confidence interval for data in addition to other
% descriptive statistical measures.
% Input: data - a data column vector or a matrix with rows corresponding to
%               individual observations and columns to separate data
%               instances.
% Output: meanCI95 - 95% confidence interval on data mean.
%         sd - standard deviation.
%         SEM - standard error of the mean.
%         dataMean - data mean.

dataMean = mean(data,1, 'omitnan');
sd = std(data,1,1, 'omitnan');
SEM = sd ./ sqrt(sum(~isnan(data),1));
CI95 = zeros(2,numel(dataMean));
meanCI95 = zeros(2,numel(dataMean));
for i = 1:numel(dataMean)
  CI95(:,i) = (tinv([0.025 0.975], sum(~isnan(data(:,i)))-1))';
  meanCI95(:,i) = bsxfun(@times, SEM(i), CI95(:,i));
end