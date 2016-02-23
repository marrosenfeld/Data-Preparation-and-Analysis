library("dplyr")

CommAreas <- read.csv(file="CommAreas.csv",head=TRUE,sep=",")
CommAreasShort <- select(CommAreas, AREA_NUMBE, COMMUNITY, AREA_NUM_1)

Graffitis <- read.csv(file="311_Service_Requests_-_Graffiti_Removal.csv",head=TRUE,sep=",")


merged <- merge(x=Graffitis,y=CommAreasShort,by.x="Community.Area",by.y="AREA_NUMBE")
