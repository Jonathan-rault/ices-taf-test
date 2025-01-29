## QUESTION : if package has unknown dependancies : install them before ? what is unknown ? renv ?

icesTAF::taf.library("TEST.PACKAGE")

library(CREDO.utils)
library(dplyr)

my_sample_data <- TEST.PACKAGE::my_function()

api_data <- icesVocab::getCodeList("ICES_StockCode") |>
  filter(!Deprecated) |>
  select(Key, Description) 

icesTAF::mkdir("../DATA_OTHERS")
icesTAF::write.taf(my_sample_data, dir = "../DATA_OTHERS", file = "my_data.csv")
icesTAF::write.taf(api_data, quote=TRUE, dir = "../DATA_OTHERS", file = "stock_list.csv")

