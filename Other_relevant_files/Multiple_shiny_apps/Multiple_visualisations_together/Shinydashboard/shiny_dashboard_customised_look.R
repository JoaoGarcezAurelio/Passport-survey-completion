# Creating a theme for shinydashboard using the fresh package

mytheme <- create_theme(
    adminlte_color(
        light_blue = "#434C5E"
    ),
    adminlte_sidebar(
        width = "400px",
        dark_bg = "#D8DEE9",
        dark_hover_bg = "#81A1C1",
        dark_color = "#2E3440"
    ),
    adminlte_global(
        content_bg = "#FFF",
        box_bg = "#D8DEE9", 
        info_box_bg = "#D8DEE9"
    )
)

# Starting the shinyapp

ui <- dashboardPage(skin = "purple",
    dashboardHeader(title = "Passport to Success"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Surveys Per Day", tabName = "Histogram", icon = icon("calendar")),
            menuItem("Total Surveys Completed", tabName = "Line", icon = icon("timeline")),
            menuItem("Completion Rate Per School", tabName = "Table", icon = icon("percentage"))
        )
    ),
    dashboardBody(use_theme(mytheme),
        fluidRow(
            tabItems(
                tabItem("Histogram",
                        fluidPage(
                            box(title = "Daily Surveys",
                                background = "black",
                                status = "primary",
                                sliderInput("bins",
                                            "Use the slider to change bin number:",
                                            min = 1,
                                            max = 70,
                                            value = 70), width = 4
                            ),
                            box(plotlyOutput("DailyCompletion"), width = 12)
                        )),
                tabItem("Line",
                        fluidPage(
                            box(title = "Total Surveys",
                                plotlyOutput("TotalSurveyCompletion",
                                             height = "1000px"), width = 12)
                        )),
                tabItem("Table",
                        fluidPage(
                            box(title = "Completion Percentages",
                                background = "black",
                                column(width = 8,
                                       selectInput(inputId = "SCHOOL_ID",
                                                   label = tags$p(fa("school", fill = "purple"),"School:"),
                                                   choices = c("All",
                                                     unique(as.character(Completion_Table$SCHOOL_ID))))
                                ),
                                column(width = 8,
                                       selectInput(inputId = "Trial_Arm",
                                                   label = tags$p(fa("children", fill = "darkgreen"),"Group:"),
                                                   choices = c("All",
                                                     unique(as.character(Completion_Table$Trial_Arm))))
                                ),
                                column(width = 8,
                                       selectInput(inputId = "Survey",
                                                   label = tags$p(fa("laptop", fill = "blue"),"Survey:"),
                                                   choices = c("All",
                                                     unique(as.character(Completion_Table$Survey))))
                                )
                            ),
                            # Create a new row for the table.
                            DT::dataTableOutput("table")
                        )))
        )
    )
)





server <- function(input, output) {
    
    output$DailyCompletion <- renderPlotly({
        x <- Survey_timeline_Data$Days_Elapsed_Start
        bins <- seq(min(x), max(x), length.out = input$bins + 1)
        
        ggplot(Survey_timeline_Data,  
               aes(x = x,
                   fill = Time)) +
            geom_histogram( position = "identity",
                            alpha = 0.8,
                            breaks = bins) + 
            scale_x_continuous(name = "Day of survey window", 
                               breaks = seq(0, 70, 5)) +
            scale_y_continuous(name = "Surveys completed per day") +
            scale_fill_brewer(palette = "Set1",
                              labels = c("Baseline", "Follow-Up")) + 
            theme_ft_rc(base_size = 20, 
                        axis_text_size = 14, 
                        axis_title_size = 16) +
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
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
