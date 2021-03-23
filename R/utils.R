# extdata_file -----------------------------------------------------------------

#' Get Path to File in This Package
#'
#' @param \dots parts of path passed to \code{\link{system.file}}
#' @export
extdata_file <- function(...) {
  system.file("extdata", ..., package = "kwb.abimo")
}

# default_config -----------------------------------------------------------------

#' Default ABIMO config.xml path
#'
#' @export
#' @examples
#' kwb.abimo::default_config()
default_config <- function() {
  extdata_file("config.xml")
}
