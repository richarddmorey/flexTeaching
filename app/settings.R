require(digest)
require(base64enc)
require(haven)
require(xlsx)
require(lubridate)


cols1 = c("#edd9c0",
          "#c9d8c5",
          "#a8b6bf",
          "#7d4627",
          "#506C61",
          "#E06C50",
          "#004073")

par.list = list(bg = "white", #col = cols1[7], col.axis = cols1[7],
                #col.lab = cols1[7], col.main  = cols1[7], col.sub = cols1[7],
                las = 1,
                lwd = 2,
                cex = 1.1,
                cex.axis = 1.1,
                cex.lab = 1.1,
                yaxs="i",mgp = c(2.5,.5,0), tcl = -0.25,
                mar=c(4.5,4.5,1,1))

par.list2 = par.list
par.list2[['mar']] = c(4.5,1,1,1)

getAssignments <- function(){
  a = dir("assignments/", no..=TRUE)
  meta_info = sapply(a, function(d){
    mpath = file.path("assignments",d,"meta_info.csv")
    if(file.exists(mpath)){
      meta_info0 = read.csv(mpath, header = TRUE, stringsAsFactors = FALSE)[1,]
      meta_info = unlist(meta_info0)
      names(meta_info) = names(meta_info0)
    }else{
      meta_info = c()
    }
    meta_info["title"] = ifelse(is.null(meta_info["title"]) || is.null(meta_info["title"]),
                                d,
                                meta_info["title"])
    meta_info["sortkey"] = ifelse(is.null(meta_info["sortkey"]) || is.na(meta_info["sortkey"]),
                                d,
                                meta_info["sortkey"])
    meta_info
  })
  names(a) = meta_info["title",]
  ord = stringi::stri_order(meta_info["sortkey",], locale="en_US")
  a[ord]
}


### http://stackoverflow.com/questions/10910698/questions-about-set-seed-in-r
set.seed.alpha <- function(x) {
  hexval <- paste0("0x",digest(x,"crc32"))
  intval <- type.convert(hexval) %% .Machine$integer.max
  set.seed(intval)
}


getURIdata<-function(seed, secret, format, assignment_list){
  myData = assignment_list$getData(seed, secret, assignment_list$assignment)
  if(is.null(myData)){
    return("")
  }
  if(!is.data.frame(myData)){
    if(is.list(myData) & is.data.frame(myData[['data']])){
      myData = myData[['data']] 
    }else{
      stop("Assignment configuration error. Data is not in correct format.")   
    }
  }
  name_prefix = paste0("data_", assignment_list$assignment,"_")
  if(format=="SPSS"){
    ext="sav"
    filenameWithExt = tempfile(name_prefix,fileext=paste0(".",ext))
    write_sav(myData, path=filenameWithExt)
  }else if(format=="Excel"){
    ext="xlsx"
    filenameWithExt = tempfile(name_prefix,fileext=paste0(".",ext))
    write.xlsx(myData, file=filenameWithExt)
  }else if(format=="R data"){
    ext="Rda"
    filenameWithExt = tempfile(name_prefix,fileext=paste0(".",ext))
    save(myData,file = filenameWithExt)
  }else{
    ext="csv"
    filenameWithExt = tempfile(name_prefix,fileext=paste0(".",ext))
    write.csv(myData, file=filenameWithExt)
  }
  divname = "dl.data.file"
  textHTML = "Click here to download the data."
  onlyFileName = basename(filenameWithExt)
  
  uri = dataURI(file = filenameWithExt, mime = "application/octet-stream", encoding = "base64")
  paste0("<a style='text-decoration: none; cursor: pointer;' id='",divname,"'></a>
    <script>
      var my_uri = '",uri,"';
      var my_blob = dataURItoBlob(my_uri);
      var div = document.getElementById('",divname,"');
      div.innerHTML = '",textHTML,"';
      div.setAttribute('onclick', 'saveAs(my_blob, \"",onlyFileName ,"\");');
      </script>")
}

assignment_time = function(assignmentDir, secret, tz = "Europe/London"){
  
  dates_fn = paste0(assignmentDir, "/times.csv")
  if(file.access(dates_fn, mode = 4) == -1){
    return(TRUE)
  }
  
  date.constraints = read.csv(dates_fn, header=TRUE)
  
  check.dates = apply(date.constraints, 1, function(row, secret, tz){
    cur = now(tz)
    dl = ymd_hms(row['date'], tz = tz)
    regex = row['secret']
    if(grepl(regex, secret)){
      res = cur>dl
    }else{
      res = TRUE
    }
  }, secret = secret, tz = tz)
  
  can_do = all(check.dates)
  if(!can_do){
    stop(safeError("You cannot access this resource at this time."))
  }
  return(can_do)
}

writeHeaders = function( file ){
  
  require(htmltools)
  
  assignments = getAssignments()
  html.content = NULL
  
  allTags = tagList()
  
  # top js directory
  fs = dir(paste0("js/"), full.names = TRUE)
  for(f in fs){
    lns = paste(readLines(f),collapse="\n")
    allTags = tagAppendChild( allTags, tags$script(HTML(lns), type="text/javascript") )
  }
  
  for(a in assignments){
    
    # CSS
    fs = dir(paste0("assignments/",a,"/include/css/"), full.names = TRUE)
    for(f in fs){
      lns = paste(readLines(f),collapse="\n")
      allTags = tagAppendChild( allTags, tags$style(HTML(lns),type="text/css") )
    }
    
    # JS
    fs = dir(paste0("assignments/",a,"/include/js/"), full.names = TRUE)
    for(f in fs){
      lns = paste(readLines(f),collapse="\n")
      allTags = tagAppendChild( allTags, tags$script(HTML(lns), type="text/javascript") )
    }    
    
    # HTML
    fs = dir(paste0("assignments/",a,"/include/html/"), full.names = TRUE)
    for(f in fs){
      lns = pastereadLines(f)
      html.content = paste(html.content, lns, 
                           sep = "\n", collapse="\n")
    }    
    
  }
  
  all.content = paste(html.content,as.character(allTags),sep="\n")
  writeLines( all.content, con = file )
  
  invisible(NULL)
  
}

#https://github.com/ateucher/useful_code/blob/master/R/numbers2words.r
numbers2words <- function(x){
  ## Function by John Fox found here: 
  ## http://tolstoy.newcastle.edu.au/R/help/05/04/2715.html
  ## Tweaks by AJH to add commas and "and"
  helper <- function(x){
    
    digits <- rev(strsplit(as.character(x), "")[[1]])
    nDigits <- length(digits)
    if (nDigits == 1) as.vector(ones[digits])
    else if (nDigits == 2)
      if (x <= 19) as.vector(teens[digits[1]])
    else trim(paste(tens[digits[2]],
                    Recall(as.numeric(digits[1]))))
    else if (nDigits == 3) trim(paste(ones[digits[3]], "hundred and", 
                                      Recall(makeNumber(digits[2:1]))))
    else {
      nSuffix <- ((nDigits + 2) %/% 3) - 1
      if (nSuffix > length(suffixes)) stop(paste(x, "is too large!"))
      trim(paste(Recall(makeNumber(digits[
        nDigits:(3*nSuffix + 1)])),
        suffixes[nSuffix],"," ,
        Recall(makeNumber(digits[(3*nSuffix):1]))))
    }
  }
  trim <- function(text){
    #Tidy leading/trailing whitespace, space before comma
    text=gsub("^\ ", "", gsub("\ *$", "", gsub("\ ,",",",text)))
    #Clear any trailing " and"
    text=gsub(" and$","",text)
    #Clear any trailing comma
    gsub("\ *,$","",text)
  }  
  makeNumber <- function(...) as.numeric(paste(..., collapse=""))     
  #Disable scientific notation
  opts <- options(scipen=100) 
  on.exit(options(opts)) 
  ones <- c("", "one", "two", "three", "four", "five", "six", "seven",
            "eight", "nine") 
  names(ones) <- 0:9 
  teens <- c("ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen",
             "sixteen", " seventeen", "eighteen", "nineteen")
  names(teens) <- 0:9 
  tens <- c("twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty",
            "ninety") 
  names(tens) <- 2:9 
  x <- round(x)
  suffixes <- c("thousand", "million", "billion", "trillion")     
  if (length(x) > 1) return(trim(sapply(x, helper)))
  helper(x)
}


