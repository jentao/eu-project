#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(R.utils)
library(ggplot2)
library(grid)
library(rworldmap)
library(dplyr)
library(maps)
library(mapproj)
library(plotly)
library(htmlwidgets)
library(widgetframe)
library(leaflet)
library(tidyr)

source("functions.R")

projects <- data.table::fread("data/projects.csv")
reports <- data.table::fread("data/reports.csv")
organizations <- data.table::fread("data/organizations.csv")

## code reference http://egallic.fr/european-map-using-r/
# Get the world map
worldMap <- getMap()

# Member States of the European Union
europeanUnion <- c("Austria","Belgium","Bulgaria","Croatia","Cyprus",
                   "Czech Rep.","Denmark","Estonia","Finland","France",
                   "Germany","Greece","Hungary","Ireland","Italy","Latvia",
                   "Lithuania","Luxembourg","Malta","Netherlands","Poland",
                   "Portugal","Romania","Slovakia","Slovenia","Spain",
                   "Sweden","United Kingdom")

# Select data of EU
europe <- subset(worldMap, NAME %in% europeanUnion)

# country code
eu_code <- c("AT", "BE", "BG", "HR", "CY",
             "CZ", "DK", "EE", "FI", "FR",
             "DE", "EL", "HU", "IE", "IT", "LV",
             "LT", "LU", "MT", "NL", "PL",
             "PT", "RO", "SK", "SI", "ES",
             "SE", "UK")

europeanUnionTable <- data.frame(NAME = europeanUnion, code = eu_code)


shinyServer(function(input, output) {
  
  output$distPlot <- renderLeaflet({
    # Filter data related to the inupt topic
    tag_data <- proj_by_tag(input$topic)
  
    # Get a matrix of data (average, min, max)
    summary <- sapply(europeanUnionTable$code, 
                    function(x) cost_summary(
                      country_filter(x, tag_data)
                      ))
    # Turn matrix into data frame
    m1 <- t(summary)
    d2 <- data.frame(m1, row.names=NULL)
    
    # Add average, min, max data for each member 
    europeanUnionTable$average <- d2$average
    europeanUnionTable$max <- d2$max
    europeanUnionTable$min <- d2$min
    
    # Join dataframe and SpatialPolygonDataFrame 
    valued <- sp::merge(europe,europeanUnionTable,by="NAME", all=F)
    
    # Create labels when hover over mouse
    labels <- sprintf(
      "<strong>%s</strong><br/>Average: %e<br/>Max: %e<br/>Min: %e",
      valued@data$NAME, valued@data$average,
      valued@data$max, valued@data$min
    ) %>% lapply(htmltools::HTML)
    
    # Create color palette
    pal <- colorNumeric(
      palette = "Blues",
      domain = valued@data$average)
    
    # Graph map
    m <- leaflet(data = valued) %>% 
      addProviderTiles(providers$Esri.WorldGrayCanvas) %>%
      addPolygons(weight = 2,
                  opacity = 1,
                  color = "white",
                  dashArray = "3",
                  fillOpacity = 0.6, 
                  fillColor = ~pal(average),
                  highlight = highlightOptions(
                    weight = 5,
                    color = "#666",
                    fillOpacity = 0.9,
                    bringToFront = TRUE),
                  label = labels,
                  labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "15px",
                    direction = "auto")) 
    
    # Add legend
    m %>% 
      addLegend(pal = pal, values = ~average, opacity = 0.7, title = "Average Funding",
                position = "bottomright")
  })
  
  ## creates the plot shows number of projects a country is participating in 
  output$plot1 <- renderPlot({
    yr <- rlang::sym(input$selYear)
    ggplot(EUtb, 
           aes(x = NAME, y = !!yr)) +
      geom_bar(fill = 'darkturquoise', stat = "identity") +
      geom_text(aes(label = EUtb$NAME), 
                vjust = +0.3) + 
      ylab("Number of Projects a country is participating in") + 
      xlab("Name of EU country") +
      coord_flip()
    
  })
  
  output$selected_var <- renderText({
    dataset <- input$selYear
    paste("This is a plot of the Number of Projects a country is participating in the", 
          substr(input$selYear, 5, 8))
    
  })
  
  
  
  
  
  
})
