function [phaseFOI, cohFOI, confFOI, actualFOI, fInds] = phaseCohFOI(FOI, freq, phase, coh, conf, rateadjust_kappa)
% [phaseFOI, cohFOI, confFOI, actualFOI, fInds] = phaseCohFOI(FOI, freq, phase, coh, conf, rateadjust_kappa)
%
% Function finds phase and (spiking rate-corrected) coherence values for
% frequencies of interest.
% Input: FOI - a vector of frequencies of interest.
%        freq - an actual fequency vector.
%        phase - a corresponding phase vector.
%        coh - a corresponding coherence vector.
%        conf - a corresponding confidence interval for coherence.
%        rateadjust_kappa  - a rate-adjusted kappa vector as per Aoi et
%                            al., 2015. Default is empty meaning no
%                            rate-adjustment.
% Output: phaseFOI - a vector with phase values corresponding to FOI.
%         cohFOI - a vector with coherence values corresponding to FOI.
%         actualFOI - a vector with values from freq vector closest
%                     to given FOI values.
%         fInds - a vector with indices of values from freq vector closest
%                 to given FOI values.

if nargin < 6
  rateadjust_kappa = [];
end

fInds = nan(size(FOI));
actualFOI = nan(size(FOI));
cohFOI = nan(size(FOI));
confFOI = nan(size(conf,1),size(FOI,2));
phaseFOI = nan(size(FOI));
for i = 1:numel(FOI)
  f = FOI(i);
  relativeF = abs(freq-f);
  [~, fInds(i)] = min(relativeF);
  actualFOI(i) = freq(fInds(i));
  if (f >= 100 && abs(actualFOI(i)-f) < 10) || (f < 100 && f >= 10 && abs(actualFOI(i)-f) < 5) ||...
      (f < 10 && f >= 1 && abs(actualFOI(i)-f) < 1) || (f < 1 && f >= 0.1 && abs(actualFOI(i)-f) < 0.1) ||...
      (f < 0.1 && f >= 0.01 && abs(actualFOI(i)-f) < 0.01)
    if ~isempty(rateadjust_kappa)
      cohFOI(i) = coh(fInds(i)) * rateadjust_kappa(fInds(i));
    else
      cohFOI(i) = coh(fInds(i));
    end
    if cohFOI(i) > 1
      cohFOI(i) = 1;
    end
    if ~isempty(rateadjust_kappa)
      confFOI(:,i) = conf(:,fInds(i)) .* rateadjust_kappa(fInds(i)); %#ok<*AGROW>
    else
      confFOI(:,i) = conf(:,fInds(i));
    end
    phaseFOI(i) = phase(fInds(i));
  else
    fInds(i) = nan;
    actualFOI(i) = nan;
    break
  end
end