#Find hospital in a state that has the best (i.e. lowest) 30-day mortality for the specifed outcome in that state.
#Takes 3 arguments: the 2-character abbreviated name of a state (state), an outcome (outcome), and the ranking of a hospital in that state for that outcome (num).
#This function uses stop() function from R Base package for error handling and aborts function execution on error(s).

rankhospital <- function(state, outcome, num = "best") {
        #Read outcome-of-care-measure.csv file
        filePath <- "~/Documents/R Working Dir/rprog-data-ProgAssignment3-data/outcome-of-care-measures.csv"
        outcomeData <- read.csv(filePath, colClasses = "character")
        
        #Set column index based on the user input
        colIndex <- if (outcome == "heart attack") {
                "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"
        } else if (outcome == "heart failure") {
                "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure"
        } else if (outcome == "pneumonia") {
                "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"
        } else {
                stop("invalid outcome") #Error handling for invalid "outcome name" inputs
        }
        
        #Subset the dataset for user input State, colIndex and Hospital Name
        stateData <- outcomeData[outcomeData$State == state, c(colIndex,"Hospital.Name")]
        
        #Error handling for invalid "state" input
        if (nrow(stateData) == 0) {
                stop("invalid state")       
        }
        
        #Cast 30-Day Mortality Rates for Outcome in numeric format
        stateData[,1]<-as.numeric(stateData[,1])
        
        #Order stateData dataset for Hospital.Name by Mortality Rates using order() function
        orderedData <- order(stateData[colIndex],stateData$Hospital.Name, na.last=NA) #Remove NAs while ordering
        
        #Subset the orderedData dataset to get the hospital name for user defined "rank" num
        if (num == "best") {
                as.character(stateData$Hospital.Name[orderedData[1]]) #Show 1st element
        } else if (num == "worst") {
                as.character(stateData$Hospital.Name[orderedData[length(orderedData)]]) #Show last element
        } else if (is.numeric(num)) {
                as.character(stateData$Hospital.Name[orderedData[num]]) #Show "num"th element
        } else {
                stop("invalid num") #Error handling for invalid "num" input
        }
}