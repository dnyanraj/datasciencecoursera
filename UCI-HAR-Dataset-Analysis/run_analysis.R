#Steps to run before running following code
#1.Download file https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip. Unzip it.
#2.The resulting file structure should exist in folder @ path <working_dir>/<UCI HAR Dataset>
#NOTE - Script follows camel-case naming convention

#-=-=-
#SETUP
#-=-=-
library(reshape2)

#-=-=-=-=-=-=-=-=-
#PART1 - Read Data
#-=-=-=-=-=-=-=-=-

#1.1Read "Test" Data
#~~~~~~~~~~~~~~~~~~~

#Read Feature Names to Identify Columns in X_Test
directoryPath <- file.path(getwd(),"UCI HAR Dataset")
fileName <- paste("features","txt",sep=".") # Construct file name
filePath <- file.path(directoryPath,fileName) # Construct fully qualified file path
featureCols <- read.table(filePath, header=F, as.is=T, col.names=c("MeasureID", "MeasureName"))

#Identify Column Names With Mean or Std
colSubset <- grep(".*mean\\(\\)|.*std\\(\\)", featureCols$MeasureName)

#Read Activity Label
directoryPath <- file.path(getwd(),"UCI HAR Dataset","test")
fileName <- paste("Y_Test","txt",sep=".") # Construct file name
filePath <- file.path(directoryPath,fileName) # Construct fully qualified file path
testYData <- read.table(filePath,header=F,col.names=c("ActivityID"))

#Read Subject Data
directoryPath <- file.path(getwd(),"UCI HAR Dataset","test")
fileName <- paste("Subject_Test","txt",sep=".") # Construct file name
filePath <- file.path(directoryPath,fileName) # Construct fully qualified file path
testSubjectData <- read.table(filePath,header=F,col.names=c("SubjectID"))

#Read Set(X) Data
directoryPath <- file.path(getwd(),"UCI HAR Dataset","test")
fileName <- paste("X_Test","txt",sep=".") # Construct file name
filePath <- file.path(directoryPath,fileName) # Construct fully qualified file path
testXData <- read.table(filePath,header=F,col.names=featureCols$MeasureName)
#Subset Mean and Std Columns
testXData <- testXData[,colSubset]

#Add Activity Id Column
testXData$ActivityID <- testYData$ActivityID

#Add Subject Id Column
testXData$SubjectID <- testSubjectData$SubjectID


#1.2Read "Train" Data
#~~~~~~~~~~~~~~~~~~~
#Read Feature Names to Identify Columns in X_train
directoryPath <- file.path(getwd(),"UCI HAR Dataset")
fileName <- paste("features","txt",sep=".") # Construct file name
filePath <- file.path(directoryPath,fileName) # Construct fully qualified file path
featureCols <- read.table(filePath, header=F, as.is=T, col.names=c("MeasureID", "MeasureName"))

#Identify Column Names With Mean or Std
colSubset <- grep(".*mean\\(\\)|.*std\\(\\)", featureCols$MeasureName)

#Read Activity Label
directoryPath <- file.path(getwd(),"UCI HAR Dataset","train")
fileName <- paste("Y_train","txt",sep=".") # Construct file name
filePath <- file.path(directoryPath,fileName) # Construct fully qualified file path
trainYData <- read.table(filePath,header=F,col.names=c("ActivityID"))

#Read Subject Data
directoryPath <- file.path(getwd(),"UCI HAR Dataset","train")
fileName <- paste("Subject_train","txt",sep=".") # Construct file name
filePath <- file.path(directoryPath,fileName) # Construct fully qualified file path
trainSubjectData <- read.table(filePath,header=F,col.names=c("SubjectID"))

#Read Set(X) Data
directoryPath <- file.path(getwd(),"UCI HAR Dataset","train")
fileName <- paste("X_train","txt",sep=".") # Construct file name
filePath <- file.path(directoryPath,fileName) # Construct fully qualified file path
trainXData <- read.table(filePath,header=F,col.names=featureCols$MeasureName)
#Subset Mean and Std Columns
trainXData <- trainXData[,colSubset]

#Add Activity Id Column
trainXData$ActivityID <- trainYData$ActivityID

#Add Subject Id Column
trainXData$SubjectID <- trainSubjectData$SubjectID

#-=-=-=-=-=-=-=-=-=-
#PART2 - Merge Data
#-=-=-=-=-=-=-=-=-=-
#Append Rows From Two Datasets
mergedData <- rbind(testXData, trainXData) #Rowbind datasets

#Read Activity Lables
directoryPath <- file.path(getwd(),"UCI HAR Dataset")
fileName <- paste("activity_labels","txt",sep=".") # Construct file name
filePath <- file.path(directoryPath,fileName) # Construct fully qualified file path
activityLabels <- read.table(filePath, header=F, as.is=T, col.names=c("ActivityID", "ActivityName"))
#Note that ActivityName is read in as "character"

#Add ActivityNames Column To Merged Dataset
activityLabels$ActivityName <- as.factor(activityLabels$ActivityName) #Convert ActivityName to factors
labeledMergedData <- merge(mergedData,activityLabels) #Gets merged on ActivityID


#-=-=-=-=-=-=-=-=-
#PART3 - Melt Data
#-=-=-=-=-=-=-=-=-
#NOTE: We need average of each variable for each activity and each subject.

#Create idVars vector to hold id variables
idVars <- c("ActivityID", "ActivityName", "SubjectID")

#Create measureVars vector to hold measure varibles
measureVars <- setdiff(colnames(labeledMergedData), idVars) #Extract only MeasureNames from labeledMergedData set

#Melt Data
meltedData <- melt(labeledMergedData, id=idVars, measure.vars=measureVars)

#DCast using Mean() aggregate function for each ActivityName & Subject ID FOR each Variable from melted data
castedData <- dcast(meltedData,ActivityName+SubjectID~variable,mean)


#-=-=-=-=-=-=-=-=-=-=-=-
#PART4 - Write Data File
#-=-=-=-=-=-=-=-=-=-=-=-
write.table(castedData, "tidy.txt")