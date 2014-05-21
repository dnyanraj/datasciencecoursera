#Set Working Dir
setwd(getwd())
library(ggplot2)

#Read Data Files - Code assumes that data files are available in working directory
filePath <- "summarySCC_PM25.rds"
NEIData <- readRDS(filePath)

filePath <- "Source_Classification_Code.rds"
SCCData<- readRDS(filePath)

#-=-=-=-=

#Q5:How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
motorIdx <- grep("motor|Motor",SCCData$Short.Name)
SCCMotor <- SCCData[motorIdx,]

#Merge NEI data on SCC to subset records with Coal combustion related SCCs
x1sub <- merge(NEIData, SCCMotor[], by = "SCC") #All Motor Vehicle SCCs and All fips

#Identify only Baltimore City records
x2sub <- subset(x1sub, fips=="24510", select = c(Emissions, year, SCC))

#Aggregate Emmission over Years
x2 <- aggregate(Emissions~year, x2sub, sum)

#Create png device with specified specifications
png(file="plot5.png")

#Plot
p <- ggplot(x2, aes(year, Emissions))
p <- p+geom_point()+labs(title="Total PM2.5 Emission Over Years \n from Motor Vehicle Sources in Baltimore City", x = "Year", y = "Emission in Tons")
p <- p+geom_line()
print(p)

#Turn device off. If this step is not executed, the file won't be accessible for viewing
dev.off()