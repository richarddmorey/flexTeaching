
#' Use id, seed, and salt to create an integer seed
#'
#' @param id id number of the student
#' @param seed assignment seed 
#' @param salt assignment salt
#'
#' @return
assignmentSeed <- function(id, seed, salt){
  concat = paste0(trimws(id),
         trimws(seed),
         trimws(salt))
  return(alp2int(concat))
}