# DS-Salaries boxplot
#

library(shiny)
library(tidyverse)
library(ggplot2)
library(thematic)
library(plotly)

options(shiny.autoreload = TRUE)

# read in raw data as data
data <-read.csv("data/merged_salaries.csv")

# preliminary data cleaning and wrangling

# change remote_ratio and year into categorical variables
data$remote_ratio <- factor(data$remote_ratio)
data$work_year <- factor(data$work_year)


# Define UI for application that draws a reactive boxplot
ui <- fluidPage(
  
  theme = bslib::bs_theme(bootswatch="journal"),
  titlePanel(title="Data Science Salaries Dashboard"),
  h6(" "),
  
  # dropdown menu with a single selection
  # default employment type is 'full-time'
  
  selectInput(inputId = 'country',
              label = 'select the country',
              choices = unique(data$country),
              selected = 'Canada'),
  
  selectInput(inputId = 'remote_ratio',
              label = "remote ratio:", 
              choices = unique(data$remote_ratio), 
              selected = '0'),
  
  # show the boxplot
  mainPanel(
    column(width = 12, 
           column(width=10, align="center",
                  plotlyOutput(
                    outputId = "TopTenPlot",
                    width = "100%",
                    height = "220px",
                    inline = FALSE,
                    reportTheme = TRUE
                  ),
                  plotOutput(
                    outputId = "boxplot",
                    width = "100%",
                    height = "220px"
                  ))
  )
))

# Define server logic required to draw a reactive boxplot
server <- function(input, output, session) {

  TopJobs <- reactive({
    data |> dplyr::filter (
      country == input$country, job_title %in% (data |>  
                                                                       dplyr::filter( country == input$country)  |>
                                                                       dplyr::group_by(job_title) |> dplyr::summarise(med = median(salary_in_usd)) |>
                                                                       dplyr:: top_n(10,med) |> dplyr::pull(job_title)) )
  }) 
  
  output$TopTenPlot <- plotly::renderPlotly({ 
    
    thematic::thematic_shiny()
    
    plotly::ggplotly(
      TopJobs() |> 
        ggplot2::ggplot(ggplot2::aes(y= job_title, x = salary_in_usd , color = job_title)) +
        ggplot2 ::geom_pointrange(stat = 'summary', fun.min = min,
                                  fun.max = max,
                                  fun = median) + 
        ggplot2 :: theme(legend.position = "none") +
        ggplot2::labs(title = paste('Top 10 highest Paid jobs in ',input$country),
                      x = 'Salary In USD',
                      y = '') , tooltip = "text" 
    )  
    
    
  })  
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
        title = paste('Salary by year when remote ratio is',
                      input$remote_ratio),
        x = 'Year',
        y = 'Salary In USD') +
      ggplot2::theme_bw() +
      ggplot2::theme(legend.position = "none")  
    
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)
