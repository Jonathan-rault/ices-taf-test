## Run analysis, write model results

## Before:
## After:


##### GETTING STOCK INFOS (stock name & years)

source("current-run-parameters.R")


##### LIBRARIES

library(icesTAF)
library(dplyr)
library(CREDO.utils)


##### MAKING OUTPUT FOLDER

icesTAF::mkdir("model")


##### PATH TO ALL BOOT/DATA USED

path_referentiels <- "./boot/data/REFS"


##### READING USEFULL TABLES FROM BOOT/DATA

refs <- path_referentiels |>
  my_referentiels_load(tables = c("stocks_ices", "stocks_ices_area"))


##### BUIDING ICES STOCK

current_stock <- stock |>
  stock_ices_infos_create(refs$stocks_ices, refs$stocks_ices_area)

input_dir <- paste("data", current_stock$ices_group, current_stock$name, sep = "/")


##### GETTING CURRENT STOCK DATA

sampling_prep <- readRDS(file = paste0(input_dir, "/", "sampling_prep.rds"))
sacrois_prep <- readRDS(file = paste0(input_dir, "/", "sacrois_prep.rds"))


##### raising data

data_raise_prep <- sampling_prep |>
  free3_raising_obsmer_raise_to_sampled_marees(population_fields = "ESPECE")

raised_landings <- data_raise_prep |>
  free3_raising_raise_to_landings(sacrois_prep, field_landings = "LANDINGS_G")


##### SAVING OUTPUTS

output_dir <- paste("model", current_stock$ices_group, current_stock$name, sep = "/")

icesTAF::mkdir(output_dir)

saveRDS(raised_landings, file = paste0(output_dir, "/", "raised_data.rds"))