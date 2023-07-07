#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Shim for MCC biostools server: locally installed arrow package.
.libPaths(c("/home/eschris/R/x86_64-pc-linux-gnu-library/4.0",.libPaths()))
library(shiny)

# Load the object to browse through
cmap_table <- arrow::read_feather("cmap.arrow") |>
  dplyr::select(cmap_name, cell2, vehicle_rsi,perturbation_rsi,deltaRSI, dplyr::everything()) |>
  dplyr::arrange(deltaRSI)

if ( tibble::has_rownames(cmap_table))
  cmap_table <- tibble::rownames_to_column(cmap_table)

# Define UI
ui <- fluidPage(

  # Simple page with download buttons and table view.
  wellPanel(
    fluidRow(
      column(width = 12,
             paste("From this application, you can navigate through the data dynamically. The table can be sorted by clicking on a ",
                   "column name and filtered by clicking on the textbox. Note that filtering may be discrete (list all matching entries) ",
                   "or a range (if numeric)."
             )))),

  # Download buttons as a row. Icons are font-awesome icons.
    fluidRow(
      downloadButton("xlsx", label=".xlsx",icon=shiny::icon("file-excel")),
      downloadButton("tsv",label=".tsv",icon=shiny::icon("file-lines")),
      downloadButton("csv",label=".csv",icon=shiny::icon("file-csv")),
      downloadButton("robj", label=".rds",icon=shiny::icon("r-project"))
    ),
    hr(),

    # Show Data Table (DT) output
    fluidRow(
      column(
        width=12,
        DT::DTOutput("cmap")
      )
    )
  )







# Define server logic
server <- function(input, output) {

  # DataTable
  # include filter and 100 entries per page
  output$cmap <- DT::renderDT(cmap_table, filter='top', options=list(lengthChange=FALSE,pageLength = 100, autoWidth = TRUE))

  # Downloaders
  output$csv <- downloadHandler(
    filename = paste0("rsi_cmap_",Sys.Date(),".csv"),
    content = function(file) {
      readr::write_excel_csv(cmap_table,file = file)
    }
  )
  output$tsv <- downloadHandler(
    filename = paste0("rsi_cmap_",Sys.Date(),".tsv"),
    content = function(file) {
      readr::write_tsv(cmap_table,file = file)
    }
  )

  output$xlsx <- downloadHandler(
    filename = paste0("rsi_cmap_",Sys.Date(),".xlsx"),
    content = function(file) {
      openxlsx::write.xlsx(cmap_table,file = file)
    }

  )

  output$robj <- downloadHandler(
    filename = paste0("rsi_cmap_",Sys.Date(),".rds"),
    content = function(file) {
      saveRDS(cmap_table, file = file)
    }
  )
}

# Run the application
shinyApp(ui = ui, server = server)

