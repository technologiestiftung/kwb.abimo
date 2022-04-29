#install.packages("xml2")

# Configure ABIMO Model Run ----------------------------------------------------
if (FALSE)
{
  # Path to Abimo configuration file
  xml_file <- "~/qt-projects/abimo/data/config.xml"

  # Create a configurator object
  config <- create_configurator(xml_file)

  # Provide xpath expressions to config elements
  xpaths <- get_xpaths()

  # Get/set Infiltrationsfaktoren using the xpath expressions...
  config$get(xpaths$Infiltrationsfaktoren$Dachflaechen)
  config$get(xpaths$Infiltrationsfaktoren$Belaglsklasse4)

  config$set(xpaths$Infiltrationsfaktoren$Dachflaechen, 0.6)
  config$set(xpaths$Infiltrationsfaktoren$Belaglsklasse4, 0.99)

  # Get/set Bagrovwerte
  config$get(xpaths$Bagrovwerte$Dachflaechen)
  config$set(xpaths$Bagrovwerte$Dachflaechen, 0.123)
  config$set(xpaths$Bagrovwerte$Belaglsklasse4, 0.91)

  # Get/set ErgebnisNachkommaStellen
  config$get(xpaths$ErgebnisNachkommaStellen$ROW)
  config$set(xpaths$ErgebnisNachkommaStellen$ROW, 13)
  config$set(xpaths$ErgebnisNachkommaStellen$VERDUNSTUNG, 23)

  # Get/set Diverse
  config$get(xpaths$Diverse$BERtoZero)
  config$set(xpaths$Diverse$BERtoZero, "true")

  config$get(xpath = xpaths$Diverse$NIEDKORRF)
  config$set(xpaths$Diverse$NIEDKORRF, 1.23)

  # More complicated: variable node sets
  config$get_nodes(xpath = xpaths$Gewaesserverdunstung)
  config$get_nodes(xpaths$PotentielleVerdunstung)

  # Modify existing nodes
  config$modify_node(
    xpaths$PotentielleVerdunstung,
    i = 1L,
    bezirke = "123-125",
    etp = 123,
    etps = 234
  )

  config$modify_node(xpaths$PotentielleVerdunstung, 6, etp = "666")

  # TODO: Add/remove nodes

  config$set_node(xpath = xpaths$PotentielleVerdunstung, i = 2, new_node = node)

  config$get_node(xpaths$PotentielleVerdunstung, i = 2L)
  config$get_node(xpaths$PotentielleVerdunstung, i = 6L)

  # Save the modified configuration to a new xml file
  new_xml_file <- config$save(name = "config_001.xml")

  # Open the folder containing the xml file
  kwb.utils::hsOpenWindowsExplorer(dirname(new_xml_file))
}

# create_configurator ----------------------------------------------------------
create_configurator <- function(xml_file)
{
  x <- xml2::read_xml(xml_file)

  safely_get_node <- function(xpath) {
    nodeset <- xml2::xml_find_all(x, xpath)
    stopifnot(length(nodeset) == 1L)
    nodeset[[1L]]
  }

  safely_get_at <- function(nodes, i) {
    stopifnot(i %in% seq_along(nodes))
    nodes[[i]]
  }

  get_nodes <- function(xpath) {
    xml2::xml_find_all(x, xpath)
  }

  get_node <- function(xpath, i) {
    safely_get_at(get_nodes(xpath), i)
  }

  set_node <- function(xpath, i, new_node) {
    nodes <- xml2::xml_find_all(x, xpath)
    safely_get_at(nodes, i)
    xml2::xml_replace(nodes[[i]], new_node)
  }

  # Return a list of functions that allow to inspect/modify the xml tree x
  list(
    get = function(xpath) {
      node <- safely_get_node(xpath)
      xml2::xml_attr(node, "value")
    },

    set = function(xpath, value) {
      node <- safely_get_node(xpath)
      xml2::xml_attr(node, "value") <- value
    },

    get_nodes = get_nodes,

    get_node = get_node,

    set_node = set_node,

    modify_node = function(xpath, i, ...) {
      set_node(xpath, i, set_node_attributes(get_node(xpath, i), ...))
    },

    # Return the full xml tree
    get_config = function() {
      x
    },

    save = function(name, file = NULL) {
      file <- kwb.utils::defaultIfNULL(file, file.path(dirname(xml_file), name))
      xml2::write_xml(x, file)
      file
    }
  )
}

# get_xpaths -------------------------------------------------------------------
get_xpaths <- function()
{
  area_types <- c(
    "Dachflaechen",
    "Belaglsklasse1",
    "Belaglsklasse2",
    "Belaglsklasse3",
    "Belaglsklasse4"
  )

  output_columns <- c(
    "R",
    "ROW",
    "RI",
    "RVOL",
    "ROWVOL",
    "RIVOL",
    "FLAECHE",
    "VERDUNSTUNG"
  )

  diverse <- c(
    "BERtoZero",
    "NIEDKORRF"
  )

  # Helper functions
  xpath_section_item <- function(section) {
    sprintf("//section[@name='%s']/item", section)
  }

  xpath_key_in_section_item <- function(section, key) {
    paste0(xpath_section_item(section), sprintf("[@key='%s']", key))
  }

  apply_named <- function(x, fun, ...) {
    lapply(stats::setNames(nm = x), fun, ...)
  }

  list(
    Infiltrationsfaktoren = apply_named(
      area_types,
      xpath_key_in_section_item,
      section = "Infiltrationsfaktoren"
    ),
    Bagrovwerte = apply_named(
      area_types,
      xpath_key_in_section_item,
      section = "Bagrovwerte"
    ),
    ErgebnisNachkommaStellen = apply_named(
      output_columns,
      xpath_key_in_section_item,
      section = "ErgebnisNachkommaStellen"
    ),
    Gewaesserverdunstung = xpath_section_item("Gewaesserverdunstung"),
    PotentielleVerdunstung = xpath_section_item("PotentielleVerdunstung"),
    Diverse = apply_named(
      diverse,
      xpath_key_in_section_item,
      section = "Diverse"
    )
  )
}

# set_node_attributes ----------------------------------------------------------
set_node_attributes <- function(node, ...)
{
  args <- list(...)

  for (name in names(args)) {
    xml2::xml_attr(node, name) <- args[[name]]
  }

  node
}

