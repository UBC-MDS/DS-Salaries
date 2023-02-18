# DS-Salaries project initial format set up
#

library(shiny)
library(tidyverse)
library(ggplot2)

data <-read.csv("data/salaries.csv")
  
# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Data Science Salaries"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- data$salary_in_usd
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'gold', border = 'white',
             xlab = 'Salary',
             main = 'Histogram of salary')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
