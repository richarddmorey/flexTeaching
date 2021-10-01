#' Create animal string
#'
#' @param seed 
#'
#' @importFrom digest sha1
#' @importFrom dplyr `%>%`
#' @importFrom R.utils withSeed
#' @importFrom noah pseudonymize
#' @return
#'
animalSeed <- function(seed, salt){
  c(seed, salt) %>%
    trimws() %>%
    digest::sha1() %>%
    alp2int() -> int_hash
  
  animals = R.utils::withSeed({noah::pseudonymize("")},
                              int_hash)
  animals = gsub(pattern = " ",
                 replacement = "_",
                 x = tolower(animals)
                 )
  alpha_num = R.utils::withSeed({randomAlphaNum(1)},
                                int_hash)
  return(paste(animals, alpha_num,  sep = "_"))
}