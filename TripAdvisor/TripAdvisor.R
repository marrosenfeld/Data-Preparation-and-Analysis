#Run this lines to install the necessary packages
install.packages("jsonlite")
install.packages("XML")
install.packages("dplyr")


library(jsonlite)
library(XML)
library(dplyr)

#indicate here the directory where the json files are stored
path = "C:/Users/marro/Downloads/Data Prep/json/"
file_list <- list.files(path)

#create data frame to store all hotels data
hotels= data.frame(FileName=character(), Name=character(), City=character(), Country=character(), PriceRange = character(), Address=character(), stringsAsFactors=FALSE)

#loop over all the files
for (file_name in file_list){
  #read json file
  data <- fromJSON(txt=paste(path,file_name,sep=""))
  address <- data$HotelInfo$Address
  name <- data$HotelInfo$Name
  price = NA
  if(is.character(data$HotelInfo$Price)){
    price <- data$HotelInfo$Price
  }
  if(!is.null(address)){
    doc <- htmlParse(address, asText=TRUE)
    #get address attributes by parsing the xml
    locality <- xpathSApply(doc, "//span[@property='v:locality']", xmlValue)
    region <- xpathSApply(doc, "//span[@property='v:region']", xmlValue)
    country_name <- xpathSApply(doc, "//span[@property='v:country-name']", xmlValue)
    whole_address = xpathSApply(doc, "//span[@rel='v:address']", xmlValue)
    
    city = NA
    country = NA
    
    if(is.character(locality)){
      city = locality
    }
    if(is.character(country_name)){
      country = country_name
    }
    else if(!is.na(city)){
      #assume no country is US
      country = "US"
    }
    
    #insert hotel in data frame
    hotels[nrow(hotels) + 1,] = c(file_name,name,city,country,price, whole_address)
    
  }
}

#Question 2: set of distinct city names
distinct_city_names <- filter(hotels,!is.na(City)) %>% select(City) %>% distinct
write.table(distinct_city_names, file = "distinct_city_names.csv", row.names = FALSE, col.names = FALSE)

#Question 2: set of distinct us city names
us_distinct_city_names <- filter(hotels,!is.na(City)) %>% filter(Country == "US")  %>% select(City) %>% distinct
write.table(us_distinct_city_names, file = "us_distinct_city_names.csv", row.names = FALSE, col.names = FALSE)

#Question 3: number of hotels in each city
distinct_hotels <- hotels %>% select(City,Name) %>% distinct #just in case hotels are more than one time
hotels_count_by_city <- filter(distinct_hotels,!is.na(City)) %>%  group_by(City) %>% summarise(n())
colnames(hotels_count_by_city)[2] <- "Count"
write.table(hotels_count_by_city, file = "hotels_count_by_city.csv", row.names = FALSE,sep=",")


#Question 3: cities with more than 30 hotels
cities_with_more_than_30 <- hotels_count_by_city %>% filter(Count>30) %>% select(City)
write.table(cities_with_more_than_30, file = "cities_with_more_than_30.csv", row.names = FALSE)


#Question 4: table containing the name of each hotel, its price range, and its address
table = dplyr::select(hotels, Name, PriceRange, Address)
write.table(table, file = "table.csv", row.names = FALSE,sep=",")


