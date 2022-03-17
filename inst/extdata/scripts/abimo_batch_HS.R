batch_lines <- c(
  "SET ABIMO_EXE=C:\\_UserProg\\abimo_v3.2.2_win64\\Abimo.exe",
  "SET SCENARIOS=C:\\Aendu_lokal\\ABIMO_Paper\\Daten\\ABIMO_Input\\scenarios", 
  sapply(1991:2019, function(year) {
    sprintf(
      paste(
        "%%ABIMO_EXE%% --config %%SCENARIOS%%\\climate_%4d\\config.xml", 
        "%%SCENARIOS%%\\climate_%4d\\x_in_%4d.dbf",
        "%%SCENARIOS%%\\climate_%4d\\x_out_%4d.dbf"
      ),
      year, year, year, year, year
    )
  }),
  "pause"
)

writeLines(batch_lines, "~/../Desktop/run-abimo-batch.bat")

