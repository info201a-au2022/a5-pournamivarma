library("shiny")
library("dplyr")
library("plotly")
library("ggplot2")
library("tidyr")
library("tidyverse")
library("shinythemes")

source("../project_a5/ui.R")
source("../project_a5/server.R")

shinyApp(ui = ui, server = server)
