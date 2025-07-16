


#' QQ plot for > 1M points
#'
#' QQ plot for > 1M points using scattermore to create small editable images
#'
#' @param pvalues array of p-values
#' @param n number of tests performed. defaults to \code{length(pvalues)}
#' @param pointsize size of points
#' @param color color of points
#' @param ... other arguments passed to \code{geom_scattermore()} 
#'
#' @examples
#' qqgwas(runif(1000000))
#' 
#' @description
#' Saving a QQ plot with >1M p-values can be slow and create a huge PDF since each point is saved when using \code{geom_point()}. Instead, use \code{geom_scattermore()} to rasterize points. This saves an image of the points, so overlapping points are just plotted once. This dramatically reduces the size of editable PDFs.
#'
#' @importFrom stats ppoints qqplot
#' @importFrom scattermore geom_scattermore
#' @import ggplot2
#' @export
qqgwas = function(pvalues, n = length(pvalues), pointsize = 4, color = "dodgerblue",...){
  
  ord <- order(pvalues)
  xval <- ppoints(n)

  res_qq <- qqplot(xval, pvalues[ord], plot.it = FALSE)

  x <- y <- NULL

  # using order() to retain original order of statistics
  df_tmp <- data.frame(
    x = -log10(res_qq$x[order(ord)]),
    y = -log10(res_qq$y[order(ord)])
  )

  xmax = max(df_tmp$x) * 1.02
  ymax = max(df_tmp$y) * 1.02

  ggplot(df_tmp, aes(x,y)) +
    geom_abline(intercept=0, slope=1) +
    geom_scattermore(pointsize=pointsize, color=color,...) +
    theme_classic() +
    theme(aspect.ratio=1) +
    scale_x_continuous(limits=c(0, xmax), expand=c(0,0)) +
    scale_y_continuous(limits=c(0, ymax), expand=c(0,0)) +
    xlab(bquote(Expected~-log[10]~P))+
    ylab(bquote(Observed~-log[10]~P))
}
