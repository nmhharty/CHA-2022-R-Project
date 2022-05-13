#Script to clean and analyze Colorado Measures of Academic Success 
#First authored 2022-05-13 by Nicole Harty
#Last update: 2022-05-13 by Nicole Harty
#

library(openxlsx)
library(tidyverse)
library(janitor)

#load spreadsheets, need to skip appropriate lines
CMAS_ELA_Math <- read.xlsx("Data Files/CMAS/2021_CMAS_ELA_Math.xlsx", sheet=2, skipEmptyRows = TRUE, startRow = 28) %>%
  clean_names()
CMAS_Science <- read.xlsx("Data Files/CMAS/2021_CMAS_Science.xlsx", sheet=2, skipEmptyRows = TRUE, startRow = 28) %>%
  clean_names()

#subset to just relevant districts/schools and CO state average
#District Codes
## South Routt RE 2 = 2780
## Steamboat Springs RE 2 = 2770
## Hayden RE-1 = 2760
## State All Districts = 0000
## HSR 11 School Districts: Moffatt County RE 1 = 2020, Rangely RE 4 = 2720, Meeker RE 1 = 2710, North Park R 1 = 1410 (suppressed)
CMAS_ELA_Math <- CMAS_ELA_Math %>%
  mutate(routt_district = ifelse(district_code %in% c(2780,2770,2760),TRUE,FALSE),
         hsr11_district = ifelse(district_code %in% c(2780,2770,2760,2020,2720,2710,1410),TRUE,FALSE)) %>%
  filter(district_code %in% c(2780,2770,2760,"0000",2020,2720,2710,1410)) 

CMAS_Science <- CMAS_Science %>%
  mutate(routt_district = ifelse(district_code %in% c(2780,2770,2760),TRUE,FALSE),
         hsr11_district = ifelse(district_code %in% c(2780,2770,2760,2020,2720,2710,1410),TRUE,FALSE)) %>%
  filter(district_code %in% c(2780,2770,2760,"0000",2020,2720,2710,1410))

#clean up values - replace "- -" with NA, replace anything with "<" with NA, make all numeric

CMAS_ELA_Math[,c(8:25)] <- lapply(CMAS_ELA_Math[,c(8:25)], na_if, "- -")
CMAS_Science[,c(7:22)] <- lapply(CMAS_Science[,c(7:22)], na_if, "- -")

CMAS_ELA_Math[,c(8:25)] <- lapply(CMAS_ELA_Math[,c(8:25)], str_replace, "<", "NA")
CMAS_Science[,c(7:22)] <- lapply(CMAS_Science[,c(7:22)], str_replace, "<", "NA")

CMAS_ELA_Math[,c(8:25)] <- lapply(CMAS_ELA_Math[,c(8:25)], as.numeric)
CMAS_Science[,c(7:22)] <- lapply(CMAS_Science[,c(7:22)], as.numeric)

#Average Percent Met or Exceeded Expectations across all Routt Schools
##check missingness/suppression at school level vs district for aggregation level to use
CMAS_ELA_Math %>%
  mutate(NAvalue = is.na(percent_met_or_exceeded_expectations)) %>%
  group_by(level, NAvalue) %>%
  count()

CMAS_Science %>%
  mutate(NAvalue = is.na(percent_met_or_exceeded_expectations)) %>%
  group_by(level, NAvalue) %>%
  count()
##Too much missingness at school level. need to average across districts

## ELA, 3rd, 5th, 7th

##avg across all grade levels, all districts
CMAS_ELA_Math %>%
  filter(level=="DISTRICT") %>%
  group_by(routt_district, hsr11_district, content) %>%
  summarise(mean(percent_met_or_exceeded_expectations, na.rm = TRUE))

##avg each grade levels, by district
CMAS_ELA_Math %>%
  filter(level=="DISTRICT") %>%
  group_by(routt_district, hsr11_district, content, grade) %>%
  summarise(mean(percent_met_or_exceeded_expectations, na.rm = TRUE))

##Statewide average, all grade levels
CMAS_ELA_Math %>%
  filter(level=="STATE") %>%
  group_by(content) %>%
  summarise(mean(percent_met_or_exceeded_expectations, na.rm = TRUE))

##Statewide average, each grade level
CMAS_ELA_Math %>%
  filter(level=="STATE") %>%
  group_by(content, grade) %>%
  summarise(mean(percent_met_or_exceeded_expectations, na.rm = TRUE))

## Science, 8th

##Routt
CMAS_Science %>%
  filter(level=="DISTRICT") %>%
  group_by(routt_district, hsr11_district, grade) %>%
  summarise(mean(percent_met_or_exceeded_expectations, na.rm = TRUE))

##Statewude
CMAS_Science %>%
  filter(level=="STATE") %>%
  group_by(grade) %>%
  summarise(mean(percent_met_or_exceeded_expectations, na.rm = TRUE))


