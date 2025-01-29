#' Title
#'
#' Description
#'
#' @return result
#'
#' @export
#'
get_boot_data_path <- function() {

  path <- list(
    free3_obsmer = "./boot/data/FREE3",
    sacrois = "./boot/data/SACROIS",
    referentiels = "./boot/data/REFS"
  )

  return(path)

}


#' Title
#'
#' Description
#'
#' @param stock description
#'
#' @return result
#'
#' @export
#'
compute_stock_taf_path <- function(stock_infos, years) {

  sub_folder <- paste(stock_infos$ices_group, stock_infos$name, sep = "/")

  res <- list(
    data = paste("data", sub_folder, sep = "/"),
    model = paste("model", sub_folder, sep = "/"),
    output = paste("output", sub_folder, sep = "/"),
    report = paste("report", sub_folder, sep = "/")
  )

  folder_name <- paste(range(years), collapse = "-")

  res$output_series <- paste(res$output, folder_name, sep = "/")

  return(res)

}