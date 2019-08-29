function [phaseFOI, cohFOI, confFOI, actualFOI, fInds] = phaseCohFOI(FOI, freq, phase, coh, conf, rateadjust_kappa)
% Find phase and spiking rate-corrected coherence values for frequencies of
% interest.
% Input: FOI - a vector of frequencies of interest.
%        freq - a fequency vector.
%        phase - a phase vector.
%        coh - a coherence vector.
%        conf - a confidence interval for coherence.
%        rateadjust_kappa  - a rate adjusted kappa vector as per Aoi et
%        al., 2015.
% Output: phaseFOI - a vector with phase values corresponding to FOI.
%         cohFOI - a vector with coherence values corresponding to FOI.
%         actualFOI - a vector with values from freq vector closest
%                     corresponfing to given FOI values.
%         fInds - a vector with indices of values from freq vector closest
%                 corresponfing to given FOI values.

fInds = nan(size(FOI));
actualFOI = nan(size(FOI));
cohFOI = nan(size(FOI));
confFOI = nan(size(FOI));
phaseFOI = nan(size(FOI));
for i = 1:numel(FOI)
  f = FOI(i);
  relativeF = abs(freq-f);
  [~, fInds(i)] = min(relativeF);
  actualFOI(i) = freq(fInds(i));
  if (f >= 100 && abs(actualFOI(i)-f) < 10) || (f < 100 && f >= 10 && abs(actualFOI(i)-f) < 5) ||...
      (f < 10 && f >= 1 && abs(actualFOI(i)-f) < 1) || (f < 1 && f >= 0.1 && abs(actualFOI(i)-f) < 0.1) ||...
      (f < 0.1 && f >= 0.01 && abs(actualFOI(i)-f) < 0.01)
    cohFOI(i) = coh(fInds(i)) * rateadjust_kappa(fInds(i));
    if cohFOI(i) > 1
      cohFOI(i) = 1;
    end
    confFOI(i) = conf(fInds(i)) * rateadjust_kappa(fInds(i)); %#ok<*AGROW>
    phaseFOI(i) = phase(fInds(i));
  else
    fInds(i) = nan;
    actualFOI(i) = nan;
    break
  end
end