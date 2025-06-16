## Extract results of interest, write TAF output tables

## Before:
## After:


##### GETTING STOCK INFOS (stock name & years)

source("current-run-parameters.R")
source("r-utils/utils-path.R")


##### LIBRARIES

library(icesTAF)
library(dplyr)
library(CREDO.utils)


##### MAKING OUTPUT FOLDER

icesTAF::mkdir("output")


##### PATH TO BOOT/DATA USED

path_data <- get_boot_data_path()


##### READING USEFULL TABLES FROM BOOT/DATA

refs <- path_data$referentiels |>
  my_referentiels_load(tables = c("stocks_ices", "stocks_ices_area"))


#### BUIDING ICES STOCK

current_stock <- stock |>
  stock_ices_object_create(refs$stocks_ices, refs$stocks_ices_area)

stock_path <- current_stock |>
  compute_stock_taf_path(years)


##### GETTING CURRENT STOCK DATA

raised_data <- readRDS(file = paste0(stock_path$model, "/", "raised_data.rds"))


##### SAVING FUNCTION

years_saving_outputs <- function(selected_years) {

  # selected_years <- 2021

  folder_name <- paste(range(selected_years) |> unique(), collapse = "-")

  output_dir <- paste(stock_path$output, folder_name, sep = "/")

  icesTAF::mkdir(output_dir)

  selected_strata <- raised_data$fishing_strata_list |>
    filter(ANNEE %in% selected_years) |>
    pull(ID_STRATE)

  sampling_infos <- raised_data$fishing_strata_list |>
    left_join(raised_data$fishing_strata_infos, by = "ID_STRATE") |>
    filter(ID_STRATE %in% selected_strata) |>
    left_join(raised_data$fishing_strata_infos) |>
    select(ANNEE, ZONE, METIER_DCF5, FO_VAL_SPP, N_SAMPLED_VAL)
  
  saveRDS(sampling_infos, file = paste0(output_dir, "/", "sampling_infos.rds"))

  size_structures <- raised_data$fishing_strata_list |>
    filter(ID_STRATE %in% selected_strata) |>
    left_join(raised_data$full_strata_measures)

  saveRDS(size_structures, file = paste0(output_dir, "/", "size_structures.rds"))

}


##### SAVING OUTPUTS

for(current_year in years) {

  years_saving_outputs(current_year)

}

years_saving_outputs(years)