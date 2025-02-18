% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/abimo_functions_am.R
\name{replace_value}
\alias{replace_value}
\title{Helper function: replace value}
\usage{
replace_value(
  string,
  new_value,
  parameter = "etp",
  pattern_value = "\\"[0-9]+?\\\\.?[0-9]+?\\""
)
}
\arguments{
\item{string}{string with ABIMO config}

\item{new_value}{new parameter value}

\item{parameter}{parameter name to search for (default: "etp")}

\item{pattern_value}{pattern of value field (default: '\"[0-9]+?\\.?[0-9]+?\"')}
}
\value{
returns string with modified parameter = value
}
\description{
searches for string for parameter=pattern_value
pattern and replaces with parameter="new_value" for all found
entries
}
\examples{
### Simple string
string <- '<item bezirke="15,16,18,19,20" etp="807" etps="600" />'
replace_value(string, new_value = 100, parameter = "etp")
replace_value(string, new_value = 100, parameter = "etps")
### Default ABIMO config
config <- readLines(kwb.abimo::default_config())
replace_value(config, new_value = 100, parameter = "etp")
}
