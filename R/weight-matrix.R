#' Renders a plot showing the given weight matrix.
#' @author Viliam Simko
#'
#' @param w Weight matrix
#' @param show.legend When TRUE, a legend is also rendered within the plot.
#' @examples
#' w <- weight_matrix_circular_fade(11,2)
#' plot_weight_matrix(w)
#'
#' @import grDevices graphics
#' @export
plot_weight_matrix <- function(w, show.legend = TRUE) {

  # sanity check
  stopifnot(is.matrix(w))
  stopifnot(is.logical(show.legend))

  # plotting the matrix
  image(w, col = gray.colors(100), axes = FALSE, asp = 1)

  # plotting a box around the image
  cx <- .5 / (ncol(w) - 1)
  cy <- .5 / (nrow(w) - 1)
  rect(0 - cx, 0 - cy, 1 + cx, 1 + cy)

  # plotting the legend
  if (show.legend) {
    # matrix dimensions
    legend(1,1,
           xjust = 1,
           yjust = 1,
           bg = rgb(0,0,0,.3),
           border = rgb(1,1,1,.5),
           text.col = "white",
           legend = c( sprintf("%d x %d", nrow(w), ncol(w)) )
    )

    # min/max values
    legend(1,0,
           xjust = 1,
           yjust = 0,
           bg = "white",
           legend = c(sprintf("Min value = %.2f", round(min(w, na.rm = TRUE), 2)),
                      sprintf("Max value = %.2f", round(max(w, na.rm = TRUE), 2))
           ),
           fill = c(col[1], col[length(col)])
    )
  }
}

#' Just a simple square matrix.
#' @author Viliam Simko
#'
#' @param size Odd number representing the matrix width and height. Minimal
#'   matrix size is 3x3.
#' @return boolean square matrix
#' @examples
#' weight_matrix_squared(5)
#' @export
weight_matrix_squared <- function(size) {
  # sanity checks
  stopifnot(size %% 2 == 1) # size must be an odd number
  stopifnot(size >= 3)

  wmatrix <- matrix(TRUE, size, size)
  stopifnot(is.logical(wmatrix)) # sanity check
  wmatrix
}

#' Circular shape with a sharp falloff at the edge.
#' @author Viliam Simko
#'
#' @param size Odd number representing the matrix width and height.
#'   Minimal matrix size is 3x3.
#' @return boolean square matrix
#' @examples
#' w <- weight_matrix_circular(5)
#' plot_weight_matrix(w)
#' @export
weight_matrix_circular <- function(size) {
  # sanity checks
  stopifnot(size %% 2 == 1) # size must be an odd number
  stopifnot(size >= 3)

  w <- matrix(1, size, size)
  x <- col(w)
  y <- row(w)
  m <- (size + 1) / 2
  r <- sqrt((x - m) ^ 2 + (y - m) ^ 2)

  wmatrix <- (r <= m - 0.6)
  wmatrix[!wmatrix] <- NA # replace FALSE with NAs
  stopifnot(is.logical(wmatrix)) # sanity check
  wmatrix
}

#' Helper function used in \code{sigmoid_falloff}. See example.
#' @author Viliam Simko
#'
#' @param x X-coordinate.
#' @return value on the sigmoid curve
#' @examples
#' plot(sigmoid(-10:10), type="l")
sigmoid <- function(x) 1/(1 + exp(-x))

#' Helper function which produces a smooth transition from 1 to 0 with a
#' sigmoidal falloff. See example.
#' @author Viliam Simko
#'
#' @param x Input number on x-axis
#' @param size Size of the interpolation
#' @param fsize Size of the fallof part.
#' @examples
#' x <- 1:100
#' y <- sigmoid_falloff(x, 100, 20)
#' plot(x, y)
#' @export
sigmoid_falloff <- function(x, size, fsize) {
  sigmoid( -6 * (x - size + fsize/2) / fsize)
}

#' Circular shape with sigmoid falloff at the edge.
#' @author Viliam Simko
#'
#' @param size Odd number representing the matrix width and height.
#'   Minimal matrix size is 3x3.
#' @param fsize Size of the fallof part.
#' @return square matrix of doubles
#' @examples
#' w <- weight_matrix_circular_fade(21, 3)
#' plot_weight_matrix(w)
#' @export
weight_matrix_circular_fade <- function(size, fsize) {
  # sanity checks
  stopifnot(size %% 2 == 1) # size must be an odd number
  stopifnot(size >= 3)

  w <- matrix(1, size, size)
  x <- col(w)
  y <- row(w)
  m <- (size + 1) / 2
  r <- sqrt((x - m) ^ 2 + (y - m) ^ 2)

  wmatrix <- sigmoid_falloff(r, size/2, fsize)
  wmatrix[wmatrix == 0] <- NA
  stopifnot(is.double(wmatrix)) # sanity check
  wmatrix
}
