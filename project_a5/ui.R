library(shiny)
library(dplyr)
library(plotly)
library(ggplot2)
library(tidyr)
library(tidyverse)
library(shinythemes)

page_one <- tabPanel(
  "Introduction",
  titlePanel(strong("Carbon Dioxide (CO2) Emissions")),
  mainPanel(
    includeMarkdown("./introduction.md"),
    
    h4(strong("Key Values")),
    h5("Which country had the highest CO2 per gdp value in the year 2018?"),
    tableOutput("table_one"),
    h5("What is the mean of the CO2_per_capita variable across all the countries in 2018?"),
    tableOutput("table_two"),
    h5("What is the variance in CO2 per capita over the past year (2017-2018) of the dataset?"),
    tableOutput("table_three"),
  )
)
page_two <- tabPanel(
  "Interctive Scatter Plot Visualization",
  titlePanel(strong("Scatter Plot")),
  sidebarLayout(
    sidebarPanel(
      uiOutput("choosecountry"),
      uiOutput("choosexvariable"),
      uiOutput("chooseyvariable")
    ),
    mainPanel(
      h2("CO2 Emission Production Breakdown Per Year"),
      plotlyOutput("scatter_plot_co2")
    )
  )
)
ui <- navbarPage(
  "Emissions of CO2",
  page_one,
  page_two
)

shinyUI(fluidPage(
  theme = shinytheme("flatly"),
  ui))