# Use a smaller base image for R (precompiled)
FROM rocker/r-ver:4.0.0

# Metadata
LABEL org.opencontainers.image.authors="barret@rstudio.com"

# Install necessary system dependencies in a single layer and clean up
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  libssl-dev \
  libsodium-dev \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean

# Install essential R packages (without extra ones)
RUN R -e "install.packages(c('plumber', 'dplyr', 'readxl', 'data.table'))"

# Expose the port for Plumber API
EXPOSE 8080

# Set the working directory
WORKDIR /app

# Copy only the necessary application files
COPY plumber.R /app/plumber.R

# Copy the Data folder containing your .RData files into the container
COPY Data/ /app/Data/

# Clean up unnecessary dependencies and caches
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Run the Plumber API on the correct port
CMD ["R", "-e", "pr <- plumber::plumb('/app/plumber.R'); pr$run(host = '0.0.0.0', port = as.numeric(Sys.getenv('PORT', '8080')) )"]
