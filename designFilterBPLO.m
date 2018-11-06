function d = designFilterBPLO(Fpass, Astop1, Apass, Astop2, Fs)
% A helper function of AnHT for designing low order bandpass filters.

d = designfilt('bandpassiir', ...
  'FilterOrder',2, ...
  'PassbandFrequency1', Fpass(2,1),'PassbandFrequency2', Fpass(4,1), ...
  'StopbandAttenuation1', Astop1, 'PassbandRipple', Apass, ...
  'StopbandAttenuation2', Astop2, ...
  'SampleRate', Fs);
end