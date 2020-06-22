function [pRayleigh, zRayleigh, pOmnibus, mOmnibus, pRao, U_Rao, pV, vV, pHR, T_HR, nModes, excessMass, U2_KDE, pKDE, modes, dipHDT, pHDT] = phaseDistributionTests(phase, edges, modeTest)
% [pRayleigh, zRayleigh, pOmnibus, mOmnibus, pRao, U_Rao, pV, vV, pHR, T_HR, nModes, excessMass, U2_KDE, pKDE, modes, dipHDT, pHDT] = phaseDistributionTests(phase, edges, modeTest)
%
% Function performs various phase distribution uniformity and modality
% tests.

% Statistical tests for phase distribution uniformity
phase = phase(~isnan(phase));
if isempty(phase)
  pRayleigh = NaN; zRayleigh = NaN; pOmnibus = NaN; mOmnibus = NaN; pRao = NaN; U_Rao = NaN; pV = NaN; vV = NaN; pHR = NaN; T_HR = NaN;
  nModes = NaN; excessMass = NaN; U2_KDE = NaN; pKDE = NaN; modes = NaN; dipHDT = NaN; pHDT = NaN;
  return
end
[pRayleigh, zRayleigh] = circ_rtest(phase); % Rayleigh Test
[pOmnibus, mOmnibus] = circ_otest(phase); % Omnibus Test
[pRao, U_Rao] = circ_raotest(phase); % Rao's Spacing Test
[pV, vV] = circ_vtest(phase, circmean(phase(~isnan(phase)))); % V Test
[pHR, T_HR] = hrtest(phase); % Hermans-Rasson Test

% Distribution modality tests
if modeTest
  [resultsTable, ~, U2_KDE, ~, pKDE, modes] = kdeModalityTest(phase, 'circular', [], 0.05, 5, [(2*pi)/360 ((2*pi)/360)/10]);
  nModes = resultsTable(1,:);
  excessMass = resultsTable(3,:);
else
  nModes = []; excessMass = []; U2_KDE = []; pKDE = []; modes = [];
end
phase = recentrePhase(phase,pi/2);
shiftedEdges = edges + pi/2;
histSlice = histcounts(phase, shiftedEdges);
if ~sum(isnan(histSlice)) && sum(histSlice) > 0
  [dipHDT, pHDT] = HartigansDipSignifTest(histSlice, 500);
else
  dipHDT = []; pHDT = [];
end