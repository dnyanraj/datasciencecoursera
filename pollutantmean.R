pollutantmean <- function(directory, pollutant, id = 1:332) {
  #-- Original Comments
  ## 'directory' is a character vector of length 1 indicating the location of the CSV files
  ## 'pollutant' is a character vector of length 1 indicating the name of the pollutant for which we will calculate the mean; either "sulfate" or "nitrate".
  ## 'id' is an integer vector indicating the monitor ID numbers to be used
  
  ## Return the mean of the pollutant across all monitors list in the 'id' vector (ignoring NA values)
  
  #-- Dnyanraj's Comments
  # "direcotry" is relative to current working directory. This function will look for directory ONLY in CWD
  # "id" will specify which files to use to compute average (na.rm = TRUE)
  # File path is constructed using file.path() function
  
  # Construct directory path relative to working directory
  directoryPath <- file.path(getwd(),directory)
  
  # Get the length of vector id. We'll use this for the loop counter
  idlen <- length(id)
  
  # Initialize column index on Pollutant Type input param
  if (pollutant=="sulfate") (colIndex <- 2) else if (pollutant=="nitrate") (colIndex <- 3)
  
  # Initialize a vector to hold pollutant all data
  pollutantAllData <- vector('numeric',length = 0)
  
  # Loop through each id file to compute pollutant mean
  for (i in 1:idlen)
  {
    # Construct file id with leading "0"s for id < 100
    n<-id[i] # Temp file id holder, gets initiated at the every iteration
    if (n<10) (n<-paste("00",n,sep="")) else if ((n>9)&(n<100)) (n<-paste("0",n,sep="")) else n<-n
    fileName <- paste(n,"csv",sep=".") # Construct file name
    filePath <- file.path(directoryPath,fileName) # Construct fully qualified file path
    
    rawData <- read.csv(filePath) # Read raw data for i-th file
    pollutantAllData <- c(pollutantAllData,rawData[,colIndex]) # Initialize a vector to hold column values appended
  }
  
  # Compute the final mean of the pollutantMean vector
  mean(pollutantAllData,na.rm=TRUE)
  
}