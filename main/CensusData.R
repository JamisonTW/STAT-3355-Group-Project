# load libraries
library(tidyverse)
library(tidycensus)

# load Dallas crime data
police_arrests <- read.csv("./inputs/Police_Arrests.csv")

# select unique zip codes in crime data
zip_codes <- unique(police_arrests$Arrest.Zipcode)

census_api_key("70a95da093399ce5ebc9ad8c1049514f084234ca", install = FALSE)

# load ACS demographic data from US Census Bureau by unique zip codes of police arrests

# pulls selected social characteristics
social_data <- get_acs(
  geography = "zcta",
  zcta = zip_codes,
  table = "DP02",
  survey = "acs5",
  output = "wide"
)

# pulls select economic characteristics
economic_data <- get_acs(
  geography = "zcta",
  zcta = zip_codes,
  table = "DP03",
  survey = "acs5",
  output = "wide"
)

# pulls select housing characteristics (not very helpful other then maybe rent data)
housing_data <- get_acs(
  geography = "zcta",
  zcta = zip_codes,
  table = "DP04",
  survey = "acs5",
  output = "wide"
)

# pulls demographic estimates
demographic_data <- get_acs(
  geography = "zcta",
  zcta = zip_codes,
  table = "DP05",
  survey = "acs5",
  output = "wide"
)

zip-data <- get_acs(
  variables = c("")
  geography = "zcta",
  zcta = zip_codes,
  survey = "acs5",
  output = "wide"
)
