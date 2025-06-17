## Preprocess data, write TAF data tables

## Before:
## After:

##### GETTING STOCK INFOS (stock name & years)

source("current-run-parameters.R")
source("r-utils/utils-path.R")


##### LIBRARIES

library(icesTAF)
library(dplyr)
library(CREDO.utils)


##### WHEN AVAILABLE IN BOOT LIBRARIES

# taf.library(CREDO.utils)


##### MAKING OUTPUT FOLDER

icesTAF::mkdir("data")


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


##### ADDITIONAL PARAMETERS PARAMETERS

free3_strate_fields <- c("ANNEE", "ZONE", "METIER_DCF5")
sacrois_strate_fields <- c("ANNEE", "SECT_COD_SACROIS_NIV3", "METIER_DCF_5_COD")


##### READING DATA

free3_obsmer <- path_data$free3_obsmer |>
  datalake_read("free3-obsmer", is_dataset_path = TRUE)

sacrois <- path_data$sacrois |>
  datalake_open("sacrois", is_dataset_path = TRUE) |>
  filter(ANNEE %in% years) |>
  select(ANNEE, MAREE_DATE_RET, METIER_DCF_5_COD, SECT_COD_SACROIS_NIV3, SECT_COD_SACROIS_NIV5, ESP_COD_FAO, QUANT_POIDS_VIF_SACROIS) |>
  datalake_collect()


##### PREPARING DATA : AT-SEA SAMPLING

free3_obsmer_subset <- free3_obsmer |>
  free3_obsmer_format_fields() |>
  free3_obsmer_rename_fields() |>
  free3_obsmer_filter_dcf_programs() |>
  free3_obsmer_filter_marees(ANNEE %in% years) |>
  free3_obsmer_add_season() |>
  free3_obsmer_filter_table("operation_peche", ZONE %in% current_stock$ices_area, filter_marees = TRUE) |>
  free3_obsmer_add_efforts()

sampling_prep <- free3_obsmer_subset |>
  free3_raising_obsmer_prepare_data(
    species = current_stock$ices_species,
    catch_cat = c("PR"),
    reference_measure = NULL,
    size_unit = "cm",
    fishing_strata_fields = free3_strate_fields,
    filter_valid = TRUE,
    use_only_weight = FALSE,
    output_details = FALSE
  )

##### PREPARING DATA : COMMERCIAL LANDINGS

sacrois_prep <- sacrois |>
  filter(ESP_COD_FAO %in% current_stock$taxa_fao) |>
  filter(SECT_COD_SACROIS_NIV3 %in% current_stock$ices_area) |>
  group_by_at(sacrois_strate_fields) |>
  summarize(LANDINGS_G = sum(QUANT_POIDS_VIF_SACROIS, na.rm = TRUE) * 1000) |>
  ungroup() |>
  dplyr::rename(!!!setNames(sacrois_strate_fields, free3_strate_fields))


##### SAVING OUTPUTS

output_dir <- stock_path$data

icesTAF::mkdir(output_dir)

saveRDS(sampling_prep, file = paste0(output_dir, "/", "sampling_prep.rds"))
saveRDS(sacrois_prep, file = paste0(output_dir, "/", "sacrois_prep.rds"))
