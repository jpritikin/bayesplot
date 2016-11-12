#' Posterior predictive checks (S3 generic and default method)
#'
#' S3 generic with simple default method. The intent is to provide a generic so
#' authors of other \R packages who wish to provide interfaces to the functions
#' in \pkg{bayesplot} will be encouraged to include \code{pp_check} methods in
#' their package, preserving the same naming conventions for posterior
#' predictive checking across many \R packages for Bayesian inference. This is
#' for the convenience of both users and developers. See the \strong{Details}
#' and \strong{Examples} sections, below, and the package vignettes for examples
#' of defining \code{pp_check} methods.
#'
#' @export
#' @param object Typically a fitted model object. The default method, however,
#' takes \code{object} to be a \code{y} (outcome) vector.
#' @param ... For the generic, arguments passed to individual methods. For the
#'   default method, these are additional arguments to pass to \code{fun}.
#' @return The exact form of the value returned by \code{pp_check} may vary by
#'   the class of \code{object}, but for consistency we encourage authors of
#'   methods to return the ggplot object created by one of \pkg{bayesplot}'s
#'   plotting functions. The default method returns the object returned by
#'   \code{fun}.
#'
#' @details A package that creates fitted model objects of class \code{"foo"}
#'   can include a method \code{pp_check.foo} that prepares the appropriate
#'   inputs (\code{y}, \code{yrep}, etc.) for the \pkg{bayesplot} functions. The
#'   \code{pp_check.foo} method may, for example, let the user choose between
#'   various plots, calling the functions from \pkg{bayesplot} internally as
#'   needed. See \strong{Examples}, below, and the package vignettes.
#'
#' @examples
#' # default method
#' y <- example_y_data()
#' yrep <- example_yrep_draws()
#' pp_check(y, yrep[1:50,], ppc_dens_overlay)
#'
#' g <- example_group_data()
#' pp_check(y, yrep, fun = "stat_grouped", group = g, stat = "median")
#'
#' # defining a method
#' x <- list(y = rnorm(50), yrep = matrix(rnorm(5000), nrow = 100, ncol = 50))
#' class(x) <- "foo"
#' pp_check.foo <- function(object, ..., type = c("multiple", "overlaid")) {
#'   y <- object[["y"]]
#'   yrep <- object[["yrep"]]
#'   switch(match.arg(type),
#'          multiple = ppc_hist(y, yrep[1:min(8, nrow(yrep)),, drop = FALSE]),
#'          overlaid = ppc_dens_overlay(y, yrep))
#' }
#' pp_check(x)
#' pp_check(x, type = "overlaid")
#'
pp_check <- function(object, ...) {
  UseMethod("pp_check")
}

#' @rdname pp_check
#' @export
#' @param yrep For the default method, a \code{yrep} matrix passed to
#'   \code{fun}.
#' @param fun For the default method, the plotting function to call. Can be any
#'   of the \link[=PPC]{PPC functions}. The \code{"ppc_"} prefix can optionally
#'   be dropped if \code{fun} is specified as a string.
#'
pp_check.default <- function(object, yrep, fun, ...) {
  if (is.character(fun) && substr(fun, 1, 4) != "ppc_")
    fun <- paste0("ppc_", fun)
 .ppcfun <- match.fun(fun)
 .ppcfun(y = object, yrep = yrep, ...)
}