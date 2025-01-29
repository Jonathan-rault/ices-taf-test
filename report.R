source("report_prep.R")

library(rmarkdown)

source("r-utils/utils-report.R")

# rmarkdown::render(
#   input = "report_docx.Rmd",
#   output_file = "report.docx",
#   encoding = "UTF-8",
#   output_dir = paste0(output_dir, "/docx")
# )

rmarkdown::render(
  input = "report_pdf.Rmd",
  encoding = "UTF-8",
  output_dir = paste0(stock_path$report, "/pdf")
)
