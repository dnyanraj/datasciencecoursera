#Set Working Dir
setwd(getwd())

#Read Data Files - Code assumes that data files are available in working directory
filePath <- "summarySCC_PM25.rds"
NEIData <- readRDS(filePath)

filePath <- "Source_Classification_Code.rds"
SCCData<- readRDS(filePath)

#-=-=-=-=

#Q4:Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

#Identify coal related sources from SCC data based on Short.Name
coalIdx <- grep("coal|Coal",SCCData$Short.Name)
SCCCoal <- SCCData[coalIdx,]

#Merge NEI data on SCC to subset records with Coal combustion related SCCs
x1sub <- merge(NEIData, SCCCoal[], by = "SCC")

#Aggregate over years
x1 <- aggregate(Emissions~year, x1sub, sum)

#Create png device with specified specifications
png(file="plot4.png")

#Plot the year over year total emission by type using ggplot2
p <- ggplot(x1, aes(year, Emissions))
p <- p+geom_point()+labs(title="Total PM2.5 Emission Over Years for Coal Combustion-related Sources in United States", x = "Year", y = "Emission in Tons")
p <- p+geom_line()
print(p)

#Turn device off. If this step is not executed, the file won't be accessible for viewing
dev.off()