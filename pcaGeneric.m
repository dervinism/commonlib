function [pcaCoef, explained, PCs, nPCs, prob, individualVarExplained] = pcaGeneric(data)
% [pcaCoef, explained, PCs, nPCs, prob] = pcaGeneric(data)
% The most generic PCA used by PCAanalysis.
% Inputs: data - a data matrix with rows corresponding to individual data
%                vectors and columns corresponding to single instances or
%                time.
% Outputs: pcaCoef - coeficients of principal components (see Matlab's
%                inbuilt pca function for more explanation).
%          explained - the percentage of the total variance explained by
%                each principal component (see Matlab's pca).
%          PCs - the actual principal components. This matrix has the same
%                dimensions as the input matrix data.
%          nPCs - number of principal components.
%          prob - the probabilities of Bartlett's test (alpha = 0.05). The
%                number of ouput probabilities will always be a number of
%                components - 1. It tests whether variances of all
%                principal components are equal followed by a test
%                excluding the first component and so on until only the
%                last two components remain in the last test.
%          individualVarExplained - a matrix giving the proportion of
%                variance explained by each PC (dim 1) in each original
%                data variable (dim 2).
%                explained = mean(individualVarExplained,2)

[pcaCoef, PCs, latent, ~, explained] = pca(data');
explained = explained';
PCs = PCs';
[nPCs, prob] = barttest(pcaCoef,0.05);

individualVarExplained = zeros(size(PCs,1),size(data,1));
for j = 1:size(PCs,1)
  for i = 1:size(data,1)
    individualVarExplained(j,i) = (pcaCoef(i,j)*latent(j)*pcaCoef(i,j))/(pcaCoef(i,:)*(latent.*pcaCoef(i,:)'));
  end
end