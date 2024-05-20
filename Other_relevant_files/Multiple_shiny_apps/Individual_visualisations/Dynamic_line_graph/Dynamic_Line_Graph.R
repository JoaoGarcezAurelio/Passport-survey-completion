library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(theme = shinytheme("darkly"),
                
                # Application title
                titlePanel("Total Surveys Completed"),
                
                
                
                # Show a plot of the generated distribution
                mainPanel(
                    plotlyOutput("TotalSurveyCompletion",
                                 width = "150%",
                                 height = "1000px")
                )
)


# Define server logic required to draw a line graph
server <- function(input, output) {
    
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
}

# Run the application 
shinyApp(ui = ui, server = server)