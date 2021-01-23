#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Key TA
#'
#' @param data,params,size key stuff to gracefully place the TA on the graph
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
draw_key_TA <-  function(data, params, size) {

  filename <- system.file(paste0(data$TA, ".png"), package = "ggprotist", mustWork = TRUE)
  # print(filename)
  img <- as.raster(png::readPNG(filename))
  aspect <- dim(img)[1]/dim(img)[2]
  # rasterGrob
  grid::rasterGrob(image         = img)
}

# TAGrob
TAGrob <- function(x, y, size, TA = "papilio", geom_key = list(papilio = "papilio.png")) {

  filename <- system.file(geom_key[[unique(TA)]], package = "ggprotist", mustWork = TRUE)
  img <- as.raster(png::readPNG(filename))

  # rasterGrob
  grid::rasterGrob(x             = x,
                   y             = y,
                   image         = img,
                   # only set height so that the width scales proportionally and so that the icon
                   # stays the same size regardless of the dimensions of the plot
                   height        = size * ggplot2::unit(20, "mm"))
}

# GeomBernie
GeomTA <- ggplot2::ggproto(`_class` = "GeomTA",
                               `_inherit` = ggplot2::Geom,
                               required_aes = c("x", "y"),
                               non_missing_aes = c("size", "TA"),
                               default_aes = ggplot2::aes(size = 1, TA = "papilio", shape  = 19,
                                                          colour = "black",   fill   = NA,
                                                          alpha  = NA,
                                                          stroke =  0.5,
                                                          scale = 5,
                                                          image_filename = "papilio"),

                               draw_panel = function(data, panel_scales, coord, na.rm = FALSE) {
                                 coords <- coord$transform(data, panel_scales)
                                 ggplot2:::ggname(prefix = "geom_TA",
                                                  grob = TAGrob(x = coords$x,
                                                                    y = coords$y,
                                                                    size = coords$size,
                                                                    TA = coords$TA))
                               },

                               draw_key = draw_key_TA)

#' @title Testate Amoeba layer
#' @description The geom is used to add Testate Amoeba to plots. See ?ggplot2::geom_points for more info.
#' @inheritParams ggplot2::geom_point
#' @param TA The TA species you want to use (for now on only papilio works. More to come)
#' @examples
#'
#' # install.packages("ggplot2")
#'library(ggplot2)
#'
#' ggplot(mtcars) +
#'  geom_TA(aes(mpg, wt), TA = "papilio") +
#'  theme_bw()
#'
#' ggplot(mtcars) +
#'  geom_TA(aes(mpg, wt), TA = "papilio") +
#'  theme_bw()
#'
#' @importFrom grDevices as.raster
#' @export
geom_TA <- function(mapping = NULL,
                        data = NULL,
                        stat = "identity",
                        position = "identity",
                        ...,
                        na.rm = FALSE,
                        show.legend = NA,
                        inherit.aes = TRUE) {

  ggplot2::layer(data = data,
                 mapping = mapping,
                 stat = stat,
                 geom = GeomTA,
                 position = position,
                 show.legend = show.legend,
                 inherit.aes = inherit.aes,
                 params = list(na.rm = na.rm, ...))
}




