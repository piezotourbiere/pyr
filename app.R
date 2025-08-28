library(tidyverse)
library(lubridate)
library(shiny)
library(DBI)
library(RSQLite)
library(plotly)
library(shinyWidgets)
library(pool)
library(leaflet)
library(DT)

# Charger les puits uniques si disponible
if (file.exists("unique.rds")) {
  unikalie <- read_rds(file = "unique.rds")
} else {
  unikalie <- tibble(station = character(), well = character(), name = character())
}

source('my_ui.R', local = TRUE)

# Connexion à la base de données SQLite (adapter à votre usage)
con <- dbConnect(RSQLite::SQLite(), "db.sqlite")

# Définition du serveur
my_server <- function(input, output, session) {
  output$table <- DT::renderDataTable({
    tibble(message = "Tableau de données ici")
  })
}

# Lancer l’application
shinyApp(
  ui = my_ui,
  server = my_server
)