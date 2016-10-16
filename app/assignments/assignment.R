assignment = "Assignment 1 (ANOVA)"

getData <- function(seed, secret, extra = ""){
  set.seed.alpha(paste0(seed, secret, extra))
    # Assignment Problem 1: 
    # 1.	Completely between-subjects design
    # 2.	Two factors  
    #   a.	Factor A should have two levels
    #   b.	Factor B should have three levels
    # 3.	3 participants in each of the groups for a total of 18 data points
  
  var.names = c("Data",
                "FactorA", 
                "FactorB") 
  
  level_A = 2
  level_B = 3
  num_sub  = 10 # number of subjects per cell 
  num_group = level_A *level_B # number of groups
  num_sub_tot = num_sub * num_group
  
  ## samping data
  factorB1_factorA1=round(rnorm(num_sub, sample(15:20, 1)))
  factorB1_factorA2=round(rnorm(num_sub, sample(8:12, 1)))
  factorB2_factorA1=round(rnorm(num_sub, sample(12:17, 1)))
  factorB2_factorA2=round(rnorm(num_sub, sample(15:18, 1)))
  factorB3_factorA1=round(rnorm(num_sub, sample(10:14, 1)))
  factorB3_factorA2=round(rnorm(num_sub, sample(15:20, 1)))
  
  data = c(factorB1_factorA1, factorB1_factorA2, factorB2_factorA1, factorB2_factorA2, factorB3_factorA1, factorB3_factorA2) #subject ID
  factorA = rep(c(rep(c("A"),num_sub), rep(c("B"),num_sub)), level_B)
  factorB = c(rep(rep(c("A"),num_sub),level_A), rep(rep(c("B"),  num_sub), level_A), rep(rep(c("C"),num_sub), level_A))
  ## creating data frame
  X = matrix( NA, nrow = num_sub_tot, ncol = length(var.names))
  df = data.frame(X)
  colnames(df) = var.names
  df$Data = data
  df$FactorA = factorA
  df$FactorB = factorB
  
  return(df)
}
 
getAssignment <- function(seed, secret, assignmentDir = NULL, solutions = FALSE){
  tmpfn = tempfile()
  input = paste0(assignmentDir,"/assignment.Rmd")
  rmarkdown::render(input = input, output_format = "html_fragment", output_file = tmpfn, envir = new.env())
  return(tmpfn)
}





