# DS-Salaries boxplot
#

library(shiny)
library(tidyverse)
library(ggplot2)
library(plotly)
library(thematic)


data <-read.csv("data/merged_salaries.csv")

boxplot_data <- data |> dplyr::mutate(
  employment_type = case_when(
  employment_type == "FT" ~ "Full-time",
  employment_type == "PT"  ~ "Part-time",
  employment_type == "FL"  ~ "Freelance",
  employment_type == "CT"  ~ "Contract"))
boxplot_data$work_year <- factor(boxplot_data$work_year)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Data Science Salaries"),

    # Sidebar with a slider input for number of bins
    selectInput(inputId = 'employment_type',
                label = "employment type:", 
                choices = unique(boxplot_data$employment_type), 
                selected = 'Part-time'),

        # Show a plot of the generated distribution
    mainPanel(
        plotOutput("boxplot")
        )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {

    output$boxplot <- renderPlot({

      ggplot2::ggplot(boxplot_data,
                      aes(x = work_year,
                          y = salary_in_usd,
                          color = work_year)) +
      ggplot2::geom_boxplot() +
      ggplot2::scale_y_continuous(
        labels = scales::label_dollar(scale = .001, 
                                      suffix = "K")) + 
      ggplot2::labs(
            title = paste('Salary by year for',
                          input$employment_type, 'employment'),
                          x = 'Year',
                          y = 'Salary In USD') +
      ggplot2::theme_bw()
        
    })

}

# Run the application
shinyApp(ui = ui, server = server)
