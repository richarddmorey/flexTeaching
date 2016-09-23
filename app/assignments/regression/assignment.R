assignment = "Assignment 2 (regression)"

getData <- function(seed, secret, extra = ""){
  set.seed.alpha(paste0(seed, secret, extra))

  N = 150
  
  var.names = c("ID",
  "stress.before.test1",
  "score.test1",
  "IQ", 
  "cognitive.task2",
  "practice.task2",
  "response.time.task2",
  "college.math",
  "score.math.course1",
  "score.math.course2")
  
  types = 1:3 * NA
  texts = 1:3 * NA
  X = matrix( NA, nrow = N, ncol = length(var.names) )
  df = data.frame(X)
	colnames(df) = var.names
	df$ID = factor(1:N)
	
	
	z = random.set(N, x.mean = 50, x.sd = 10, y.mean = 1000, y.sd = 200)
	df$stress.before.test1 = z$data$x
	df$score.test1 = z$data$y
	types[1] = z$type
	texts[1] = z$text
	
	z = random.set(N, x.mean = 100, x.sd = 15, y.mean = 50, y.sd = 10)
	df$IQ = z$data$x
	df$cognitive.task2 = z$data$y
	types[2] = z$type
	texts[2] = z$text
	
	z = random.set(N, x.mean = 10, x.sd = 3, y.mean = 2000, y.sd = 400)
	df$practice.task2 = z$data$x
	df$response.time.task2 = z$data$y
	types[3] = z$type
	texts[3] = z$text
	
	x = runif(N, 1, 100)
	z = x + runif(N,0,10)
	y = .5 * z + .5 * x + rnorm(N,0,10)
	
	df$college.math = y
  df$score.math.course1 = x
	df$score.math.course2 = z
	
  all.data = list(
    data = df,
    info = list(types = types, texts = texts)
  )
	return(all.data)
}
 
getAssignment <- function(seed, secret, assignmentDir = NULL, solutions = FALSE){
  tmpfn = tempfile()
  input = paste0(assignmentDir,"/assignment.Rmd")
  rmarkdown::render(input = input, output_format = "html_fragment", output_file = tmpfn, envir = new.env())
  return(tmpfn)
}


############ Helper functions

random.set = function(N = 150, ...){
  type = sample(c("linear","none","nonmonotone","nonlinear"), 1)
  df = make.set(type = type, N = N, ... )
  if( type == "nonmonotone"){
    correl = NA
    text = "The relationship strong but it is not monotone. A correlation is not an appropriate statistic for characterizing this relationship."
  }else if( type == "nonlinear"){
    correl = round(cor(df$x, df$y, method = "kendall"),3)
    text = paste0("The relationship strong but it is not linear.", 
    " A nonparametric correlation coefficient such as Kendall's $\\tau$ is appropriate statistic for characterizing this relationship.",
    " Kendall's $\\tau=",correl,"$.")
  }else{
    correl = c(kendall=round(cor(df$x, df$y, method = "kendall"),3),
               pearson=round(cor(df$x, df$y),3))
    if(abs(correl[['pearson']])<.3){
      text.str = "This linear correlation is weak."
    }else if(abs(correl[['pearson']])<.5){
      text.str = "This linear correlation is of medium strength."
    }else if(abs(correl[['pearson']])<.8){
      text.str = "This linear correlation is fairly strong."
    }else{  
      text.str = "This linear correlation is very strong."
    }
    if(sign(correl[['pearson']])>0){
      text.sign = "The relationship is positive."
    }else{
      text.sign = "The relationship is negative."
    }
    text = paste0(text.str," ", text.sign, 
                  " Typically, a Pearson correlation would be used to characterize this relationship, but a nonparametric correlation might also be reported.",
                  " Pearson's $r=",correl[['pearson']],"$, and",
                  " Kendall's $\\tau=",correl[['kendall']],"$.")
  }
  
  list(data = df, type = type, text = text)
}

make.set = function(type="linear", N = 150, ...){
  switch(type,
         linear = make.linear(N, ...),
         nonlinear = make.nonlinear(N, ...),
         nonmonotone = make.nonmonotone(N, ...),
         none = make.linear(N, TRUE, ...))
}

make.nonlinear <- function(N, x.mean=0, x.sd = 1, y.mean = 0, y.sd = 1 ){
  x = runif(N,0,100)
  x=sort(x)
  x0 = (x - min(x))/sd(x)
  y0 = exp(x0^1.2)
  err.sd = diff(range(y0))/10
  if(rbinom(1,1,.5)){
    x=rev(x)
  }else if(rbinom(1,1,.5)){
    rnge = diff(range(y0))
    y0 = min(y0) + rnge*(1 - (y0 - min(y0))/rnge)
  }
  y = 50 + y0 + rnorm(y0,0,err.sd)
  
  y = rescale(y, y.mean, y.sd)
  x = rescale(x, x.mean, x.sd)
  return(data.frame(x=x,y=y))
}

make.nonmonotone <- function(N, x.mean=0, x.sd = 1, y.mean = 0, y.sd = 1){
  x = runif(N,0,100)
  x0 = (x - mean(x))/sd(x)
  y0 = x0^2
  if(rbinom(1,1,.5)){
    rnge = diff(range(y0))
    y0 = min(y0) + rnge*(1 - (y0 - min(y0))/rnge)
  }
  err.sd = diff(range(y0))/10
  y = 5*(y0 + rnorm(y0,0,err.sd))
  
  y = rescale(y, y.mean, y.sd)
  x = rescale(x, x.mean, x.sd)
  return(data.frame(x=x,y=y))
}

make.linear <- function(N, no.cor=FALSE, x.mean=0, x.sd = 1, y.mean = 0, y.sd = 1){
  x = rnorm(N,50,15)
  x0 = (x - mean(x))/sd(x)
  slp = (rbeta(1, 2, 2)*2 - 1) * (1 - no.cor)
  y0 = slp * x0
  
  err.sd = ifelse(no.cor,10,diff(range(y0))/runif(1,0,10))
  y = 5*(y0 + rnorm(y0,0,err.sd))
  
  y = rescale(y, y.mean, y.sd)
  x = rescale(x, x.mean, x.sd)
  return(data.frame(x=x,y=y))
}

rescale = function(x, mean=0, sd=1){
  as.vector(scale(x))*sd + mean
}

