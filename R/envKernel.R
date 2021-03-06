#'@title Easily Building of Environmental Relatedness Kernels
#'
#'
#' @description Returns environmental kinships for reaction norm models. Output is a list containing the objects varCov kinship for environmental variables and envCov kinshp for environmental relatedness.
#' @author Germano Costa Neto
#' @param env.data matrix. Data from environmental variables (or markers) per environment (or combinations of genotype-environment).
#' @param is.scaled boolean. If environmental data is mean-centered and scaled (default = TRUE), assuming x~N(0,1).
#' @param sd.tol numeric. Maximum standard deviation value for quality control. Coluns above this value are eliminated.
#' @param tol numeric. Value of tolerance (default = 0.001).
#' @param Y data.frame. Phenotypic data set containing environment id, genotype id and trait value.
#' @param merge boolean. if TRUE, the environmental covariables are merged with Y to build a n x n dimension env.kernel.
#' @param env.id character. Identification of experiment.
#' @param bydiag boolean. If TRUE, the parametrization by WW'/diag(WW') is applied. If FALSE, WW'/ncol(W).
#' @param gaussian boolean. If TRUE, uses the gaussian kernel parametrization for W, where envCov = exp(-h*d/q).
#' @param h.gaussian numeric. If gaussian = TRUE, returns the h parameter for exp(-h*d/q).
#'
#' @return A list with environmental kinships for reaction norm models. Two matrices are produced. varCov with the distance for environmental covariables, and envCov with distances for genotypes.
#'
#' @details
#' TODO
#'
#' @examples
#' ### Loading the genomic, phenotype and weather data
#' data('maizeYield'); data("maizeWTH")
#'
#' ### getting the W matrix from weather data
#' W.cov <- W.matrix(env.data = maizeWTH)
#'
#' ### Parametrization by K_W = WW'/ncol(W)
#' EnvKernel(env.data = W.cov,
#'           Y = maizeYield,
#'           merge = FALSE,
#'           env.id = 'env',
#'           gaussian = FALSE)
#'
#' ### Parametrization by K_W = WW'/diag( WW')
#' EnvKernel(env.data = W.cov,
#'           Y = maizeYield,
#'           merge = FALSE,
#'           env.id = 'env',
#'           bydiag = TRUE)
#'
#' @seealso W.matrix
#'
#' @importFrom stats sd dist
#' @export

EnvKernel <-function(env.data,Y=NULL, is.scaled=TRUE, sd.tol = 1,
                     tol=1E-3, bydiag=FALSE, merge=FALSE,
                     env.id=NULL,gaussian=FALSE, h.gaussian=NULL){

  nr<-nrow(env.data)
  nc <-ncol(env.data)

  if(!is.matrix(env.data)){stop('env.data must be a matrix')}
  if(isFALSE(is.scaled)){
    Amean <- env.data-apply(env.data,2,mean)+tol
    sdA   <- apply(Amean,2,sd)
    A. <- Amean/sdA
    removed <- names(sdA[sdA < sd.tol])
    env.data <- A.[,!colnames(A.) %in% removed]
    t <- ncol(env.data)
    r <- length(removed)
    cat(paste0('------------------------------------------------','\n'))
    cat(paste0(' Removed envirotype markers:','\n'))
    cat(paste0(r,' from ',t,'\n'))
    cat(paste0(removed,'\n'))
    cat(paste0('------------------------------------------------','\n'))

  }

  if(isTRUE(merge)){
    if(is.null(env.id)) env.id <- 'env'
    env.data <- envK(env.data = env.data,df.pheno=Y,env.id=env.id)
  }
  if(isTRUE(gaussian)){
    O <- gaussian(x = env.data,h=h.gaussian)
    H <- gaussian(x = t(env.data),h=h.gaussian)
    return(list(varCov=H,envCov=O))

  }
  if(isFALSE(gaussian)){
    O <- tcrossprod(env.data)#/ncol(env.data)  # env.relatedness kernel from covariates
    H <- crossprod(env.data)#/nrow(env.data)   # covariable relatedness kernel from covariates
    if(isTRUE(bydiag)){
      O <- O/(sum(diag(O))/nc) + diag(1e-2, nrow(O))
      H <- H/(sum(diag(H))/nr) + diag(1e-2, nrow(H))
    }
    if(isFALSE(bydiag)){
      O <- O/nc + diag(1e-2, nrow(O))
      H <- H/nr + diag(1e-2, nrow(H))
    }


  }
  return(list(varCov=H,envCov=O))
}



gaussian <- function(x,h=NULL){
  d<-as.matrix(dist(x,upper = TRUE,diag = TRUE))^2
  q <- median(d)
  if(is.null(h)) h <- 1

  return(exp(-h*d/q))
}

envK = function(env.data,df.pheno,skip=3,env.id){
  df.pheno <-data.frame(df.pheno)
  env.data <-data.frame(env.data)
  env.data$env <- as.factor(rownames(env.data))
  W <- as.matrix(merge(df.pheno,env.data, by=env.id)[,-c(1:skip)])
  return(W)

}
