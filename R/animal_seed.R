#' Create animal string
#'
#' @param seed 
#'
#' @importFrom digest digest
#' @importFrom R.utils withSeed
#' @importFrom noah pseudonymize
#' @return
#'
animal_seed <- function(seed, salt){
  hash = digest::digest(paste0(seed, salt))
  animals = R.utils::withSeed({noah::pseudonymize("")},
                              alp2int(hash))
  animals = gsub(pattern = " ",
                 replacement = "_",
                 x = tolower(animals)
                 )
  alpha_num = R.utils::withSeed({ran_alphanum(1)},
                                alp2int(hash))
  return(paste(animals, alpha_num,  sep = "_"))
}