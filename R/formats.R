

formats = list(
  SPSS = list(
    title = "SPSS",
    ext = ".sav",
    f = function(d, file = tempfile(fileext = ".sav"), ...){
      haven::write_sav(data = d, path = file, ...)
      }
    ),
  CSV = list(
    title = "CSV",
    ext = ".csv",
    f = function(d, file = tempfile(fileext = ".csv"), ...){
      readr::write_csv(x = d, file = file, ...)
    }
  ),
  Excel = list(
    title = "Excel",
    ext = ".xlsx",
    f = function(d, file = tempfile(fileext = ".xlsx"), ...){
      writexl::write_xlsx(x = d, path = file, ...)
    }
  )
)