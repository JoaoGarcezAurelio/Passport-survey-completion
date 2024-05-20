# Installing all the relevant packages

# renv::install("here") # For replicability of processes
# renv::install("tidyverse") # For data manipulation and visualisation
# renv::install("readr") # For loading csv
# renv::install("reprex") # For presentation of issues to the wider community
# renv::install("gt") # For tables
# renv::install("gtExtras") # For tables
# renv::install("shiny") # For shiny
# renv::install("plotly") # For plotly
# renv::install("DT") # For reactive tables
# renv::install("shinythemes") # For shiny themes
# renv::install("lintr") # For syntax being used
# renv::install("bslib") # For aesthetics in shiny
# renv::install("bsicons") # For icons to use via bslib
# renv::install("thematic") # For consistence between layout and plots
# renv::install("shinylive") # To allow your app to be interactive

# Loading the packages

library(here) # For replicability of processes
library(tidyverse) # For data manipulation and visualisation
library(readr) # For loading csv
library(reprex) # For presentation of issues to the wider community
library(gt) # For tables
library(gtExtras) # For tables
library(shiny) # For shiny
library(plotly) # For plotly
library(DT) # For reactive tables
library(shinythemes) # For shiny themes
library(lintr) # For syntax being used
library(bslib) # For aesthetics in shiny
library(bsicons) # For icons to use via bslib
library(thematic) # For consistence between layout and plots
library(shinylive) # To allow your app to be interactive

# Upload the two data sets that sustain shiny. The first is for the histogram
# and the line graph, the second for the table.

Survey_timeline_Data <- 
  read_csv(here("Data",
                "Processed Data",
                "Survey_Time_Data.csv"))

Completion_Table <- 
  read_csv(here("Data",
                "Processed Data",
                "Completion_table_manually_updated.csv"))


# Transform the time variables

Survey_timeline_Data <- mutate(Survey_timeline_Data,
                               Survey_Opened = as.POSIXct(Survey_Opened, 
                                                          format = "%d/%m/%Y %H:%M"))


Survey_timeline_Data <- mutate(Survey_timeline_Data,
                               Survey_Closed = as.POSIXct(Survey_Closed, 
                                                          format = "%d/%m/%Y %H:%M"))


Survey_timeline_Data <- mutate(Survey_timeline_Data,
                               First_Access = as.POSIXct(First_Access, 
                                                         format = "%d/%m/%Y %H:%M"))


Survey_timeline_Data <- mutate(Survey_timeline_Data,
                               Completion_Date = as.POSIXct(Completion_Date, 
                                                            format = "%d/%m/%Y %H:%M"))

Survey_timeline_Data <- mutate(Survey_timeline_Data,
                               Shiny_Date = as.POSIXct(Shiny_Date, 
                                                       format = "%d/%m/%Y %H:%M"))


Survey_timeline_Data <- mutate(Survey_timeline_Data,
                               Survey_Duration_Minutes = Completion_Date - First_Access)

# The issue with using the Completion date variable to calculate the days and 
# hours elapsed is that the last day it has on record is the day of the last 
# survey that was completed. So if someone has not completed a survey in 10 days,
# in the plots you are building below, the line will stop ten days ago. So if you 
# are in day 30 of the surveys, you will only have data until day 20, which 
# makes it look as if your survey is incomplete. The way to get around this is
# with a cheat. On excel I created a variable equal to Completion Date, but
# I manually replace the value of the last row with today's date (assuming no
# one completed a survey today). 

Survey_timeline_Data <- mutate(Survey_timeline_Data,
                               Hours_Elapsed_Start = difftime(Shiny_Date, 
                                                              Survey_Opened,
                                                              units = "hours"))


Survey_timeline_Data <- mutate(Survey_timeline_Data,
                               Days_Elapsed_Start =  difftime(Shiny_Date, 
                                                              Survey_Opened,
                                                              units = "days"))




Survey_timeline_Data <- mutate(Survey_timeline_Data,
                               Hours_Until_End = difftime(Survey_Closed,
                                                          Completion_Date,
                                                          units = "hours"))


Survey_timeline_Data <- mutate(Survey_timeline_Data,
                               Days_Until_End = difftime(Survey_Closed,
                                                         Completion_Date,
                                                         units = "days"))


Survey_timeline_Data <- mutate(Survey_timeline_Data,
                               Survey_Window_Days = Survey_Closed - Survey_Opened)


Survey_timeline_Data <- mutate(Survey_timeline_Data,
                               Survey_Window_Hours = difftime(Survey_Closed,
                                                              Survey_Opened,
                                                              units = "hours"))


# Converting some key variables to factors across both data sets

Survey_timeline_Data$PASSWORDS <- as.factor(Survey_timeline_Data$PASSWORDS)

Survey_timeline_Data$SCHOOL_ID <- as.factor(Survey_timeline_Data$SCHOOL_ID)

Survey_timeline_Data$Time <- as.factor(Survey_timeline_Data$Time)

Completion_Table$SCHOOL_ID <- as.factor(Completion_Table$SCHOOL_ID)

Completion_Table$Survey <- as.factor(Completion_Table$Survey)

Completion_Table$Trial_Arm <- as.factor(Completion_Table$Trial_Arm)

# Converting the completion percentage (which is in decimals) to its adequate
# format.

Completion_Table$Completion_Rate <- Completion_Table$Completion_Rate * 100

# Ensuring the completion percentages have two decimal places only.

Completion_Table <- Completion_Table %>% mutate(across(where(is.numeric),
                                                       ~ round(., 2)))


# Now to build the layout elements that will constitute the options that users
# can select in the sidebar panel that will be created for the shiny app

# Make layout elements, namely:

Schools = c("1", "2", "3", "4", "6", "7", "8", "9", "10", "11", "12", "13", "15", 
            "16", "17", "18", "19", "20", "21", "23", "24", "25", "26", "28", 
            "30", "31", "32", "34", "36", "39", "40", "44", "45", "46", "47", 
            "48", "49", "51", "53", "54", "56", "57", "58", "61", "62", "63", 
            "64", "65", "66", "67", "68", "72", "73", "75", "77", "78", "79",
            "80", "81", "82", "83", "84", "All")    

Group = c("Control Group", "Intervention Group")

Survey = c("Baseline", "Follow-Up")

passport_sidebar_content <-
  list(
    selectInput("SCHOOL_ID",
                "Select School",
                c("All",
                  unique(as.character(Completion_Table$SCHOOL_ID)))),
    selectInput("Trial_Arm",
                "Select Trial Arm",
                c("All",
                  unique(as.character(Completion_Table$Trial_Arm)))),
    selectInput("Survey",
                "Select Survey Period",
                choices = Survey,
                c("Baseline", "Follow-Up"),
    ),
    sliderInput("bins",
                "Use the slider below to change the number of bins in the 
                histogram for Daily Surveys. If you select n = 2, you divide 
                the survey window into two periods. If you select n = 70, 
                you can see the number of surveys for each day of the survey
                period:",
                min = 1,
                max = 70,
                value = 70),
    "The plots are interactive. You can zoom in to a certain period and, when
    hovering over the plot, you can click the house icon to reset the axes back 
    to normal"
  )

# To assess the code:
# lintr::lint_dir()
