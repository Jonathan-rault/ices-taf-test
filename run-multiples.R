year_start <- 2020
year_end <- 2023

stocks <- c(
  "sol.27.7h-k", 
  "sol.27.8ab",
  "bss.27.8ab"
)

for(stock in stocks) {

  single_run_parameters <- paste0("years <- seq(", year_start, ", ", year_end, ")")
  single_run_parameters[2] <- paste0("stock <- \"", stock, "\"")
 
  writeLines(single_run_parameters, "current-run-parameters.R")

  icesTAF::source.all(clean = FALSE) # FALSE : otherwise erase other stock outputs

}