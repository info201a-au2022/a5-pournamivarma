library(shiny)
library(dplyr)
library(plotly)
library(ggplot2)
library(tidyr)
library(tidyverse)
library(shinythemes)

emissions_co2 <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")
emissions_co2 <- na.omit(emissions_co2)
# View(emissions_co2)

by_capita <- emissions_co2 %>% 
  select(year, country, co2_per_capita, gdp, co2_per_gdp)


#------Data Summary Values---------------------# 
# Which country had the highest CO2 per gdp value in the year 2018?
CO2_gdp_highest <- by_capita %>% 
  filter(year == 2018) %>% 
  filter(co2_per_gdp == max(co2_per_gdp, na.rm = TRUE)) %>% 
  select(country)

# What is the mean of the CO2_per_capita variable across all the countries in 2018?
mean_val <- by_capita %>% 
  filter(year == 2018) %>% 
  summarize(avg_per_capita_CO2 = mean(co2_per_capita, na.rm = TRUE)) %>% 
  select(avg_per_capita_CO2)

# What is the variance in CO2 per capita over the past year (2017-2018) of the dataset?
C02_capita_variance <- by_capita %>% 
  filter(year %in% (2017:2018)) %>% 
  group_by(year) %>% 
  summarize(CO2_capita_average = mean(co2_per_capita, na.rm = TRUE)) %>% 
  mutate(variance = CO2_capita_average - lag(CO2_capita_average)) %>% 
  select(variance) %>% 
  drop_na()
#-----------------------------------------------# 


#-----------------------------------------------# 
thirty_year_difference <- by_capita %>% 
  filter(year %in% (1990:2018)) %>% 
  drop_na() 

shinyServer(function(input, output) {
  output$choosecountry <- renderUI({
    selectInput("Country", "Select a Country", choices = unique(thirty_year_difference$country))
  })
  output$choosexvariable  <- renderUI({
    selectizeInput("x", "Determine the x variable of choice:", choices = c("gdp", "year"), selected = "year")
  })
  output$chooseyvariable <- renderUI({
    selectizeInput("y", "Determine the y variable of choice", choices = c("co2_per_capita", "co2_per_gdp"), selected = "CO2 emissions per capita")
  })
  
  scatter_plot <- reactive({
    country_plot <- thirty_year_difference %>% 
      filter(country %in% input$country)
    
    scatterplot <- ggplot(country_plot, aes_string(x =input$x, y = input$y)) +
      geom_point() +
      labs(
        x = input$x,
        y = input$y,
        title = "CO2 per capita and per GDP from 1990 - 2018")
  })
  
  output$scatter_plot_co2 <- renderPlotly({
    scatter_plot()
  })
  output$table_one <- renderTable({
    table_one <- mean_val
  })
  output$table_two <- renderTable({
    table_two <- CO2_gdp_highest
  })
  output$table_three <- renderTable({
    table_three <- C02_capita_variance
  })
})
#-----------------------------------------------# 

