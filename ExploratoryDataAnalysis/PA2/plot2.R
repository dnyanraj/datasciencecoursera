#Set Working Dir
setwd(getwd())

#Read Data Files - Code assumes that data files are available in working directory
filePath <- "summarySCC_PM25.rds"
NEIData <- readRDS(filePath)

filePath <- "Source_Classification_Code.rds"
SCCData<- readRDS(filePath)

#-=-=-=-=

#Q2: Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008?
#Use the base plotting system to make a plot answering this question.
x1sub <- subset(NEIData, fips=="24510", select = c(Emissions, year))
x1 <- aggregate(Emissions~year, x1sub, sum)

#Create png device with specified specifications
png(file="plot2.png")

#Create plot
plot(x1, main = "Total PM2.5 Emmissions By Year for Baltimore City, Maryland", xlab = "Year", ylab = "Total Emmissions in Tons")
lines(x1$year, x1$Emissions, type='l', col="red")

#Turn device off. If this step is not executed, the file won't be accessible for viewing
dev.off()