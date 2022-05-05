file_sets <- list(
  list(
    file_1 = "~/qt-projects/abimo/abimo_2012gesout.dbf",
    file_2 = "y:/SUW_Department/Projects/SpuR/Data-Work_packages/AP1_Modellierung/ABIMO/abimo_2012gesout.dbf"
  ),
  list(
    file_1 = "~/../Downloads/A/ABIMO_fuer_Hauke/abimo_2019_mitstrassenout_new-1.dbf",
    file_2 = "~/../Downloads/A/ABIMO_fuer_Hauke/abimo_2019_mitstrassenout.dbf"
  ),
  list(
    file_1 = "~/qt-projects/abimo/abimo-result.dbf",
    file_2 = "~/qt-projects/abimo/abimo_2012gesout.dbf"
  ),
  list(
    file_1 = "~/qt-projects/abimo/abimo_2012ges_out.dbf",
    file_2 = "~/qt-projects/abimo/build-Abimo-Desktop_Qt_5_12_12_MinGW_64_bit-Release/release/out-1.dbf"
  )
)

file_in <- "~/../Downloads/A/ABIMO_fuer_Hauke/abimo_2019_mitstrassen.dbf"
file_in <- "~/qt-projects/abimo/abimo_2012ges.dbf"

# Select a file set
file_set <- file_sets[[2L]]

db_1 <- foreign::read.dbf(file_set$file_1)
db_2 <- foreign::read.dbf(file_set$file_2)

identical(db_1, db_2)
all.equal(db_1, db_2)

db_in <- foreign::read.dbf(file_in)

head(db_in)

i <- 2

result <- lapply(seq_len(nrow(db_1)), function(i)
  identical(db_1[i, ], db_2[i, ])
)

table(unlist(result))

str(db_1)
str(db_2)

kwb.test:::testColumnwiseIdentity(db1 = db_1, db2 = db_2)

par(mfrow = kwb.plot:::bestRowColumnSetting(ncol(db_1)))

lapply(stats::setNames(nm = names(db_1)), function(column) {
  x <- db_1[[column]]
  y <- db_2[[column]]
  if (is.factor(x)) {
    table(x == y)
  } else {
    plot(
      x,
      y,
      asp = 1,
      xlab = "with rebuilt executable",
      ylab = "with original executable",
      main = sprintf("Comparison of variable '%s'", column)
    )
    abline(a = 0, b = 1)
    range(x - y, na.rm = TRUE)
    #range((x - y) / y * 100, na.rm = TRUE)
  }
})


db_in[db_in$CODE %in% db_1$CODE[i], ]
