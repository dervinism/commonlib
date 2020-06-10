% Simulate 200 data points from 4 von Misses distributions as in Fisher and Marron (2001)
cleanUp
fMu1 = 0;
fKappa = 7;
dimensions = [1 50];
dist1 = vmrand(fMu1, fKappa, dimensions);

fMu2 = 0.5*pi;
dist2 = vmrand(fMu2, fKappa, dimensions);

fMu3 = pi;
dist3 = vmrand(fMu3, fKappa, dimensions);

fMu4 = 1.5*pi;
dist4 = vmrand(fMu4, fKappa, dimensions);

dist = [dist1 dist2 dist3 dist4];

% Test the kdeModalityTest function
[resultsTable, modalityFits, testStatistic, pValDiff, pValFit, modes, fits, fitPts] = kdeModalityTest(dist, 'circular');
disp(resultsTable);