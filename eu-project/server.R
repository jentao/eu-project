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
source("functions.R")


projects <- data.table::fread("data/projects.csv")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    
   
    
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
