#This is where we are going to put functions to manipulate data


library(shiny)
library(R.utils)
library(data.table)

library(dplyr)

setwd("~/Desktop/Info201HW/eu-project/eu-project/data")

data_projects <- data.table::fread("~/Desktop/Info201HW/eu-project/eu-project/data/projects.csv")
data_org <-data.table::fread("~/Desktop/Info201HW/eu-project/eu-project/data/organizations.csv")


##function that sorts into new dataframe by sustainable food projects
## does this by taking all project data and filtering by topic for ones that start with
## The SFS tag
proj_sfs<- filter(data_projects, like(topics, 'SFS') ) %>%
  select(rcn, id, acronym, status, programme, topics, frameworkProgramme, title, startDate, 
         endDate, projectUrl, objective, totalCost,
         ecMaxContribution, call, fundingScheme,
         coordinator, coordinatorCountry, participants,
         participantCountries, subjects)


##function that sorts into new dataframe by low carbon projects
## does this by taking all project data and filtering by topic for ones that start with
## The LC tag

proj_LC <-filter(data_projects, like(topics, 'LC') ) %>%
  select(rcn, id, acronym, status, programme, topics, frameworkProgramme, title, startDate, 
         endDate, projectUrl, objective, totalCost,
         ecMaxContribution, call, fundingScheme,
         coordinator, coordinatorCountry, participants,
         participantCountries, subjects)


##this is a function where you put in a country code as a string from 
## this list https://ec.europa.eu/eurostat/statistics-explained/index.php/Tutorial:Country_codes_and_protocol_order 
## and it will filter to a data fram that only contains projects that that chosen country particpates in

country_filter <- function(cnt){
   fil_cnt_data <-filter(data_projects, like(participantCountries, cnt) ) %>%
     select(rcn, id, acronym, status, programme, topics, frameworkProgramme, title, startDate, 
            endDate, projectUrl, objective, totalCost,
            ecMaxContribution, call, fundingScheme,
            coordinator, coordinatorCountry, participants,
            participantCountries, subjects) 
}

## test i wrote to make sure my filter funciton worked
uk_fil<-country_filter('UK')

# gets rid of commas in costs and converts the cost column to workable number format\
# for both the low carbon proects and the Sustainable food projects
proj_LC$totalCost<-sub(",", ".", proj_LC$totalCost)
proj_LC$totalCost<-as.numeric(proj_LC$totalCost)
proj_LC$ecMaxContribution<-sub(",", ".", proj_LC$ecMaxContribution)
proj_LC$ecMaxContribution<-as.numeric(proj_LC$ecMaxContribution)


proj_sfs$totalCost<-sub(",", ".", proj_sfs$totalCost)
proj_sfs$totalCost<-as.numeric(proj_sfs$totalCost)
proj_sfs$ecMaxContribution<-sub(",", ".", proj_sfs$ecMaxContribution)
proj_sfs$ecMaxContribution<-as.numeric(proj_sfs$ecMaxContribution)



# calculations to get some cost data on the low carbon projects
average_LC_cost <-mean(proj_LC$totalCost)
max_LC_cost <- max(proj_LC$totalCost)
min_LC_cost <- min(proj_LC$totalCost)

# calculations to get some cost data on the sustainable food projects
average_SFS_cost <-mean(proj_sfs$totalCost)
max_SFS_cost <- max(proj_sfs$totalCost)
min_SFS_cost <- min(proj_sfs$totalCost)





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

uk_fil_datfill <- year_filter('2016', uk_fil)



  










