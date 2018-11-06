function [phaseFOI, cohFOI, actualFOI, fInds] = phaseCohFOI(FOI, freq, phase, coh, rateadjust_kappa)
% Find phase and spiking rate-corrected coherence values for frequencies of
% interest.
% Input: FOI - a vector of frequencies of interest.
%        freq - a fequency vector.
%        phase - a phase vector.
%        coh - a coherence vector.
%        rateadjust_kappa  - a rate adjusted kappa vector as per Aoi et
%        al., 2015.
% Output: phaseFOI - a vector with phase values corresponding to FOI.
%         cohFOI - a vector with coherence values corresponding to FOI.
%         actualFOI - a vector with values from freq vector closest
%                     corresponfing to given FOI values.
%         fInds - a vector with indices of values from freq vector closest
%                 corresponfing to given FOI values.

fInds = zeros(size(FOI));
actualFOI = zeros(size(FOI));
cohFOI = zeros(size(FOI));
phaseFOI = zeros(size(FOI));
for i = 1:numel(FOI)
  f = FOI(i);
  relativeF = abs(freq-f);
  [~, fInds(i)] = min(relativeF);
  actualFOI(i) = freq(fInds(i));
  cohFOI(i) = coh(fInds(i)) * rateadjust_kappa(fInds(i));
  phaseFOI(i) = phase(fInds(i));
end