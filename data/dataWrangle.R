#Required packages
#install.packages("readxl")
library(httr)
library(readxl)
library(dplyr)
library(tidyr)

# Modified function to get data from GitHub with sheet specification
get_github_data <- function(username, repo, filepath, sheet = 1, branch = "main") {
  url <- paste0("https://raw.githubusercontent.com/", username, "/", repo, "/", branch, "/", filepath)
  
  temp <- tempfile()
  
  response <- GET(url)
  if (status_code(response) == 200) {
    writeBin(content(response, "raw"), temp)
    df <- read_excel(temp, sheet = sheet)
    unlink(temp)
    return(df)
  } else {
    stop("Failed to download file from GitHub")
  }
}

# Get the data
raw_data <- get_github_data(
  username = "martyclark",
  repo = "urbanResilience",
  filepath = "data/your_data.xls",
  sheet = "Sheet1"  # Replace with your sheet name or number
)

# Rest of your data wrangling code...
