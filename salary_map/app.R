library(shiny)
library(leaflet)
library(thematic)
library(bslib)
library(tidyverse)
library(rnaturalearth)
library(sf)

# load data
data <- read.csv("../data/merged_salaries.csv")


ui <- fluidPage(
    theme = bslib::bs_theme(bootswatch = "flatly"),

    fluidRow(
        radioButtons(
            inputId = "comp_size",
            label = "Select the Company Size",
            # choices = unique(data$company_size),
            selected = "L",
            choiceNames = c("Small < 50 Employees", "Large > 250 Employees", "Medium 50-250 Employees"),
            choiceValues = unique(data$company_size),
            inline = TRUE
        ),
        fluidRow(column(
            12,
            leaflet::leafletOutput(outputId = 'map'))

             )

    )

)

server <- function(input, output, session) {

    # filter data based on selected input
    filtered_data <-reactive({


        data |>
            dplyr::filter(company_size == input$comp_size) |>
            dplyr::group_by(country, latitude, longitude) |>
            dplyr::summarise(
                number_of_jobs = dplyr::n(),
                median_salary = round(median(salary_in_usd), 0),
                unique_jobs = dplyr::n_distinct(job_title)
            )

    })



    output$map <- leaflet::renderLeaflet({

        # obtain sf file for map polygons
        country_data <-
            ne_countries(scale = "medium", returnclass = "sf")

        # merge filtered df and country info (need to preserve order)
        comp_size_country <-
            merge(
                x = country_data ,
                y = filtered_data(),
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

}

shinyApp(ui, server)
