#' Create animal string
#'
#' @param seed 
#'
#' @importFrom digest sha1
#' @importFrom dplyr `%>%`
#' @importFrom R.utils withSeed
#' @return
#'
animalSeed <- function(seed, salt){
  c(seed, salt) %>%
    trimws() %>%
    digest::sha1() %>%
    alp2int() -> int_hash

  animals = R.utils::withSeed(
    {
      with(name_parts, 
      {
        tolower(paste(sample(adjectives, 1), sample(animals, 1), sep='_'))
      })      
    }, int_hash)
  
  alpha_num = R.utils::withSeed({randomAlphaNum(1)},
                                int_hash)
  return(paste(animals, alpha_num,  sep = "_"))
}


