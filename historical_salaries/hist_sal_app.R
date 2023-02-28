library(shiny)
library(dplyr)
library(ggplot2)

# UI
ui <- fluidPage(
  titlePanel("Average Salary by Year, USD"),
  sidebarPanel(
    checkboxGroupInput("experience", label = "Select experience level(s)",
                       choices = c("Junior", "Intermediate", "Expert", "Director"),
                       selected = c("Junior", "Intermediate", "Expert", "Director"))
  ),
  mainPanel(
    plotOutput("plot")
  )
)

# Server
server <- function(input, output) {
  
  data <- reactive({
    data <- read.csv("../data/merged_salaries.csv")  |> 
      dplyr::mutate(experience_level = case_when(
        experience_level == "EN" ~ "Junior",
        experience_level == "EX"  ~ "Expert",
        experience_level == "MI"  ~ "Intermediate",
        experience_level == "SE"  ~ "Director"
      ))
    
    data |>
      dplyr::group_by(work_year, experience_level) |>
      dplyr::summarize(avg_salary_usd = mean(salary_in_usd), .groups = 'drop')
  })
  
  output$plot <- renderPlot({
    filtered_data <- data() |>
      dplyr::filter(experience_level %in% input$experience)
    
    ggplot2::ggplot(filtered_data, aes(x = work_year, y = avg_salary_usd, color = experience_level, group = experience_level)) +
      ggplot2::geom_line(size = 1) +
      ggplot2::geom_point() +
      ggplot2::labs(x = "Work Year", y = "Salary USD", color = "Experience level") +
      ggplot2::scale_color_hue(labels = c("Junior", "Intermediate", "Expert", "Director"))
  })
  
}

shinyApp(ui = ui, server = server)
