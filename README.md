# DS-Salaries
[![Test app w/ {renv}](https://github.com/UBC-MDS/DS-Salaries/actions/workflows/testing.yaml/badge.svg?branch=main)](https://github.com/UBC-MDS/DS-Salaries/actions/workflows/testing.yaml) [![shiny-deploy](https://github.com/UBC-MDS/DS-Salaries/actions/workflows/deploy-app.yaml/badge.svg)](https://github.com/UBC-MDS/DS-Salaries/actions/workflows/deploy-app.yaml)

-   authors: Mehwish Nabi, Yaou Hu, Jonah Hamilton, Ruslan Dimitrov

# Table of Contents


-   [DS-Salaries on shinyapps.io](#DS-Salaries-on-shinyapps)
-   [Motivation and research questions](#Motivation-and-research-questions)
-   [Description of the app](#Description-of-the-app)
-   [Installation](#Installation)
-   [Get Involved](#Get-Involved)
-   [Contact us](#Contact-us)
-   [License](#license)

## DS Salaries on shinyapps

The Shiny app has been deployed on shinyapps.io. It can be accessed [here](https://yhuuu.shinyapps.io/DS-Salaries/).

![](img/demo.mp4)

## Motivation and research questions

Target audience: Our main target audience includes individuals searching for employment in the Data Science space. A secondary audience includes managers, recruiters, and founders looking to build a talented Data Science team.

The main research questions addressed by DS-Salaries are:

-   How have salary levels changed over the past couple of years?
-   What is the association between salary levels and experience?
-   What are the top paying positions in the field of Data Science?
-   How do salary levels for Data Science professionals vary across the world?

## Description of the app

Based on the motivation and aim of this app, it has a landing page that shows the distribution of data scientist salaries depending on the candidate’s experience level, the job market’s trend in the past three years, job titles, and company locations.

Specifically, this app contains four plots that correspond to our four research questions: A line plot shows the salary levels over the past years, a box plot comparing salaries based on the candidate’s experience level, a ranking chart of the top ten job titles with the highest salaries at different countries, and a map showing how salary levels vary across the world.

The app has four tab panels. Each panel has one interactive plot:

The map shows the global salary comparison across company sizes (small vs. medium vs. large). Users can select the company size using a radio button.

The ranking chart of the top ten job titles with the highest salaries varies across user-selected countries.

The box plot comparing salaries based on the candidate’s experience level varies by the remote ratio (the overall amount of work done remotely), which users can choose with a drop-down menu.

The line plot shows the salary levels over the past years, varying by candidates’ experience level(s) that users can choose with a checkbox. 

## Installation

To install `DS-Salaries` locally, you can:

1. Clone this repository with:

```
git clone https://github.com/UBC-MDS/DS-Salaries.git
```

2. Run the following command in your R console to install the required libraries locally:

```{r}
install.packages(c('shiny', 'tidyverse', 'ggplot2', 'thematic', 'plotly', 'dplyr', 'leaflet', 'bslib', 'rnaturalearthdata', 'rnaturalearth', 'sf', 'htmltools'))
```

3. Finally, move to the directory and run the following command to run the app locally:

```{r}
RScript app.R
```

## Get Involved

If you are interested in contributing to the app we welcome to share your thoughts. Particularly we would appreciate:

-   Additional data. This app is constantly evolving and being updated with new data. If you posses data related to Data Science salaries that can be applied to this Dashboard we would highly appreciate your contribution.

## Contact us

If you would like to help with the development of this Dashboard feel free to contact us after referring to our [contributor's guidelines](CONTRIBUTING.md)

## License

Licensed under the terms of the [MIT license](LICENSE).
