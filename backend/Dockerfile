FROM rstudio/plumber
# Install the R package `pacman`:
RUN R -e "install.packages('pacman')"

# Install essential R packages (without extra ones)
RUN R -e "install.packages(c('plumber', 'dplyr', 'readxl', 'data.table'))"

# Copy the Plumber API file into the container
COPY plumber.R /app/plumber.R
COPY plumber_run.R /app/plumber_run.R
COPY Data /app/Data
WORKDIR /app

# Run the API
CMD ["Rscript", "plumber_run.R"]
