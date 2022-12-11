library(shiny)
library(dplyr)
library(plotly)
library(ggplot2)
library(tidyr)
library(tidyverse)
library(shinythemes)

#-----------------# 
emissions_co2 <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")
by_capita<- emissions_co2 %>% 
  select(country, year, gdp, co2_per_capita, co2_per_gdp)

# What is the average value of co2 per capita across all the countries in 2020?
mean_val <- by_capita %>% 
  filter(year == 2020) %>% 
  summarize(avg_per_capita_CO2 = mean(co2_per_capita, na.rm = TRUE)) %>% 
  select(avg_per_capita_CO2)

# Which country had the highest CO2 per capita value in the year 2020?
CO2_capita_highest <- by_capita %>% 
  filter(year == 2020) %>% 
  filter(co2_per_capita == max(co2_per_capita, na.rm = TRUE)) %>% 
  select(country)

# Which country had the lowest CO2 per capita value in the year 2020?
CO2_capita_lowest <- by_capita %>% 
  filter(year == 2020) %>% 
  filter(co2_per_capita == min(co2_per_capita, na.rm = TRUE)) %>% 
  select(country)

# What is the variance in CO2 per capita over the 2019-2020 years in the dataset?
C02_capita_variance <- by_capita %>% 
  filter(year %in% (2019:2020)) %>% 
  group_by(year) %>% 
  summarize(CO2_capita_average = mean(co2_per_capita, na.rm = TRUE)) %>% 
  mutate(variance = CO2_capita_average - lag(CO2_capita_average)) %>% 
  select(variance) %>% 
  drop_na()

#------------------------# 
fifty_year_difference <- by_capita %>% 
  filter(year %in% (1970:2020)) %>% 
  drop_na() 

shinyServer(function(input, output) {
  output$chooseCountry <- renderUI({
    selectInput("Country", "Select a Country:", choices = unique(fifty_year_difference$country))
  })
  output$chooseXVariable  <- renderUI({
    selectizeInput("x", "Choose the x variable of your choice:", choices = c("gdp", "year"), selected = "year")
  })
  output$chooseYVariable <- renderUI({
    selectizeInput("y", "Choose the y variable of your choice:", choices = c("co2_per_gdp", "co2_per_capita"), selected = "CO2 emissions per gdp")
  })
  
  scatterplot <- reactive({
    countryPlot <- fifty_year_difference %>% 
      filter(country %in% input$Country)
    
    scatter_plot <- ggplot(countryPlot, aes_string(x =input$x, y = input$y)) +
      geom_point() +
      labs(
        x = input$x,
        y = input$y,
        title = "CO2 per GDP and per capita from 1970 - 2020")
  })
  
  output$co2_scatterplot <- renderPlotly({
    scatterplot()
  })
  output$table1 <- renderTable({
    table1 <- mean_val
  })
  output$table2 <- renderTable({
    table2 <- CO2_capita_lowest
  })
  output$table3 <- renderTable({
    table3 <- CO2_capita_highest
  })
  output$table4 <- renderTable({
    table4 <- C02_capita_variance 
  })
})
