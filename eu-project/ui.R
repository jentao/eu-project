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

library(dplyr)
library(ggplot2)
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
             tabPanel("Participation",
                      sidebarLayout(
                        sidebarPanel(
                          selectInput("selYear", "Select Year", 
                                      c("Year 2014" = "year2014", 
                                        "Year 2015" = "year2015",
                                         "Year 2016" = "year2016",
                                         "Year 2017" = "year2017",
                                         "Year 2018" = "year2018",
                                         "Year 2019" = "year2019"), selected = "Year 2014")
                                      ),
                          mainPanel(
                            plotOutput("plot1"),
                            textOutput("selected_var")
                          )
                      )
                      
             )
  )
))
