# DS-Salaries boxplot
#

library(shiny)
library(tidyverse)
library(ggplot2)
library(thematic)

# read in raw data as data
data <-read.csv("data/merged_salaries.csv")

# preliminary data cleaning and wrangling
# change employment type to the full name
boxplot_data <- data |> dplyr::mutate(
  employment_type = case_when(
  employment_type == "FT" ~ "Full-time",
  employment_type == "PT"  ~ "Part-time",
  employment_type == "FL"  ~ "Freelance",
  employment_type == "CT"  ~ "Contract"))
# change year into categorical variable
boxplot_data$work_year <- factor(boxplot_data$work_year)

# Define UI for application that draws a reactive boxplot
ui <- fluidPage(

    # Application title
    titlePanel("Data Science Salaries"),

    # dropdown menu with a single selection
    # default employment type is 'full-time'
    selectInput(inputId = 'employment_type',
                label = "employment type:", 
                choices = unique(boxplot_data$employment_type), 
                selected = 'Full-time'),

    # show the boxplot
    mainPanel(
        plotOutput("boxplot")
        )
)

# Define server logic required to draw a reactive boxplot
server <- function(input, output, session) {
  
  # filter data frame for employment type based on selection
  boxplot_react_data <- reactive({
    boxplot_data |>
      dplyr::filter(employment_type == input$employment_type)
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
                        input$employment_type, 'employment'),
                        x = 'Year',
                        y = 'Salary In USD') +
    ggplot2::theme_bw() +
    ggplot2::theme(legend.position = "none")  
        
  })

}

# Run the application
shinyApp(ui = ui, server = server)
