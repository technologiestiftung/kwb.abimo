# run_abimo --------------------------------------------------------------------

#' Run Abimo with Input Data or Input File
#'
#' @param input_file path to input dbf file
#' @param input_data data frame from which a temporaryinput file is to be
#'   generated
#' @param output_file path to output file. By default the output file has the
#'   same name as the input file with "_result" appended
#' @param config_file path to config.xml file
#' @return data frame, read from dbf file that was created by Abimo.exe
#' @export
run_abimo <- function(
  input_file = NULL, input_data = NULL, output_file = NULL, config_file = NULL
)
{
  if (is.null(input_file) && is.null(input_data)) {
    stop("Either input_file or input_data must be given")
  }

  if (is.null(input_file)) {

    input_file <- file.path(tempdir(), "abimo_input.dbf")
    write.dbf.abimo(input_data, input_file)
  }

  if (! check_abimo_binary()) {
    stop("Could not install Abimo!")
  }

  fullwinpath <- function(x) kwb.utils::windowsPath(path.expand(x))

  output_file <- kwb.utils::defaultIfNULL(
    output_file, default_output_file(input_file)
  )

  args <- fullwinpath(c(input_file, output_file))

  if (! is.null(config_file)) {
    args <- c(args, paste("--config", fullwinpath(config_file)))
  }

  write_abimo_stdout(args)

  foreign::read.dbf(output_file)
}

# default_output_file ----------------------------------------------------------
default_output_file <- function(input_file)
{
  paste0(kwb.utils::removeExtension(input_file), "_result.dbf")
}

# write_abimo_stdout -----------------------------------------------------------
write_abimo_stdout <- function(args)
{
  writeLines(system_to_stdout(abimo_binary(), args = args))
}

# system_to_stdout -------------------------------------------------------------
system_to_stdout <- function(...)
{
  system2(stdout = TRUE, ...)
}

# abimo_help -------------------------------------------------------------------
abimo_help <- function()
{
  write_abimo_stdout("--help")
}

# abimo_version ----------------------------------------------------------------
abimo_version <- function()
{
  write_abimo_stdout("--version")
}
