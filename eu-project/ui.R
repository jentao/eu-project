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
library(leaflet)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  theme = shinytheme("cosmo"),
  navbarPage("Horizon 2020 Data",
             tabPanel("About",
                      titlePanel("Project Overview"),
                      h3("Data"),
                      p("Our project is an analysis of the EU research 
                        projects under Horizon 2020. The data is compiled by", 
                        a("The EU Open Data Portal", href="https://data.europa.eu/euodp/data/dataset/cordisH2020projects?fbclid=IwAR0QM-YgHTwobcWksrDtLBj7kKwGD_WN2NrUincxO7DUKVdEvAqLnEQm6zo"),  
                        ", which is a project set up by the European Union to add more 
                        transparency to their actions. The data itself 
                        is aggregated by the Community Research and Development Information Service."),
                      p("The data sets we are working with are the 
                        H2020 Organizations and  H2020 Projects data sets.
                        The Organizations dataset contains data on the organizations 
                        that are part of the H2020 mission and includes data 
                        such as role, name, and address. The Projects dataset contains 
                        data on the projects involved with the H2020 mission. 
                        The data in this set contains attributes such as project name, cost, 
                        objective, and participating countries. "),
                      h3("Purpose"),
                      tags$ul(
                        tags$li("First list item"), 
                        tags$li("Second list item"), 
                        tags$li("Third list item")
                      ),
                      h3("Structure"),
                      tags$ul(
                        tags$li(
                          p("The first tab, ", tags$b("Funding by Topic"),
                            "contains a map shows funding information by country.
                            The two topics we are analyszing are ",
                            tags$i("low carbon"), " and ", tags$i("sustainable food."),
                            "By looking at this map, we can tell which countries 
                            are more concerned with environment focused projects.")
                        ), 
                        tags$li("Third list item")
                      ),
                      h3("Team"),
                      tags$ul(
                        tags$li("Liam  Albright"), 
                        tags$li("Jennifer Tao"), 
                        tags$li("Christine Zhang")
                      )
             ),
             tabPanel("Funding by Topic",
                      titlePanel("Topic Funding by Country"),
                      p("This map shows project funding data by country.
                        The project topic can be selected with the drop down menu.
                        Hovering over a country will display average, max, and min funding
                        in euro."),
                      selectInput("topic", "Topic:",
                                  c("Low Carbon" = "LC",
                                    "Sustainable Food" = "SFS")
                                  ),
                      
                      leafletOutput("distPlot")
             ),
             tabPanel("Energy projects"
                      
             )
  )
))
