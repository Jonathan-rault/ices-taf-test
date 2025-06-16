## Run analysis, write model results

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

icesTAF::mkdir("model")


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

sampling_prep <- readRDS(file = paste0(stock_path$data, "/", "sampling_prep.rds"))
sacrois_prep <- readRDS(file = paste0(stock_path$data, "/", "sacrois_prep.rds"))


##### raising data

data_raise_prep <- sampling_prep |>
  free3_raising_obsmer_raise_samples(population_fields = "SEXE")

raised_landings <- data_raise_prep |>
  free3_raising_raise_to_landings(sacrois_prep, field_landings = "LANDINGS_G")


##### SAVING OUTPUTS

output_dir <- stock_path$model

icesTAF::mkdir(output_dir)

saveRDS(raised_landings, file = paste0(output_dir, "/", "raised_data.rds"))