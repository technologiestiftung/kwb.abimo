[![R-CMD-check](https://github.com/KWB-R/kwb.abimo/workflows/R-CMD-check/badge.svg)](https://github.com/KWB-R/kwb.abimo/actions?query=workflow%3AR-CMD-check)
[![pkgdown](https://github.com/KWB-R/kwb.abimo/workflows/pkgdown/badge.svg)](https://github.com/KWB-R/kwb.abimo/actions?query=workflow%3Apkgdown)
[![codecov](https://codecov.io/github/KWB-R/kwb.abimo/branch/main/graphs/badge.svg)](https://codecov.io/github/KWB-R/kwb.abimo)
[![Project Status](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/kwb.abimo)]()

# kwb.abimo

R Package with functions for working with water balance model ABIMO
https://www.berlin.de/umweltatlas/_assets/literatur/goedecke_et_al_abimo2019_doku.pdf

## Installation

For details on how to install KWB-R packages checkout our [installation tutorial](https://kwb-r.github.io/kwb.pkgbuild/articles/install.html).

```r
### Optionally: specify GitHub Personal Access Token (GITHUB_PAT)
### See here why this might be important for you:
### https://kwb-r.github.io/kwb.pkgbuild/articles/install.html#set-your-github_pat

# Sys.setenv(GITHUB_PAT = "mysecret_access_token")

# Install package "remotes" from CRAN
if (! require("remotes")) {
  install.packages("remotes", repos = "https://cloud.r-project.org")
}

# Install KWB package 'kwb.abimo' from GitHub
remotes::install_github("KWB-R/kwb.abimo")
```

## Documentation

Release: [https://kwb-r.github.io/kwb.abimo](https://kwb-r.github.io/kwb.abimo)

Development: [https://kwb-r.github.io/kwb.abimo/dev](https://kwb-r.github.io/kwb.abimo/dev)

## General Usage

### Run Abimo with current data for Berlin as stored in this package

```
result <- kwb.abimo::run_abimo(input_data = kwb.abimo::abimo_input_2019)
```

### Run Abimo with a given dbf file

```
result <- kwb.abimo::run_abimo(input_file = input_file)
```

### Let Abimo calculate the "Bagrov curves"

```
library(ggplot2)

# Let Abimo.exe output results of the Bagrov calculation
bagrov_lines <- kwb.abimo::run_abimo_command_line("--write-bagrov-table")

# Convert the text lines to a data frame
bagrov <- read.table(text = bagrov_lines, header = TRUE, sep = ",")

# Plot the Bagrov data
ggplot(bagrov, aes(x = x, y = y, groups = factor(bag))) + geom_line()
```
