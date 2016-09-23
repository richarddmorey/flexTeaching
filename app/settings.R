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
  dir("assignments/", no..=TRUE)
}


### http://stackoverflow.com/questions/10910698/questions-about-set-seed-in-r
set.seed.alpha <- function(x) {
  hexval <- paste0("0x",digest(x,"crc32"))
  intval <- type.convert(hexval) %% .Machine$integer.max
  set.seed(intval)
}


getURIdata<-function(seed, secret, format, assignment_list){
  myData = assignment_list$getData(seed, secret, assignment_list$assignment)
  if(!is.data.frame(myData)){
    if(is.list(myData) & is.data.frame(myData[['data']])){
      myData = myData[['data']] 
    }else{
      stop("Assignment configuration error. Data is not in correct format.")   
    }
  }
  if(format=="SPSS"){
    ext="sav"
    filenameWithExt = tempfile("data_",fileext=paste0(".",ext))
    write_sav(myData, path=filenameWithExt)
  }else if(format=="Excel"){
    ext="xlsx"
    filenameWithExt = tempfile("data_",fileext=paste0(".",ext))
    write.xlsx(myData, file=filenameWithExt)
  }else if(format=="R data"){
    ext="Rda"
    filenameWithExt = tempfile("data_",fileext=paste0(".",ext))
    save(myData,file = filenameWithExt)
    #write.xlsx(myData, file=filenameWithExt)
  }else{
    ext="csv"
    filenameWithExt = tempfile("data_",fileext=paste0(".",ext))
    write.csv(myData, file=filenameWithExt)
  }
   divname = "dl.data.file"
  textHTML = "Click here to download the data."
  
  
  uri = dataURI(file = filenameWithExt, mime = "application/octet-stream", encoding = "base64")
  paste0("<a style='text-decoration: none' id='",divname,"'></a>
    <script>
      var a = document.createElement('a');
      var div = document.getElementById('",divname,"');
      div.appendChild(a);
      a.setAttribute('href', '",uri,"');
      a.innerHTML = '",textHTML,"';
      if (typeof a.download != 'undefined') {
      a.setAttribute('download', '",filenameWithExt,"');
      }else{
      a.setAttribute('onclick', 'confirm(\"Your browser does not support the download HTML5 attribute. You must rename the file to [something].",ext," after downloading it (or use Chrome/Firefox/Opera). \")');
      }
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
    stop("You cannot access this resource at this time.")
  }
  return(can_do)
}

