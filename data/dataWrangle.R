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

# Get the data of the indicator names
raw_data <- get_github_data(
  username = "martyclark",
  repo = "urbanResilience",
  filepath = "data/GHS_STAT_UCDB2015MT_GLOBE_R2019A_V1_2.xls",
  sheet = "Index"  # Replace with your sheet name or number
)

#subset to just the variable names and defintions
indicators <- 
  raw_data %>%
  select(`Column(s)`, Attribute)


#drop NA rows
indicators <-
  indicators %>%
  drop_na()


# Get the data of the variables names
ghsl <- get_github_data(
  username = "martyclark",
  repo = "urbanResilience",
  filepath = "data/GHS_STAT_UCDB2015MT_GLOBE_R2019A_V1_2.xls",
  sheet = "Data"  # Replace with your sheet name or number
)

#melt this data frame
names(ghsl)
