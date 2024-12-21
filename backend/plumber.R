# Load necessary libraries
library(plumber)
library(dplyr)
library(data.table)
# library(readxl)  # Uncomment if you need readxl
# library(lubridate)  # Uncomment if you need lubridate
# library(DT)  # Uncomment if you need DT
# library(googlesheets4)  # Uncomment if you need googlesheets4

# Load necessary data
load("Data/Mile.Rdata")
load("Data/Mile1.Rdata")
load("Data/MenCalcTable.Rdata")
load("Data/MenViewTable.Rdata")
load("Data/WomenCalcTable.Rdata")
load("Data/WomenViewTable.Rdata")
load("Data/finalMenBest.Rdata")
load("Data/finalMenBestE.Rdata")
load("Data/summariseMen.Rdata")
load("Data/finalsMenBest.Rdata")
load("Data/finalsMenBestE.Rdata")
load("Data/summariseWomen.Rdata")

# CORS filter (Allow cross-origin requests)
# This is necessary to allow your API to be called from different origins (such as a front-end app)
#* @filter cors
cors <- function(req, res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  res$setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
  res$setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization")
  plumber::forward()
}

# Example Authentication Endpoint
#* @post /authenticate
function(req, res) {
  body <- jsonlite::fromJSON(req$postBody)
  user <- body$user
  password <- body$password
  
  # User authentication logic (example)
  user_base <- tibble::tibble(
    user = c("user1", "BillyCaldwell"),
    password = c("pass1", "GoPirates")
  )
  
  if (any(user_base$user == user & user_base$password == password)) {
    res$status <- 200
    list(authenticated = TRUE)
  } else {
    res$status <- 401
    list(authenticated = FALSE)
  }
}

# Example of loading and filtering data
#* @get /filter_data
#* @param class Filters by class
#* @param state Filters by state
#* @param event Filters by event
function(class = NULL, state = NULL, event = NULL) {
  print(paste("Class:", class, "State:", state))
  filtered_data <- finalMenBest
  
  if (!is.null(class)) {
    filtered_data <- filtered_data %>% filter(Class %in% class)
  }
  
  if (!is.null(state)) {
    filtered_data <- filtered_data %>% filter(State %in% state)
  }
  
  if (!is.null(event)) {
    filtered_data <- filtered_data %>% filter(topEvent %in% event)
  }
  
  filtered_data
}

# Example of saving athlete data
#* @post /save_athlete
function(req, res) {
  body <- jsonlite::fromJSON(req$postBody)
  athlete <- body$athlete
  
  # Logic to save athlete (example, to a local file)
  write.csv(athlete, "saved_athletes.csv", row.names = FALSE, append = TRUE)
  
  list(status = "success", message = "Athlete saved")
}

# Get summary data for Men
#* @get /summary_men
function() {
  summariseMen
}

# Get summary data for Women
#* @get /summary_women
function() {
  summariseWomen
}

# Get detailed ranking data for Men
#* @get /rankings_men
#* @param class Filters by class
#* @param state Filters by state
#* @param score_min Minimum score
#* @param score_max Maximum score
function(class = NULL, state = NULL, score_min = NULL, score_max = NULL) {
  rankings <- finalMenBest
  
  if (!is.null(class)) {
    rankings <- rankings %>% filter(Class %in% class)
  }
  
  if (!is.null(state)) {
    rankings <- rankings %>% filter(State %in% state)
  }
  
  if (!is.null(score_min) & !is.null(score_max)) {
    rankings <- rankings %>% filter(Score >= as.numeric(score_min) & Score <= as.numeric(score_max))
  }
  
  rankings
}

# Get detailed ranking data for Women
#* @get /rankings_women
#* @param class Filters by class
#* @param state Filters by state
#* @param score_min Minimum score
#* @param score_max Maximum score
function(class = NULL, state = NULL, score_min = NULL, score_max = NULL) {
  rankings <- finals
  
  if (!is.null(class)) {
    rankings <- rankings %>% filter(Class %in% class)
  }
  
  if (!is.null(state)) {
    rankings <- rankings %>% filter(State %in% state)
  }
  
  if (!is.null(score_min) & !is.null(score_max)) {
    rankings <- rankings %>% filter(Score >= as.numeric(score_min) & Score <= as.numeric(score_max))
  }
  
  rankings
}

# Load event-specific data
#* @get /event_data
#* @param event Event name
function(event = NULL) {
  if (is.null(event)) {
    stop("Event parameter is required")
  }
  
  event_data <- finals %>% filter(topEvent == event)
  event_data
}

# Fetch saved athletes
#* @get /saved_athletes
function() {
  if (file.exists("saved_athletes.csv")) {
    read.csv("saved_athletes.csv")
  } else {
    data.frame()
  }
}

# Delete a saved athlete
#* @delete /delete_athlete
#* @param name Athlete name to delete
function(name) {
  if (file.exists("saved_athletes.csv")) {
    saved_data <- read.csv("saved_athletes.csv")
    updated_data <- saved_data %>% filter(Name != name)
    write.csv(updated_data, "saved_athletes.csv", row.names = FALSE)
    list(status = "success", message = "Athlete deleted")
  } else {
    list(status = "failure", message = "No saved athletes found")
  }
}

# Running the Plumber API on all network interfaces (0.0.0.0) and port 8000
#* @apiTitle Plumber API for Rankings App
#* @apiDescription Backend for the converted Shiny app.

# Load necessary libraries
library(plumber)
library(dplyr)
library(data.table)
# library(readxl)  # Uncomment if you need readxl
# library(lubridate)  # Uncomment if you need lubridate
# library(DT)  # Uncomment if you need DT
# library(googlesheets4)  # Uncomment if you need googlesheets4

# Load necessary data
load("Data/Mile.Rdata")
load("Data/Mile1.Rdata")
load("Data/MenCalcTable.Rdata")
load("Data/MenViewTable.Rdata")
load("Data/WomenCalcTable.Rdata")
load("Data/WomenViewTable.Rdata")
load("Data/finalMenBest.Rdata")
load("Data/finalMenBestE.Rdata")
load("Data/summariseMen.Rdata")
load("Data/finalsMenBest.Rdata")
load("Data/finalsMenBestE.Rdata")
load("Data/summariseWomen.Rdata")

# CORS filter (Allow cross-origin requests)
# This is necessary to allow your API to be called from different origins (such as a front-end app)
#* @filter cors
cors <- function(req, res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  res$setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
  res$setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization")
  plumber::forward()
}

# Example Authentication Endpoint
#* @post /authenticate
function(req, res) {
  body <- jsonlite::fromJSON(req$postBody)
  user <- body$user
  password <- body$password
  
  # User authentication logic (example)
  user_base <- tibble::tibble(
    user = c("user1", "BillyCaldwell"),
    password = c("pass1", "GoPirates")
  )
  
  if (any(user_base$user == user & user_base$password == password)) {
    res$status <- 200
    list(authenticated = TRUE)
  } else {
    res$status <- 401
    list(authenticated = FALSE)
  }
}

# Example of loading and filtering data
#* @get /filter_data
#* @param class Filters by class
#* @param state Filters by state
#* @param event Filters by event
function(class = NULL, state = NULL, event = NULL) {
  print(paste("Class:", class, "State:", state))
  filtered_data <- finalMenBest
  
  if (!is.null(class)) {
    filtered_data <- filtered_data %>% filter(Class %in% class)
  }
  
  if (!is.null(state)) {
    filtered_data <- filtered_data %>% filter(State %in% state)
  }
  
  if (!is.null(event)) {
    filtered_data <- filtered_data %>% filter(topEvent %in% event)
  }
  
  filtered_data
}

# Example of saving athlete data
#* @post /save_athlete
function(req, res) {
  body <- jsonlite::fromJSON(req$postBody)
  athlete <- body$athlete
  
  # Logic to save athlete (example, to a local file)
  write.csv(athlete, "saved_athletes.csv", row.names = FALSE, append = TRUE)
  
  list(status = "success", message = "Athlete saved")
}

# Get summary data for Men
#* @get /summary_men
function() {
  summariseMen
}

# Get summary data for Women
#* @get /summary_women
function() {
  summariseWomen
}

# Get detailed ranking data for Men
#* @get /rankings_men
#* @param class Filters by class
#* @param state Filters by state
#* @param score_min Minimum score
#* @param score_max Maximum score
function(class = NULL, state = NULL, score_min = NULL, score_max = NULL) {
  rankings <- finalMenBest
  
  if (!is.null(class)) {
    rankings <- rankings %>% filter(Class %in% class)
  }
  
  if (!is.null(state)) {
    rankings <- rankings %>% filter(State %in% state)
  }
  
  if (!is.null(score_min) & !is.null(score_max)) {
    rankings <- rankings %>% filter(Score >= as.numeric(score_min) & Score <= as.numeric(score_max))
  }
  
  rankings
}

# Get detailed ranking data for Women
#* @get /rankings_women
#* @param class Filters by class
#* @param state Filters by state
#* @param score_min Minimum score
#* @param score_max Maximum score
function(class = NULL, state = NULL, score_min = NULL, score_max = NULL) {
  rankings <- finals
  
  if (!is.null(class)) {
    rankings <- rankings %>% filter(Class %in% class)
  }
  
  if (!is.null(state)) {
    rankings <- rankings %>% filter(State %in% state)
  }
  
  if (!is.null(score_min) & !is.null(score_max)) {
    rankings <- rankings %>% filter(Score >= as.numeric(score_min) & Score <= as.numeric(score_max))
  }
  
  rankings
}

# Load event-specific data
#* @get /event_data
#* @param event Event name
function(event = NULL) {
  if (is.null(event)) {
    stop("Event parameter is required")
  }
  
  event_data <- finals %>% filter(topEvent == event)
  event_data
}

# Fetch saved athletes
#* @get /saved_athletes
function() {
  if (file.exists("saved_athletes.csv")) {
    read.csv("saved_athletes.csv")
  } else {
    data.frame()
  }
}

# Delete a saved athlete
#* @delete /delete_athlete
#* @param name Athlete name to delete
function(name) {
  if (file.exists("saved_athletes.csv")) {
    saved_data <- read.csv("saved_athletes.csv")
    updated_data <- saved_data %>% filter(Name != name)
    write.csv(updated_data, "saved_athletes.csv", row.names = FALSE)
    list(status = "success", message = "Athlete deleted")
  } else {
    list(status = "failure", message = "No saved athletes found")
  }
}

# Running the Plumber API on all network interfaces (0.0.0.0) and port 8000
#* @apiTitle Plumber API for Rankings App
#* @apiDescription Backend for the converted Shiny app.

# Create the Plumber API object
pr <- plumber$new()

# Set up Swagger documentation (if using Plumber version 1.0.0 or above)
if (packageVersion('plumber') >= '1.0.0') {
  pr$setDocs(TRUE)  # Enable Swagger UI for documentation
} else {
  args$swagger <- TRUE  # For older versions, this flag enables Swagger UI
}

# Start the Plumber API server
pr$run(host = "0.0.0.0", port = 8080)

