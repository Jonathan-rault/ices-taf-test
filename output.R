## Extract results of interest, write TAF output tables

## Before:
## After:


##### GETTING STOCK INFOS (stock name & years)

source("current-run-parameters.R")


##### LIBRARIES

library(icesTAF)
library(dplyr)
library(CREDO.utils)


##### MAKING OUTPUT FOLDER

icesTAF::mkdir("output")


##### PATH TO ALL BOOT/DATA USED

path_referentiels <- "./boot/data/REFS"


##### READING USEFULL TABLES FROM BOOT/DATA

refs <- path_referentiels |>
  my_referentiels_load(tables = c("stocks_ices", "stocks_ices_area"))


##### BUIDING ICES STOCK

current_stock <- stock |>
  stock_ices_infos_create(refs$stocks_ices, refs$stocks_ices_area)

input_dir <- paste("model", current_stock$ices_group, current_stock$name, sep = "/")


##### GETTING CURRENT STOCK DATA

raised_data <- readRDS(file = paste0(input_dir, "/", "raised_data.rds"))


##### SAVING FUNCTION

years_saving_outputs <- function(selected_years) {

  # selected_years <- 2021

  folder_name <- paste(range(selected_years), collapse = "-")

  output_dir <- paste("output", current_stock$ices_group, current_stock$name, folder_name, sep = "/")

  icesTAF::mkdir(output_dir)

  selected_strata <- raised_data$fishing_strata_list |>
    filter(ANNEE %in% selected_years) |>
    pull(ID_STRATE)

  sampling_infos <- raised_data$fishing_strata_list |>
    filter(ID_STRATE %in% id_strata_year) |>
    left_join(raised_data$fishing_strata_infos) |>
    select(ANNEE, ZONE, METIER_DCF5, FO_SAMPLED, N_SAMPLED_VAL_PR, N_SAMPLED_VAL_PNR)
  
  saveRDS(sampling_infos, file = paste0(output_dir, "/", "sampling_infos.rds"))

  size_structures <- raised_data$fishing_strata_list |>
    filter(ID_STRATE %in% id_strata_year) 

}


##### SAVING OUTPUTS

for(current_year in years) {

  years_saving_outputs(current_year)

}

years_saving_outputs(years)