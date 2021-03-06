% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/GetisOrdLocalStats.R
\name{GetisOrdLocalStats}
\alias{GetisOrdLocalStats}
\title{Locality-aware Getis-Ord G* statistics.}
\usage{
GetisOrdLocalStats(r, focus_matrix)
}
\arguments{
\item{r}{Input raster}

\item{focus_matrix}{Square matrix with odd number of rows/column and boolean
cells.}
}
\value{
Returns a list used in the function \link{GetisOrd}:
  \item{rmean}{Global mean of all raster cells.}
  \item{n}{Number of all cells within the raster.}
  \item{SD}{A raster where each cell corresponds to a focal standard
  deviation from area around the cell given by the matrix \code{focus}.}
  \item{MEAN}{A raster where each cell corresponds to a focal mean from area
  around the cell given by the matrix \code{focus}.}
  \item{focus}{Copy of the \code{focus} matrix given as input parameter.}
}
\description{
Locality-aware Getis-Ord G* statistics.
}
\examples{
library(raster)
r <- raster( matrix(rnorm(400), 20, 20) )
w <- weight_matrix_circular_fade(7, 2)
f <- weight_matrix_circular(11)
st <- GetisOrdLocalStats(r, f)
plot(GetisOrd(r, w, st))

}
\author{
Viliam Simko
}
