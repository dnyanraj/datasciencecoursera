#Set Working Dir
setwd(getwd())

#Read Data Files
filePath <- "summarySCC_PM25.rds"
NEIData <- readRDS(filePath)

filePath <- "Source_Classification_Code.rds"
SCCData<- readRDS(filePath)

#-=-=-=-=

#Q1: Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
#Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.
x1sub <- subset(NEIData, year>= 1999, select = c(Emissions, year))
x1 <- aggregate(Emission~year, x1sub, sum)

#Create png device with specified specifications
png(file="plot1.png")

#Create plot
plot(x1, main = "Total PM2.5 Emmissions By Year", xlab = "Year", ylab = "Total Emmissions in Tons")
lines(x1$year, x1$Emissions, type='l', col="blue")

#Turn device off. If this step is not executed, the file won't be accessible for viewing
dev.off()