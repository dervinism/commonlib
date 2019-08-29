function getSpectrogram(fileName, nCh, lfpChans, faultyChans, chOI, period, sr, subtractMedian)
% getSpectrogram(fileName, nCh, lfpChans, faultyChans, chOI, period, sr, subtractMedian)
% The function draws a spectrogram for a chosen channel at a specified time
% interval.
% Input: fileName - a string specifying the binary recording file.
%        nCh - number of channels in the recording in total (including any
%              analog channels).
%        lfpChans - a vector of lfp Channels.
%        faultyChans - a vector of channels to be excluded from median subtraction.
%        chOI - channel of interest;
%        period - time period in seconds: [start end];
%        sr - sampling rate;
%        subtractMedian - a logical for subtracting median: True or false.

dat = getContinuousDataFromDatfile(fileName, nCh, period(1), period(2), lfpChans, sr);

deleteChans = faultyChans;

if subtractMedian
  chans2include = ones(1,size(dat,1));
  chans2include(deleteChans) = zeros(1,numel(deleteChans));
  chm = zeros(size(dat,1),1);
  chm(logical(chans2include)) = median(dat(logical(chans2include),:),2);
  dat = bsxfun(@minus, dat, int16(chm)); % subtract median of each channel
  tm = int16(median(dat(logical(chans2include),:),1));
  dat = bsxfun(@minus, dat, tm);
end

% nDelChansBelow = deleteChans - chOI;
% nDelChansBelow(nDelChansBelow > 0) = 0;
% nDelChansBelow(nDelChansBelow < 0) = 1;
% chOI = chOI - sum(nDelChansBelow);
datOI = dat(chOI,:);

fb = cwtfilterbank('SignalLength',size(datOI,2),'SamplingFrequency',sr,...
  'FrequencyLimits',[1 200],'WaveletParameters',[3 16],'VoicesPerOctave',10);
[wt,f] = cwt(double(datOI),'FilterBank',fb); % Continuous wavelet transform
cwt(double(datOI),'FilterBank',fb);
time = period(1)+1/sr:1/sr:period(1)+size(datOI,2)/sr;
titleStr = ['Spectrogram for channel #' num2str(chOI)];
figure; helperCWTTimeFreqPlot(wt, time, f, 'surf', titleStr, 'Time (seconds)', 'Frequency (Hz)');
%set(gca, 'YScale', 'log')