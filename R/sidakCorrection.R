
#' @useDynLib sidakCorrection, .registration = TRUE
#' @importFrom Rcpp sourceCpp
NULL 

f <- Vectorize( .sidakCorrection, c("p", "n") )  


#' Sidak correction with high precision
#' 
#' Apply the Sidak correction the to smallest p-value selected for a set of n p-values.
#'
#' @param p an array of p-value, with each entry selected as the minimum of n p-values
#' @param n array where each entry is the number of p-values tested
#' @param cutoff for p-values less than this cutoff, the Taylor series is used.  Otherwise the standard formula is used
#'
#' @details
#' When summarizing the results from n statistical tests, simply reporting the minimum p-value, p,  inflates the false positive rate.  Instead, p must be corrected for the number of tests.  The Sidak corrected p-value is \eqn{1 - (1 - p)^n}.  This is uniformly distributed under the null were all individual tests satisfy the null.
#'
#' While this works well statistically, evaluating the formula when p is small can suffer from numerical underflow.  This produces Sidak-corrected p-values of 0, instead of the true value.  This is caused by rounding errors in floating point arithmetic.  For example, with \eqn{p = 1e-16}, \eqn{1-p} rounds to 1 due to finite precision.
#'
#' In applications in genetics, p can often be this small and returning a Sidak-corrected p-value causes problems for downstream analysis.  
#' 
#' We consider 2 ways to compute the Sidak correction with increased precision.
#' 
#' First, we could use the Rmpfr library to perform the calculation at high precision than available with the standard double.  This calculation is simple enough using the code below.  But 1) is >100x slower, 2) it is hard to predict what precision level to test, and 3) requires a high precision library.  This last point isn't an issue in R, but can become a problem in a typical C/C++ program. 
#' 
#' Instead, we use a Taylor series approximation which gives precise estimates even for very small p-values.  Taylor series approximations are widely used to evaluate special functions like sin(), log(), etc.  In this case, the 4th order Taylor series is 
#' \deqn{n * p + (n * (n-1) / 2) * p^2 + (n * (n-1) * (n-2) / 6) * p^3}
#' This performs well for small values of p, but very poorly for large p.  Therefore, the standard formula is used for p > cutoff, and the Taylor series used otherwize.  But default, cutoff = 1e-12.
#' 
#' @examples
#'
#' p = 1e-5 # p-value
#' n = 1000 # number of tests
#'
#' # Sidak-corrected p-value
#' sidakCorrection(p, n)
#' 
#' # Same calculation using Rmpfr high precision library
#' # with precision set to 200 bits
#' p_mpfr <- Rmpfr::mpfr(p, precBits = 200)
#' as.numeric(1 - (1 - p_mpfr)^n)
#'
#' # Simlate minimum p-values 
#' res = lapply(1:20, function(i){
#' 
#'   n = rpois(1, 1000) # number of tests
#'   p.min = min(runif(n)) # minimum p-value
#' 
#'   data.frame(p.min = p.min, n = n)
#'   })
#' res = do.call(rbind, res)
#' 
#' # Apply Sidak-correction for each row
#' sidakCorrection( res$p.min, res$n)
#
#' @export
sidakCorrection <- function(p, n, cutoff = 1e-12){

  stopifnot(all(p <= 1))
  stopifnot(all(p > 0))

  f(p, n, cutoff)
}
     
