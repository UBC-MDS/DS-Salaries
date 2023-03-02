# DS-Salaries boxplot
#

library(shiny)
library(tidyverse)
library(ggplot2)
library(thematic)

# read in raw data as data
data <-read.csv("data/merged_salaries.csv")

# preliminary data cleaning and wrangling

# change remote_ratio and year into categorical variables
data$remote_ratio <- factor(data$remote_ratio)
data$work_year <- factor(data$work_year)


# Define UI for application that draws a reactive boxplot
ui <- fluidPage(

    # Application title
    titlePanel("Data Science Salaries"),

    # dropdown menu with a single selection
    # default employment type is 'full-time'
    selectInput(inputId = 'remote_ratio',
                label = "remote ratio:", 
                choices = unique(data$remote_ratio), 
                selected = '0'),

    # show the boxplot
    mainPanel(
        plotOutput("boxplot")
        )
)

# Define server logic required to draw a reactive boxplot
server <- function(input, output, session) {
  
  # filter data frame for employment type based on selection
  boxplot_react_data <- reactive({
    data |>
      dplyr::filter(remote_ratio == input$remote_ratio)
  })

  output$boxplot <- renderPlot({
    ggplot2::ggplot(boxplot_react_data(),
                    aes(x = work_year,
                        y = salary_in_usd,
                        color = work_year)) +
    ggplot2::geom_boxplot() +
    ggplot2::scale_y_continuous(
      labels = scales::label_dollar(scale = .001, 
                                    suffix = "K")) + 
    ggplot2::labs(
          title = paste('Salary by year for',
                        input$remote_ratio, 'remote ratio'),
                        x = 'Year',
                        y = 'Salary In USD') +
    ggplot2::theme_bw() +
    ggplot2::theme(legend.position = "none")  
        
  })

}

# Run the application
shinyApp(ui = ui, server = server)
