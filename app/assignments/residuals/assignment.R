assignment = read.csv('meta_info.csv', stringsAsFactors = FALSE)[1,"title"]

getData <- function(seed, secret, extra = ""){
  set.seed.alpha(paste0(seed, secret, extra))

  N = 150
  
  z = random.set(N)
  df = z$data
  text = z$text
  
  all.data = list(
    data = df,
    info = list(text = text)
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

random.set = function(N = 150){
  type = sample(c("linear","none","nonmonotone","nonlinear"), 1)
  df = make.set(type = type, N = N)
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

make.set = function(type="linear", N = 150){
  switch(type,
         linear = make.linear(N),
         nonlinear = make.nonlinear(N),
         nonmonotone = make.nonmonotone(N),
         none = make.linear(N, TRUE))
}

make.nonlinear <- function(N){
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
  
  return(data.frame(x=x,y=y))
}

make.nonmonotone <- function(N){
  x = runif(N,0,100)
  x0 = (x - mean(x))/sd(x)
  y0 = x0^2
  if(rbinom(1,1,.5)){
    rnge = diff(range(y0))
    y0 = min(y0) + rnge*(1 - (y0 - min(y0))/rnge)
  }
  err.sd = diff(range(y0))/10
  y = 5*(y0 + rnorm(y0,0,err.sd))
  return(data.frame(x=x,y=y))
}

make.linear <- function(N, no.cor=FALSE){
  x = rnorm(N,50,15)
  x0 = (x - mean(x))/sd(x)
  slp = (rbeta(1, 2, 2)*2 - 1) * (1 - no.cor)
  y0 = slp * x0
  
  err.sd = ifelse(no.cor,10,diff(range(y0))/runif(1,0,10))
  y = 5*(y0 + rnorm(y0,0,err.sd))
  return(data.frame(x=x,y=y))
}



