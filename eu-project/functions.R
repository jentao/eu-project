#This is where we are going to put functions to manipulate data
library(shiny)
library(R.utils)
library(data.table)
library(dplyr)

## setwd("~/Desktop/Info201HW/eu-project/eu-project/data")

data_projects <- data.table::fread("data/projects.csv")
data_org <-data.table::fread("data/organizations.csv")

## function that sorts into new dataframe by low carbon/sustainable food projects
## does this by taking all project data and filtering by topic for ones that start with
## The LC/SFS tag
proj_by_tag <- function(tag){
  proj <- filter(data_projects, like(topics, tag) ) %>%
    select(rcn, id, acronym, status, programme, topics, frameworkProgramme, title, startDate, 
           endDate, projectUrl, objective, totalCost,
           ecMaxContribution, call, fundingScheme,
           coordinator, coordinatorCountry, participants,
           participantCountries, subjects)
  
  proj$totalCost <- sub(",", ".", proj$totalCost)
  proj$totalCost <- as.numeric(proj$totalCost)
  proj$ecMaxContribution <- sub(",", ".", proj$ecMaxContribution)
  proj$ecMaxContribution <- as.numeric(proj$ecMaxContribution)
  proj
}

## test
proj_LC <- proj_by_tag("LC")
proj_sfs <- proj_by_tag("SFS")

## this is a function where you put in a country code as a string from 
## this list https://ec.europa.eu/eurostat/statistics-explained/index.php/Tutorial:Country_codes_and_protocol_order 
## and it will filter to a data fram that only contains projects that that chosen country particpates in

country_filter <- function(cnt, data){
   fil_cnt_data <-filter(data, like(participantCountries, cnt) ) %>%
     select(rcn, id, acronym, status, programme, topics, frameworkProgramme, title, startDate, 
            endDate, projectUrl, objective, totalCost,
            ecMaxContribution, call, fundingScheme,
            coordinator, coordinatorCountry, participants,
            participantCountries, subjects) 
}

## test i wrote to make sure my filter funciton worked
uk_fil<-country_filter('UK', proj_LC)

## calculations to get some cost data
## return a list of avg, max, and min
cost_summary <- function(data){
  average_cost <-mean(data$totalCost)
  max_cost <- max(data$totalCost)
  min_cost <- min(data$totalCost)
  l <- c(average = average_cost, max = max_cost, min = min_cost)
  l
}







## creates a seperate dataframe for each country that contains all the projects
## the country particpates in
Belgium_part <-country_filter('BE')
Bulgaria_part <-country_filter('BG')
Czech_Republic_part  <-country_filter('CZ')
Denmark_part    <-country_filter('DK')
Germany_part <-country_filter('DE')
Estonia_part	<-country_filter('EE')
Ireland_part <-country_filter('IE')
Greece_part <-country_filter('EL')
Spain_part <-country_filter('ES')
France_part <-country_filter('FR')
Croatia_part <-country_filter('HR')
Italy_part   <-country_filter('IT')
Cyprus_part	<-country_filter('CY') 
Latvia_part <-country_filter('LV')
Lithuania_part <-country_filter('LT')
Luxembourg_part <-country_filter('LU')
Hungary_part <-country_filter('HU')
Malta_part <-country_filter('MT')
Netherlands_part  <-country_filter('NL')
Austria_part 	<-country_filter('AT')
Poland_part   <-country_filter('PL')
Portugal_part	<-country_filter('PT')
Romania_part		<-country_filter('RO')
Slovenia_part	<-country_filter('SI')	
Slovakia_part	<-country_filter('SK')
Finland_part	<-country_filter('FI')
Sweden_part	<-country_filter('SE')
United_Kingdom_part <-country_filter('UK')


## plain list of strings of EU countries
eu_states <- c('Belgium','Bulgaria','Czech Republic','Denmark','Germany',
              'Estonia','Ireland','Greece','Spain','France',
              'Croatia','Italy','Cyprus','Latvia','Lithuania',
              'Luxembourg','Hungary','Malta','Netherlands',
              'Austria','Poland','Portugal','Romania',
              'Slovenia','Slovakia','Finland','Sweden',
              'United Kingdom')

## this function takes in a year and data frame and fiters out the 
## dataframe for only projects that that in the input year

year_filter <- function(year, in_df){
  fil_cnt_data <-filter(in_df, like(startDate, year) ) %>%
    select(rcn, id, acronym, status, programme, topics, frameworkProgramme, title, startDate, 
           endDate, projectUrl, objective, totalCost,
           ecMaxContribution, call, fundingScheme,
           coordinator, coordinatorCountry, participants,
           participantCountries, subjects) 
}

#uk_fil_datfill <- year_filter('2016', uk_fil)
#befil_datfill_14 <- year_filter('2014', Belgium_part)


## the is a list of data frams by eu country, got from using country filter
eu_states_dfram <- list(Belgium_part,
                      Bulgaria_part, Czech_Republic_part, Denmark_part, Germany_part , Estonia_part,
                     Ireland_part,Greece_part, Spain_part  ,France_part ,Croatia_part ,
                     Italy_part, Cyprus_part	,Latvia_part ,Lithuania_part ,Luxembourg_part , Hungary_part ,
                     Malta_part , Netherlands_part, Austria_part 	, Poland_part   ,Portugal_part	,
                     Romania_part	,	Slovenia_part ,	Slovakia_part	, Finland_part	, Sweden_part	, 
                     United_Kingdom_part )

year_fun <-function(yr){
  
  num_vec <- c(1:28)
  dat_name <- paste("")
  
  for (i in 1:28) {
    num_vec[i] <- as.integer(nrow(year_filter(yr, eu_states_dfram[[i]]  )))
  }
  
  my_data_dne <- data.frame(eu_states, num_vec, stringsAsFactors = FALSE)
  
} 

part_year_2014<- year_fun('2014')
part_year_2015<- year_fun('2015')
part_year_2016<- year_fun('2016')
part_year_2017<- year_fun('2017')
part_year_2018<- year_fun('2018')
part_year_2019<- year_fun('2019')


  










