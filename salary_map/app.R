library(shiny)
library(leaflet)
library(thematic)
library(bslib)
library(dplyr)

# load data
data <- read.csv("../data/merged_salaries.csv")

ui <- fluidPage(
    theme = bslib::bs_theme(bootswatch = "flatly"),
    fluidRow(checkboxGroupInput(inputId = "comp_size",
                                label = "Select the Company Size",
                                choices = unique(data$company_size),
                                inline = TRUE
                                ),
             fluidRow(column(12,
                             leaflet::leafletOutput(outputId = 'map')
                             )

             )

    )

)

server <- function(input, output, session) {

    # filter data based on selected input
    filtered_data <-reactive({

        data |>
            dplyr::filter(company_size == input$comp_size)

    })

    output$map <- leaflet::renderLeaflet({


        # color palette need to add

        # add if else for blank map - if options are selected

        filtered_data() |>
            leaflet::leaflet() |>
            # leaflet::addTiles() |>
            leaflet::addProviderTiles(providers$CartoDB.Positron) |>
            leaflet::addCircleMarkers(
                lat = ~latitude,
                lng = ~longitude,

                # add popups

                )
    })

}

shinyApp(ui, server)
