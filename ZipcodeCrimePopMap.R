crime <- read.csv("C:/Users/sophi/Downloads/archive/Police_Arrests.csv")

install.packages("devtools")
library(devtools)
install_github('arilamstein/choroplethrZip@v1.5.0')

crime$Arrest.Zipcode <- factor(crime$Arrest.Zipcode)
zipcodes <- c("75201", "75216", "75220", "75217", "75215", "75243", "75204", "75202", "75211", "75228")
zipcrime <- c(3770, 3494, 3460, 2880, 2856, 2774, 2541, 2523, 2372, 2301)


library(ggplot2)
library(choroplethrZip)
data(df_pop_zip)

zips <- df_pop_zip

zips$value[zips$region == "75201"] = 3770
zips$value[zips$region == "75216"] = 3494
zips$value[zips$region == "75220"] = 3460
zips$value[zips$region == "75217"] = 2880
zips$value[zips$region == "75215"] = 2856
zips$value[zips$region == "75243"] = 2774
zips$value[zips$region == "75204"] = 2541
zips$value[zips$region == "75202"] = 2523
zips$value[zips$region == "75211"] = 2372
zips$value[zips$region == "75228"] = 2301

zip_choropleth(zips, 
               zip_zoom = zipcodes, 
               title      = "Top Dallas zipcodes by Crime",
               legend     = "Crime") + coord_map()

zip_choropleth(df_pop_zip, 
               zip_zoom = zipcodes, 
               title      = "Top Dallas zipcodes by Population",
               legend     = "Population") + coord_map()