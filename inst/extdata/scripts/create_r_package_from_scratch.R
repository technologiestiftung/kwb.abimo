## How to build an R package from scratch
remotes::install_github("kwb-r/kwb.pkgbuild")

usethis::create_package(".")
fs::file_delete(path = "DESCRIPTION")


author <- list(name = "Michael Rustler",
               orcid = "0000-0003-0647-7726",
               url = "https://mrustl.de")

pkg <- list(name = "kwb.abimo",
            title = " R Package with Functions for Working with Water Balance Model ABIMO ",
            desc  = paste("R Package with functions for working with water balance bodel ABIMO ",
                          "https://www.stadtentwicklung.berlin.de/umwelt/umweltatlas/download/goedecke_et_al_abimo2019_doku.pdf)."))


kwb.pkgbuild::use_pkg(author,
                      pkg,
                      version = "0.0.0.9000",
                      stage = "experimental")


usethis::use_vignette("tutorial")

### R functions
if(FALSE) {
  ## add your dependencies (-> updates: DESCRIPTION)
  pkg_dependencies <- c('foreign', 'gridExtra', 'kwb.utils')

  sapply(pkg_dependencies, usethis::use_package)

  desc::desc_add_remotes("kwb-r/kwb.utils",normalize = TRUE)
  usethis::use_pipe()
}

kwb.pkgbuild::create_empty_branch_ghpages("kwb.abimo")
