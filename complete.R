complete <- function(directory, id = 1:332) {
  #-- Original Comments
  ## 'directory' is a character vector of length 1 indicating the location of the CSV files
  ## 'id' is an integer vector indicating the monitor ID numbers to be used
  ## Return a data frame of the form:
  ## id nobs
  ## 1  117
  ## 2  1041
  ## ...
  ## where 'id' is the monitor ID number and 'nobs' is the number of complete cases
  
  #-- Dnyanraj's Comments
  # "direcotry" is relative to current working directory. This function will look for directory ONLY in CWD
  # "id" will specify which files to use to compute average (na.rm = TRUE)
  # Complete cases are identified using complete.cases() functio
  
  # Construct directory path relative to working directory
  directoryPath <- file.path(getwd(),directory)
  
  # Get the length of vector id. We'll use this for the loop counter
  idlen <- length(id)
  
  # Initialize an empty data frame to store file ids and counts
  complete<-data.frame(id=numeric(0),nobs=numeric(0))
  
  # Loop through each id file to identify complete cases
  for (i in 1:idlen)
  {
    # Construct file id with leading "0"s for id < 100
    n<-id[i] # Temp file id holder, gets initiated at the every iteration
    if (n<10) (n<-paste("00",n,sep="")) else if ((n>9)&(n<100)) (n<-paste("0",n,sep="")) else n<-n
    fileName <- paste(n,"csv",sep=".") # Construct file name
    filePath <- file.path(directoryPath,fileName) # Construct fully qualified file path
    
    rawData <- read.csv(filePath) # Read the file
    newRow <- c(id[i],nrow(rawData[complete.cases(rawData),])) # Count complete cases and create a new row to be inserted
    complete[i,]<-newRow # Insert the new row in final data frame
  }
  
  # Print Complete data frame
  complete
}