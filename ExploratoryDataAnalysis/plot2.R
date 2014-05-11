#NOTES:
#This code tries to filter the data set while loading, based on dates to conserve memory
#sqldf package is used to specify date filters
#Note that date filters are applied on "string" datatypes as sqlite doesn't allow date type conversion
#There's a solution of performing "substring" for comparison as explained here http://stackoverflow.com/questions/4428795/sqlite-convert-string-to-date
#but this dataset doesn't append 0's to dateparts, so it it hard to compare them to date formats

#Assumptions:
#1.Code assumes data file is present in working directory
#2.Plot file is written to working directory
#3.Code assumes that the client machine has required R packages loaded

#Begin Code
#-=-=-=-=-=

#Load sqldf package
require(sqldf)

#Read only records for specified dates
data<-read.csv.sql("household_power_consumption.txt",
                   sql="SELECT * FROM file WHERE Date = '1/2/2007' OR Date = '2/2/2007' ",
                   header = TRUE, sep =";")

#Convert measure from string to numeric
data$Global_active_power=as.numeric(data$Global_active_power)

#Define a function to concatenate two columns
dateTimeConcat=function(a,b) {paste(a,b,sep=" ")}

#mapply concatenation function on date and time, and add a new column to data frame
data$dateTime=mapply(dateTimeConcat,data$Date,data$Time)

#Convert dateTime to date time format
data$dateTime=strptime(data$dateTime,format="%d/%m/%Y %H:%M:%S")

#Create png device with specified specifications
png(file="plot2.png",width=480,height=480)

#Create histogram for selected measure and specify plot attributes
#type = 'l" - creates lines
plot(data$dateTime,data$Global_active_power, type="l", xlab="",ylab="Global Active Power (kilowatts)")

#Turn device off. If this step is not executed, the file won't be accessible for viewing
dev.off()

#End Code
#-=-=-=-=