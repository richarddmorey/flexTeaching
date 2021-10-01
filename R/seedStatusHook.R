#' @export seedStatusHook
seedStatusHook <- local({
  initial_seed <- NULL
  
  function(before, options, envir, name) {
    opt = options[[name]]
    if( !(opt %in% c("warn","reset")) )
      stop("Unknown value for option ", name," : ", opt)
    
    if (before){
      initial_seed <<- if(exists(".Random.seed", envir = .GlobalEnv, inherits=FALSE)) 
        .Random.seed
    }else{
      seed_change = !identical(.Random.seed, initial_seed)
      if(opt == "reset"){
        if(!is.null(initial_seed))
          .Random.seed <<- initial_seed
        else
          rm(".Random.seed", envir = .GlobalEnv)
      }else if(seed_change && opt == "warn" ){
        txt = paste("**The seed has changed during execution of chunk: ", options$label, "**", collapse="")
        warning(txt)
        return(txt)
      }
    }
  }
})
