library(ggplot2)

# Let Abimo.exe output results of the Bagrov calculation
bagrov_lines <- kwb.abimo::run_abimo_command_line("--write-bagrov-table")

# Convert the text lines to a data frame
bagrov <- read.table(text = bagrov_lines, header = TRUE, sep = ",")

# Plot the Bagrov data
ggplot(bagrov, aes(x = x, y = y, groups = factor(bag))) + geom_line()
