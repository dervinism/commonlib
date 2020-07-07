function [phaseSyncInd, phaseSyncInd_t, phase1, phase2, phaseDiff] = hilbertPhaseSync(signal1, signal2, averagingWindowSize)
% [phaseSyncInd, phaseSyncInd_t, phase1, phase2, phaseDiff] = hilbertPhaseSync(signal1, signal2, averagingWindowSize)
%
% Function calculates Hilbert phase synchronisation measures.
% Input: signal1, signal2
%        averagingWindowSize - averaging window size used when calculating
%                              the evolution of Hilbert phase
%                              synchronisation index over time. Default is
%                              100.
% Output: phaseSyncInd - Hilbert phase synchronisation index.
%         phaseSyncInd_t - Hilbert phase synchronisation index over time.
%         phase1 - phase of signal1 estimated using Hilbert transform.
%         phase2 - phase of signal2 estimated using Hilbert transform.
%         phaseDiff - phase of signal1 with regards to signal2. Positive
%                     phase means signal1 is preceding signal2.

signal1 = torow(signal1);
signal2 = torow(signal2);

if nargin < 3
    averagingWindowSize = 100;
end

% Estimate phase using Hilbert transform
[~, phase1] = hilbertTransform(signal1-mean(signal1));
phase1 = recentrePhase(phase1, 0);
[~, phase2] = hilbertTransform(signal2-mean(signal2));
phase2 = recentrePhase(phase2, 0);

% Calculate Hilbert phase synchronisation index
phaseDiff = recentrePhase(phase2 - phase1, 0);
phaseSyncInd = sqrt(mean(cos(phaseDiff))^2 + mean(sin(phaseDiff))^2);

% Calculate the evolution of Hilbert phase synchronisation index over time
phaseDiffCos = smoothdata(cos(phaseDiff), 'movmean', averagingWindowSize);
phaseDiffSin = smoothdata(sin(phaseDiff), 'movmean', averagingWindowSize);
phaseSyncInd_t = sqrt(phaseDiffCos.^2 + phaseDiffSin.^2);
