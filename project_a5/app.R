library("tidyverse")
library("ggplot2")
library("dplyr")
library("shiny")

source("../project_a5/ui.R")
source("../project_a5/server.R")

shinyApp(ui = ui, server = server)
