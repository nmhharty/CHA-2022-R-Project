#Script to analyze Yampa Valley CHNA Survey
#First authored 2022-04-11 by Nicole Harty
#Last update: 2022-04-11
#

library(openxlsx)
library(tidyverse)
library(likert)

#load survey data wrangling script
source("SurveyDataCleanWrangle.R")

#Demographics of Routt respondents
DemosColumns <- ncol(Demos)
for (i in 2:DemosColumns) {
  Demos %>%
    filter(County=="Routt") %>%
    group_by_at(i) %>%
    summarise(Count = n()) %>%
    mutate(Percentage = scales::percent(Count/sum(Count))) %>%
    arrange(Count) %>%
    print()
}

#get column indices for questions with single select to loop over summary stats
colnames(DataOnly)

SingleSelectColumns <- ncol(7:15,39,44,47,50:55,56:58,60:68,70:71,73,76,78:79,81:82,85,87,89:90,92:94,96,98,100,102,104,106,108)

for (i in 2:SingleSelectColumns) {
  SingleSelectColumns %>%
    filter(County=="Routt") %>%
    group_by_at(i) %>%
    summarise(Count = n()) %>%
    mutate(Percentage = scales::percent(Count/sum(Count))) %>%
    arrange(Count) %>%
    print()
}

#Need and Use Services questions summary

##NEED TO PULL OPEN ENDED RESPONSES INTO DEDOOSE/SOMETHING TO CODE AND THEN JOIN BACK TO DISCRETE DATA AS APPROPRIATE
