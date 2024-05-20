source("data_cleaning.R") # this allows for the data cleaning and functions
# you built to be obtained and sourced into the shiny app

thematic_shiny() # this command ensures the shiny layout is visually consistent

ui <- page_sidebar(
    theme = bs_theme(bootswatch = "pulse", # this is a bslib theme for the background
                     primary = "#660099",
                     secondary = "#FFB240",
                     # In bslib there are several components,
                     # and one of them is called primary. By setting the color
                     # of primary, I can then call the primary argument for
                     # several of the boxes below, thus customising their colour.
                     # Same for the secondary
    ),
    title = "Passport to Success Trial",
    sidebar = sidebar(
        HTML('<img src = "Passport_purple.png" width = "60%" height = "25%">'), # this
        # is so that the image of passport can be imported to the dashboard
        passport_sidebar_content # This is an object created in the data_cleaning.R
        #file. The purpose is to create the components that go in the sidebar
    ),
    layout_columns(
        card(card_header("Daily Surveys"), #card header names the card
             plotlyOutput("DailyCompletion"), # this is to ensure the ui has plotly
             #for your plot of interest
        ),
        card(card_header("Total Surveys"),
             plotlyOutput("TotalSurveyCompletion"),
        ),
        value_box(title = "Total Surveys Completed",
                  value = "757", # this is being manually input
                  showcase = bs_icon("award-fill"), # chose these icons
                  theme = "primary"), # by selecting primary, i select the colour up top
        value_box(title = "Overall Completion Rate",
                  value = "32.7%", # this is being manually input
                  showcase = bs_icon("percent"),
                  theme = "secondary"),
        value_box(title = "Schools Finished",
                  value = "14",
                  showcase = bs_icon("building-check"),
                  theme = "primary"), 
        value_box(title = "Schools Not Started",
                  value = "38", # this is being manually input
                  showcase = bs_icon("building-dash"),
                  theme = "secondary" 
        ),
        card(card_header("Completion Rates"),
             DT::dataTableOutput("table")
        ),
        col_widths = c(6,6,3,3,3,3,12) # a column has 12 sections. With the two 6's
        # you ensure the two first plots are side by side. Then with four 3's, you 
        # ensure the four value boxes are side by side. Finally, the 12 is for the
        # data table
    ),
)


server <- function(input, output) {
    
    
    output$DailyCompletion <- renderPlotly({
        x    <- Survey_timeline_Data$Days_Elapsed_Start 
        bins <- seq(min(x), max(x), length.out = input$bins + 1) # have to set the
        # bins to ensure the slider has an object
        
        ggplot(Survey_timeline_Data,  
               aes(x = x,
                   fill = Time)) +
            geom_histogram( position = "identity",
                            alpha = 0.65,
                            breaks = bins) + 
            scale_x_continuous(name = "Day of survey window", 
                               breaks = seq(0, 70, 5)) +
            scale_y_continuous(name = "Surveys completed per day") +
            scale_fill_manual(values = c("#660099", "#FFB240")) # these are from the
        #Rcolor brewer set 1 pallete.
        
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
            geom_line(linewidth = 1,
                      alpha = .65) +
            geom_point(size = 1) +
            scale_x_continuous(name = "Day of survey window", 
                               breaks = seq(0, 80, 5)) +
            scale_colour_manual(values = c("#660099", "#FFB240")) 
        
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
    })  
    
}

# Run the application 
shinyApp(ui = ui, server = server)
