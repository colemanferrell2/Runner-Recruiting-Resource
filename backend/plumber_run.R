# Create the Plumber API object
pr <- plumber::plumb("plumber.R")

# Set up Swagger documentation (if using Plumber version 1.0.0 or above)
if (packageVersion('plumber') >= '1.0.0') {
  pr$setDocs(TRUE)  # Enable Swagger UI for documentation
} else {
  args$swagger <- TRUE  # For older versions, this flag enables Swagger UI
}

# Start the Plumber API server
pr$run(host = "0.0.0.0", port = 8080)
