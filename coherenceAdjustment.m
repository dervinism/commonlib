function kappa = coherenceAdjustment(mfr1, mfr2, spectrum1, beta, dt)
% Correction for the spike-field or spike-spike coherence when the
% conditions have different firing rates (see Aoi et al., 2015).
%
% Input: mfr1 - mean firing rate in condition1;
%        mfr2 - mean firing rate in condition2 (mfr2 = 1 for LFP);
%        spectrum1 - power spectrum in condition 1;
%        beta - homogenous Poisson noise rate;
%        dt - sampling time step (1 when using Chronux spectrum).
%
% Output: kappa - coherence adjustment factor.
%
% Use: C_n*y (f) = kappa*C_ny (f) in case of LFP comparison and
%      C_n1*n2* (f) = kappa1*kappa2*C_n1n2 (f) in case of two spiking rates
%


alpha = mfr2/mfr1;
kappa_temp = 1 + ((dt^2)*((1/alpha - 1)*mfr1 + beta/(alpha^2)))./spectrum1;
kappa_temp(kappa_temp < 0) = NaN;
kappa = 1./sqrt(kappa_temp);