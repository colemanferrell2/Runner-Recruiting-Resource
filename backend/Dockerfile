FROM rstudio/plumber
# Install the R package `pacman`:
RUN R -e "install.packages('pacman')"

# Install essential R packages (without extra ones)
RUN R -e "install.packages(c('plumber', 'dplyr', 'readxl', 'data.table'))"

# Set the working directory in the container
WORKDIR /app

# Copy the local 'backend' directory files into the container's '/app' directory
COPY . /app

# Set the command to run the Plumber API on container startup
CMD ["Rscript", "/app/plumber.R"]