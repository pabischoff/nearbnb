library(shiny)
library(RCurl)
library(stringr)
library(rsconnect)

shinyServer(function(input, output) {
      
      
      
      coords.lines <- reactive({
            
            #coords.lines <- as.character(input$pacinput)

            airbnb.url <- as.character(input$pacinput)
            airbnb.source <- getURLContent(airbnb.url)
            airbnb.lines <- strsplit(airbnb.source, ";")
            airbnb.df <- do.call(cbind.data.frame, airbnb.lines)
            airbnb.df[] <- lapply(airbnb.df, as.character)
            
            ###the '+1' points to correct coordinates
            rawcoords <- airbnb.df[grep("offset_",airbnb.df[,1])+1,] 
            coords.lines <- str_extract(rawcoords, "-*[0-9]+\\.[0-9]+")
      })
      
      latitude <- reactive ({
            coords.lines <- coords.lines()[1]
            #coords.lines <- paste("{lat:",cleancoords[1],",lng:",cleancoords[2],"}",sep="")
      })
      
      longitude <- reactive ({
            coords.lines <- coords.lines()[2]
      })
      #test url: "https://www.airbnb.com/rooms/13266284?checkin=11%2F18%2F2016&checkout=11%2F21%2F2016&guests=1"

      output$markerLat <- renderText({latitude()})
      output$markerLng <- renderText({longitude()})
      
      
})