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

#install.packages('shinythemes')
library(shinythemes)
source("ui.R")


projects <- data.table::fread("data/projects.csv")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    
   
    
  })
  ## creates the data switch that happens when selecting a year
  datasetInputYear <- reactive({
    switch(input$selYear,
           "Year 2014" = part_year_2014,
           "Year 2015" = part_year_2015,
           "Year 2016" = part_year_2016,
           "Year 2017" = part_year_2017,
           "Year 2018" = part_year_2018,
           "Year 2019" = part_year_2019
           )
  })
  ## creates the plot shows number of projects a country is participating in 
  output$plot1 <- renderPlot({
    
    dataset <- datasetInputYear()
    ggplot(dataset, aes(x = dataset$eu_states, y = dataset$num_vec)) +
      geom_bar(fill = 'darkturquoise', stat = "identity") +
      geom_text(aes(label = dataset$num_vec), 
                vjust = -0.3) + ylab("Number of Projects a country is participating in") +xlab("Name of EU country")
    
  })
  
  output$selected_var <- renderText({
    dataset <- datasetInputYear()
    paste("This is a plot of the Number of Projects a country is participating in the", input$selYear)
    
  })
  
  
  
  
  
  
})
