function figCoh = cohVcohPlot(coh1, coh2, FOI, xStr, yStr, visibility)
% Plot two coherence data vectors on separate axes. Can be two matrices of
% equal dimensions. In the latter case multiple figures are produced
% corresponding to the matrix rows. This function is intended to be used
% for visualising correlations.
% Input: coh1 and coh2 are data row vectors or matrices.
%        FOI is a vector with corresponding (i.e., rows of matrices)
%          frequencies of interest.
%        xStr is the beginning of the x-axis label string.
%        yStr is the beginning of the y-axis label string.
%        (figure) visibility is either true or false.

for iF = 1:numel(FOI)
  figCoh(iF) = figure('units', 'normalized', 'position', [0.002, .04, 1/2, .88/1.04], 'Visible', visibility); %#ok<*AGROW>
  if sum(sum(~isnan(coh1))) && sum(sum(~isnan(coh2)))
    plot(coh1(:,iF),coh2(:,iF), '.', 'MarkerSize',10);
  end
  title(['Phase: ' num2str(FOI(iF)) ' Hz']);
  xlabel([xStr ' coherence'])
  ylabel([yStr ' coherence'])
end