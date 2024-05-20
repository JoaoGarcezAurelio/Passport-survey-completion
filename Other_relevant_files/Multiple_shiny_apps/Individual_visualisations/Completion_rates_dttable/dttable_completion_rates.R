# Importing the data to build the table in the shiny app.
#
Completion_Table <- 
    read_csv(here("Data",
                  "Processed Data",
                  "Completion_table_manually_updated.csv"))

# Formatting the data

Completion_Table$SCHOOL_ID <- as.factor(Completion_Table$SCHOOL_ID)
Completion_Table$Survey <- as.factor(Completion_Table$Survey)
Completion_Table$Trial_Arm <- as.factor(Completion_Table$Trial_Arm)

Completion_Table$Completion_Rate <- Completion_Table$Completion_Rate * 100

Completion_Table$Completion_Rate <- format(round(Completion_Table$Completion_Rate),
                                           nsmall = 1)

# Building the shiny app

# Turning the static table into a dynamic table

ui <- fluidPage(
    titlePanel("Passport To Success"),
    
    # Create a new Row in the UI for selectInputs
    fluidRow(
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
        )
    ),
    # Create a new row for the table.
    DT::dataTableOutput("table")
)

server <- function(input, output) {
    
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
