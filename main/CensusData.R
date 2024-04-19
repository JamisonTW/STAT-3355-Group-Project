# load libraries
library(tidyverse)
library(tidycensus)

# load Dallas crime data
police_arrests <- read.csv("./inputs/Police_Arrests.csv")

# select unique zip codes in crime data
zip_codes <- unique(police_arrests$Arrest.Zipcode)
zip_mosts_arrests <- c("75201",
                       "75216",
                       "75220",
                       "75217",
                       "75215",
                       "75243",
                       "75204",
                       "75202",
                       "75211",
                       "75228"
                       )
census_api_key("70a95da093399ce5ebc9ad8c1049514f084234ca", install = FALSE)

# load ACS demographic data from US Census Bureau by unique zip codes of police arrests

# set up variables to pull
total_population <-  "B15003_001"
income <- "B19013_001"
poverty <- c("B17010_001", 
             "B17010_002")
education <- c("B15003_001",
               "B15003_002",
               "B15003_003",
               "B15003_004",
               "B15003_005",
               "B15003_006",
               "B15003_007",
               "B15003_008",
               "B15003_009",
               "B15003_010",
               "B15003_011",
               "B15003_012",
               "B15003_013",
               "B15003_014",
               "B15003_015",
               "B15003_016",
               "B15003_017",
               "B15003_018",
               "B15003_019",
               "B15003_020",
               "B15003_021",
               "B15003_022",
               "B15003_023",
               "B15003_024",
               "B15003_025")
unemployment <-  c("B23025_005", 
                   "B23025_003")
vars <- c(total_population, income, poverty, education, unemployment)

# pulls demographic estimates
demographic_data_raw <- get_acs(
  geography = "zcta",
  zcta = zip_codes,
  survey = "acs5",
  output = "wide",
  variables = vars
) %>% 
  select(!ends_with("M"))

# data cleaning

# vectors for final df
zip_vector <- demographic_data_raw$GEOID
pop_vector <- demographic_data_raw$B15003_001E
income_vector <- demographic_data_raw$B19013_001E
poverty_percent <- demographic_data_raw$B17010_002E / demographic_data_raw$B17010_001E
unemployment_percent <- demographic_data_raw$B23025_005E / demographic_data_raw$B23025_003E

demographic_data <- data.frame(zip_vector, pop_vector, income_vector, poverty_percent, unemployment_percent)
names(demographic_data) <- c("zipcode", "population", "income", "poverty", "unemployment")

# Aggregate the total number of arrests for each zipcode
total_arrests <- aggregate(IncidentNum ~ Arrest.Zipcode, data = police_arrests, FUN = length)
names(total_arrests) <- c("zipcode", "total arrests")

# Merge the total arrests data with the demographic data
demographic_data <- merge(demographic_data, total_arrests, by = "zipcode", all.x = TRUE)
names(demographic_data) <- c("zipcode", "population", "income", "poverty", "unemployment", "police_arrests")




ACSlist <- load_variables(2021, "acs5")

unique(police_arrests$Arrestee.Race)

