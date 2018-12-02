#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  theme = shinytheme("cosmo"),
  navbarPage("Navbar!",
             tabPanel("About"
                      
             ),
             tabPanel("Funding",
                      sidebarLayout(
                        sidebarPanel(
                          
                        ),
                        mainPanel(
                          
                        )
                      )
             ),
             tabPanel("Energy projects"
                      
             )
  )
))
