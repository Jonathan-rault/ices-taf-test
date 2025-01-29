## Prepare plots and tables for report

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

icesTAF::mkdir("report")


##### PATH TO BOOT/DATA USED

path_data <- get_boot_data_path()


##### READING USEFULL TABLES FROM BOOT/DATA

refs <- path_data$referentiels |>
  my_referentiels_load(tables = c("stocks_ices", "stocks_ices_area"))


#### BUIDING ICES STOCK

current_stock <- stock |>
  stock_ices_infos_create(refs$stocks_ices, refs$stocks_ices_area)

stock_path <- current_stock |>
  compute_stock_taf_path(years)


##### GETTING CURRENT STOCK DATA

sampling_infos <- readRDS(file = paste0(stock_path$output_series, "/", "sampling_infos.rds"))
size_structures <- readRDS(file = paste0(stock_path$output_series, "/", "size_structures.rds"))


##### CREATING OUTPUT DIRECTORY

output_dir <- stock_path$report

icesTAF::mkdir(output_dir)
icesTAF::mkdir(paste0(output_dir, "/elements"))
icesTAF::mkdir(paste0(output_dir, "/docx"))
icesTAF::mkdir(paste0(output_dir, "/pdf"))


##### SAVING SOME TABLES

summary_samples <- sampling_infos |>
  group_by(ANNEE, ZONE) |>
  summarize_at(c("FO_SAMPLED", "N_SAMPLED_VAL_PR", "N_SAMPLED_VAL_PNR"), sum) |>
  ungroup()

icesTAF::write.taf(summary_samples, dir = paste0(output_dir, "/elements"), quote = TRUE)
