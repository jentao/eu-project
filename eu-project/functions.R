#This is where we are going to put functions to manipulate data
library(R.utils)
library(data.table)
library(dplyr)

data_projects <- data.table::fread("data/projects.csv")

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
#proj_LC <- proj_by_tag("LC")
#proj_sfs <- proj_by_tag("SFS")

## this is a function where you put in a country code as a string from 
## this list https://ec.europa.eu/eurostat/statistics-explained/index.php/Tutorial:Country_codes_and_protocol_order 
## and it will filter to a data fram that only contains projects that that chosen country particpates in
country_filter <- function(cnt, data){
   fil_cnt_data <- data %>% 
     filter(like(participantCountries, cnt) ) %>%
     select(rcn, id, acronym, status, programme, topics, frameworkProgramme, title, startDate, 
            endDate, projectUrl, objective, totalCost,
            ecMaxContribution, call, fundingScheme,
            coordinator, coordinatorCountry, participants,
            participantCountries, subjects) 
}

## test i wrote to make sure my filter funciton worked
#uk_fil<-country_filter('UK', proj_LC)

## calculations to get some cost data
## return a list of avg, max, and min
cost_summary <- function(data){
  average_cost <-mean(data$totalCost)
  max_cost <- max(data$totalCost)
  min_cost <- min(data$totalCost)
  l <- c(average = average_cost, max = max_cost, min = min_cost)
  l
}

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

europeanUnion <- c("Austria","Belgium","Bulgaria","Croatia","Cyprus",
                   "Czech Rep.","Denmark","Estonia","Finland","France",
                   "Germany","Greece","Hungary","Ireland","Italy","Latvia",
                   "Lithuania","Luxembourg","Malta","Netherlands","Poland",
                   "Portugal","Romania","Slovakia","Slovenia","Spain",
                   "Sweden","United Kingdom")

# country code
eu_code <- c("AT", "BE", "BG", "HR", "CY",
             "CZ", "DK", "EE", "FI", "FR",
             "DE", "EL", "HU", "IE", "IT", "LV",
             "LT", "LU", "MT", "NL", "PL",
             "PT", "RO", "SK", "SI", "ES",
             "SE", "UK")

EUtb <- data.frame(NAME = europeanUnion, code = eu_code)

test <- function(yr){
  summary <- sapply(EUtb$code, 
                    function(x) nrow(year_filter(yr, country_filter(x, data_projects)))
                    )
  EUtb$colname <- summary
  colnames(EUtb)[ncol(EUtb)] <- paste0("year", yr)
  EUtb
}

t <- sapply(c("2014", "2015", "2016", "2017", "2018", "2019"),
            test)

for(i in c("2014", "2015", "2016", "2017", "2018", "2019")){
  EUtb <- test(i)
}



  










