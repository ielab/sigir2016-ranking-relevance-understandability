# Author: Mark D. Smucker
# Date: January 2013
# version: 1.0 (January, 2013)
# Most recent version: http://www.mansci.uwaterloo.ca/~msmucker/apcorr.r
#
#    This code was written for and used in the evaluation of the TREC
#    2013 Crowdsourcing Track.  If you use this code, please cite:
#
#    Mark D. Smucker, Gabriella Kazai, and Matthew Lease, "Overview of the
#    TREC 2013 Crowdsourcing Track," TREC 2013. 
#    http://trec.nist.gov/pubs/trec22/papers/CROWD.OVERVIEW.pdf
#

# apcorr implements a version of Yilmaz et al' AP Correlation Coefficient
# that has been adapted to handle ties in the ranking.  See apcorr.nosampling
# for a description of the problem solved by this function.
#
# Input to the function is two vectors of the same length with matching
# pairs at each index.  The values in the vectors determine the ordering 
# of the items.  This is the same way that cor.test works (see cor.test in R).
#
# This version handles ties with sampling. If there are no ties, this version
# simply returns the exact AP Correlation.  
#
# Correct functioning of this method combined with apcorr.nosampling depends 
# on the R order function using a stable sort, which it does.  As per the 
# R manual page for order, "The sort used is stable (except for method = "quick"), 
# so any unresolved ties will be left in their original ordering." 
#
apcorr <- function( truth, estimate, numSamples=1000 )
{
  # we're going to say that the scores at rank i are for an
  # item with an ID of i.  Thus "ID" means the index into
  # the truth and estimate vectors.
  n <- length(truth) 
  if ( length(estimate) != n )
     stop( "must be same length" )

  if ( length(unique(truth)) + length(unique(estimate)) == n + n )
  {
      numSamples <- 1
  }

  sumAPcorr <- 0 
  for ( sampleIdx in 1:numSamples )
  {
      permutation <- sample(n)
      truth <- truth[permutation]
      estimate <- estimate[permutation]	 

      result <- apcorr.nosampling( truth, estimate )
      sumAPcorr <- sumAPcorr + result
  }
  return( sumAPcorr / numSamples )
}

# apcorr.nosampling implements Yilmaz et al' AP Correlation Coefficient.
#
# Input to the function is two vectors of the same length with matching
# pairs at each index.  The values in the vectors determine the ordering 
# of the items.  This is the same way that cor.test works (see cor.test in R).
#
# Note: apcorr.nosampling, while implementing Yilmaz et al,'s original
# formulation of AP Correlation, does not handle ties.  Use the apcorr 
# function to have ties handled gracefully.
#
# Issue with ties: 
#
# Say you have a truth vector of scores for systems A <- c(1,2,3,4), that is,
# A[i] is the score for system i. You then have another vector of scores
# B <- c(1,1,1,1).  The B vector has assigned the same score to every 
# system.  Clearly, B should not have any rank correlation with A.  If
# we compute AP Correlation without handling ties, we get:
# 
# > apcorr.nosampling(c(1,2,3,4),c(1,1,1,1))
# [1] -1
# > apcorr.nosampling(c(4,3,2,1),c(1,1,1,1))
# [1] 1
#
# where the first vector to apcorr.nosampling is the truth (A) and the second
# vector is the estimate (B).  
# 
# As can be seen about, depending on the truth scores, the correlation 
# of B with A can vary from -1 to 1, even though B should have zero 
# correlation with A.
#
# If we sample different orderings of the tied system scores, we get:
# 
# > apcorr(c(1,2,3,4),c(1,1,1,1))
# [1] -0.02222222
# > apcorr(c(4,3,2,1),c(1,1,1,1))
# [1] -0.01044444
#
# which is much more sensible, for no correlation is effectively zero. 
#
# If those estimates are not precise enough for you, you can increase the
# number of samples as needed.  Here we use 10000 samples rather than the 
# default 1000:
#
# > apcorr(c(1,2,3,4),c(1,1,1,1),10000)
# [1] -0.004222222
# > apcorr(c(4,3,2,1),c(1,1,1,1),10000)
# [1] 0.002088889
#
# More examples: Below shows that if we have the highest ranked
# item correctly in the top result, but if we don't handle ties
# correctly, we incorrectly punish the estimate too much.  We next show 
# that if we rank the bottom item correctly, but tie the tops of the
# ranking, then we do get a lower apcorr, but the unsampled version
# says we have a negative correlation -- without proper handling of ties,
# it seems that apcorr can return results that do not make sense.
#
# First example: truth = c(1,2,3,4), estimate=c(1,1,1,2)
# In this example, truth[4] is the best system (highest score of 4)
# and the estimate[4] has correctly placed this system above all
# other systems.  
#
# What does Kendall's tau do with this input?
#
# > cor.test(c(1,2,3,4),c(1,1,1,2),method="kendall")
#
#         Kendall's rank correlation tau
#
# data:  c(1, 2, 3, 4) and c(1, 1, 1, 2) 
# z = 1.3416, p-value = 0.1797
# alternative hypothesis: true tau is not equal to 0 
# sample estimates:
#       tau 
# 0.7071068 
#
# Warning message:
# In cor.test.default(c(1, 2, 3, 4), c(1, 1, 1, 2), method = "kendall") :
#   Cannot compute exact p-value with ties
#
# We see above, that Kendall's tau handles the ties and gives a tau of 
# 0.7, which means there is fairly good rank correlation.
# 
# If we call apcorr and use sampling to handle ties (same pair-wise rankings,
# just different ordering of the pairs):
#
# > apcorr(c(1,2,3,4),c(1,1,1,2), 10000)
# [1] 0.6114889
# > apcorr(c(4,3,2,1),c(2,1,1,1),10000)
# [1] 0.6122
# > apcorr(c(1,4,3,2),c(1,2,1,1), 10000)
# [1] 0.6099444
# > apcorr(c(2,4,3,1),c(1,2,1,1),10000)
# [1] 0.609
# > apcorr(c(3,4,2,1),c(1,2,1,1),10000)
# [1] 0.6064333
#
# versus not handling of the ties:
#
# > apcorr.nosampling(c(1,2,3,4),c(1,1,1,2))
# [1] 0.2222222
# > apcorr.nosampling(c(1,4,3,2),c(1,2,1,1))
# [1] 0.4444444
# > apcorr.nosampling(c(2,4,3,1),c(1,2,1,1))
# [1] 0.6666667
# > apcorr.nosampling(c(4,3,2,1),c(2,1,1,1))
# [1] 1
#
# In other words, if we don't handle ties, we can produce a
# range of values depending on the input order, even though
# each case, the pair-wise scores have not changed.  
#
# Next, what happens if we tie the top 3 systems, but do
# correctly rank the worst system on the bottom?
#
# > cor.test(c(1,2,3,4),c(0,1,1,1),method="kendall")
#
#         Kendall's rank correlation tau
#
# data:  c(1, 2, 3, 4) and c(0, 1, 1, 1) 
# z = 1.3416, p-value = 0.1797
# alternative hypothesis: true tau is not equal to 0 
# sample estimates:
#       tau 
# 0.7071068 
#
# Warning message:
# In cor.test.default(c(1, 2, 3, 4), c(0, 1, 1, 1), method = "kendall") :
#   Cannot compute exact p-value with ties
#
# We see that Kendall's tau gives up the same rank correlation as
# above when we got the top system correct but tied the bottom 
# 3 systems.  This is the problem with Kendall's tau that AP Correlation
# is supposed to solve.  It is far better to correctly get the best system
# at rank 1 than it is to correctly get the worst system at the bottom
# of the ranking!  
# 
# So, what does AP Correlation do?
#
# > 
# > apcorr.nosampling(c(1,2,3,4),c(0,1,1,1))
# [1] -0.3333333
#
# Without sampling, it can give a negative correlation.  Yes, this is
# worse than the other values it gave above for getting the top system
# correct and tying the bottom systems, but this does not seem right.
# What is negative? The order of the systems is correct, but there 
# are ties.
#
# In contrast, if we handle the ties:
#
# > apcorr(c(1,2,3,4),c(0,1,1,1))
# [1] 0.3346667
#
# We now get the lower correlation as expected, and it is nicely
# still positive.
#
#
apcorr.nosampling <- function( truth, estimate )
{
  # we're going to say that the scores at rank i are for an
  # item with an ID of i.  Thus "ID" means the index into
  # the truth and estimate vectors.
  n <- length(truth) 
  if ( length(estimate) != n )
     stop( "must be same length" )
  truth.order <- order( truth, decreasing=TRUE ) 
  estimate.order <- order( estimate, decreasing=TRUE ) 
  innerSum <- 0
  for ( i in 2:n )
  {
	currDocID <- estimate.order[i] 
	estimate.rankedHigherIDs <- estimate.order[1:(i-1)] 
	# where is the current doc in the truth order?
	currDoc.truth.order.index <- which( truth.order == currDocID )
	truth.rankedHigherIDs <- vector()
	if ( currDoc.truth.order.index != 1 ) # top ranked doc, beware
	{
	    truth.rankedHigherIDs <- truth.order[1:(currDoc.truth.order.index-1)]
	}
	C_i <- length( intersect(estimate.rankedHigherIDs, truth.rankedHigherIDs) )
	innerSum <- innerSum + (C_i / (i-1))
  }
  result = 2 / (n-1) * innerSum - 1   
  return( result )
}

