#Script to load, clean and prep Yampa Valley CHNA Survey for analysis
#First authored 2022-04-08 by Nicole Harty
#Last update: 2022-04-11
#

library(openxlsx)
library(tidyverse)

#load raw survey data
#first sheet is truly "raw" data, second sheet is more cleaned up Qualtrics export, but has two header rows
raw <- read.xlsx("YV_CHNA_SurveyAllResultsRaw.xlsx", sheet=2, skipEmptyRows = TRUE)

#pull second header row that has the full question to create question/column mapping
SurQuestColNames <- raw[1,]

# Clean up Question Names -------------------------------------------------

#Add cleaned up question name
colnames(SurQuestColNames)
RawColNames <- c("ResponseID",
                 "Language",
                          "Select the three most important factors for a Healthy Community.",
                          "Select the three most important factors for a Healthy Community. OPEN ENDED",
                          "Select the three factors which you feel you would like to see more of in Yampa Valley.",
                          "Select the three factors which you feel you would like to see more of in Yampa Valley. OPEN ENDED",
                          "My community is a good place to raise children.",
                          "My community is a good place to grow old.",
                          "There is economic opportunity in my community.",
                          "There are networks of support for individuals and families during times of stress and need.",
                          "Every person and group can contribute to and participate in the community's quality of life.",
                          "There is a broad variety of affordable healthcare services in my community.",
                          "There are adequate social services in the community to meet the needs of our residents.",
                          "The level of mutual trust and respect is increasing among community members and we participate in collaborative activities to achieve shared community goals.", 
                          "There is an active sense of civic responsibility and engagement, and of civic pride in the community.",
                          "Select up to THREE worst health problems in the Yampa Valley.",
                          "Select up to THREE worst health problems in the Yampa Valley. OPEN ENDED",
                          "Select up to three most common risky health behaviors and circumstances.", 
                          "Select up to three most common risky health behaviors and circumstances. OPEN ENDED",
                          "Select up to three drugs misuse or abuse you are most concerned about.",
                          "Select up to three drugs misuse or abuse you are most concerned about. OPEN ENDED",
                          "Select up to three places or people you turn to When you are sick or need health advice.",
                          "Select up to three places or people you turn to When you are sick or need health advice. OPEN ENDED",
                          "Select up to three places you go if you need help getting non-medical resources.",
                          "Select up to three places you go if you need help getting non-medical resources. OPEN ENDED",
                          "Did you or your family need or use services for children/youth with emotional problems or delinquent behavior in the past 12 months.",
                          "Did you or your family need or use treatment or counseling for alcohol or drug addiction in the past 12 months.",
                          "Did you or your family need or use low- or no-cost dental/oral health services in the past 12 months.",
                          "Did you or your family need or use mental health services in the past 12 months.",
                          "Did you or your family need or use parenting information, training, or classes in the past 12 months.",
                          "Did you or your family need or use child care/daycare financial assistance (including CCCAP) in the past 12 months.",
                          "Did you or your family need or use physical or mental health care because of sexual assault or physical abuse in the past 12 months.",
                          "Did you or your family need or use work-related/employment services (help finding work or job training) in the past 12 months.",
                          "Did you or your family need or use financial assistance (unemployment, Colorado Works/TANF, Social Security) in the past 12 months.",
                          "Did you or your family need or use housing services (rental/utility bill assistance, LEAP, or shelters) in the past 12 months.",
                          "Did you or your family need or use transportation assistance services (vouchers, reimbursements) in the past 12 months.",
                          "Select all the reasons you did not receive the support or services you needed.",
                          "Select all the reasons you did not receive the support or services you needed. OPEN ENDED",
                          "Which of the following best describes the services and resources you rely on in your community.",
                          "Which of the following best describes the services and resources you rely on in your community. OPEN ENDED",
                          "What are the top three areas of health and well-being would you want Yampa Valley to prioritize as it considers where to focus improvement efforts?",
                          "What are the top three areas of health and well-being would you want Yampa Valley to prioritize as it considers where to focus improvement efforts? OPEN ENDED",
                          "What does Yampa Valley need and/or need to do to ensure it is a place where all individuals can live up to their fullest potential?",
                          "On average, how much time does it take you to travel to see a doctor or other health care provider?",
                          "Select the challenges faced in getting the care you needed or wanted.",
                          "Select the challenges faced in getting the care you needed or wanted. OPEN ENDED",
                          "Have you avoided or delayed important health care services because of fear or discomfort?",
                          "Select all the reasons you were worried that your concerns would not be taken seriously or would not be treated fairly.",
                          "Select all the reasons you were worried that your concerns would not be taken seriously or would not be treated fairly. OPEN ENDED",
                          "How satisfied are you with your own health?",
                          "How satisfied are you with your community's health?",
                          "How satisfied are you with the safety in your community?", 
                          "How satisfied are you with getting the medical care you need?",
                          "How satisfied are you with getting the mental health or substance use care you need?",
                          "How satisfied are you with getting help during stressful times", 
                          "What ZIP code do you live in the Yampa Valley?",
                          "How many months of the year do you live in the Yampa Valley?", 
                          "How often is the ZIP code you live in also where you get services and resources?",
                          "How long have you lived in Routt or Moffat county? (number of year(s))",
                          "How often in the past 12 months were you worried or stressed about having enough money to buy nutritious meals?",
                          "How often in the past 12 months were you worried or stressed about paying your rent/mortgage?",
                          "How often in the past 12 months were you worried or stressed about paying for gas for a car or other transportation costs?",
                          "How often in the past 12 months were you worried or stressed about paying for utilities (electricity, water)?",
                          "How often in the past 12 months were you worried or stressed about having internet service?",
                          "How often in the past 12 months were you worried or stressed about having Phone/Cell phone service?",
                          "How often in the past 12 months were you worried or stressed about paying for clothing?",
                          "How often in the past 12 months were you worried or stressed about being able to afford the medical care you need?",
                          "Do you or does anyone in your household prefer to use a language other than English in the home?",
                          "Do you or does anyone in your household prefer to use a language other than English in the home? SPECIFY",
                          "Age",
                          "Gender",
                          "Gender OPEN ENDED",
                          "Sexual orientation or sexual identity?",
                          "Sexual orientation or sexual identity? OPEN ENDED",
                          "Ethnicity",
                          "Race",
                          "Race OPEN ENDED",
                          "What is the highest level of education you have completed?",
                          "Household income",
                          "How many people does household income support?",
                          "Are you raising children ages 0 to 18 years old in Routt or Moffat County?",
                          "Employment status", 
                          "Type of work. Select all that apply.",
                          "Type of work. OPEN ENDED",
                          "Do you work in the county where you live?",
                          "Work outside of county: county where work.",
                          "How are you generally paid for the work you do?",
                          "How are you generally paid for the work you do. OPEN ENDED",
                          "Do you have a primary health care provider whom you see regularly?",
                          "What is your primary source of health care coverage?",
                          "What is your primary source of health care coverage? OPEN ENDED",
                          "About how long has it been since you last had health care coverage?",
                          "Have you personally received at least one dose of the COVID-19 vaccine?",
                          "MAIN reason why you decided to get vaccinated for COVID-19.",
                          "MAIN reason why you decided to get vaccinated for COVID-19. OPEN ENDED",
                          "Main reason you have not gotten the COVID-19 vaccine.",
                          "Main reason you have not gotten the COVID-19 vaccine. OPEN ENDED",
                          "Measure best indicates education preparedness in the early years of life",
                          "Measure best indicates education preparedness in the early years of life OPEN ENDED",
                          "Measure best indicates education preparedness for a future career in the county",
                          "Measure best indicates education preparedness for a future career in the county OPEN ENDED",
                          "Measure best indicates the financial stability of an individual or family living in the county",
                          "Measure best indicates the financial stability of an individual or family living in the county OPEN ENDED",
                          "Measure best indicates the health of an individual living and working in the county",
                          "Measure best indicates the health of an individual living and working in the county OPEN ENDED",
                          "Measure best indicates an individual aging well in the county",
                          "Measure best indicates an individual aging well in the county OPEN ENDED",
                          "How did you learn about this survey?",
                          "How did you learn about this survey? OPEN ENDED",
                          "GC Interest",
                          "GC Name",
                          "GC Phone",
                          "GC Email",
                          "GC Best Contact",
                          "GC Best Contact Other",
                          "Interest in Community Meetings",
                          "Name",
                          "Phone",
                          "Email",
                          "best way to contact you",
                          "best way to contact you OPEN ENDED",
                          "DemoRace",
                          "DemoSexualOrientation",
                          "County",
                          "DemoGender",
                          "DemoSchooling")

SurQuestColNames[2,] <- RawColNames


# Restructure Data --------------------------------------------------------
colnames(raw) <- RawColNames

#remove second header row from raw data
raw <- raw[2:1168,]

#subset columns not needed for main analysis (names for additional outreach, etc)

DataOnly <- raw %>%
  select(-c(110:121))

#set column types
DataOnly[,c(7:15)] <- lapply(DataOnly[,c(7:15)], factor, 
                                                  levels = c("Disagree", "Somewhat Disagree", "Neutral", "Somewhat Agree", "Agree"))
DataOnly[,c(26:36)] <- lapply(DataOnly[,c(26:36)], factor, 
                                             levels = c("I did not need this service", "I Needed this service and used it", 
                                                        "I needed this service, but did not use it", "I choose not to answer"))
DataOnly[,c(39)] <- factor(DataOnly[,c(39)], levels = c("Affirming of my culture and practices",
                                                                   "Affordable",
                                                                   "Easy to access (easy to get)",
                                                                   "High quality",
                                                                   "Don’t know",
                                                                   "I don't know what this question is asking",
                                                                   "I don't want to answer",
                                                                   "In your own words:"))
DataOnly[,c(44)] <- factor(DataOnly[,c(44)], levels = c("15 min or less",
                                                                "15 - 30 minutes",
                                                                "30 - 45 minutes",
                                                                "Longer than 45 minutes"))
DataOnly[,c(47)] <- factor(DataOnly[,c(47)], levels = c("No","Yes"))
DataOnly[,c(50:55)] <- lapply(DataOnly[,c(50:55)], factor, levels = c("Very Unsatisfied","Unsatisfied","Neutral","Satisfied",
                                                                      "Very Satisfied","Not Applicable"))
DataOnly[,c(56:58,68,70:71,73,76,78:79,81:82,85,87,89:90,92:94,96,98,100,102,104,106,108)] <- 
  lapply(DataOnly[,c(56:58,68,70:71,73,76,78:79,81:82,85,87,89:90,92:94,96,98,100,102,104,106,108)], as.factor)
DataOnly[,c(60:67)] <- lapply(DataOnly[,c(60:67)], factor, levels = c("Never","Sometimes (3-4 times per year)","Every month"))

#clean up open-ended responses
##column 59: years in Routt/Moffat allows text and years
##column 80: number of people income supports allows numbers and text


# create demos df ---------------------------------------------------------
Demos <- DataOnly %>%
  select(1,2,56,70,75,78:79,81,82,110:114)
SOGIraceEthDemoDetails <- DataOnly %>%
  select(71:74,76:77)

# create county-specific data set ----------------------------------------

RouttDataOnly <- DataOnly %>%
  filter(County=="Routt")

# create separate df for each multiselect question ---------------------------------
HealthyCommunityFactors <- RouttDataOnly %>%
  select(ResponseID,`Select the three most important factors for a Healthy Community.`,`Select the three most important factors for a Healthy Community. OPEN ENDED`)

HealthyCommunityFactors <- HealthyCommunityFactors %>%
  mutate(AccessPrimaryCare_HealthyComm = str_detect(`Select the three most important factors for a Healthy Community.`,
                                                    "Access to primary care"),
         AccessMHsud_HealthyComm = str_detect(`Select the three most important factors for a Healthy Community.`,
                                              "Access to mental health and substance use treatment"),
         AccessSpecialty_HealthyComm = str_detect(`Select the three most important factors for a Healthy Community.`,
                                                  "Access to specialty care"),
         AccessDental_HealthyComm = str_detect(`Select the three most important factors for a Healthy Community.`,"Access to dental care"),
         GoodJobWage_HealthyComm = str_detect(`Select the three most important factors for a Healthy Community.`,"Good Paying Jobs / Livable Wages"),
         GoodSchool_HealthyComm = str_detect(`Select the three most important factors for a Healthy Community.`,
                                             "Good schools"),
         AffordHouse_HealthyComm = str_detect(`Select the three most important factors for a Healthy Community.`,"Affordable housing"),
         ArtsCulture_HealthyComm = str_detect(`Select the three most important factors for a Healthy Community.`,"Arts and cultural events"),
         BusinFriend_HealthyComm = str_detect(`Select the three most important factors for a Healthy Community.`,"Business friendly environment"),
         CleanWaterEnviro_HealthyComm = str_detect(`Select the three most important factors for a Healthy Community.`,"Clean water and environment"),
         FairEquitTreat_HealthyComm = str_detect(`Select the three most important factors for a Healthy Community.`,
                                                 "Fair and equitable treatment of people and groups"),
         GoodKids_HealthyComm = str_detect(`Select the three most important factors for a Healthy Community.`,"Good place to raise children"),
         GrowOld_HealthyComm = str_detect(`Select the three most important factors for a Healthy Community.`,"A place to grow old"),
         HealthyBehav_HealthyComm = str_detect(`Select the three most important factors for a Healthy Community.`,"Healthy behaviors and lifestyles"),
         HealthyFood_HealthyComm = str_detect(`Select the three most important factors for a Healthy Community.`,"Healthy food and proximity to grocery stores"),
         Transport_HealthyComm = str_detect(`Select the three most important factors for a Healthy Community.`,"Reliable transportation"),
         LowDeathDisease_HealthyComm = str_detect(`Select the three most important factors for a Healthy Community.`,"Low death and disease rates"),
         LowCrimeSafe_HealthyComm = str_detect(`Select the three most important factors for a Healthy Community.`,"Low crime"),
         LowViolence_HealthyComm = str_detect(`Select the three most important factors for a Healthy Community.`,"Low levels of violence"),
         ParksRec_HealthyComm = str_detect(`Select the three most important factors for a Healthy Community.`,"Parks and recreation"),
         ReligSpirit_HealthyComm = str_detect(`Select the three most important factors for a Healthy Community.`,"Religious or spiritual supports"),
         socialSupport_HealthyComm = str_detect(`Select the three most important factors for a Healthy Community.`,"Social support and connections"),
         FamilyUnitRelat_HealthyComm = str_detect(`Select the three most important factors for a Healthy Community.`,
                                                  "Safe, stable, and nurturing relationships within family units"),
         DontKnow_HealthyComm = str_detect(`Select the three most important factors for a Healthy Community.`,"Don’t know"),
         DontKnowQ_HealthyComm= str_detect(`Select the three most important factors for a Healthy Community.`,"I don’t know what this question is asking"),
         NoAnswer_HealthyComm = str_detect(`Select the three most important factors for a Healthy Community.`,"I don’t want to answer"),
         OpenEnded_HealthyComm= str_detect(`Select the three most important factors for a Healthy Community.`,"In your own words:")
         )

SeeMoreFactors <- RouttDataOnly %>%
  select(ResponseID,`Select the three factors which you feel you would like to see more of in Yampa Valley.`,`Select the three factors which you feel you would like to see more of in Yampa Valley. OPEN ENDED`)

SeeMoreFactors <- SeeMoreFactors %>%
  mutate(AccessPrimaryCare_SeeMore = str_detect(`Select the three factors which you feel you would like to see more of in Yampa Valley.`,
                                                "Access to primary care"),
         AccessMHsud_SeeMore = str_detect(`Select the three factors which you feel you would like to see more of in Yampa Valley.`,
                                          "Access to mental health and substance use treatment"),
         AccessSpecialty_SeeMore = str_detect(`Select the three factors which you feel you would like to see more of in Yampa Valley.`,
                                              "Access to specialty care"),
         AccessDental_SeeMore = str_detect(`Select the three factors which you feel you would like to see more of in Yampa Valley.`,
                                           "Access to dental care"),
         GoodJobWage_SeeMore = str_detect(`Select the three factors which you feel you would like to see more of in Yampa Valley.`,
                                          "Good Paying Jobs / Livable Wages"),
         GoodSchool_SeeMore = str_detect(`Select the three factors which you feel you would like to see more of in Yampa Valley.`,
                                         "Good schools"),
         AffordHouse_SeeMore = str_detect(`Select the three factors which you feel you would like to see more of in Yampa Valley.`,
                                          "Affordable housing"),
         ArtsCulture_SeeMore = str_detect(`Select the three factors which you feel you would like to see more of in Yampa Valley.`,
                                          "Arts and cultural events"),
         BusinFriend_SeeMore = str_detect(`Select the three factors which you feel you would like to see more of in Yampa Valley.`,
                                          "Business friendly environment"),
         CleanWaterEnviro_SeeMore = str_detect(`Select the three factors which you feel you would like to see more of in Yampa Valley.`,
                                               "Clean water and environment"),
         FairEquitTreat_SeeMore = str_detect(`Select the three factors which you feel you would like to see more of in Yampa Valley.`,
                                             "Fair and equitable treatment of people and groups"),
         GoodKids_SeeMore = str_detect(`Select the three factors which you feel you would like to see more of in Yampa Valley.`,
                                       "Good place to raise children"),
         GrowOld_SeeMore = str_detect(`Select the three factors which you feel you would like to see more of in Yampa Valley.`,
                                      "A place to grow old"),
         HealthyBehav_SeeMore = str_detect(`Select the three factors which you feel you would like to see more of in Yampa Valley.`,
                                           "Healthy behaviors and lifestyles"),
         HealthyFood_SeeMore = str_detect(`Select the three factors which you feel you would like to see more of in Yampa Valley.`,
                                          "Healthy food and proximity to grocery stores"),
         Transport_SeeMore = str_detect(`Select the three factors which you feel you would like to see more of in Yampa Valley.`,
                                        "Reliable transportation"),
         LowDeathDisease_SeeMore = str_detect(`Select the three factors which you feel you would like to see more of in Yampa Valley.`,
                                              "Low death and disease rates"),
         LowCrimeSafe_SeeMore = str_detect(`Select the three factors which you feel you would like to see more of in Yampa Valley.`,
                                           "Low crime"),
         LowViolence_SeeMore = str_detect(`Select the three factors which you feel you would like to see more of in Yampa Valley.`,
                                          "Low levels of violence"),
         ParksRec_SeeMore = str_detect(`Select the three factors which you feel you would like to see more of in Yampa Valley.`,"Parks and recreation"),
         ReligSpirit_SeeMore = str_detect(`Select the three factors which you feel you would like to see more of in Yampa Valley.`,
                                          "Religious or spiritual supports"),
         socialSupport_SeeMore = str_detect(`Select the three factors which you feel you would like to see more of in Yampa Valley.`,
                                            "Social support and connections"),
         FamilyUnitRelat_SeeMore = str_detect(`Select the three factors which you feel you would like to see more of in Yampa Valley.`,
                                              "Safe, stable, and nurturing relationships within family units"),
         DontKnow_SeeMore = str_detect(`Select the three factors which you feel you would like to see more of in Yampa Valley.`,"Don’t know"),
         DontKnowQ_SeeMore = str_detect(`Select the three factors which you feel you would like to see more of in Yampa Valley.`,"I don’t know what this question is asking"),
         NoAnswer_SeeMore = str_detect(`Select the three factors which you feel you would like to see more of in Yampa Valley.`,"I don’t want to answer"),
         OpenEnded_SeeMore = str_detect(`Select the three factors which you feel you would like to see more of in Yampa Valley.`,"In your own words:")
  )

WorstProb <- RouttDataOnly %>%
  select(ResponseID,`Select up to THREE worst health problems in the Yampa Valley.`,`Select up to THREE worst health problems in the Yampa Valley. OPEN ENDED`)

WorstProb <- WorstProb %>%
  mutate(Aging = str_detect(`Select up to THREE worst health problems in the Yampa Valley.`,"Aging related problems"),
         Cancer = str_detect(`Select up to THREE worst health problems in the Yampa Valley.`,"Cancer"),
         Diabetes = str_detect(`Select up to THREE worst health problems in the Yampa Valley.`,"Diabetes"),
         RepiratoryLung = str_detect(`Select up to THREE worst health problems in the Yampa Valley.`,"lung disease"),
         HeartDiseaseStroke = str_detect(`Select up to THREE worst health problems in the Yampa Valley.`,"Heart disease and stroke"),
         HIVaids = str_detect(`Select up to THREE worst health problems in the Yampa Valley.`,"AIDS"),
         VPD = str_detect(`Select up to THREE worst health problems in the Yampa Valley.`,"Vaccine preventable diseases"),
         PoorMH = str_detect(`Select up to THREE worst health problems in the Yampa Valley.`,"Poor mental health"),
         SubDrugUse = str_detect(`Select up to THREE worst health problems in the Yampa Valley.`,"Drug use"),
         Suicide = str_detect(`Select up to THREE worst health problems in the Yampa Valley.`,"Suicide and suicidality"),
         STIs = str_detect(`Select up to THREE worst health problems in the Yampa Valley.`,"Sexually Transmitted Infections"),
         Isolation = str_detect(`Select up to THREE worst health problems in the Yampa Valley.`,"Social isolation"),
         UnintendPreg = str_detect(`Select up to THREE worst health problems in the Yampa Valley.`,"Unintended pregnancy, including teenage pregnancy"),
         FirearmInjury = str_detect(`Select up to THREE worst health problems in the Yampa Valley.`,"Firearm-related injuries"),
         Homicide = str_detect(`Select up to THREE worst health problems in the Yampa Valley.`,"Homicide"),
         UnintentInjury = str_detect(`Select up to THREE worst health problems in the Yampa Valley.`,"Unintentional injuries"),
         DontKnow_WorstProb = str_detect(`Select up to THREE worst health problems in the Yampa Valley.`,"Don’t know"),
         DontKnowQ_WorstProb = str_detect(`Select up to THREE worst health problems in the Yampa Valley.`,"I don’t know what this question is asking"),
         NoAnswer_WorstProb = str_detect(`Select up to THREE worst health problems in the Yampa Valley.`,"I don’t want to answer"),
         OpendEnded_WorstProb = str_detect(`Select up to THREE worst health problems in the Yampa Valley.`,"In your own words:"))

RiskBehav <- RouttDataOnly %>%
  select(ResponseID, `Select up to three most common risky health behaviors and circumstances.`,`Select up to three most common risky health behaviors and circumstances. OPEN ENDED`)

RiskBehav <- RiskBehav %>%
  mutate(Homeless = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Homelessness"),
         FoodInsecurity = str_detect(`Select up to three most common risky health behaviors and circumstances.`,
                                     "Lack of access, at times, to enough food for an active, healthy life"),
         Obesity = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Obesity"),
         Bullying = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Bullying"),
         ElderAbuse = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Elder abuse"),
         ChildAbuse = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Child abuse"),
         IPVandDV = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Intimate partner violence"),
         CommViolence = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Community violence"),
         RapeSexAssault = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"sexual assault"),
         NoHS = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Not completing high school"),
         LackExercise = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Lack of exercise"),
         Tobacco = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Tobacco use"),
         Vaping = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Vaping"),
         Alcohol = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Alcohol misuse"),
         SubstDrudUse = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Drug misuse"),
         NoMaternCare = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Not getting prenatal"),
         NoHealthScreen = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Not getting regular health screenings"),
         NoCOVIDvax = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Not getting vaccinated against COVID-19"),
         NoSeatbelts = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Not using seat belts"),
         PoorEatHabit = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Poor eating habits"),
         SugarDrink = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Consuming sugary drinks"),
         UnfairGender = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Unfair treatment because of gender"),
         UnfariRace = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Unfair treatment because of race"),
         UnfairSO = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Unfair treatment because of sexual orientation"),
         UnsafeDriving = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Unsafe driving behaviors"),
         UnsafeSex = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Unsafe sex"),
         Trafficking = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Human trafficking"),
         Unemployment = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Under-employment"),
         UnsecuredFirearms = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Unsecured firearms"),
         ExcessiveSM = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"inappropriate use of Social Media"),
         ExcessinveTechScreen = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Overuse of technology"),
         DontKnow_RiskBehav = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"Don’t know"),
         DontKnowQ_RiskBehav = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"I don’t know what this question is asking"),
         NoAnswer_RiskBehav = str_detect(`Select up to three most common risky health behaviors and circumstances.`,"I don’t want to answer"),
         OpenEnded_RiskBehav= str_detect(`Select up to three most common risky health behaviors and circumstances.`,"In your own words:")
         )

DrugConcern <- RouttDataOnly %>%
  select(ResponseID, `Select up to three drugs misuse or abuse you are most concerned about.`,`Select up to three drugs misuse or abuse you are most concerned about. OPEN ENDED`)

DrugConcern <- DrugConcern %>%
  mutate(NoDrugConcern = str_detect(`Select up to three drugs misuse or abuse you are most concerned about.`,"I am not concerned about substances or drugs"),
         MethAmpht = str_detect(`Select up to three drugs misuse or abuse you are most concerned about.`,"Amphetamines, including Methamphetamines"),
         Benzo = str_detect(`Select up to three drugs misuse or abuse you are most concerned about.`,"Benzodiazepines"),
         GHB = str_detect(`Select up to three drugs misuse or abuse you are most concerned about.`,"GHB"),
         Nicotine = str_detect(`Select up to three drugs misuse or abuse you are most concerned about.`,"Nicotine"),
         Cocaine = str_detect(`Select up to three drugs misuse or abuse you are most concerned about.`,"Cocaine"),
         MDMA = str_detect(`Select up to three drugs misuse or abuse you are most concerned about.`,"MDMA"),
         Hallucin = str_detect(`Select up to three drugs misuse or abuse you are most concerned about.`,"Hallucinogens"),
         Alcohol = str_detect(`Select up to three drugs misuse or abuse you are most concerned about.`,"Alcohol"),
         MMJ = str_detect(`Select up to three drugs misuse or abuse you are most concerned about.`,"Marijuana"),
         Opiods = str_detect(`Select up to three drugs misuse or abuse you are most concerned about.`,"Opioids"),
          DontKnow_DrugConcern = str_detect(`Select up to three drugs misuse or abuse you are most concerned about.`,"Don’t know"),
          DontKnowQ_DrugConcern = str_detect(`Select up to three drugs misuse or abuse you are most concerned about.`,"I don’t know what this question is asking"),
          NoAnswer_DrugConcern = str_detect(`Select up to three drugs misuse or abuse you are most concerned about.`,"I don’t want to answer"),
          OpenEnded_DrugConcern = str_detect(`Select up to three drugs misuse or abuse you are most concerned about.`,"In your own words:")
          )


WhereGoSick <- RouttDataOnly %>%
  select(ResponseID, `Select up to three places or people you turn to When you are sick or need health advice.`,`Select up to three places or people you turn to When you are sick or need health advice. OPEN ENDED`)

WhereGoSick <- WhereGoSick %>%
  mutate(DocOffice_Sick = str_detect(`Select up to three places or people you turn to When you are sick or need health advice.`,"Doctor’s office"),
         Hospital_Sick = str_detect(`Select up to three places or people you turn to When you are sick or need health advice.`,
                                    "Hospital"),
         CHC_Sick = str_detect(`Select up to three places or people you turn to When you are sick or need health advice.`,
                               "Community Health Center"),
         RetailClinic_Sick = str_detect(`Select up to three places or people you turn to When you are sick or need health advice.`,
                                        "Retail store or minute health clinic"),
         FaithOrg_Sick = str_detect(`Select up to three places or people you turn to When you are sick or need health advice.`,"Faith-based organizations"),
         CBO_Sick = str_detect(`Select up to three places or people you turn to When you are sick or need health advice.`,
                               "Community based organizations"),
         CulturalOrg_Sick = str_detect(`Select up to three places or people you turn to When you are sick or need health advice.`
                                       ,"Cultural centers"),
         CHWpromotora_Sick = str_detect(`Select up to three places or people you turn to When you are sick or need health advice.`,
                                        "Community health workers"),
         PeerHealth_Sick = str_detect(`Select up to three places or people you turn to When you are sick or need health advice.`,
                                      "Peer health support"),
         AdvocacyOrg_Sick = str_detect(`Select up to three places or people you turn to When you are sick or need health advice.`,
                                       "Advocacy organizations"),
         School_Sick = str_detect(`Select up to three places or people you turn to When you are sick or need health advice.`,"Schools"),
         GovtAgency_Sick = str_detect(`Select up to three places or people you turn to When you are sick or need health advice.`,"Government agencies"),
        InternetGroup_Sick = str_detect(`Select up to three places or people you turn to When you are sick or need health advice.`,"social media"),
        Library_Sick = str_detect(`Select up to three places or people you turn to When you are sick or need health advice.`,"Libraries"),
        Family_Sick = str_detect(`Select up to three places or people you turn to When you are sick or need health advice.`,"Family member"),
        FriendCommMember_Sick = str_detect(`Select up to three places or people you turn to When you are sick or need health advice.`,"Friend or community member"),
        UW211_Sick = str_detect(`Select up to three places or people you turn to When you are sick or need health advice.`,"211"),
        UrgentCare_Sick = str_detect(`Select up to three places or people you turn to When you are sick or need health advice.`,"Urgent Care"),
        None_Sick = str_detect(`Select up to three places or people you turn to When you are sick or need health advice.`,"None"),
         DontKnow_Sick = str_detect(`Select up to three places or people you turn to When you are sick or need health advice.`,"Don’t know"),
         DontKnowQ_Sick = str_detect(`Select up to three places or people you turn to When you are sick or need health advice.`,"I don’t know what this question is asking"),
         NoAnswer_Sick = str_detect(`Select up to three places or people you turn to When you are sick or need health advice.`,"I don’t want to answer"),
         OpenEnded_Sick = str_detect(`Select up to three places or people you turn to When you are sick or need health advice.`,"In your own words:")
  )

WhereGoNoMed <- RouttDataOnly %>%
  select(ResponseID, `Select up to three places you go if you need help getting non-medical resources.`,`Select up to three places you go if you need help getting non-medical resources. OPEN ENDED`)

WhereGoNoMed <- WhereGoNoMed %>%
  mutate(DocOffice_NoMed = str_detect(`Select up to three places you go if you need help getting non-medical resources.`,"Doctor’s office"),
         Hospital_NoMed = str_detect(`Select up to three places you go if you need help getting non-medical resources.`,"Hospital"),
         CHC_NoMed = str_detect(`Select up to three places you go if you need help getting non-medical resources.`,"Community Health Center"),
         RetailClinic_NoMed = str_detect(`Select up to three places you go if you need help getting non-medical resources.`,"Retail store or minute health clinic"),
         FaithOrg_NoMed = str_detect(`Select up to three places you go if you need help getting non-medical resources.`,"Faith-based organizations"),
         CBO_NoMed = str_detect(`Select up to three places you go if you need help getting non-medical resources.`,"Community based organizations"),
         CulturalOrg_NoMed = str_detect(`Select up to three places you go if you need help getting non-medical resources.`,"Cultural centers or culturally specific organizations"),
         CHWpromotora_NoMed = str_detect(`Select up to three places you go if you need help getting non-medical resources.`,"Community health workers"),
         PeerHealth_NoMed = str_detect(`Select up to three places you go if you need help getting non-medical resources.`,"Peer health support"),
         AdvocacyOrg_NoMed = str_detect(`Select up to three places you go if you need help getting non-medical resources.`,"Advocacy organizations"),
         School_NoMed = str_detect(`Select up to three places you go if you need help getting non-medical resources.`,"Schools"),
         GovtAgency_NoMed = str_detect(`Select up to three places you go if you need help getting non-medical resources.`,"Government agencies"),
         InternetGroup_NoMed = str_detect(`Select up to three places you go if you need help getting non-medical resources.`,"social media"),
         Library_NoMed = str_detect(`Select up to three places you go if you need help getting non-medical resources.`,"Libraries"),
         Family_NoMed = str_detect(`Select up to three places you go if you need help getting non-medical resources.`,"Family member"),
         FriendCommMember_NoMed = str_detect(`Select up to three places you go if you need help getting non-medical resources.`,"Friend or community member"),
         UW211_NoMed = str_detect(`Select up to three places you go if you need help getting non-medical resources.`,"211"),
         UrgentCare_NoMed = str_detect(`Select up to three places you go if you need help getting non-medical resources.`,"Urgent Care"),
         None_NoMed = str_detect(`Select up to three places you go if you need help getting non-medical resources.`,"None"),
         DontKnow_NoMed = str_detect(`Select up to three places you go if you need help getting non-medical resources.`,"Don’t know"),
         DontKnowQ_NoMed = str_detect(`Select up to three places you go if you need help getting non-medical resources.`,"I don’t know what this question is asking"),
         NoAnswer_NoMed = str_detect(`Select up to three places you go if you need help getting non-medical resources.`,"I don’t want to answer"),
         OpenEnded_NoMed = str_detect(`Select up to three places you go if you need help getting non-medical resources.`,"In your own words:")
         )


HealthPriority <- RouttDataOnly %>%
  select(ResponseID, `What are the top three areas of health and well-being would you want Yampa Valley to prioritize as it considers where to focus improvement efforts?`,
         `What are the top three areas of health and well-being would you want Yampa Valley to prioritize as it considers where to focus improvement efforts? OPEN ENDED`)

HealthPriority <- HealthPriority %>%
  mutate(Collaboration = str_detect(`What are the top three areas of health and well-being would you want Yampa Valley to prioritize as it considers where to focus improvement efforts?`,
                       "Collaboration between medical centers and community organizations"),
         AgingFriendly = str_detect(`What are the top three areas of health and well-being would you want Yampa Valley to prioritize as it considers where to focus improvement efforts?`,
                                    "Creating an aging friendly community"),
        SUDprevent = str_detect(`What are the top three areas of health and well-being would you want Yampa Valley to prioritize as it considers where to focus improvement efforts?`,
                      "Substance use prevention program"),
        SchoolHealth = str_detect(`What are the top three areas of health and well-being would you want Yampa Valley to prioritize as it considers where to focus improvement efforts?`,
                      "School health and wellness programs"),
        YouthServices = str_detect(`What are the top three areas of health and well-being would you want Yampa Valley to prioritize as it considers where to focus improvement efforts?`,
                      "Youth services, resources, and programming"),
        DiseasePreventMgmt = str_detect(`What are the top three areas of health and well-being would you want Yampa Valley to prioritize as it considers where to focus improvement efforts?`,
                      "Disease prevention and management"),
        InjuryViolPrevent = str_detect(`What are the top three areas of health and well-being would you want Yampa Valley to prioritize as it considers where to focus improvement efforts?`,
                      "Injury and violence prevention"),
       FoodInsecurity = str_detect(`What are the top three areas of health and well-being would you want Yampa Valley to prioritize as it considers where to focus improvement efforts?`,
                      "Innovative approaches to food insecurity"),
        SpecialtyAccess = str_detect(`What are the top three areas of health and well-being would you want Yampa Valley to prioritize as it considers where to focus improvement efforts?`,
                      "Increased access to specialists"),
        EmergPrepare = str_detect(`What are the top three areas of health and well-being would you want Yampa Valley to prioritize as it considers where to focus improvement efforts?`,
                      "Emergency preparedness"),
        ChildCare = str_detect(`What are the top three areas of health and well-being would you want Yampa Valley to prioritize as it considers where to focus improvement efforts?`,
                      "Quality and affordable child care options"),
       Housing = str_detect(`What are the top three areas of health and well-being would you want Yampa Valley to prioritize as it considers where to focus improvement efforts?`,
                              "Affordable housing"),
        MHsudTreat = str_detect(`What are the top three areas of health and well-being would you want Yampa Valley to prioritize as it considers where to focus improvement efforts?`,
                      "Increase access and capacity for mental health"),
        BehavHealthEduc = str_detect(`What are the top three areas of health and well-being would you want Yampa Valley to prioritize as it considers where to focus improvement efforts?`,
                      "Education opportunities around behavioral health"),
        AddictPrevent = str_detect(`What are the top three areas of health and well-being would you want Yampa Valley to prioritize as it considers where to focus improvement efforts?`,
                      "Programs to prevent addiction"),
        RecFacility = str_detect(`What are the top three areas of health and well-being would you want Yampa Valley to prioritize as it considers where to focus improvement efforts?`,
                      "Recreational facilities"),
        ResourceJobWage = str_detect(`What are the top three areas of health and well-being would you want Yampa Valley to prioritize as it considers where to focus improvement efforts?`,
                      "Resources for good paying jobs and livable wages"),
        PromoteSocialSupport = str_detect(`What are the top three areas of health and well-being would you want Yampa Valley to prioritize as it considers where to focus improvement efforts?`,
                      "Resources to promote social support and connections"),
       DontKnow_Priority = str_detect(`What are the top three areas of health and well-being would you want Yampa Valley to prioritize as it considers where to focus improvement efforts?`,"Don’t know"),
       DontKnowQ_Priority = str_detect(`What are the top three areas of health and well-being would you want Yampa Valley to prioritize as it considers where to focus improvement efforts?`,"I don’t know what this question is asking"),
       NoAnswer_Priority = str_detect(`What are the top three areas of health and well-being would you want Yampa Valley to prioritize as it considers where to focus improvement efforts?`,"I don’t want to answer"),
       OpenEnded_Priority = str_detect(`What are the top three areas of health and well-being would you want Yampa Valley to prioritize as it considers where to focus improvement efforts?`,"In your own words:")
          )

Barriers <- RouttDataOnly %>%
  select(ResponseID, `Select the challenges faced in getting the care you needed or wanted.`, `Select the challenges faced in getting the care you needed or wanted. OPEN ENDED`)

Barriers <- Barriers %>%
  mutate(NoBarriers = str_detect(`Select the challenges faced in getting the care you needed or wanted.`,"I have not experienced any barriers"),
        HandicapAccess  = str_detect(`Select the challenges faced in getting the care you needed or wanted.`,"Poor physical access"),
         UnawareServices = str_detect(`Select the challenges faced in getting the care you needed or wanted.`,"Unaware of what services and resources were available"),
         Language = str_detect(`Select the challenges faced in getting the care you needed or wanted.`,"Language barriers"),
         EveningWeekend = str_detect(`Select the challenges faced in getting the care you needed or wanted.`,"weekend hours of service"),
         NotInCommunity = str_detect(`Select the challenges faced in getting the care you needed or wanted.`,"Needed service not offered in my community "),
         LackTransportation = str_detect(`Select the challenges faced in getting the care you needed or wanted.`,"Lacked transportation"),
         NotEligible = str_detect(`Select the challenges faced in getting the care you needed or wanted.`,"Not eligible for services"),
         AppsComplex = str_detect(`Select the challenges faced in getting the care you needed or wanted.`,"Application forms were too complicated"),
         NoSafe = str_detect(`Select the challenges faced in getting the care you needed or wanted.`,"Did not feel safe"),
       NoCulture = str_detect(`Select the challenges faced in getting the care you needed or wanted.`,"understood, valued, and respected my culture"),
       DontLookLikeMe = str_detect(`Select the challenges faced in getting the care you needed or wanted.`,"Could not find providers that looked like me"),
       NoInsurance = str_detect(`Select the challenges faced in getting the care you needed or wanted.`,"No health insurance"),
       HighOOPcost = str_detect(`Select the challenges faced in getting the care you needed or wanted.`,"High out-of-pocket-costs"),
       Embarrassed = str_detect(`Select the challenges faced in getting the care you needed or wanted.`,"Felt embarrassed about getting services"),
          DontKnow_Barriers = str_detect(`Select the challenges faced in getting the care you needed or wanted.`,"Don’t know"),
          DontKnowQ_Barriers = str_detect(`Select the challenges faced in getting the care you needed or wanted.`,"I don’t know what this question is asking"),
          NoAnswer_Barriers = str_detect(`Select the challenges faced in getting the care you needed or wanted.`,"I don’t want to answer"),
          OpenEnded_Barriers = str_detect(`Select the challenges faced in getting the care you needed or wanted.`,"In your own words:")
        )


FearDiscrim <- RouttDataOnly %>%
  select(ResponseID, `Select all the reasons you were worried that your concerns would not be taken seriously or would not be treated fairly.`, 
         `Select all the reasons you were worried that your concerns would not be taken seriously or would not be treated fairly. OPEN ENDED`)

FearDiscrim <- FearDiscrim %>%
  mutate(Race_FearDiscrim = str_detect(`Select all the reasons you were worried that your concerns would not be taken seriously or would not be treated fairly.`,
                       "Race"),
         Ethnicity_FearDiscrim = str_detect(`Select all the reasons you were worried that your concerns would not be taken seriously or would not be treated fairly.`,
                       "Ethnicity"),
         Immigration_FearDiscrim = str_detect(`Select all the reasons you were worried that your concerns would not be taken seriously or would not be treated fairly.`,
                       "Immigration status "),
        Lang_FearDiscrim  = str_detect(`Select all the reasons you were worried that your concerns would not be taken seriously or would not be treated fairly.`,
                       "Preferred language"),
         Income_FearDiscrim = str_detect(`Select all the reasons you were worried that your concerns would not be taken seriously or would not be treated fairly.`,
                       "Income"),
         Insurance_FearDisrim = str_detect(`Select all the reasons you were worried that your concerns would not be taken seriously or would not be treated fairly.`,
                       "Insurance status"),
         Gender_FearDisrim = str_detect(`Select all the reasons you were worried that your concerns would not be taken seriously or would not be treated fairly.`,
                       "Gender identity"),
         SexOrient_FearDisrim = str_detect(`Select all the reasons you were worried that your concerns would not be taken seriously or would not be treated fairly.`,
                       "Sexual orientation"),
         Religion_FearDisrim = str_detect(`Select all the reasons you were worried that your concerns would not be taken seriously or would not be treated fairly.`,
                       "Religion or Spiritual beliefs"),
         SUD_FearDisrim = str_detect(`Select all the reasons you were worried that your concerns would not be taken seriously or would not be treated fairly.`,
                       "Substance use"),
         Disability_FearDisrim = str_detect(`Select all the reasons you were worried that your concerns would not be taken seriously or would not be treated fairly.`,
                       "Disability"),
        HealthCondit_FearDisrim = str_detect(`Select all the reasons you were worried that your concerns would not be taken seriously or would not be treated fairly.`,
                      "Specific health condition"),
        Age = str_detect(`Select all the reasons you were worried that your concerns would not be taken seriously or would not be treated fairly.`,
                      "Age"),
          DontKnow_FearDiscr = str_detect(`Select all the reasons you were worried that your concerns would not be taken seriously or would not be treated fairly.`,
                                          "Don’t know"),
          DontKnowQ_FearDiscr = str_detect(`Select all the reasons you were worried that your concerns would not be taken seriously or would not be treated fairly.`,
                                           "I don’t know what this question is asking"),
          NoAnswer_FearDiscr = str_detect(`Select all the reasons you were worried that your concerns would not be taken seriously or would not be treated fairly.`,
                                          "I don’t want to answer"),
          OpenEnded_FearDiscr = str_detect(`Select all the reasons you were worried that your concerns would not be taken seriously or would not be treated fairly.`,
                                           "In your own words:")
  )









# Create domain subsets and pivot -----------------------------------------

NeedUseServices <- RouttDataOnly %>%
  select(1,26:36) %>%
  pivot_longer(2:12,names_to = "ServiceList") %>%
  mutate(ServiceList = str_remove(ServiceList,"Did you or your family need or use "))

Satisfaction <- RouttDataOnly %>%
  select(1,50:55) %>%
  pivot_longer(2:7,names_to = "SatisfiedWith") %>%
  mutate(SatisfiedWith = str_remove(SatisfiedWith,"How satisfied are you with "))

WorryStress <- RouttDataOnly %>%
  select(1,60:67) %>%
  pivot_longer(2:9,names_to = "WorryStressed") %>%
  mutate(WorryStressed = str_remove(WorryStressed,"How often in the past 12 months were you worried or stressed about "))

CommunityStatementAgreement <- RouttDataOnly %>%
  select(1,9:15) %>%
  pivot_longer(2:8,names_to = "CommunityStatements")





