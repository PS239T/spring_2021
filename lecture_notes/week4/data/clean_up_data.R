library(tidyverse)

rm(list=ls())

#setwd("~/Desktop/ps239t/week4")

#explanatory variable data
weather_data <- read.csv("brazil_weather_oct_2012.csv")

#outcome variable data
elections_data <- read.csv("br_muni_elections_2012.csv")

#------------------------------------------------------------------------------------------------------------------
#cleaning up weather data------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------

#let's first clean up this weather value data which has variously included units which we don't care about

weather_data <-
  weather_data %>%
  select(-X)

weather_data <-
  weather_data %>%
  mutate(value = str_remove(value, "kt.s|    celcius|cm|%"))

#dates

#fix the months thing
weather_data <-
  weather_data %>%
  mutate(new_date = case_when(str_detect(new_date, "january") ~ str_replace(new_date, "january", "-01-"),
                              str_detect(new_date, "february") ~ str_replace(new_date, "february", "-02-"),
                              str_detect(new_date, "march") ~ str_replace(new_date, "march", "-03-"),
                              str_detect(new_date, "april") ~ str_replace(new_date, "april", "-04-"),
                              str_detect(new_date, "may") ~ str_replace(new_date, "may", "-05-"),
                              str_detect(new_date, "june") ~ str_replace(new_date, "june", "-06-"),
                              str_detect(new_date, "july") ~ str_replace(new_date, "july", "-07-"),
                              str_detect(new_date, "august") ~ str_replace(new_date, "august", "-08-"),
                              str_detect(new_date, "september") ~ str_replace(new_date, "september", "-09-"),
                              str_detect(new_date, "october") ~ str_replace(new_date, "october", "-10-"),
                              str_detect(new_date, "november") ~ str_replace(new_date, "november", "-11-"),
                              str_detect(new_date, "december") ~ str_replace(new_date, "december", "-12-"),
                              TRUE ~ new_date))

#split time and date
weather_data <-
  weather_data %>%
  separate(col = new_date, into = c("date", "time"), sep = " ")


#fix hour thing
weather_data <-
  weather_data %>%
  mutate(hour = substr(time, start = 1, stop = 2))

#province thing is just plain wrong.... we just want the code. also make sure city is uppercase
summary(factor(weather_data$prov))

weather_data <-
  weather_data %>%
  mutate(prov = case_when(prov == "Espirito Santo" ~ "ES",
                          prov == "Rio de Janeiro" ~ "RJ",
                          prov == "Sao Paolo" ~ "SP",
                          TRUE ~ prov)) %>%
  mutate(city = toupper(city))

#fix the lat-long thing
weather_data <-
  weather_data %>%
  separate(col = lat_lon, into = c("lat", "lon"), sep = "\\) ") %>%
  mutate_at(vars(lat, lon), 
            funs(. = str_remove_all(., "\\)|\\(")))
  
weather_data <-
  weather_data %>%
  select(-lat, -lon) %>%
  rename(lat = lat_., lon = lon_.)

#let's deal with these NAs too. They really mean 0
weather_data <-
  weather_data %>%
  mutate(value = case_when(is.na(value) ~ "0",
                           TRUE ~ as.character(value)))


#reshape time!

weather_data <-
  weather_data %>%
  pivot_wider(
    names_from = weather_value,
    values_from = value
  )


#recall that we only want data from elections day (october 7, 2012). we also only want obserations during voting hours (8am-5pm). Let's restrict obserations.

weather_data <-
  weather_data %>%
  mutate(hour = as.numeric(as.character(hour))) %>%
  filter(date == "2012-10-07", hour > 8 & hour < 17)


#let's now average the weather conditions over the horus the voting booths were open
weather_data <-
  weather_data %>%
  mutate_at(vars(precipitation, temperature, humidity, wind_speed),
            funs(as.numeric(as.character(.)))) %>%
  group_by(prov, city, date) %>%
  summarise_at(vars(precipitation, temperature, humidity, wind_speed),
               funs(mean(., na.rm = T)))



#------------------------------------------------------------------------------------------------------------------
#cleaning up elections data------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------

#let's filter on the provinces for which we have weather data
elections_data <-
  elections_data %>%
  filter(SIGLA_UF %in% c("ES", "RJ", "SP"))


#let's get the data grouped on leftists, or not -- and also add the total votes column/vote share
elections_data <-
  elections_data %>%
  group_by(SIGLA_UF, NOME_MUNICIPIO, leftist_party, date) %>%
  summarise(votes = sum(QTDE_VOTOS_NOMINAIS, na.rm = T)) %>%
  group_by(SIGLA_UF, NOME_MUNICIPIO, date) %>%
  mutate(total_votes = sum(votes, na.rm = T)) %>%
  mutate(vote_share = (votes/total_votes)*100)
  



#------------------------------------------------------------------------------------------------------------------
#merging the data------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------

merged_data <-
  left_join(
    elections_data,
    weather_data,
    by = c("SIGLA_UF" = "prov", "NOME_MUNICIPIO" = "city", "date")
  )


#------------------------------------------------------------------------------------------------------------------
#analyse------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------


merged_data %>%
  filter(leftist_party == 1) %>%
  ggplot(aes(x=humidity, y= vote_share)) +
  geom_point()

summary(lm(vote_share ~ temperature, data = merged_data %>% filter(leftist_party == 1)))
