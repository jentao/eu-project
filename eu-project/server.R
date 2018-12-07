#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(grid)
library(rworldmap)
library(maps)
library(mapproj)
library(plotly)
library(htmlwidgets)
library(widgetframe)
library(leaflet)
library(tidyr)
library(knitr)
library(markdown)
library(rmarkdown)


source("functions.R")

projects <- data.table::fread("data/projects.csv")

## code reference http://egallic.fr/european-map-using-r/
# Get the world map
worldMap <- getMap()

# Select data of EU
europe <- subset(worldMap, NAME %in% europeanUnion)

europeanUnionTable <- data.frame(NAME = europeanUnion, code = eu_code)

yearH <- c("2014", "2015", "2016", "2017", "2018", "2019")

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
      "<strong>%s</strong><br/>Average: %e €<br/>Max: %e €<br/>Min: %e €",
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
  
  # create line plot of average funding per year
  output$fundingline <- renderPlot({
    country <- europeanUnionTable %>% 
      filter(NAME == input$selectinput)
    tag_data <- proj_by_tag(input$topic)
    country_data <- country_filter(country$code, tag_data)
    
    ave <- sapply(yearH, yearave, country_data)
    df <- data.frame(yearH, ave, stringsAsFactors = FALSE)
    
    ggplot(data=df, aes(x=yearH, y=ave, group=1)) +
      geom_line() +
      geom_point() + 
      ylab(paste("Average funding of", input$selectinput)) + 
      xlab("Year")
  })
  
  ## creates the plot shows number of projects a country is participating in 
  output$plot1 <- renderPlot({
    yr <- rlang::sym(input$selYear)
    ggplot(EUtb, 
           aes(x = NAME, y = !!yr)) +
      geom_bar(fill = 'darkturquoise', stat = "identity") +
      geom_text(data=EUtb,aes(label = !!yr), 
                vjust = +0.3) + 
      ylab("Number of projects a country is participating in") + 
      xlab("Name of EU country") +
      coord_flip()
    
  })
  
  # create line plot of average projects per year
  output$projline <- renderPlot({
    dfrow <- EUtb %>% 
      filter(NAME == input$selectinput2)
    peoj_num <- as.numeric(dfrow[1,3:8])
    
    df <- data.frame(yearH, peoj_num, stringsAsFactors = FALSE)
    ggplot(data=df, aes(x=yearH, y=peoj_num, group=1)) +
      geom_line() +
      geom_point() + 
      ylab(paste("Number of projects ", input$selectinput, " participates in")) + 
      xlab("Year")
  })
  
  output$selected_var <- renderText({
    dataset <- input$selYear
    paste("This is a plot of the number of projects a country is participating in the", 
          substr(input$selYear, 5, 8))
    
  })
  
  output$selected_anly <- renderText({ 
      paste("<p><i>", max_proj_tle, "</i></p>")
  })
})

dfrow <- EUtb %>% 
  filter(NAME == "Austria")
peoj_num <- as.numeric(dfrow[1,3:8])
