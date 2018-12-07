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
library(knitr)
library(markdown)
library(rmarkdown)


source("functions.R")

my_autocomplete_list <- c("John Doe","Ash","Ajay sharma","Ken Chong","Will Smith","Neo")

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  theme = shinytheme("cosmo"),
  navbarPage("Horizon 2020 Data",
             tabPanel("About",
                      titlePanel("Project Overview"),
                      h3("Data"),
                      p("Our project is an analysis of the European Unions Horizon 2020 programme. Horizon 2020 is a programme that funds research, 
                        technological development, and innovation. The data is compiled by", 
                        a("The EU Open Data Portal", href="https://data.europa.eu/euodp/data/dataset/cordisH2020projects?fbclid=IwAR0QM-YgHTwobcWksrDtLBj7kKwGD_WN2NrUincxO7DUKVdEvAqLnEQm6zo"),  
                        ". The portal contains a very wide variety of high-value open data across EU policy domains, as also more recently identified by the G8 Open Data Charter. 
                     These include the economy, employment, science, environment and education.
                   The number of data providers — which include Eurostat, the European Environment Agency and the Joint Research Centre — continues to grow.
                          The data itself 
                        is aggregated by the Community Research and Development Information Service."),
                      p("The data sets we are working with are the 
                        H2020 Organizations and  H2020 Projects data sets.
                        The Organizations dataset contains data on the organizations 
                        that are part of the H2020 programme and includes data 
                        such as role, name, and address. The Projects dataset contains 
                        data on the projects involved with the H2020 programme. 
                        The data in this set contains attributes such as project name, cost, 
                        objective, and participating countries. "),
                      h3("Purpose"),
                      p("Some questions this app can answer are:"),
                      tags$ul(
                        tags$li("Does the location of an organization has any effect on the funding of the project?"), 
                        tags$li("Which countaries are more concerned with  environment focused issues?"), 
                        tags$li("How does time influence the participation rate?")
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
                        tags$li(
                          p("The second tab, ", tags$b("Participation"),
                            "contains a barplot shows the number of projectes each country
                            participated in.")
                        )
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
                      sidebarLayout(
                        sidebarPanel( 
                          selectInput("topic", "Topic:",
                                       c("Low Carbon" = "LC",
                                         "Sustainable Food" = "SFS",
                                         "Information and Communication Technology" = "ICT",
                                         'Marie Skłodowska-Curie actions'="MSCA",
                                         "Fuel Cells and Hydrogen" = "FCH")
                            ),
                          selectizeInput("selectinput", label = NULL, choices = europeanUnion)
                          ),
                          mainPanel(     # specify content for the "main" column
                            leafletOutput("distPlot"),
                            plotOutput("fundingline")
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
                                        "Year 2019" = "year2019"), selected = "Year 2014"),
                          selectizeInput("selectinput2", label = NULL, choices = europeanUnion)
                          ),
                          mainPanel(     # specify content for the "main" column
                            plotOutput("plot1"),
                            textOutput("selected_var"),
                            plotOutput("projline")
                          )
                        )
                      ),
             tabPanel("Analysis",
                      titlePanel("Analysis"),
                      h2("Quick facts"),
                      tags$ul(
                        tags$li("The United States does participate minimally in Horizon2020, however they only participate in Sustainable food projects "), 
                        tags$li("The Marie Skłodowska-Curie actions make up the most occuring projects with 6169 of them"), 
                        tags$li("The countries that coordinate the most projects are the United Kingdom(3529), Spain(2276), and Germany(2105) ")
                      ),
                      h3("More in depth Findings"), 

                      p("We found several key details in analyzing this dataset. 
                        The key finding is that the most expansive project was the ",  strong(as.character (max_proj_tle)),
                        ". The main object of this undertaking is ",as.character (max_proj_obj), "The total cost of the project is",
                        paste(max_proj_tocos,"€",sep = "") ,  "and the EU is funding", 
                        paste(max_proj_perEU,"%",sep = ""), "of the projects total cost" ),
                 
                      p("Another finding is that the lowest cost project is. 
                        The key finding is that the lowest expansive project was the ",  strong(as.character (min_proj_tle)),
                        ". The main object of this undertaking is ",as.character (min_proj_obj), "The total cost of the project is",
                        paste(min_proj_tocos,"€",sep = "") ,  "and the EU is funding", 
                        paste(min_proj_perEU,"%",sep = ""), "of the projects total cost" ),
                      
                      h3("Topic findings"),
                      h4("The Sustainable Food Security projects aim to create research and innovation in relation to Food and Nutrition Security in Europe and beyond."),
                      p("Out of the sustainable food projects the highest cost one is the ",  strong(sfs_max_aly[1]),
                        "The coordinating country is France. ",sfs_max_aly[2], "The total cost of the project is",
                        paste(sfs_max_aly[3],"€",sep = "") ,  "and the EU is funding", 
                        paste(sfs_max_aly[4],"%",sep = ""), "of the projects total cost" ),
                      
                      p("Also out of the sustainable food projects the lowest cost one is the ",  strong(sfs_min_aly[1]),
                        ". The coordinating country is Denmark. ",sfs_min_aly[2], "The total cost of the project is",
                        paste(sfs_min_aly[3],"€",sep = "") ,  "and the EU is funding", 
                        paste(sfs_min_aly[4],"%",sep = ""), "of the projects total cost" ),
                      
                      h4("The Low carbon projects aim to create  secure, clean and efficient energy; and focus on Building a low-carbon, climate resilient future."),
                      p("Out of the low carbon projects the highest cost one is the ",  strong(lc_max_aly[1]),
                        ". The coordinating country is the United Kingdom ",lc_max_aly[2], "The total cost of the project is",
                        paste(lc_max_aly[3],"€",sep = "") ,  "and the EU is funding", 
                        paste(lc_max_aly[4],"%",sep = ""), "of the projects total cost" ),
                    
                        p("Also out of of the low carbon projects the lowest cost one is the ",  strong(lc_min_aly[1]),
                        ". The coordinating country is the United Kingdom ",lc_min_aly[2], "The total cost of the project is",
                        paste(lc_min_aly[3],"€",sep = "") ,  "and the EU is funding", 
                        paste(lc_min_aly[4],"%",sep = ""), "of the projects total cost" )
                      
                      
                 
                   
                      )
             )
))
