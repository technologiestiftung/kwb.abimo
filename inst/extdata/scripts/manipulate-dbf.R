# This script reads a dbf file, convertes those numeric columns that are 
# actually integer to integer and writes the data back to a new dbf file.
#
# Author: Hauke Sonnenberg
# Created: 2021-12-21

files <- kwb.utils::resolve(list(
  downloads = "~/../Downloads",
  ref = "<downloads>/A/ABIMO_fuer_Hauke/abimo_2019_mitstrassen.dbf",
  data_michael = "<downloads>/A/abimo/input_data_michael",
  inp = "<data_michael>/abimo_Beijing_dot.dbf",
  out = "<data_michael>/abimo_Beijing_dot_int.dbf",
  out2 = "<data_michael>/abimo_Beijing_dot_rounded.dbf",
  ref2 = "<data_michael>/abimo_Beijing_commaout.dbf",
  new = "<data_michael>/abimo_Beijing_dot_intout.dbf",
  new2 = "<data_michael>/abimo_Beijing_dot_roundedout.dbf"
))

# Which columns are of type integer in the reference dbf file?
x_ref <- foreign::read.dbf(files$ref)

all_integer_fields <- names(which(sapply(x_ref, is.integer)))
all_numeric_fields <- names(which(sapply(x_ref, is.numeric)))
all_float_fields <- setdiff(all_numeric_fields, all_integer_fields)
str(x_ref)

# Convert numeric to integer and remove decimal fraction from floats
x_in <- foreign::read.dbf(files$inp)
str(x_in)

integer_fields <- intersect(all_integer_fields, names(x_in))
float_fields <- intersect(all_float_fields, names(x_in))

x_out <- x_in
x_out[integer_fields] <- lapply(x_out[integer_fields], as.integer)
x_out[float_fields] <- lapply(x_out[float_fields], floor)

str(x_out)

# Rewrite dbf file
#install.packages("kwb.abimo")
kwb.abimo::write.dbf.abimo(x_out, files$out2)

# Compare different Abimo results
x_ref <- foreign::read.dbf(files$ref2)
x_new <- foreign::read.dbf(files$new2)

kwb.abimo::abimo_compare_output(x_ref, x_new)

# Try to reproduce what happens with the "comma numerics"
