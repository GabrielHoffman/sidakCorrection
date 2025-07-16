
LOCATION=/Users/gabrielhoffman/workspace/repos/sidakCorrection
cd $LOCATION/../

VERSION=$(grep Version $LOCATION/DESCRIPTION | cut -f2 -d' ')
Rscript -e "library(roxygen2); roxygenise('${LOCATION}')"; 

R CMD build $LOCATION

R CMD INSTALL sidakCorrection_${VERSION}.tar.gz


R CMD check --as-cran sidakCorrection_${VERSION}.tar.gz


# rm -f  NAMESPACE R/RcppExports.R src/RcppExports.* src/*o



rmarkdown::render("sidakCorrection.Rmd")



library(sidakCorrection)
pkgdown::build_site()
pkgdown::build_reference()

pkgdown::build_article("sidakCorrection")




q()
R
library(sidakCorrection)

p = runif(10000) 
sidakCorrection(p, 1000)


sidakCorrection( res$p.min, res$n)[5]
sidakCorrection( res$p.min[5], res$n[5])