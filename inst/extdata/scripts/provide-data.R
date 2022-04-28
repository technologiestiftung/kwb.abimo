file <- "~/qt-projects/abimo/data/abimo_2019_mitstrassen.dbf"
abimo_input_2019 <- foreign::read.dbf(file)
usethis::use_data(abimo_input_2019)
file.size("data/abimo_input_2019.rda")
