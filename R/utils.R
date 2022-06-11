# extdata_file -----------------------------------------------------------------

#' Get Path to File in This Package
#'
#' @inheritParams kwb.utils::extdataFile
#' @export
extdata_file <- kwb.utils::createFunctionExtdataFile("kwb.abimo")

# default_config -----------------------------------------------------------------

#' Default ABIMO config.xml path
#'
#' @export
#' @examples
#' kwb.abimo::default_config()
default_config <- function() {
  extdata_file("config.xml")
}
