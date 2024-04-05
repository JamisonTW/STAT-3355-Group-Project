# load libraries
library(tidyverse)
library(tidycensus)

# load Dallas crime data
police_arrests <- read.csv("./inputs/Police_Arrests.csv")

# Data Cleaning

# Add leading zeros to single digit values for dates

leading_zeros <- function(date_string) {
  parts <- str_split(date_string, "/")[[1]]
  month <- sprintf("%02d", as.numeric(parts[2]))
  day <- sprintf("%02d", as.numeric(parts[3]))
  paste(parts[1], month, day, sep = "/")
}

police_arrests$Arrest.Date <- sapply(police_arrests$Arrest.Date, leading_zeros)

police_arrests <- police_arrests %>% mutate(Arrest.Date = str_pad(Arrest.Date, 8, side = "left", pad = "0"))

# Left pad Arrest.Time with 0 to put in correct format for strptime
police_arrests <- police_arrests %>% mutate(Arrest.Time = str_pad(Arrest.Time, 11, side = "left", pad = "0"))

# Join Arrest.Date and Arrest.Time
police_arrests$date_time <- paste(police_arrests$Arrest.Date, police_arrests$Arrest.Time, sep = ' ')

# Convert date_time from a character format to a date and time format
police_arrests$date_time <- as.POSIXct(police_arrests$date_time, format = "%m/%d/%y %I:%M:%S %p")

police_arrests$date_time <- as.POSIXct(police_arrests$date_time, format = "%Y-%m-%d %H:%M:%S")

# create a numeric column containing the hour of arrests
police_arrests$hour <- as.numeric(format(police_arrests$date_time, "%H"))

# split up arrests into 4 hour intervals
police_arrests$time_groups <- cut(police_arrests$hour, breaks = c(0, 4, 8, 12, 16, 20, 24), labels = c(1, 2, 3, 4, 5, 6), include.lowest = TRUE)

# Display the dataframe
print(police_arrests)




ggplot(data = police_arrests, aes(x = time_groups)) +
  geom_bar() +
  facet_wrap("Arrest.Day.of.The.Week")
