file <- "~/qt-projects/abimo/data/abimo_2019_mitstrassen.dbf"
abimo_input_2019 <- foreign::read.dbf(file)

new_text <- kwb.utils::substSpecialChars(abimo_input_2019$AGEB1, deuOnly = TRUE)

# What has changed?
unique(new_text[new_text != abimo_input_2019$AGEB1])

# Update column with new text values
abimo_input_2019$AGEB1 <- new_text

# Save data frame in package
usethis::use_data(abimo_input_2019, overwrite = TRUE)

# What is the file size of the saved data frame?
file.size("data/abimo_input_2019.rda")
