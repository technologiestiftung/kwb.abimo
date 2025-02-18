% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/run_abimo.R
\name{run_abimo}
\alias{run_abimo}
\title{Run Abimo with Input Data or Input File}
\usage{
run_abimo(
  input_file = NULL,
  input_data = NULL,
  output_file = NULL,
  config_file = NULL,
  config = NULL,
  tag = "v3.3.0"
)
}
\arguments{
\item{input_file}{path to input dbf file}

\item{input_data}{data frame from which a temporaryinput file is to be
generated}

\item{output_file}{path to output file. By default the output file has the
same name as the input file with "_result" appended}

\item{config_file}{optional. Path to config.xml file}

\item{config}{optional. Configuration object of class "abimoConfig", as
returned by \code{create_configurator}. If given, \code{config_file} is
ignored.}

\item{tag}{version tag of Abimo release to be used, see
\url{https://github.com/KWB-R/abimo/releases}}
}
\value{
data frame, read from dbf file that was created by Abimo.exe
}
\description{
Run Abimo with Input Data or Input File
}
