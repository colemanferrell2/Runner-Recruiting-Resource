# Running the Plumber API on all network interfaces (0.0.0.0) and port 8000
#* @apiTitle Plumber API for Rankings App
#* @apiDescription Backend for the converted Shiny app.

# Load necessary libraries
library(plumber)
library(dplyr)
library(data.table)

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
#* @param class:string Filters by class (e.g., "Freshman")
#* @param state:string Filters by state (e.g., "NC")
#* @param event:string Filters by event (e.g., "100m")
function(class = NULL, state = NULL, event = NULL) {
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
#* @param class:string Filters by class (e.g., "Freshman")
#* @param state:string Filters by state (e.g., "NC")
#* @param score_min:double Minimum score (e.g., 85.5)
#* @param score_max:double Maximum score (e.g., 99.0)
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
#* @param class:string Filters by class (e.g., "Freshman")
#* @param state:string Filters by state (e.g., "NC")
#* @param score_min:double Minimum score (e.g., 85.5)
#* @param score_max:double Maximum score (e.g., 99.0)
function(class = NULL, state = NULL, score_min = NULL, score_max = NULL) {
  rankings <- finalsMenBest
  
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
#* @param event:string Event name (e.g., "100m")
function(event = NULL) {
  if (is.null(event)) {
    stop("Event parameter is required")
  }
  
  event_data <- finalsMenBestE %>% filter(topEvent == event)
  event_data
}
