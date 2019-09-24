function [pcaCoef, explained, PCs, nPCs, prob] = pcaGeneric(data)
% [pcaCoef, explained, PCs, nPCs, prob] = pcaGeneric(data)
% The most generic PCA used by PCAanalysis.
% Inputs: data - a data matrix with rows corresponding to individual data
%                vectors and columns corresponding to single instances or
%                time.
% Outputs: pcaCoef - coeficients of principal components (see Matlab's
%                    inbuilt pca function for more explanation).
%          explained - the percentage of the total variance explained by
%                      each principal component (see Matlab's pca).
%          PCs - the actual principal components. This matrix has the same
%                dimensions as the input matrix data.
%          nPCs - number of principal components.
%          prob - the probabilities of Bartlett's test (alpha = 0.05). The
%                 number of ouput probabilities will always be a number of
%                 components - 1. It tests whether variances of all
%                 principal components are equal followed by a test
%                 excluding the first component and so on until only the
%                 last two components remain in the last test.

[pcaCoef, PCs, ~, ~, explained] = pca(data');
explained = explained';
PCs = PCs';
[nPCs, prob] = barttest(pcaCoef,0.05);
end