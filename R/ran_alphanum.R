
#' Create random alphanumeric strings
#'
#' @param n number of strings
#' @param n_char length of strings
#'
#' @return
#'
ran_alphanum <- function(n = 1, n_char = 10) {
  replicate(n, paste0(sample(c(letters, 0:9), size = n_char), collapse = ""))
}
