
LOCATION=/Users/gabrielhoffman/workspace/repos/sidakCorrection
cd $LOCATION/../

VERSION=$(grep Version $LOCATION/DESCRIPTION | cut -f2 -d' ')
Rscript -e "library(roxygen2); roxygenise('${LOCATION}')"; 

R CMD build $LOCATION

R CMD INSTALL sidakCorrection_${VERSION}.tar.gz



rmarkdown::render("sidakCorrection.Rmd")


q()
R
library(sidakCorrection)


sidakCorrection:::sidakCorrection(.4, 1000)




p = runif(10000) 
sidakCorrection(p, 1000)


