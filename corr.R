corr<- function(directory, threshold = 0) {
  #-- Original Comments
  ## 'directory' is a character vector of length 1 indicating the location of the CSV files
  ## 'threshold' is a numeric vector of length 1 indicating the number of completely observed observations (on all variables) required to compute the correlation between nitrate and sulfate; the default is 0
  ## Return a numeric vector of correlations
  
  #-- Dnyanraj's Comments
  # "direcotry" is relative to current working directory. This function will look for directory ONLY in CWD
  # "id" will specify which files to use to compute average (na.rm = TRUE)
  # Files in a directory are identified using list.files() function
  
  # Construct directory path relative to working directory
  directoryPath <- file.path(getwd(),directory)
  
  # Use this function to get all the files from directory and assign it to a vector
  filenames<-list.files("specdata",pattern="*.csv")
  
  # Get the length of vector id. We'll use this for the loop counter
  numfiles <- length(filenames)
  
  # Initialize an empty vector to store correlation data points for each file
  corr<-vector('numeric',length = 0)
  
  # Initialize a counter to hold active counter id for corr elements
  counter <- 1
  
  # Loop through each id file to identify complete cases
  for (i in 1:numfiles)
  {
    filePath <- file.path(directoryPath,filenames[i]) # Construct fully qualified file path
    rawData <- read.csv(filePath) # Read the file
    
    if(nrow(rawData[complete.cases(rawData),]) > threshold)
    {
      sulfate<-rawData[,2] # Extract Sulfate data
      nitrate<-rawData[,3] # Extract Nitrate data
      corr[counter] <- cor(sulfate,nitrate,use="complete.obs") 
      counter <- counter+1
    }
  }
  
  # If none of the files meet threhold, return a zero vector
  if(length(corr) == 0) {corr <- 0}
  
  # Print Complete data frame
  corr
}