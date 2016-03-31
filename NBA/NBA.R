library(dplyr)
#set conference
data <- read.csv(file="NBAdataTest.csv",head=TRUE,sep=",")
east <- c("Charlotte Hornets/Charlotte Bobcats", "Toronto Raptors", "Orlando Magic","Miami Heat","Boston Celtics", "Chicago Bulls", "Atlanta Hawks", "Cleveland Cavaliers", "Detroit Pistons", "Indiana Pacers", "Milwaukee Bucks", "Brooklyn Nets/New Jersey Nets", "New York Knicks", "Philadelphia 76ers", "Washington Wizards/Washington Bullets")
west <- c("Minnesota Timberwolves","New Orleans/Oklahoma City Hornets/Pelicans","Dallas Mavericks","Memphis Grizzlies/Vancouver Grizzlies","Denver Nuggets", "Golden State Warriors","Houston Rockets","Kansas City Kings/Sacramento Kings", "Los Angeles Lakers", "Phoenix Suns", "Portland Trail Blazers", "San Antonio Spurs", "Los Angeles Clippers/San Diego Clippers", "Oklahoma City Thunder/Seattle SuperSonics", "Utah Jazz")
#dplyr::filter(data, !is.element(Team, east) & !is.element(Team,west))$Team # && )
data[which(is.element(data$Team, east)),"Conference"]<-"east"
data[which(is.element(data$Team, west)),"Conference"]<-"west"

for (year in 1984:2014){
  #teams per conference in the playoffs
  n=8
  
  teams = filter(data, Season==year)
  eastTeams = filter(teams, Conference=="east")
  
  classifiedEast = arrange(eastTeams, desc(GW))[1:n,]
  data[which(data$Season == year & data$Conference == "east" & is.element(data$Team,classifiedEast$Team)), "Classified"] = TRUE 
  data[which(data$Season == year & data$Conference == "east" & !is.element(data$Team,classifiedEast$Team)), "Classified"] = FALSE
  
  westTeams = filter(teams, Conference=="west")
  classifiedWest = arrange(westTeams, desc(GW))[1:n,]
  data[which(data$Season == year & data$Conference == "west" & is.element(data$Team,classifiedWest$Team)), "Classified"] = TRUE 
  data[which(data$Season == year & data$Conference == "west" & !is.element(data$Team,classifiedWest$Team)), "Classified"] = FALSE
}
  

write.table(data,file="NBADataTest_extended.csv",sep=",",row.names = FALSE)
