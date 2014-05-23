# National Storm and Severe Weather Data Analysis

**NOTE**: *This analysis is created as a class assignment for Coursera's "Reproducible Research" class, from Data Science track, offered by Dr. Roger Peng.*

## Summary
This report evaluates the effects of different types of natural events based on their impacts on human health and economy. The data used for this analysis comes from US National Oceanic and Atmospheric Administration's (NOAA) storm database. After considering data from 1950 to 2011, we conclude that tornados caused the most fatalities and injuries over the considered time period accross US. In terms of economic impact, floods have been the costliest causing the most property and crop damage.

## Data
The data for this assignment is in CSV format compressed using bzip2 algorithm. The code downloads it from National Weather Service's website ([link](https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2)). The documentation for data is available [here](https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf) and [here](https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2FNCDC%20Storm%20Events-FAQ%20Page.pdf).

## Data Processing
### Step 1: Download Data

```r
# Setup
library(R.utils)
library(reshape2)
library(ggplot2)

# Download Data
filePath <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
if (!file.exists("StormData.csv.bz2")) {
    download.file(filePath, destfile = "StormData.csv.bz2", method = "curl")
}  #method = 'curl' because the site is https
if (!file.exists("StormData.csv")) {
    bunzip2("StormData.csv.bz2", "StormData.csv", remove = F)
}
```


### Step 2: Load Data and Create Aggregates
Here's what that raw data looks like

```r
data <- read.csv("StormData.csv")
str(data)
```

```
## 'data.frame':	902297 obs. of  37 variables:
##  $ STATE__   : num  1 1 1 1 1 1 1 1 1 1 ...
##  $ BGN_DATE  : Factor w/ 16335 levels "1/1/1966 0:00:00",..: 6523 6523 4242 11116 2224 2224 2260 383 3980 3980 ...
##  $ BGN_TIME  : Factor w/ 3608 levels "00:00:00 AM",..: 272 287 2705 1683 2584 3186 242 1683 3186 3186 ...
##  $ TIME_ZONE : Factor w/ 22 levels "ADT","AKS","AST",..: 7 7 7 7 7 7 7 7 7 7 ...
##  $ COUNTY    : num  97 3 57 89 43 77 9 123 125 57 ...
##  $ COUNTYNAME: Factor w/ 29601 levels "","5NM E OF MACKINAC BRIDGE TO PRESQUE ISLE LT MI",..: 13513 1873 4598 10592 4372 10094 1973 23873 24418 4598 ...
##  $ STATE     : Factor w/ 72 levels "AK","AL","AM",..: 2 2 2 2 2 2 2 2 2 2 ...
##  $ EVTYPE    : Factor w/ 985 levels "   HIGH SURF ADVISORY",..: 834 834 834 834 834 834 834 834 834 834 ...
##  $ BGN_RANGE : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ BGN_AZI   : Factor w/ 35 levels "","  N"," NW",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ BGN_LOCATI: Factor w/ 54429 levels ""," Christiansburg",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ END_DATE  : Factor w/ 6663 levels "","1/1/1993 0:00:00",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ END_TIME  : Factor w/ 3647 levels ""," 0900CST",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ COUNTY_END: num  0 0 0 0 0 0 0 0 0 0 ...
##  $ COUNTYENDN: logi  NA NA NA NA NA NA ...
##  $ END_RANGE : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ END_AZI   : Factor w/ 24 levels "","E","ENE","ESE",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ END_LOCATI: Factor w/ 34506 levels ""," CANTON"," TULIA",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ LENGTH    : num  14 2 0.1 0 0 1.5 1.5 0 3.3 2.3 ...
##  $ WIDTH     : num  100 150 123 100 150 177 33 33 100 100 ...
##  $ F         : int  3 2 2 2 2 2 2 1 3 3 ...
##  $ MAG       : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ FATALITIES: num  0 0 0 0 0 0 0 0 1 0 ...
##  $ INJURIES  : num  15 0 2 2 2 6 1 0 14 0 ...
##  $ PROPDMG   : num  25 2.5 25 2.5 2.5 2.5 2.5 2.5 25 25 ...
##  $ PROPDMGEXP: Factor w/ 19 levels "","-","?","+",..: 17 17 17 17 17 17 17 17 17 17 ...
##  $ CROPDMG   : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ CROPDMGEXP: Factor w/ 9 levels "","?","0","2",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ WFO       : Factor w/ 542 levels ""," CI","%SD",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ STATEOFFIC: Factor w/ 250 levels "","ALABAMA, Central",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ ZONENAMES : Factor w/ 25112 levels "","                                                                                                                               "| __truncated__,..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ LATITUDE  : num  3040 3042 3340 3458 3412 ...
##  $ LONGITUDE : num  8812 8755 8742 8626 8642 ...
##  $ LATITUDE_E: num  3051 0 0 0 0 ...
##  $ LONGITUDE_: num  8806 0 0 0 0 ...
##  $ REMARKS   : Factor w/ 436781 levels "","\t","\t\t",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ REFNUM    : num  1 2 3 4 5 6 7 8 9 10 ...
```


We considered data range 1950 - 2011. Health impact is computed by summing `FATALITIES` and `INJURIES` by `EVTYPE` variable.

```r
health <- aggregate(cbind(FATALITIES, INJURIES) ~ EVTYPE, data = data, sum)
property <- aggregate(PROPDMG ~ EVTYPE + PROPDMGEXP, data = data, sum)
crop <- aggregate(CROPDMG ~ EVTYPE + CROPDMGEXP, data = data, sum)
```


### Step 3: Analyze Health Impact
5 deadliest event types and the injuries and fatalities they caused are as follows

```r
# Identify 5 most harmful events
health <- health[order(health$FATALITIES, health$INJURIES, decreasing = T), 
    ]
health$EVTYPE <- factor(as.character(health$EVTYPE), levels = as.character(health$EVTYPE))
TOTAL <- health$FATALITIES + health$INJURIES
health <- cbind(health, TOTAL)
health1 <- health[1:5, ]
id <- 1:5
health1 <- cbind(id, health1)

# Melt the dataframe with one variable value appened to other on variable
health1 <- melt(health1[c("EVTYPE", "FATALITIES", "INJURIES")], id.vars = 1)
```


### Step 4: Analyze Economic Impact
We now use crop damage and property damage currency amounts to evaluate economic impact. `PROPDMG` and `CROPDMG` are expressed in different measures of units (`PROPDMGEXP` and `CROPDMGEXP` respectively). Here are the different measure of units in for these two measurements in the data.

```r
table(property$PROPDMGEXP)
```

```
## 
##       -   ?   +   0   1   2   3   4   5   6   7   8   B   h   H   K   m 
## 805   1   4   5  15   4   4   2   4   8   2   5   1  19   1   2 371   4 
##   M 
## 131
```

```r
table(crop$CROPDMGEXP)
```

```
## 
##       ?   0   2   B   k   K   m   M 
## 947   3   5   1   6   4 135   1  73
```


**Interpretation of Units:** k=K=10^3, m=M=10^6, h=H=10^2, i=10^1.  
**Proposed Common Unit of Currency:** k=K=10^3 (Dollar Amount in Thousand)  

Here's a function that converts all measures of unit to k=K=10^3 for all `PROPDMG` and `CROPDMG` records.

```r
unify <- function(economy, colValue, colUnit) {
    economy1 <- economy[!economy[[colUnit]] %in% c("", "-", "?", "+"), ]
    economy1[[colValue]] <- as.numeric(economy1[[colValue]])
    value.In.K <- numeric()
    for (i in 1:nrow(economy1)) {
        oriNum <- economy1[i, ][[colValue]]
        if (economy1[i, ][[colUnit]] == "0") {
            damage <- oriNum/1000
        } else if (economy1[i, ][[colUnit]] == "1") {
            damage <- oriNum/100
        } else if (economy1[i, ][[colUnit]] == "2") {
            damage <- oriNum/10
        } else if (economy1[i, ][[colUnit]] == "3") {
            damage <- oriNum
        } else if (economy1[i, ][[colUnit]] == "4") {
            damage <- oriNum * 10
        } else if (economy1[i, ][[colUnit]] == "5") {
            damage <- oriNum * 100
        } else if (economy1[i, ][[colUnit]] == "6") {
            damage <- oriNum * 1000
        } else if (economy1[i, ][[colUnit]] == "7") {
            damage <- oriNum * 10^4
        } else if (economy1[i, ][[colUnit]] == "8") {
            damage <- oriNum * 10^5
        } else if (economy1[i, ][[colUnit]] == "B") {
            damage <- oriNum * 10^6
        } else if (economy1[i, ][[colUnit]] == "H" | economy1[i, ][[colUnit]] == 
            "h") {
            damage <- oriNum/10
        } else if (economy1[i, ][[colUnit]] == "M" | economy1[i, ][[colUnit]] == 
            "m") {
            damage <- oriNum * 10^3
        } else {
            damage <- oriNum
        }
        value.In.K <- c(value.In.K, damage)
    }
    economy1 <- cbind(economy1, value.In.K)
    economy1 <- aggregate(value.In.K ~ EVTYPE, data = economy1, sum)
    economy1 <- economy1[order(economy1$value.In.K, decreasing = T), ]  #Order by Econmic Impact Value
    invisible(economy1)
}
```


Convert measures of unit.

```r
property1 <- unify(property, "PROPDMG", "PROPDMGEXP")
crop1 <- unify(crop, "CROPDMG", "CROPDMGEXP")
```


Merge currency adjusted property and crop damage datasets into a `economy` dataset.

```r
merge <- function(property, crop) {
    economy <- rbind(property, crop)
    economy <- aggregate(value.In.K ~ EVTYPE, data = economy, sum)
    economy <- economy[order(economy$value.In.K, decreasing = T), ]
    names(economy) <- c("EVTYPE", "Total.Value")
    Property.Value <- numeric(length = nrow(economy))
    Crop.Value <- numeric(length = nrow(economy))
    economy <- cbind(economy, Property.Value, Crop.Value)
    for (i in 1:nrow(economy)) {
        type <- economy[i, ]$EVTYPE
        if (type %in% property$EVTYPE) {
            economy[i, ]$Property.Value <- property[property$EVTYPE == type, 
                ]$value.In.K
        }
        if (type %in% crop$EVTYPE) {
            economy[i, ]$Crop.Value <- crop[crop$EVTYPE == type, ]$value.In.K
        }
    }
    invisible(economy)
}
economy <- merge(property1, crop1)
```


Identify 5 economically damading events

```r
# Identify 5 economically damaging events
economy1 <- economy[1:5, ]
id <- 1:5
economy1 <- cbind(id, economy1)

# Melt the dataframe with one variable value appened to other on variable
economy1 <- melt(economy1[c("EVTYPE", "Property.Value", "Crop.Value")], id.vars = 1)
```


## Results
From the following plot, it is clear that tornados have been deadlist, causing most harm to humans.

```r
# Plot
p <- ggplot(health1, aes(EVTYPE, value, fill = variable, ymax = 10000)) + geom_bar(aes(order = value), 
    stat = "identity", position = "dodge")
p <- p + geom_text(aes(label = value), vjust = -0.25, position = position_dodge(0.9), 
    size = 3)
p <- p + ggtitle("5 Deadliest Event Types in United States from 1950 to 2011")
p <- p + theme(plot.title = element_text(lineheight = 0.8, face = "bold"), axis.text.x = element_text(angle = 90, 
    hjust = 1))
p <- p + xlab("Event Type") + ylab("Number of Humans Affected") + labs(fill = "Types of Human Harm")
print(p)
```

![plot of chunk unnamed-chunk-10](figure/unnamed-chunk-10.png) 


From the following plot, it is clear that floods have caused the most economic damage, both to property as well as crops.

```r
# Plot
q <- ggplot(economy1, aes(EVTYPE, value, fill = variable, ymax = 1e+06)) + geom_bar(aes(order = value), 
    stat = "identity", position = "dodge")
q <- q + geom_text(aes(label = value), vjust = -0.25, position = position_dodge(0.9), 
    size = 3)
q <- q + ggtitle("5 Costliest Events in United States from 1950 to 2011")
q <- q + theme(plot.title = element_text(lineheight = 0.8, face = "bold"), axis.text.x = element_text(angle = 90, 
    hjust = 1))
q <- q + xlab("Event Type") + ylab("USD Amount in Thousands") + labs(fill = "Types of Economic Impact")
print(q)
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-11.png) 

