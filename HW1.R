install.packages("jsonlite")
install.packages("XML")
install.packages("RCurl")
install.packages("dplyr")


library(jsonlite)
library(XML)
library(RCurl)
library(dplyr)
setwd("C:/Users/marro/Downloads/Data Prep/json/")
file_list <- list.files()

hotels= data.frame(FileName=character(), Name=character(), City=character(), Country=character(), PriceRange = character(), Address=character(), stringsAsFactors=FALSE)
for (file_name in file_list){
  data <- fromJSON(txt=file_name)
  address <- data$HotelInfo$Address
  name <- data$HotelInfo$Name
  price = NA
  if(is.character(data$HotelInfo$Price)){
    price <- data$HotelInfo$Price
  }
  if(!is.null(address)){
    doc <- htmlParse(address, asText=TRUE)
    
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
    
    hotels[nrow(hotels) + 1,] = c(file_name,name,city,country,price, whole_address)
    
  }
}

distinct_city_names <- unique(hotels$City)
us_distinct_city_names <- unique((dplyr::filter(hotels,Country=="US"))$City)
table = dplyr::select(hotels, Name, Price, Address)
