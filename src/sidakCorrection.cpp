
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export(.sidakCorrection)]]
double sidakCorrection(const double &p, const double &n, const double &cutoff = 1e-12) {
  double value;

  if( p > cutoff ){
    // standard formula
    value = 1 - pow(1 - p, n);
  }else{
    // Taylor series to 3rd power
    value = n * p + (n * (n-1) / 2.0) * pow(p, 2.0) + (n * (n-1) * (n-2) / 6.0) * pow(p, 3.0);
  }
  return( value );
 }