% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/envKernel.R
\name{EnvKernel}
\alias{EnvKernel}
\title{Easily Building of Environmental Relatedness Kernels}
\usage{
EnvKernel(
  env.data,
  Y = NULL,
  is.scaled = TRUE,
  sd.tol = 1,
  tol = 0.001,
  bydiag = FALSE,
  merge = FALSE,
  env.id = NULL,
  gaussian = FALSE,
  h.gaussian = NULL
)
}
\arguments{
\item{env.data}{matrix. Data from environmental variables (or markers) per environment (or combinations of genotype-environment).}

\item{Y}{data.frame. Phenotypic data set containing environment id, genotype id and trait value.}

\item{is.scaled}{boolean. If environmental data is mean-centered and scaled (default = TRUE), assuming x~N(0,1).}

\item{sd.tol}{numeric. Maximum standard deviation value for quality control. Coluns above this value are eliminated.}

\item{tol}{numeric. Value of tolerance (default = 0.001).}

\item{bydiag}{boolean. If TRUE, the parametrization by WW'/diag(WW') is applied. If FALSE, WW'/ncol(W).}

\item{merge}{boolean. if TRUE, the environmental covariables are merged with Y to build a n x n dimension env.kernel.}

\item{env.id}{character. Identification of experiment.}

\item{gaussian}{boolean. If TRUE, uses the gaussian kernel parametrization for W, where envCov = exp(-h*d/q).}

\item{h.gaussian}{numeric. If gaussian = TRUE, returns the h parameter for exp(-h*d/q).}
}
\value{
A list with environmental kinships for reaction norm models. Two matrices are produced. varCov with the distance for environmental covariables, and envCov with distances for genotypes.
}
\description{
Returns environmental kinships for reaction norm models. Output is a list containing the objects varCov kinship for environmental variables and envCov kinshp for environmental relatedness.
}
\details{
TODO
}
\examples{
### Loading the genomic, phenotype and weather data
data('maizeYield'); data("maizeWTH")

### getting the W matrix from weather data
W.cov <- W.matrix(env.data = maizeWTH)

### Parametrization by K_W = WW'/ncol(W)
EnvKernel(env.data = W.cov,
          Y = maizeYield,
          merge = FALSE,
          env.id = 'env',
          gaussian = FALSE)

### Parametrization by K_W = WW'/diag( WW')
EnvKernel(env.data = W.cov,
          Y = maizeYield,
          merge = FALSE,
          env.id = 'env',
          bydiag = TRUE)

}
\seealso{
W.matrix
}
\author{
Germano Costa Neto
}
