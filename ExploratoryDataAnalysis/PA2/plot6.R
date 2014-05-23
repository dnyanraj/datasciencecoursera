#Set Working Dir
setwd(getwd())
library(ggplot2)

#Read Data Files - Code assumes that data files are available in working directory
filePath <- "summarySCC_PM25.rds"
NEIData <- readRDS(filePath)

filePath <- "Source_Classification_Code.rds"
SCCData<- readRDS(filePath)

#-=-=-=-=

#Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037").
#Which city has seen greater changes over time in motor vehicle emissions?
motorIdx <- grep("motor|Motor",SCCData$Short.Name)
SCCMotor <- SCCData[motorIdx,]

#Merge NEI data on SCC to subset records with Coal combustion related SCCs
x1sub <- merge(NEIData, SCCMotor[], by = "SCC") #All Motor Vehicle SCCs and All fips

#Identify only Baltimore City & Los Angeles County records
x2sub <- subset(x1sub, fips=="24510" |  fips=="06037", select = c(Emissions, year, SCC, fips))

#Substitute fips by City Name
x2sub$fips <- sub("06037","Los Angeles County", x2sub$fips)
x2sub$fips <- sub("24510","Baltimore City", x2sub$fips)

#Add year.fips identifier to x2sub dataset
x2sub$year.city <- with(x2sub, paste(year, fips, sep = "."))

#Aggregate Emmission over Years
x2 <- aggregate(Emissions~year.city, x2sub, sum)

#Split year.city column within x2 to create 2 seperate columns
x2<-within(x2, year.city<-data.frame(do.call('rbind', strsplit(as.character(year.city), '.', fixed = TRUE))))
x2$year <- x2$year.city$X1
x2$city <- x2$year.city$X2

#Create png device with specified specifications
#png(file="plot6.png")

#Plot 1
#p <- ggplot(x2, aes(year, Emissions))
#p <- p+geom_point()+labs(title="Total PM2.5 Emission Over Years for Motor Vehicles in \nBaltimore City vs Los Angeles County", x = "Year", y = "Emission in Tons")
#p <- p+facet_grid(.~city)+geom_line(aes(group = city))
#print(p)

#Plot 2
p <- ggplot(x2, aes(year, Emissions, color = city))
p <- p+geom_point(size=5)+labs(title="Total PM2.5 Emission Over Years for Motor Vehicles in \nBaltimore City vs Los Angeles County", x = "Year", y = "Emission in Tons")
p <- p+geom_line(size=2, aes(group = city))
print(p)

#Turn device off. If this step is not executed, the file won't be accessible for viewing
#dev.off()