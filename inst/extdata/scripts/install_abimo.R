if (FALSE)
{
  # Download abimo executable and dependencies in zip file
  #repo = "KWB-R/abimo"; tag = "v3.2.2"
  zip_file <- download_asset(repo = "KWB-R/abimo", tag = "v3.2.2")

  exdir <- file.path(kwb.abimo:::extdata_file(), "abimo_win64")

  kwb.utils::createDirectory(exdir)

  kwb.utils::hsOpenWindowsExplorer(dirname(zip_file))

  #archive::archive_extract(zip_file, dir = exdir, )
}

# download_asset ---------------------------------------------------------------
download_asset <- function(repo, tag, destfile = NULL)
{
  asset_info <- get_asset_info(repo, tag)

  if (is.null(destfile)) {
    destfile <- file.path(
      tempdir(),
      kwb.utils::selectElements(asset_info, "name")
    )
  }

  download.file(
    kwb.utils::selectElements(asset_info, "url"),
    destfile,
    headers = c(
      Authorization = paste("token", remotes:::github_pat()),
      Accept = "application/octet-stream"
    )
  )

  destfile
}

# get_asset_info ---------------------------------------------------------------
get_asset_info <- function(repo, tag)
{
  url_releases <- kwb.utils::resolve(
    "https://api.github.com/repos/<repo>/releases",
    repo = repo
  )

  release_info <- gh::gh(url_releases)

  tag_names <- sapply(release_info, "[[", "tag_name")

  match.arg(tag, tag_names)

  assets <- release_info[[which(tag == tag_names)]]$assets

  if (! length(assets)) {
    stop("There are no assets for release ", version)
  }

  asset <- assets[[1L]]

  kwb.utils::selectElements(asset, c("name", "url"))
}
