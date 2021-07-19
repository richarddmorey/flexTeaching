#' Convert string to integer using a hash 
#'
#' @param x 
#'
#' @return
#' @importFrom digest digest
#'
alp2int <- function(x) {
  # https://stackoverflow.com/a/10913336/1129889
  hexval <- paste0("0x", digest::digest(x,"crc32"))
  intval <- type.convert(hexval, as.is = FALSE) %% .Machine$integer.max
  return(intval)
}
