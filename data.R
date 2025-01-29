## Preprocess data, write TAF data tables

## Before:
## After:

##### GETTING STOCK INFOS (stock name & years)

source("current-run-parameters.R")


##### LIBRARIES

library(icesTAF)
library(dplyr)
library(CREDO.utils)


##### MAKING OUTPUT FOLDER

icesTAF::mkdir("data")


##### PATH TO BOOT/DATA USED

path_data_free3_obsmer <- "./boot/data/FREE3"
path_data_sacrois <- "./boot/data/SACROIS"
path_referentiels <- "./boot/data/REFS"


##### READING USEFULL TABLES FROM BOOT/DATA

refs <- path_referentiels |>
  my_referentiels_load(tables = c("stocks_ices", "stocks_ices_area"))


#### BUIDING ICES STOCK

current_stock <- stock |>
  stock_ices_infos_create(refs$stocks_ices, refs$stocks_ices_area)

ices_divisions <- current_stock$ices_area


##### ADDITIONAL PARAMETERS PARAMETERS

free3_strate_fields <- c("ANNEE", "ZONE", "METIER_DCF5")
sacrois_strate_fields <- c("ANNEE", "SECT_COD_SACROIS_NIV3", "METIER_DCF_5_COD")


##### READING DATA

free3_obsmer <- path_data_free3_obsmer |>
  entrepot_read_dataset("free3-obsmer", is_dataset_path = TRUE)

sacrois <- path_data_sacrois |>
  entrepot_open_dataset("sacrois", is_dataset_path = TRUE) |>
  filter(ANNEE %in% years) |>
  select(ANNEE, MAREE_DATE_RET, METIER_DCF_5_COD, SECT_COD_SACROIS_NIV3, SECT_COD_SACROIS_NIV5, ESP_COD_FAO, QUANT_POIDS_VIF_SACROIS) |>
  entrepot_collect_dataset()


##### PREPARING DATA : AT-SEA SAMPLING

free3_obsmer_subset <- free3_obsmer |>
  free3_obsmer_format_fields() |>
  free3_obsmer_rename_fields() |>
  free3_obsmer_filter_dcf_programs() |>
  free3_obsmer_filter_marees(ANNEE %in% years) |>
  free3_obsmer_add_season() |>
  free3_obsmer_filter_table("operation_peche", ZONE %in% ices_divisions, filter_marees = TRUE)

sampling_prep <- free3_obsmer_subset |>
  free3_raising_obsmer_prepare_data(
    species = current_stock$ifr_species,
    catch_cat = c("PR", "PNR"),
    reference_measure = current_stock$ifr_reference_measure,
    size_unit = current_stock$ifr_size_unit,
    fishing_strata_fields = free3_strate_fields,
    filter_valid = TRUE,
    use_only_weight = FALSE,
    output_details = TRUE
  )


##### PREPARING DATA : COMMERCIAL LANDINGS

sacrois_prep <- sacrois |>
  group_by_at(sacrois_strate_fields) |>
  summarize(LANDINGS_G = sum(QUANT_POIDS_VIF_SACROIS, na.rm = TRUE) * 1000) |>
  ungroup() |>
  dplyr::rename(!!!setNames(sacrois_strate_fields, free3_strate_fields))


##### SAVING OUTPUTS

output_dir <- paste("data", current_stock$ices_group, current_stock$name, sep = "/")

icesTAF::mkdir(output_dir)

saveRDS(sampling_prep, file = paste0(output_dir, "/", "sampling_prep.rds"))
saveRDS(sacrois_prep, file = paste0(output_dir, "/", "sacrois_prep.rds"))
