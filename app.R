# DS-Salaries 
#

library(shiny)
library(tidyverse)
library(ggplot2)
library(thematic)
library(plotly)
library(dplyr)

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
  titlePanel("Average Salary by Year, USD"),
  sidebarPanel(
    checkboxGroupInput("experience", label = "Select experience level(s)",
                       choices = c("Junior", "Intermediate", "Expert", "Director"),
                       selected = c("Junior", "Intermediate", "Expert", "Director"))
  ),
  
  # show the boxplot
  mainPanel(
    column(width = 12, 
           column(width=10, 
                  align="center",
                  plotlyOutput(
                    outputId = "TopTenPlot",
                    width = "100%",
                    height = "330px",
                    inline = FALSE,
                    reportTheme = TRUE
                  ),
                  plotOutput(
                    outputId = "boxplot",
                    width = "100%",
                    height = "220px"
                  ))
  ),
  plotOutput("plot")
  
))

# Define server logic required to draw a reactive boxplot
server <- function(input, output, session) {

  TopJobs <- reactive({
    data |> dplyr::filter (
      country == input$country, job_title %in% (data |>
                                                  dplyr::filter( country == input$country)  |>
                                                  dplyr::group_by(job_title) |> 
                                                  dplyr::summarise(med = median(salary_in_usd)) |>
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
  
  data_hist <- reactive({
    data_hist <- read.csv("data/merged_salaries.csv")  |> 
      dplyr::mutate(experience_level = case_when(
        experience_level == "EN" ~ "Junior",
        experience_level == "EX"  ~ "Expert",
        experience_level == "MI"  ~ "Intermediate",
        experience_level == "SE"  ~ "Director"
      ))
    
    data_hist |>
      dplyr::group_by(work_year, experience_level) |>
      dplyr::summarize(avg_salary_usd = mean(salary_in_usd), .groups = 'drop')
  })
  
  output$plot <- renderPlot({
    filtered_data <- data_hist() |>
      dplyr::filter(experience_level %in% input$experience)
    
    ggplot2::ggplot(filtered_data, aes(x = work_year, 
                                       y = avg_salary_usd, 
                                       color = experience_level, 
                                       group = experience_level)) +
      ggplot2::geom_line(size = 1) +
      ggplot2::geom_point() +
      ggplot2::labs(x = "Work Year", y = "Salary USD", color = "Experience level") +
      ggplot2::scale_color_hue(labels = c("Junior", "Intermediate", "Expert", "Director"))
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)
