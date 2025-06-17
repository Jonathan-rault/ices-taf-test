## loading a taf used package (see SOFTWARE.bib)
icesTAF::taf.library("TEST.PACKAGE")

#library(CREDO.utils) # my package
library(dplyr)

## get a sample data table from my own package
my_sample_data <- TEST.PACKAGE::my_function()

## get a sample data table using ICES API
api_data <- icesVocab::getCodeList("ICES_StockCode") |>
  filter(!Deprecated) |>
  select(Key, Description) 

## saving both samples data
icesTAF::mkdir("../DATA_OTHERS")
icesTAF::write.taf(my_sample_data, dir = "../DATA_OTHERS", file = "my_data.csv", quote = FALSE)
icesTAF::write.taf(api_data, quote=TRUE, dir = "../DATA_OTHERS", file = "stock_list.csv")

