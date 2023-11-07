#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(gganimate)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Pour Point as a Total Flux"),

    # Sidebar with a slider input for number of bins 
    fluidRow(
        column(width = 4, wellPanel(
            sliderInput("ppd",
                        "Pour Point Density per m^2",
                        min = 0.03,
                        max = 2.67,
                        value = 1.0),
            sliderInput("rfc",
                      "Depth times Rainfall:",
                      min = 1.5,
                      max = 15,
                      value = 4.0),
            radioButtons("rga",
                         "Rain Gauge Brand:",
                         choices = list("Davis - 0.02 m^2" = 0.02,
                                        "Texas Instruments - 0.03 m^2" = 0.03)),
            sliderInput("tfc",
                         "Percentage of Rainfall as Throughfall:", min = 5, max = 95, value = 80),
            

        )),
        column(width = 4,
           plotOutput("ppflx")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$ppflx <- renderPlot({
        # generate bins based on input$bins from ui.R
        ppfl <- input$ppd*input$rfc*as.numeric(input$rga)*100
        top <- data.frame(x = c("Pour Point", "Background Throughall"),y= c(ppfl,input$tfc))
        ggplot(top, aes(x,y)) + geom_bar(stat = "identity") + geom_text(aes(label=y), vjust=0) + 
          theme_classic() + ylab("% of Rainfall") + xlab(element_blank())
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
