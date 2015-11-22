library(shiny)

shinyUI(fluidPage(
        
        titlePanel( h2("World Bank Data Viewer", align = 'center', style ="color:blue")),
        h4("Kevin A. O'Laughlin for Data Products in Coursera's Data Science Series", align = "center", style = 'color:blue'),
        tags$p(" "),
        tags$p(" "),
        sidebarLayout (position = "left",
               sidebarPanel(h4("Select Time Series and Year:", align = 'lefts', width = 1.5),

                            selectInput("tsXSelect", label = h5("Select Time Series"), 
                                        choices = timeSeriesNames, 
                                        selected = 1),

                            sliderInput("year", label = h5("Select Year"), 
                                        value = min(years), 
                                        min = min(years), 
                                        max = max(years), 
                                        animate = TRUE,
                                        sep = "",
                                        dragRange = FALSE,
                                        step = 2),
                            
                            
                           # submitButton('Submit')
                           tags$p("  "),
                           tags$p(" "),
                           h5(textOutput("histTitle"), style = "color:maroon", align = "center"),
                           selectInput(inputId = "n_breaks",
                                       label = "Number of bins in histogram (approximate):",
                                       choices = c(10, 20, 35, 50),
                                       selected = 20),
                           
                           checkboxInput(inputId = "individual_obs",
                                         label = strong("Show individual observations"),
                                         value = FALSE),
                           
                           checkboxInput(inputId = "density",
                                         label = strong("Fit density curve"),
                                         value = FALSE),
                           
                           plotOutput(outputId = "main_plot", height = "300px"),
                           
                           # Display this only if the density is shown
                           conditionalPanel(condition = "input.density == true",
                                            sliderInput(inputId = "bw_adjust",
                                                        label = "Smoothing adjustment",
                                                        min = 0.2, max = 2, value = 1, step = 0.2)
                           )
               ),
                            
                           
               
               mainPanel(
                        h5("This tool allows you to map World Bank timeseries data from the HealthStats Dataset,
                          a comprehensive source of health, nutrition, and population data."),
                        p(" "),
                        p(" "),
                        h4(textOutput("myyear"), style = "color:maroon", align = "center"),
                        tabsetPanel(
                                tabPanel("Map", htmlOutput("view")), 
                                tabPanel("Table", dataTableOutput("table")),
                                tabPanel("Help", includeHTML("Documentation.html"))
                                ),
                         
                        p(" "),
                        p("Source: The World Bank HealthStats Database"),
                        p("The source data can be found here: http://data.worldbank.org/topic/health "))
  
 
  
 
)))
  