library(shiny)
library(plotly)
library(ggplot2)

data <- read.csv("data/merged_salaries.csv")


options(shiny.autoreload = TRUE)
ui <- fluidPage(
  # Show the plot of top ten salaries 
  ## input select items 
  selectInput(inputId = 'country',
              label = 'select the country',
              choices = unique(data$country),
              selected = 'Canada'),
  ## output to display the plot 
  mainPanel(
    plotlyOutput(outputId = "TopTenPlot")
  )
)

server <- function(input, output, session) {
  
  TopJobs <- reactive({
    data |> dplyr::filter (country == input$country, job_title %in% (data |>  
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
  
  
  
}

shinyApp(ui, server)