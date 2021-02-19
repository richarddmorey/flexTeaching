
get_data <- function(){
  N = 50
  r = runif(1, -.8, .8)
  m = matrix(rnorm(2, 50, 10), 2)
  s = rgamma(2, 5, .5)
  S = outer(s,s) * matrix(c(1,r,r,1),2)
  y = MASS::mvrnorm(N, m, S, empirical = TRUE)
  df = data.frame(
    x = y[,1],
    y = y[,2]
  )
}



init <- function(assignment_data, id, seed, solutions, e){
  ret_list = list(
    data = get_data(),
    id = id
    )  
  return(ret_list)
}



buttons <- list(
  data = list(
    label = "Download data",
    icon = "download",
    f = data_file
  )
)
