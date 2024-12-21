# plumber.R
library(plumber)
library(dplyr)
#library(readxl)
#library(lubridate)
#library(DT)
library(data.table)
#library(googlesheets4)

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

#* @filter cors
cors <- function(req, res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  res$setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
  res$setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization")
  plumber::forward()
}

# Google Sheets setup
#gs4_auth(cache = ".secrets", email = "colemanferrell2@gmail.com")
#SHEET_ID <- "1RVOeXVx7cMJmys94HwwxKEs74pb-mx-OxjWhOsiKl64"

#* @apiTitle Plumber API for Rankings App
#* @apiDescription Backend for the converted Shiny app.

#* Authentication endpoint
#* @post /authenticate
function(req, res) {
  body <- jsonlite::fromJSON(req$postBody)
  user <- body$user
  password <- body$password
  
  # User authentication logic (basic example)
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

#* Load and filter data
#* @param class Filters by class
#* @param state Filters by state
#* @param event Filters by event
#* @get /filter_data
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

#* Save athlete data
#* @post /save_athlete
function(req, res) {
  body <- jsonlite::fromJSON(req$postBody)
  athlete <- body$athlete
  
  # Logic to save athlete (for example, to Google Sheets or local file)
  write.csv(athlete, "saved_athletes.csv", row.names = FALSE, append = TRUE)
  
  list(status = "success", message = "Athlete saved")
}

#* Get summary data for Men
#* @get /summary_men
function() {
  summariseMen
}

#* Get summary data for Women
#* @get /summary_women
function() {
  summariseWomen
}

#* Get detailed ranking data for Men
#* @param class Filters by class
#* @param state Filters by state
#* @param score_min Minimum score
#* @param score_max Maximum score
#* @get /rankings_men
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

#* Get detailed ranking data for Women
#* @param class Filters by class
#* @param state Filters by state
#* @param score_min Minimum score
#* @param score_max Maximum score
#* @get /rankings_women
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

#* Load event-specific data
#* @param event Event name
#* @get /event_data
function(event = NULL) {
  if (is.null(event)) {
    stop("Event parameter is required")
  }
  
  event_data <- finals %>% filter(topEvent == event)
  event_data
}

#* Fetch saved athletes
#* @get /saved_athletes
function() {
  if (file.exists("saved_athletes.csv")) {
    read.csv("saved_athletes.csv")
  } else {
    data.frame()
  }
}

#* Delete a saved athlete
#* @param name Athlete name to delete
#* @delete /delete_athlete
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

#* Get Women's Best Event Rankings
#* @param class Filters by class
#* @param state Filters by state
#* @param event Filters by event
#* @get /women_best_event
function(class = NULL, state = NULL, event = NULL) {
  best_event_data <- finalWomenBestE
  
  if (!is.null(class)) {
    best_event_data <- best_event_data %>% filter(Class %in% class)
  }
  
  if (!is.null(state)) {
    best_event_data <- best_event_data %>% filter(State %in% state)
  }
  
  if (!is.null(event)) {
    best_event_data <- best_event_data %>% filter(topEvent %in% event)
  }
  
  best_event_data
}

#* Get Men's Best Event Rankings
#* @param class Filters by class
#* @param state Filters by state
#* @param event Filters by event
#* @get /men_best_event
function(class = NULL, state = NULL, event = NULL) {
  best_event_data <- finalMenBestE
  
  if (!is.null(class)) {
    best_event_data <- best_event_data %>% filter(Class %in% class)
  }
  
  if (!is.null(state)) {
    best_event_data <- best_event_data %>% filter(State %in% state)
  }
  
  if (!is.null(event)) {
    best_event_data <- best_event_data %>% filter(topEvent %in% event)
  }
  
  best_event_data
}

#* Scoring Calculator
#* @param time Performance time (in seconds)
#* @param event Event name
#* @get /scoring_calculator
function(time, event) {
  if (is.null(time) || is.null(event)) {
    stop("Both time and event parameters are required")
  }
  
  score <- calculate_score(time, event) # Assuming calculate_score is predefined
  list(event = event, time = time, score = score)
}

#* Star Ranking Criteria
#* @get /star_criteria
function() {
  star_criteria <- data.frame(
    Stars = c("5 Stars", "4 Stars", "3 Stars", "2 Stars", "1 Star", "No Stars"),
    Criteria = c(
      "Score > 95",
      "Score > 85",
      "Score > 75",
      "Score > 65",
      "Score > 50",
      "Score <= 50"
    )
  )
  
  star_criteria
}

# Directly load the plumber API from the known file path inside the Docker container
pr <- plumber::plumb("/app/plumber.R")  # This is the fixed path inside the Docker container

args <- list(host = '0.0.0.0', port = 8080)

if (packageVersion('plumber') >= '1.0.0') {
  pr$setDocs(TRUE)
} else {
  args$swagger <- TRUE
}

do.call(pr$run, args)

