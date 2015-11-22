suppressPackageStartupMessages(library(shiny))
suppressPackageStartupMessages(library(Rcpp))
suppressPackageStartupMessages(library(googleVis))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(BH))
suppressPackageStartupMessages(library(RCurl))
suppressPackageStartupMessages(library(gridExtra))
suppressPackageStartupMessages(library(stats))


shinyServer(
  
        function(input,output)
        {
          
          #output$tsX <- renderPrint({ input$tsXSelect})
          myYear <- reactive ({input$year})
          myTimeSeries <- reactive({input$tsXSelect})
          

          output$myyear <- renderText( { paste(myTimeSeries(), "for:",myYear())})

                          
            output$view <- renderGvis ({
                    
                    temp <-subset(world.db, (Indicator.Name == input$tsXSelect))
                            
                    options = list( height = 600,
                                  width = 800,
                                  legend = "{textStyle :{color:'maroon', fontSize:14}}",
                                  colorAxis = "{colors: ['yellow', 'orange', 'maroon']}",
                                  backgroundColor = "lightblue",
                                  datalessRegionColor = '#FFFFFF',
                                  defaultColor = '#FFFFFF',
                                  backgroundColor.strokeWidth = 10,
                                  colorAxis.minValue = min(temp$value),
                                  colorAxis.maxValue = max(temp$value)
                                  
                    )
                    
                    temp <-subset(world.db, ((Indicator.Name == input$tsXSelect) & (variable == myYear() ) ))
                    
                    gvisGeoChart(temp, options = options, locationvar = "Country.Name", colorvar = "value")
                                      
                                       })
          output$table <- renderDataTable ({
                  temp <- subset(world.db, ((Indicator.Name == input$tsXSelect) & (variable == myYear() ) ))
                  temp[,c("Country.Code","Country.Name","value")]}, options = list(orderClasses = TRUE)
          )
          output$histTitle <- renderText( { paste("Histogram for ",myTimeSeries(), ":",myYear())})
          output$main_plot <- renderPlot({
                  temp <- subset(world.db, ((Indicator.Name == input$tsXSelect) & (variable == myYear() ) ))
                  hist(temp$value,
                       probability = TRUE,
                       breaks = as.numeric(input$n_breaks),
                       xlab = "Number or Percent",
                       main = myTimeSeries())
                  
                  if (input$individual_obs) {
                          rug(temp$value)
                  }
                  
                  if (input$density) {
                          dens <- density(temp$value,na.rm = TRUE,
                                          adjust = input$bw_adjust)
                          lines(dens, col = "maroon")
                  }
                  
          })

  }

  
  
)