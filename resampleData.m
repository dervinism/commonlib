function resampledData = resampleData(data, sr, newsr)
% A function to resample data.
% Input: data vector.
%        sr - original data sampling rate (Hz).
%        newsr - new sampling rate for the output vector.
% Ouput: resampledData vector.

biggestIndex = size(data,2);
sampleDuration = ceil(sr/newsr);
newBiggestIndex = ceil(biggestIndex*(newsr/sr));
resampledData = zeros(size(data,1), newBiggestIndex);
for s = 1:newBiggestIndex
  iEnd = (s-1)*sampleDuration+sampleDuration;
  if iEnd > biggestIndex
    iSum = sum(data(:,(s-1)*sampleDuration+1:biggestIndex),2);
    iSum = iSum*(sampleDuration/(biggestIndex-((s-1)*sampleDuration)));
  else
    iSum = sum(data(:,(s-1)*sampleDuration+(1:sampleDuration)),2);
  end
%   iSumSmooth3 = smooth(iSum,3);
%   iSumSmooth5 = smooth(iSum,5);
%   plot(iSum); hold on; plot(iSumSmooth3); plot(iSumSmooth5); hold off;
  resampledData(:,s) = iSum;
end