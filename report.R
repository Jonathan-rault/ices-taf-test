## Prepare plots and tables for report

## Before:
## After:

##### GETTING STOCK INFOS (stock name & years)

source("current-run-parameters.R")


##### LIBRARIES

library(icesTAF)
library(dplyr)
library(CREDO.utils)


##### MAKING OUTPUT FOLDER

icesTAF::mkdir("report")


##### PATH TO ALL BOOT/DATA USED

path_referentiels <- "./boot/data/REFS"


##### READING USEFULL TABLES FROM BOOT/DATA

refs <- path_referentiels |>
  my_referentiels_load(tables = c("stocks_ices", "stocks_ices_area"))


##### BUIDING ICES STOCK

current_stock <- stock |>
  stock_ices_infos_create(refs$stocks_ices, refs$stocks_ices_area)


##### INPUT DATA

folder_name <- paste(range(years) |> unique(), collapse = "-")

input_dir <- paste("output", current_stock$ices_group, current_stock$name, folder_name, sep = "/")


##### GETTING CURRENT STOCK DATA

sampling_infos <- readRDS(file = paste0(input_dir, "/", "sampling_infos.rds"))
size_structures <- readRDS(file = paste0(input_dir, "/", "size_structures.rds"))


##### CREATING OUTPUT DIRECTORY

output_dir <- paste("report", current_stock$ices_group, current_stock$name, sep = "/")

icesTAF::mkdir(output_dir)


##### SAVING SOME TABLES

summary_samples <- sampling_infos |>
  group_by(ANNEE, ZONE) |>
  summarize_at(c("FO_SAMPLED", "N_SAMPLED_VAL_PR", "N_SAMPLED_VAL_PNR"), sum) |>
  ungroup()

icesTAF::write.taf(summary_samples, dir = output_dir, quote = TRUE)
