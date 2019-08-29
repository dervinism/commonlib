function beta = psdBeta(freq, psd)
% Finds beta of 1/f^beta given frequency and psd for frequency range <1 Hz.

freqFit = log10(freq(freq < 1));
psdFit = log10(psd(freq < 1));
beta = polyfit(freqFit, psdFit, 1);
% f = polyval(beta,freqFit);
% plot(freqFit,psdFit,'o',freqFit,f,'-')
% legend('data','linear fit')
beta = -beta(1);