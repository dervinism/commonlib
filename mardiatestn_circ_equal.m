function [bH, fPEst, fWTest, strPMethod] = mardiatestn_circ_equal(cvfX, fAlpha)

% mardiatestn_circ_equal - FUNCTION Perform an N-sample test of equal distributions, on a periodic domain
%
% Usage: [bH, fPEst, fWTest, strPMethod] = mardiatestn_circ_equal(cvfX <, fAlpha>)
%
% 'cvfX' is a cell array, each cell containing samples from a distribution to test.  The
% Mardia test is a non-parametric rank test whether the distributions in 'cvfX' are
% identical (H0: homogeneous) [1, 2].
%
% 'bH' is a boolean value indicating whether we must reject H0: if true, then the distributions
% in 'cvfX' are not all homogeneous.  No further indication is made as to which distributions
% are different, or which samples are different.  The optional argument 'fAlpha' can be used
% to set the significance threshold for the test (default: 5%).
%
% This statistical test compares 2 or more distributions on a periodic domain [-pi pi].  
% It is a rank test, and is insensitive to centre of mass location on the circular domain.
% For small sample sizes, p-value estimates are computed using Monte-Carlo resampling of 
% the distributions.  For larger sample sizes the test statistic adopts a Chi^2 distribution
% and a p-value estimation is made accordingly.
%
% 'fPEst' is an estimate for the p-value of the W test statistic, which is returned in 'fWTest'.
% 'strPMethod' indicates which method was used to estimate the p-value: 'monte-carlo' or
% 'chi^2', accordingly.
%
% This test is suitable for 2-N distributions.  For comparing two distributions, the Kuiper
% test may be more sensitive.
%
% References:
% [1] N.I. Fisher 1993. "Statistical analysis of circular data." Cambridge University Press.
% [2] K.V. Mardia 1972. "A multi-sample uniform scores test on a circle and its parametric 
%        competitor." J Royal Statistical Society B (Methodological) 34, 102-113.

% Author: Dylan Muir <muir@hifo.uzh.ch>
% Created: 7th February, 2013

% -- Defaults

DEF_nMonteCarloSamples = 1000;
DEF_fAlpha = 0.05;


% -- Check arguments

if (nargin < 1)
   disp('--- mardiatestn_circ_equal: Incorrect usage');
   help mardiatestn_circ_equal;
   return;
end

if (~exist('fAlpha', 'var') || isempty(fAlpha))
   fAlpha = DEF_fAlpha;
end


% -- Calculate circular ranks for each sample set

vnSampleSizes = cellfun(@numel, cvfX);
cvfX = cellfun(@(c)(c(:)), cvfX, 'UniformOutput', false);
vfAllSamples = vertcat(cvfX{:});
[~, vnLinRanks] = sort(vfAllSamples);
vfCircRanks = 2*pi * vnLinRanks / numel(vnLinRanks);

% - Calculate test statistic
fWTest = w_stat(vfCircRanks, vnSampleSizes);


% -- Do we need to estimate a P value?

if (any(vnSampleSizes < 10))
   % - Perform a monte-carlo resampling to estimate the distribution of W
   for (nSample = DEF_nMonteCarloSamples:-1:1)
      vfW_MC(nSample) = w_stat(random_order(vfCircRanks), vnSampleSizes);
   end
   
   % - Estimate P value
   fPEst = nnz(vfW_MC > fWTest) / DEF_nMonteCarloSamples;
   fPEst = nanmax(fPEst, 1 / DEF_nMonteCarloSamples);

   strPMethod = 'monte-carlo';
   
else
   % - Use a Chi^2 distribution to estimate p-value
   fPEst = 1-cdf('chi2', fWTest, 2*numel(cvfX) - 2);
   strPMethod = 'chi^2';
end

% - Perform hypothesis test
bH = (fPEst < fAlpha);

% --- END of mardiatestn_circ_equal function ---


	% w_stat - FUNCTION Compute the W statistic for a set of ranks
	
   function [fWStat] = w_stat(vfCircRanks, vnSampleSizes)
      % - Assign circular ranks back to sample sets
      cvfCircRanks = mat2cell(vfCircRanks, vnSampleSizes, 1);
      
      % - Compute C and S transformations
      vfC = cellfun(@(vfCircRank)nansum(cos(vfCircRank)), cvfCircRanks);
      vfS = cellfun(@(vfCircRank)nansum(sin(vfCircRank)), cvfCircRanks);
      
      % - Compute test statistic W
      fWStat = 2 * nansum((vfC.^2 + vfS.^2) ./ vnSampleSizes(:));
   end

	% --- END of w_stat FUNCTION ---


	% random_order - FUNCTION Return a random ordering of a set of data

   function vOrder = random_order(vData)
      [nul, vnIndices] = sort(rand(1, numel(vData)));
      vOrder = vData(vnIndices);
   end
   
end

% --- END of mardiatestn_circ_equal.m ---
