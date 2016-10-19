assignment = "Assignment 1 (ANOVA)"

#library(ggplot2)

getData <- function(seed, secret, extra = ""){
  set.seed.alpha(paste0(seed, secret, extra))
    # Assignment Problem 1: 
    # 1.	Completely between-subjects design
    # 2.	Two factors  
    #   a.	Factor A should have two levels
    #   b.	Factor B should have three levels
    # 3.	10 participants in each of the groups for a total of 18 data points
  
  var.names = c("Data",
                "FactorA", 
                "FactorB") 
  
  level_A = 2
  level_B = 3
  num_sub  = 10 # number of subjects per cell 
  num_group = level_A *level_B # number of groups
  num_sub_tot = num_sub * num_group
  
  ## samping data
  factorB1_factorA1=round(rnorm(num_sub, sample(17:18, 1)))
  factorB1_factorA2=round(rnorm(num_sub, sample(8:11, 1)))
  factorB2_factorA1=round(rnorm(num_sub, sample(16:18, 1)))
  factorB2_factorA2=round(rnorm(num_sub, sample(9:12, 1)))
  factorB3_factorA1=round(rnorm(num_sub, sample(15:17, 1)))
  factorB3_factorA2=round(rnorm(num_sub, sample(10:12, 1)))
  
  data = c(factorB1_factorA1, factorB1_factorA2, factorB2_factorA1, factorB2_factorA2, factorB3_factorA1, factorB3_factorA2) #subject ID
  factorA = rep(c(rep(c(1),num_sub), rep(c(2),num_sub)), level_B)
  factorB = c(rep(rep(c(1),num_sub),level_A), rep(rep(c(2),  num_sub), level_A), rep(rep(c(3),num_sub), level_A))
  ## creating data frame
  X = matrix( NA, nrow = num_sub_tot, ncol = length(var.names))
  df = data.frame(X)
  colnames(df) = var.names
  df$Data = data
  df$FactorA = factor(factorA)
  df$FactorB = factor(factorB)
  
  levels(df$FactorA) = paste('a',1:2)
  levels(df$FactorB) = paste('b',1:3)
  
  
  return(df)
}
 
getAssignment <- function(seed, secret, assignmentDir = NULL, solutions = FALSE){
  tmpfn = tempfile()
  input = paste0(assignmentDir,"/assignment.Rmd")
  rmarkdown::render(input = input, output_format = "html_fragment", output_file = tmpfn, envir = new.env())
  return(tmpfn)
}

get_size_str = function(eta2,name, digits = 3){
  sizes = c("essentially no effect at all", "a small effect", "a medium-sized effect", "a large effect")
  cata = sum(eta2 > c(.01,.06,.14)) + 1
  return(shiny::HTML(paste(
    "The effect size η<sup>2</sup><sub>p</sub> (eta-squared) for factor ",
    name, " is ", round(eta2,digits),
    ". This is often interpreted as ", sizes[cata],
    ".", sep="")))
}




