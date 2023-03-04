# DS-Salaries Shiny Dashboard

# load library

library(shiny)
library(tidyverse)
library(ggplot2)
library(thematic)
library(plotly)
library(dplyr)
library(leaflet)
library(thematic)
library(bslib)
library(tidyverse)
library(rnaturalearth)
library(sf)

# set options
options(shiny.autoreload = TRUE)

# read in raw data as data
data <-read.csv("data/merged_salaries.csv")

# preliminary data cleaning and wrangling

# change remote_ratio and year into categorical variables

data$remote_ratio <- factor(data$remote_ratio)
data$work_year <- factor(data$work_year)
# rename employment type
data <- data |> 
  dplyr::mutate(
    employment_type = case_when(
      employment_type == "FT" ~ "Full-time",
      employment_type == "PT"  ~ "Part-time",
      employment_type == "FL"  ~ "Freelance",
      employment_type == "CT"  ~ "Contract"))


# Define UI for applications

ui <- navbarPage(
  # use the theme from the map
  theme = bslib::bs_theme(bootswatch = "flatly"),
  
  titlePanel(title="Data Science Salaries Dashboard"),
  tabPanel('Salary map',
    fluidRow(
      radioButtons(
        inputId = "comp_size",
        label = "Select the Company Size",
        # choices = unique(data$company_size),
        selected = "L",
        choiceNames = c("Small < 50 Employees", "Large > 250 Employees", 
                      "Medium 50-250 Employees"),
        choiceValues = unique(data$company_size),
        inline = TRUE
      ),
      fluidRow(column(
      12,
      leaflet::leafletOutput(outputId = 'map'))
      
    )
    
  )),
  tabPanel('Top 10 highest paid jobs',

    selectInput(inputId = 'country',
              label = 'Select the country',
              choices = unique(data$country),
              selected = 'Canada'),
    
    # show the plots
    mainPanel(
             fluidRow(plotlyOutput(outputId = "TopTenPlot",
                                   height = "600px",
                                   width = "600px",
                                   inline = FALSE,
                                   reportTheme = TRUE)
      ))),
  
  tabPanel('Salary by employment type',
           selectInput(inputId = 'remote_ratio',
              label="The overall amount of work done remotely:", 
              choices = unique(data$remote_ratio), 
              selected = '50'),
           
    # show the plots
    mainPanel(
                  fluidRow(plotOutput(outputId = "boxplot",
                                      width = "600px"))
                    
             )),
  
  tabPanel('Salary by year',
    sidebarPanel(
      column(width = 10,
      checkboxGroupInput("experience", 
                         label = "Select experience level(s)",
                       choices = c("Junior", 
                                   "Intermediate", 
                                   "Expert", 
                                   "Director"),
                       selected = c("Junior", 
                                    "Intermediate", 
                                    "Expert", 
                                    "Director"))
   )
   ),
  
  # show the plots
  mainPanel(
            fluidRow(plotOutput(outputId = "plot",
                                width = "600px"))
    
  ))
)  

# Define server logic required to draw a reactive boxplot
server <- function(input, output, session) {
  
  #-------MAP---------------------
  # filter map data based on selected input
  filtered_data_map <-reactive({
    data |>
      dplyr::filter(company_size == input$comp_size) |>
      dplyr::group_by(country, latitude, longitude) |>
      dplyr::summarise(
        number_of_jobs = dplyr::n(),
        median_salary = round(median(salary_in_usd), 0),
        unique_jobs = dplyr::n_distinct(job_title)
      )
    
  })
  
 # MAP output 
  output$map <- leaflet::renderLeaflet({
    
    # obtain sf file for map polygons
    country_data <-
      ne_countries(scale = "medium", returnclass = "sf")
    
    # merge filtered df and country info (need to preserve order)
    comp_size_country <-
      merge(
        x = country_data ,
        y = filtered_data_map(),
        by.x = "admin",
        by.y = "country",
        all.x = TRUE
      )
    
    # custom labels for map
    my_labels <- paste(
      "Country: ",
      comp_size_country$admin,
      "<br/>",
      "Median Salary (USD): $ ",
      comp_size_country$median_salary,
      "<br/>",
      "Number of Jobs: ",
      comp_size_country$number_of_jobs,
      "<br/>",
      "Number of Unique Job Titles ",
      comp_size_country$unique_jobs,
      sep = ""
    ) |>
      lapply(htmltools::HTML)
    
    # color pal for map based on median salary of selected company sizes
    pal <- colorNumeric(palette = "YlGnBu",
                        domain = comp_size_country$median_salary)
    
    # create leaflet map
    leaflet::leaflet() |>
      leaflet::addProviderTiles(providers$CartoDB.Positron) |>
      addPolygons(
        data = comp_size_country,
        color = ~ pal(median_salary),
        weight = 1,
        opacity = 1,
        fillOpacity = 0.5,
        label = my_labels,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "13px",
          direction = "auto"
        )
      ) |>
      addLegend(
        pal = pal,
        values = comp_size_country$median_salary,
        opacity = 0.7,
        title = "Median Salary (USD)",
        position = "bottomright"
      )
    
  })

  # ----------------Top Jobs------------------------------
  # top jobs data
  TopJobs <- reactive({
    data |> dplyr::filter (
      country == input$country, 
      job_title %in% (data |>
                        dplyr::filter( country == input$country)  |>
                        dplyr::group_by(job_title) |> 
                        dplyr::summarise(med = median(salary_in_usd)) |>
                        dplyr:: top_n(10,med) |> dplyr::pull(job_title)) )
  }) 
  # top jobs plot
  output$TopTenPlot <- plotly::renderPlotly({ 
    
    thematic::thematic_shiny()
    
    plotly::ggplotly(
      TopJobs() |> 
        ggplot2::ggplot(ggplot2::aes(y= job_title, 
                                     x = salary_in_usd, 
                                     color = job_title)) +
        ggplot2 ::geom_pointrange(stat = 'summary', fun.min = min,
                                  fun.max = max,
                                  fun = median) + 
        ggplot2 :: theme(legend.position = "none") +
        ggplot2::labs(title = paste('Top 10 highest Paid jobs in ',
                                    input$country),
                      x = 'Salary In USD',
                      y = '') , tooltip = "text" 
    )  
    
    
  })
  
  # -------------boxplot-------------------
  # filter data frame for employment type based on selection
  boxplot_react_data <- reactive({
    data |>
      dplyr::filter(remote_ratio == input$remote_ratio)
  })
  # boxplot
  output$boxplot <- renderPlot({
    ggplot2::ggplot(boxplot_react_data(),
                    aes(x = reorder(employment_type, 
                                    salary_in_usd),
                        y = salary_in_usd,
                        color = employment_type)) +
      ggplot2::geom_boxplot() +
      ggplot2::scale_y_continuous(
        labels = scales::label_dollar(scale = .001, 
                                      suffix = "K")) + 
      ggplot2::labs(
        title = paste('Salary by employment type when remote ratio is',
                      input$remote_ratio),
        x = 'Employment type',
        y = 'Salary In USD') +
      ggplot2::theme_bw() +
      ggplot2::theme(legend.position = "none")  
    
  })
  
  # ----------hist line plot------------
  # data_hist
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
  
  # plot hist
  output$plot <- renderPlot({
    filtered_data <- data_hist() |>
      dplyr::filter(experience_level %in% input$experience)
    
    ggplot2::ggplot(filtered_data, aes(x = work_year, 
                                       y = avg_salary_usd, 
                                       color = experience_level, 
                                       group = experience_level)) +
      ggplot2::geom_line(size = 1) +
      ggplot2::geom_point() +
      ggplot2::labs(x = "Work Year", 
                    y = "Salary USD", 
                    color = "Experience level") +
      ggplot2::scale_color_hue(
        labels = c("Junior", "Intermediate", "Expert", "Director"))
  })
  
  
}

# Run the application
shinyApp(ui = ui, server = server)
