##Find hospitals in all states that has the user defined rank, based on 30-day mortality for the specifed outcome in that state.
#Takes 2 arguments: an outcome (outcome), and the ranking of a hospital in that state for that outcome (num).

rankall <- function(outcome, num = "best") {
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
        
        #Cast 30-Day Mortality Rates for Outcome in numeric format
        outcomeData[,colIndex] <- as.numeric(outcomeData[,colIndex])
        
        #Split outcomeData dataframe by "state" as a factor and subset only Hospital Name, State and Outcome Column
        stateFactorData <- split(outcomeData[, c("Hospital.Name", "State", colIndex)], outcomeData$State)
        
        #Create a function that returns Hospital Name from a dataset which has an order number of user input "num"
        #Takes 2 arguments: stateData dataset and num
        rankHospital <- function(stateData, num) {
                orderedData <- order(stateData[colIndex], stateData$Hospital.Name, na.last=NA)
                
                if (num == "best") {
                        stateData$Hospital.Name[orderedData[1]]
                } else if (num == "worst") {
                        stateData$Hospital.Name[orderedData[length(orderedData)]]
                } else if (is.numeric(num)) {
                        stateData$Hospital.Name[orderedData[num]]
                } else {
                        stop("invalid num")
                }
        }
        
        #lapply rankHospital function to stateFactorData to get Hospital Name for "num" rank for EACH factor (state)
        stagingVector <- lapply(stateFactorData, rankHospital, num)
        
        #Return a final data frame by "unlist"ing converting "state" factors to row elements for Hosptial Names from stagingVector
        #unlist() function flattens a vector to produce a vector containing all atomic components which occur in x
        data.frame(hospital = unlist(stagingVector), state = names(stagingVector), row.names = names(stagingVector))
}