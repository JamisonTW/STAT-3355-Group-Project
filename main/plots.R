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
police_arrests$time_groups <- cut(police_arrests$hour, breaks = c(0, 4, 8, 12, 16, 20, 24), labels = c("12am-4am", "4am-8am", "8am-12pm", "12pm-4pm", "4pm-8pm", "8pm-12am"), include.lowest = TRUE)

# convert day of week to factor variable
police_arrests$Arrest.Day.of.The.Week <- factor(police_arrests$Arrest.Day.of.The.Week, c("Sun", "Mon", "Tue", "Wed", "Thu","Fri", "Sat"))

# the graph
library(ggplot2)

# Define a custom dark blue color palette
dark_blue_palette <- c("#084594", "#2171B5", "#4292C6", "#6BAED6", "#9ECAE1", "#C6DBEF")

ggplot(data = subset(police_arrests, !is.na(time_groups)), aes(x = time_groups)) +
  geom_bar(fill = dark_blue_palette[4]) +
  facet_wrap(~ Arrest.Day.of.The.Week, scales = "fixed") +
  labs(x = "Time Interval", y = "Amount of Arrests") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, hjust = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1, size = 5), 
    axis.title = element_text(size = 12),
    strip.text = element_text(size = 10),
    legend.position = "none",
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank(),
    panel.background = element_rect(fill = "white"),
    plot.background = element_rect(fill = "#F0F5FF")
  )

police_arrests$Arrestee.Race <- factor(police_arrests$Arrestee.Race)


  

ggplot(demographic_data, aes(x = poverty, y = unemployment, color = police_arrests)) +
  geom_point(size = 2, alpha = 0.7) +  # Adjust point size and transparency
  scale_color_gradient(low = "#4D80E4", high = "#E35252", na.value = "gray50", name = "Police Arrests") +  # Blue to red color gradient
  labs(
       x = "Poverty Rate",
       y = "Unemployment Rate") +
  theme_minimal() +  # Minimal theme
  theme(
    plot.title = element_text(size = 16, hjust = 0.5, margin = margin(b = 10)),  # Adjusting title size, position, and margin
    axis.title = element_text(size = 14),  # Adjusting axis label size
    legend.position = "bottom",  # Moving legend to the bottom
    legend.title = element_text(size = 12),  # Adjusting legend title size
    legend.text = element_text(size = 10),  # Adjusting legend text size
    panel.grid.major = element_blank(), # Removing major grid lines
    panel.grid.minor = element_blank(), # Removing minor grid lines
    panel.border = element_blank(), # Removing panel border
    panel.background = element_rect(fill = "white"), # Setting panel background to white
    plot.background = element_rect(fill = "#F0F5FF"), # Setting plot background to a light blue shade
    legend.background = element_rect(fill = "transparent"), # Making legend background transparent
    legend.box.background = element_rect(color = "black") # Adding border to legend
  )









