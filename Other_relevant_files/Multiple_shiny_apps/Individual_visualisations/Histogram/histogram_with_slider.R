#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

# For the first time I set up this project, I manually installed the following
# packages. 

renv::install("tidyverse") # For the usual reasons
renv::install("here") # Easier to open files in other machines
renv::install("summarytools") # Good descriptives tool
renv::install("readr") # Reading csv data
renv::install("mice") # Treating missing data
renv::install("xfun") # For info on package versions
renv::install("reprex") # To make it easier to present a problem to outsiders
renv::install("gt") # For tables
renv::install("gtExtras")
renv::install("gtsummary") # For tables with summaries - related to GT
renv::install("Hmisc") # For descriptives
renv::install("devtools") # For some of the tools in r
renv::install("cowplot") # For plots
renv::install("kableExtra") # For tables
renv::install("ggforce")
renv::install("ggthemes") # ggplot theme
renv::install("ggridges") # Type of plot
renv::install("viridis") # Specific colour code
renv::install("scales") # To get the colour codes of a package
renv::install("psych") # For descriptives
renv::install("ggh4x") # To edit legends in plot
renv::install("vtable") # For a nice table
renv::install("shiny")
renv::install("shinydashboard")
renv::install("shinythemes")
renv::install("ggiraph")
renv::install("hrbrthemes")
remotes::install_github("vankesteren/firatheme")
remotes::install_github('Mikata-Project/ggthemr')
renv::install("plotly")
renv::install("DT")
renv::install("reactable")
renv::install("fontawesome")
renv::install("lintr")
renv::install("fresh")

library(here) # For replicability of processes
library(tidyverse) # For data manipulation
library(summarytools) # For descriptives
library(readr) # For loading csv
library(reprex) # For presentation of issues to the wider community
library(gt) # For tables
library(gtExtras)
library(ggthemes) # For plot layouts
library(ggridges) # For a specific type of plot
library(shiny)
library(hrbrthemes)
library(ggthemr)
library(plotly)
library(DT)
library(reactable)
library(shinythemes)
library(fontawesome)
library(shinydashboard)
library(lintr)

Survey_timeline_Data <- 
    read_csv(here("Data",
                  "Processed Data",
                  "Survey_Time_Data.csv"))

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

Survey_timeline_Data$PASSWORDS <- as.factor(Survey_timeline_Data$PASSWORDS)

Survey_timeline_Data$SCHOOL_ID <- as.factor(Survey_timeline_Data$SCHOOL_ID)

Survey_timeline_Data$Time <- as.factor(Survey_timeline_Data$Time)

Survey_timeline_Data$Days_Elapsed_Startv2 <- as.numeric(Survey_timeline_Data$Days_Elapsed_Start)

# Now to build the Shiny app once the data has been adequately formatted.

# Define UI for application that draws a histogram
ui <- fluidPage(theme = shinytheme("darkly"),
                
                # Application title
                titlePanel("Daily Completions"),
                
                # Sidebar with a slider input for number of bins 
                sidebarLayout(
                    sidebarPanel(
                        sliderInput("bins",
                                    "Use the slider to change bin number:",
                                    min = 1,
                                    max = 70,
                                    value = 35) # Shiny shows at value 35 by default
                    ),
                    
                    # Show a plot of the generated distribution
                    mainPanel(
                        plotlyOutput("DailyCompletion")
                    )
                )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$DailyCompletion <- renderPlotly({
        # generate bins based on input$bins from ui.R
        x    <- Survey_timeline_Data$Days_Elapsed_Start # column eleven of the data set
        bins <- seq(min(x), max(x), length.out = input$bins + 1)
        
        # draw the histogram with the specified number of bins
        ggplot(Survey_timeline_Data,  
               aes(x = x,
                   fill = Time)) +
            geom_histogram( position = "identity",
                            alpha = 0.8,
                            breaks = bins) + # This bypasses an error where the plot does not change in shiny
            scale_x_continuous(name = "Day of survey window", 
                               breaks = seq(0, 70, 5)) +
            scale_y_continuous(name = "Surveys completed per day") +
            scale_fill_brewer(palette = "Set1",
                              labels = c("Baseline", "Follow-Up")) + 
            theme_ft_rc(base_size = 20, axis_text_size = 14, axis_title_size = 16) +
            theme(legend.title = element_blank(),
                  legend.position = "top") 
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)