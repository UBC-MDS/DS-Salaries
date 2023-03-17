# Reflection Document for DS-Salaries Shiny App Project

-   authors: Mehwish Nabi, Yaou Hu, Jonah Hamilton, Ruslan Dimitrov

## Completed Implementations

Working toward the completion of Milestone 2, our team implemented all the tasks we set out in our proposal document for Milestone 1.

Specifically each of the team members implemented one of the four plots presented in the original sketch, which were then combined in one app by Yaou Hu. Furthermore as the team invested more time working and analyzing the app, we realized that the visual appeal and functionality could be improved significantly. We decided to split each plot into its own tab in order to maximize functionality and minimize cognitive load on the user. Furtheremore we changed the formats of some of the apps in order to better represent the data and to account for its limitations. Finally the evolved the functionality of the reactive elements in order to maximize the insights from each plot.

## Changes made to original proposal

1.  **Plots moved into separate tabs.**

**Rationale**: We realized that having all plots on the same tab would result in heavy cognitive load for the user as it would make the screen quite cluttered.

2.  **Change functionality of reactive elements.**

**Rationale**: Initially the team had planned to have four drop down menus. After discussing appropriate reactive elements for each plot we switched from drop down menus for each plot to: - For Salary Map plot we decided to use radio buttons with selection for number of employees per company and interactive map with custom labels containing the most important information on each country's job market.\
- For Top 10 highest paid jobs we retained our original plan for a drop down menu allowing the user to select specific country of interest, which then filters the top 10 jobs per job market. In this plot we decided to proceed with showing salaries by single market instead of comparison by country. This decision was driven by the constraints in the data. Because top 10 jobs would differ depending on the country, comparison would not be meaningful to the user and could create confusion. - For Salary by employment type the team retained the drop down menu functionality as planned. However the team decided to change the data in the drop down to be based on amount of work done remotely as opposed to by experience level. This change was driven by putting ourselves in the shoes of the user and realizing that this information would be more valuable to job seekers. Additionally we decided to still convey the information for salaries by experience level in the next plot. - For salary by year, we moved on from a dropdown menu for year and decided to plot salary history for all available years. In this plot we decided to leverage a checkboxGroupInput element in order to display salary information depending on experience level.

These changes to the dropdown menus enhanced the information contained in each plot, and we believe will maximize user satisfaction.
