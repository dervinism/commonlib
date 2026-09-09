function [pRayleigh, zRayleigh, pOmnibus, mOmnibus, pRao, U_Rao, pV, vV, pHR, T_HR, pRayleighBi, zRayleighBi, ...
  nModes, excessMass, U2_KDE, pKDE, modes, dipHDT, pHDT] = phaseDistributionTests(phase, edges, modeTest, uniformTest)
% [pRayleigh, zRayleigh, pOmnibus, mOmnibus, pRao, U_Rao, pV, vV, pHR, T_HR, pRayleighBi, zRayleighBi, nModes, excessMass, U2_KDE, pKDE, modes, dipHDT, pHDT] = phaseDistributionTests(phase, edges, modeTest)
%
% Function performs various phase distribution uniformity and modality
% tests.

if nargin < 4
  uniformTest = true(1,6);
end

% Statistical tests for phase distribution uniformity
phase = phase(~isnan(phase));
if isempty(phase)
  pRayleigh = NaN; zRayleigh = NaN; pOmnibus = NaN; mOmnibus = NaN; pRao = NaN; U_Rao = NaN; pV = NaN; vV = NaN; pHR = NaN; T_HR = NaN; pRayleighBi = NaN; zRayleighBi = NaN;
  nModes = NaN; excessMass = NaN; U2_KDE = NaN; pKDE = NaN; modes = NaN; dipHDT = NaN; pHDT = NaN;
  return
end
if uniformTest(1)
  [pRayleigh, zRayleigh] = circ_rtest(phase); % Rayleigh Test
else
  pRayleigh = NaN; zRayleigh = NaN;
end
if uniformTest(2)
  [pOmnibus, mOmnibus] = circ_otest(phase); % Omnibus Test
else
  pOmnibus = NaN; mOmnibus = NaN;
end
if uniformTest(3)
  [pRao, U_Rao] = circ_raotest(phase); % Rao's Spacing Test
else
   pRao = NaN; U_Rao = NaN;
end
if uniformTest(4)
  [pV, vV] = circ_vtest(phase, circmean(phase(~isnan(phase)))); % V Test
else
  pV = NaN; vV = NaN;
end
if uniformTest(5)
  [pHR, T_HR] = hrtest(phase); % Hermans-Rasson Test
else
  pHR = NaN; T_HR = NaN;
end
if uniformTest(6)
  phaseBi = mod(2*phase, 2*pi);
  [pRayleighBi, zRayleighBi] = circ_rtest(phaseBi); % Bimodal Rayleigh Test
else
  pRayleighBi = NaN; zRayleighBi = NaN;
end

% Distribution modality tests
if modeTest
  [resultsTable, ~, U2_KDE, ~, pKDE, modes] = kdeModalityTest(phase, 'circular', [], 0.05, 5, [(2*pi)/360 ((2*pi)/360)/10]);
  nModes = resultsTable(1,:);
  excessMass = resultsTable(3,:);
else
  nModes = []; excessMass = []; U2_KDE = []; pKDE = []; modes = [];
end
phase = recentrePhase(phase,0);
histSlice = histcounts(phase, edges-pi);
% [~, newPhaseCentreInd] = maxk(histSlice, 2);
% newPhaseCentre = mean(edges(newPhaseCentreInd+1) - mean(diff(edges))/2);
% phase = recentrePhase(phase,newPhaseCentre);
if ~sum(isnan(histSlice)) && sum(histSlice) > 0
  [dipHDT, pHDT] = HartigansDipSignifTest(phase, 500);
else
  dipHDT = []; pHDT = [];
end