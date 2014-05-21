#Set Working Dir
setwd(getwd())

#Read Data Files - Code assumes that data files are available in working directory
filePath <- "summarySCC_PM25.rds"
NEIData <- readRDS(filePath)

filePath <- "Source_Classification_Code.rds"
SCCData<- readRDS(filePath)

#-=-=-=-=

#Q3: Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City?
#Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.
x1sub <- subset(NEIData, fips=="24510", select = c(Emissions, type, year)) #Subset Baltimore City

#Compute total emission by type and year
x1sub$type.year <- with(x1sub, paste(type, year, sep = ".")) #Add column to identify unique year+type identifier
x1 <- aggregate(Emissions~type.year, x1sub, sum)

#Split year and type columns for plotting
x2<-within(x1, type.year<-data.frame(do.call('rbind', strsplit(as.character(type.year), '.', fixed = TRUE))))
x2$type <- x2$type.year$X1
x2$year <- x2$type.year$X2

#Create png device with specified specifications
png(file="plot3.png")

#Plot the year over year total emission by type using ggplot2
p <- ggplot(x2, aes(year, Emissions))
p <- p+geom_point()+labs(title="Total PM2.5 Emission Over Years by Type for Baltimore City", x = "Year", y = "Emission in Tons")
p <- p+facet_grid(.~type)+geom_line(aes(group = type))
print(p)

#Turn device off. If this step is not executed, the file won't be accessible for viewing
dev.off()