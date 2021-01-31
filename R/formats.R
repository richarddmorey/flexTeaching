

formats = list(
  SPSS = list(
    title = "SPSS", 
    f = function(d, ...){
      tf = tempfile(fileext = ".sav")
      haven::write_sav(data = d, path = tf, ...)
      return(tf)
      }
    ),
  CSV = list(
    title = "CSV",
    f = function(d, ...){
      tf = tempfile(fileext = ".csv")
      readr::write_csv(x = d, file = tf, ...)
      return(tf)
    }
  ),
  Excel = list(
    title = "Excel",
    f = function(d, ...){
      tf = tempfile(fileext = ".xlsx")
      writexl::write_xlsx(x = d, path = tf, ...)
      return(tf)
    }
  )
)