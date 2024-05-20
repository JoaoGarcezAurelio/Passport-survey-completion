

# Building the shiny app

ui <- fluidPage(theme = shinytheme("darkly"), # the dark theme you want to use
                titlePanel("Daily Completions"), # the title for the first plot
                sidebarLayout( # Sidebar with a slider input for number of bins 
                  sidebarPanel(
                    sliderInput("bins",
                                "Use the slider to change bin number:",
                                min = 1,
                                max = 70,
                                value = 35) # Shiny shows at value 35 by default
                  ),
                  mainPanel( # Show a plot of the generated distribution
                    plotlyOutput("DailyCompletion"),
                    br(), br(), br())),
                
                titlePanel("Total Surveys Completed"),
                mainPanel( # Show a plot of the generated distribution
                  plotlyOutput("TotalSurveyCompletion",
                               width = "150%",
                               height = "1000px"),
                  br(), br(),br()),
                
                titlePanel("Passport To Success"),
                mainPanel( # Create a new Row in the UI for selectInputs
                  column(4,
                         selectInput("SCHOOL_ID",
                                     "School:",
                                     c("All",
                                       unique(as.character(Completion_Table$SCHOOL_ID))))
                  ),
                  column(4,
                         selectInput("Trial_Arm",
                                     "Group:",
                                     c("All",
                                       unique(as.character(Completion_Table$Trial_Arm))))
                  ),
                  column(4,
                         selectInput("Survey",
                                     "Survey:",
                                     c("All",
                                       unique(as.character(Completion_Table$Survey))))
                  ),
                  DT::dataTableOutput("table")) # Create a new row for the table.
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
  
  output$TotalSurveyCompletion <- renderPlotly({
    Survey_timeline_Data |> count(Time, 
                                  Days_Elapsed_Start,
                                  SCHOOL_ID) |> 
      mutate(Completions = cumsum(n), 
             .by = Time) |> 
      ggplot(aes(Days_Elapsed_Start, 
                 Completions, 
                 colour = Time)) +
      geom_line(size = 1,
                alpha = .9) +
      geom_point(size = 1)+
      scale_x_continuous(name = "Day of survey window", 
                         breaks = seq(0, 80, 5)) +
      scale_colour_brewer(palette = "Set1",
                          labels = c("Baseline", "Follow-Up")) +
      theme_ft_rc(base_family = "Arial",
                  base_size = 20, 
                  axis_text_size = 14, 
                  axis_title_size = 16) 
    
  })
  
  output$table <- DT::renderDataTable(rownames = FALSE, {
    data <- Completion_Table
    if (input$SCHOOL_ID != "All") {
      data <- data[data$SCHOOL_ID == input$SCHOOL_ID,]
    }
    if (input$Trial_Arm != "All") {
      data <- data[data$Trial_Arm == input$Trial_Arm,]
    }
    if (input$Survey != "All") {
      data <- data[data$Survey == input$Survey,]
      
    }
    data
  }
  )
}

# Run the application 
shinyApp(ui = ui, server = server)
