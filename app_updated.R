# DS-Salaries Shiny App

# load library

library(shiny)
library(tidyverse)
library(ggplot2)
library(thematic)
library(plotly)
library(dplyr)
library(leaflet)
library(bslib)
library(rnaturalearthdata) 
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
  id = "navbar",
  # use the theme from the map
  theme = bslib::bs_theme(bootswatch = "flatly"),
  
  
  titlePanel(title="Data Science Salaries Dashboard"),
  tabPanel('Salary map',
           fluidRow(
             tags$style(HTML(".radio-inline {margin-right: 50px;}")),
             radioButtons(
               inputId = "comp_size",
               label = "Select the Company Size",
               selected = "L",
               choiceNames = c("Small < 50 Employees", "Large > 250 Employees",
                               "Medium 50-250 Employees"),
               choiceValues = unique(data$company_size),
               inline = TRUE
             ),
             fluidRow(column(
               12,
               leaflet::leafletOutput(outputId = 'map', height = "600px"))
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
  
  tabPanel('Average salary by employment type and by year',
           fluidRow(
             splitLayout(
               cellWidths = 800,
               #c("40%", "20%"),
               sidebarPanel(
                 column(
                   width = 12,
                   checkboxGroupInput("exp_levels", "Select experience levels:", 
                                      choices = c("Entry-level / Junior" = "EN", 
                                                  "Mid-level / Intermediate" = "MI", 
                                                  "Senior-level / Expert" = "SE", 
                                                  "Executive-level / Director" = "EX"),
                                      selected = c("EN", "MI", "SE", "EX")))),
               
               selectInput(inputId = 'remote_ratio',
                           label="The overall amount of work done remotely:", 
                           choices = unique(data$remote_ratio), 
                           selected = '100'),
               h6(" ")
             ),
             
             # show the plots
             mainPanel(
               fluidRow(
                 splitLayout(cellWidths = c("50%", "50%"),
                             plotOutput(outputId = "salary_plot",
                                        width = "600px"),
                             plotOutput(outputId = "boxplot",
                                        width = "500px"),
                 )
               ))))
  
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
        tooltip_salary = format(round(median(salary_in_usd), 0), big.mark = ',', scientific = FALSE),
        unique_jobs = dplyr::n_distinct(job_title)
      )
    
  })
  
  output$map <- renderLeaflet({
    
    
    # create static map object
    leaflet::leaflet() |>
      leaflet::addProviderTiles(providers$CartoDB.Positron) |>
      leaflet::setView(lng=1,
                       lat=1,
                       zoom=2)
    
  })
  
  # incremental map change in observer
  observe({
    
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
      "Median Salary (USD):$",
      comp_size_country$tooltip_salary,
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
    leaflet::leafletProxy("map") |>
      clearShapes() |>
      leaflet::addProviderTiles(providers$CartoDB.Positron) |>
      leaflet::addPolygons(
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
      leaflet::clearControls() |>
      leaflet::addLegend(
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
      #ggplot2::theme_bw() +
      ggplot2::theme(legend.position = "none",
                     plot.title = element_text(size = 15, face = "bold"),
                     axis.text.x = element_text(size = 12, angle = 0),
                     axis.text.y = element_text(size = 12, angle = 0),
                     axis.title = element_text(size = 15))  
    
  })
  
  # ----------Create a plot of average salary per year by experience level------------
  # Filter the data based on the user's selection
  data_salaries <- read.csv("data/merged_salaries.csv")
  filtered_data_salaries <- reactive({
    if (length(input$exp_levels) == 0){
      data_salaries
    } else{
      data_salaries  |> 
        dplyr::filter(experience_level %in% input$exp_levels)
    }
  })
  
  # Create a plot of average salary per year by experience level
  
  output$salary_plot <- renderPlot({
    data_salaries_filtered <- filtered_data_salaries() |> 
      dplyr::mutate(experience_level = case_when(
        experience_level == "EN" ~ "Entry-level / Junior",
        experience_level == "MI" ~ "Mid-level / Intermediate",
        experience_level == "SE" ~ "Senior-level / Expert",
        experience_level == "EX" ~ "Executive-level / Director",
        TRUE ~ experience_level
      ))
    if (length(input$exp_levels) == 0){
      ggplot2::ggplot(data_salaries_filtered, aes(x = work_year, 
                                                  y = salary_in_usd/1000)) +
        ggplot2::geom_line(stat = "summary", fun = "mean", color = 'green') +
        ggplot2::xlab("Work Year") +
        ggplot2::ylab("Average Salary in '000 USD") +
        ggplot2::ggtitle("Average Salary per Year by All Experience Levels") +
        ggplot2::theme(plot.title = element_text(size = 15, face = "bold"),
                       axis.text.x = element_text(size = 12, angle = 0),
                       axis.text.y = element_text(size = 12, angle = 0),
                       axis.title = element_text(size = 15))  
      
    } else {
      ggplot2::ggplot(data_salaries_filtered, aes(x = work_year, 
                                                  y = salary_in_usd/1000, 
                                                  color = experience_level)) +
        ggplot2::geom_line(stat = "summary", fun = "mean") +
        ggplot2::xlab("Work Year") +
        ggplot2::ylab("Average Salary in '000 USD") +
        ggplot2::ggtitle("Average Salary per Year by Experience Level") +
        ggplot2::scale_color_manual(values = c("Entry-level / Junior" = "blue",
                                               "Mid-level / Intermediate" = "green",
                                               "Senior-level / Expert" = "orange", 
                                               "Executive-level / Director" = "red"),
                                    name = "Experience Level"
        )+ggplot2::theme( plot.title = element_text(size = 15, face = "bold"),
                          axis.text.x = element_text(size = 12, angle = 0),
                          axis.text.y = element_text(size = 12, angle = 0),
                          axis.title = element_text(size = 15))  
    }
  })
  
  
}

# Run the application
shinyApp(ui = ui, server = server)