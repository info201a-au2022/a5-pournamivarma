library(shiny)
library(dplyr)
library(plotly)
library(ggplot2)
library(tidyr)
library(tidyverse)
library(shinythemes)

page_one <- tabPanel(
  "Introduction",
  titlePanel(strong("CO2 emissions")),
  mainPanel(
    h4(strong("Primary Variables")),
    h5(strong("co2_per_capita"), "This variable accounts for the the total contribution of the average citizen in each country 
       in terms of the emission of carbon dioxide production."),
    h5(strong("co2_per_gdp"), "This variable accounts for the ratio of total carbon dioxide emission as accounted 
       from fuel combustion by per unit of GDP."),
    
    h4(strong("Key Values")),
    h5("What is the average value of co2 per capita across all the countries in 2020?"),
    tableOutput("table1"),
    h5("Which country had the lowest CO2 per capita value in the year 2020?"),
    tableOutput("table2"),
    h5("Which country had the highest CO2 per capita value in the year 2020?"),
    tableOutput("table3"),
    h5(" What is the variance in CO2 per capita over the years 2019 to 2020, revealing the most recent data provided, in the dataset?"),
    tableOutput("table4"),
  )
)
page_two <- tabPanel(
  "Interactive Scatterplot",
  titlePanel(strong("Scatterplot")),
  sidebarLayout(
    sidebarPanel(
      uiOutput("chooseCountry"),
      uiOutput("chooseXVariable"),
      uiOutput("chooseYVariable")
    ),
    mainPanel(
      h2("Scatterplot for annual total production-based emissions of co2"),
      plotlyOutput("co2_scatterplot"),
      h5("The scatter plot presented above engages in comparing CO2 emissions by GDP as 
         well as by capita over the course of a fifty year time period across multiple countries 
         which can be accessed and altered based on user's choice by taking a look at the drop down menu
         towards the left of their screen. The central finding from my data analysis produced the result that
         higher CO2 emission correlation rates between GDP and capita have tended to become increasingly more 
         prevalent in recent years with a generally positively linear inclination for the said trend."),
    )
  )
)
ui <- navbarPage(
  "Emission Trends of Carbon Dioxide (CO2)",
  page_one,
  page_two
)

shinyUI(fluidPage(
  theme = shinytheme("cerulean"),
  ui))
