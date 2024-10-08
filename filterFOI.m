function filtData = filterFOI(data, filt)
% Function filters a signal at chosen frequencies and outputs a
% matrix with rows corresponding to filter pass-band frequencies.
% Input: data row vector.
%        filt is a structure with following fields:
%          filt.FOI - frequencies of interest;
%          filt.sr - data sampling rate.

% Set passband and stopband frequencies for each FOI
Fstop1 = 20; %17.5; %28.5;
Fpass1 = 25; %27.5; %29.5;
Fpass2 = 30;
Fpass3 = 35; %32.5; %30.5;
Fstop2 = 40; %42.5; %31.5;
Fpass = [Fstop1; Fpass1; Fpass2; Fpass3; Fstop2];
FpassLog = log10(Fpass);
FpassLog = FpassLog-FpassLog(3);

Fstop1_2 = 0.001;
Fpass1_2 = 15;
Fpass2_2 = 30;
Fpass3_2 = 45;
Fstop2_2 = 59.999;
Fpass_2 = [Fstop1_2; Fpass1_2; Fpass2_2; Fpass3_2; Fstop2_2];
FpassLog_2 = log10(Fpass_2);
FpassLog_2 = FpassLog_2-FpassLog_2(3);

criticalF = [30 0.03];

FOIlog = log10(filt.FOI);
FpassFOI = zeros(numel(Fpass),numel(filt.FOI));
for iF = 1:numel(filt.FOI)
  if filt.FOI(iF) <= criticalF(2)
    FpassFOI(:,iF) = 10.^(FOIlog(iF)+FpassLog_2);
  elseif filt.FOI(iF) <= criticalF(1)
    FpassFOI(:,iF) = 10.^(FOIlog(iF)+FpassLog);
  else
    FpassFOI(:,iF) = ones(numel(Fpass),1)*filt.FOI(iF) + Fpass-Fpass2;
  end
end

% Create filters
Astop1 = [65 30]; % 1st stopband attenuation (dB)
Apass  = [0.5 1]; % Passband ripple
Astop2 = [65 30]; % 2nd stopband attenuation (dB)
for iF = 1:numel(filt.FOI)
  if iF == numel(filt.FOI)
    d(iF) = designFilterLP(FpassFOI(4,iF), FpassFOI(5,iF), Apass(2), Astop2(2), filt.sr); %#ok<*AGROW>
  elseif filt.FOI(iF) <= criticalF(2)
    d(iF) = designFilterBP(FpassFOI(:,iF), Astop1(2), Apass(2), Astop2(2), filt.sr);
  else
    d(iF) = designFilterBP(FpassFOI(:,iF), Astop1(1), Apass(1), Astop2(1), filt.sr);
  end
  %fvtool(d(iF), 'FrequencyScale','Log');
end

% Filter the signal
filtData = zeros(numel(filt.FOI),numel(data));
for iF = 1:numel(filt.FOI)
  filtData(iF,:) = filtfilt(d(iF),double(data));
%   plot(filtData(iF,:),'b')
end