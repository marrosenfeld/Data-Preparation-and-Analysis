library("dplyr")

#read file of Community Areas
CommAreas <- read.csv(file="data/CommAreas.csv",head=TRUE,sep=",")

#read file of graffitis
Graffitis <- read.csv(file="data/311_Service_Requests_-_Graffiti_Removal.csv",head=TRUE,sep=",")

#merge graffitis and community areas
merged <- merge(x=Graffitis,y=CommAreas,by.x="Community.Area",by.y="AREA_NUMBE")

#transform creation date as date
merged$Creation.Date.asDate <- as.Date(merged$Creation.Date,"%m/%d/%Y")

#get 2015 graffitis
lastYearGraffitis <- filter(merged, format(Creation.Date.asDate, "%Y") == 2015)

#2015 graffitis by community area
graffitisByCommArea <- lastYearGraffitis %>% group_by(Community.Area, COMMUNITY) %>% summarise(n())
colnames(graffitisByCommArea)[3] <- "Count"

#visualize the number of incidents reported during 2015 by "Community Area"
barplot(graffitisByCommArea$Count,names.arg = graffitisByCommArea$Community.Area, xlab = "Community Area", ylab = "Number of Graffitis Reported in 2015", main = "Graffitis reported in 2015 by Community Area")

#split community areas in 5 quantiles
graffitisByCommArea$range <- cut(graffitisByCommArea$Count,quantile(graffitisByCommArea$Count, seq(0,1,0.2)), include.lowest=TRUE)

graffitisByCommArea$rangeLetter <- cut(graffitisByCommArea$Count,quantile(graffitisByCommArea$Count, seq(0,1,0.2)),c("A","B","C","D","E"),include.lowest=TRUE)

graffitisByCommArea %>% group_by(range) %>% summarise(n()) 
