# Importing data

Completion_Table <- 
    read_csv(here("Data",
                  "Processed Data",
                  "Completion_table_manually_updated.csv"))

Completion_Table

# Formatting the data

Completion_Table$SCHOOL_ID <- as.factor(Completion_Table$SCHOOL_ID)
Completion_Table$Survey <- as.factor(Completion_Table$Survey)
Completion_Table$Trial_Arm <- as.factor(Completion_Table$Trial_Arm)


Completion_Table

Completion_Table$Completion_Rate <- Completion_Table$Completion_Rate * 100

# Building the GT table for its use in the shiny app.

gt_completion_table <-
    Completion_Table |>
    gt() |>
    gt_highlight_rows(
        rows = Survey == "Follow-Up",# a logic statement
        bold_target_only = TRUE,
        target_col = Survey
    ) |>
    fmt_number(
        columns = Completion_Rate,
        decimals = 2,
        use_seps = FALSE
    ) |>
    gt_plt_bar(column = Completion_Rate, keep_column = FALSE, width = 45,
               color = "#D3B1E0",
               scale_type = "number") |>
    tab_header(
        title = "Passport to Success - Completion Rates per School ID",
    ) |> cols_label(
        SCHOOL_ID = "School",
        Trial_Arm = "Group",
        Survey = "Survey Period",
        Completion_Rate = "Percentage Number")

gt_completion_table

# Building the shiny app.

ui <- fluidPage(titlePanel("Completion Rate Per School"),
                mainPanel(width = 12,
                          gt_output(outputId = "CompletionTable")
                ))

server <- function(input, output) {
    output$CompletionTable <- render_gt({
        gt_completion_table |>
            opt_interactive(use_search = T,use_filters = T)
    })
}


# Run the application
shinyApp(ui = ui, server = server)
