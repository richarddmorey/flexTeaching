
#' Use id, seed, and salt to create an integer seed
#'
#' @param id id number of the student
#' @param seed assignment seed 
#' @param salt assignment salt
#'
#' @return
#' @importFrom digest sha1
#' @importFrom dplyr `%>%`
assignmentSeed <- function(id, seed, salt){
  c(id, seed, salt) %>%
    trimws() %>%
    digest::sha1() %>%
    alp2int()
}