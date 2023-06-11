x<-readxl::read_xls(
  here::here("data-raw/cmap_instances_02.xls"),
  col_types=c("numeric","text",
              "text","text",
              "numeric","numeric",
              rep("text",9)),
  range = "A1:O6101"
) |>
  dplyr::mutate(
    perturbation_scan_id =
      stringi::stri_replace(perturbation_scan_id, "", regex = "^'"),
    vehicle_scan_id4 =
      stringi::stri_replace(vehicle_scan_id4, "", regex = "^'")
  )

# Per the excel file, the vehicle scan can begin with a '.', which
# indicates that the same prefix from the perturbation scan should
# be used for all of the .-separated vehicle scans. Here, for
# convenience, we will put together the prefix (from the perturbation scan)
# with the matched vehicle scan having the same letter-series.
# For instance, in the case of "xxxxx.H02", we would pair the vehicle
# control of "xxxxxx.H01". And "xxxxx.G03" with "xxxxx.G02".

match_it <- function(vehicle, perturbation) {
  ifelse(
    stringr::str_starts(vehicle, "\\."),
    {
      # Vehicle options are the vehicle extensions that would work for a p
      vehicle_options <- stringi::stri_split(vehicle, regex="\\.", omit_empty=TRUE)
      # Perturbation options are stem + extensions
      perturbation_options <- stringi::stri_split(perturbation, regex="\\.",
                                               omit_empty=TRUE)
      # Stem will be added to vehicle
      pstem <- purrr::map_chr(perturbation_options,1)
      # pext will be used to match to appropriate vehicle
      pext <- purrr::map(
        perturbation_options,
        \(.x) {
          if (is.null(.x))
            ""
          else
            stringi::stri_sub(.x[2], from = 1L, to = 1L)
        }
      )
      vext <- purrr::map2_chr(pext, vehicle_options, \(.x,.y) {
        z <- .y[stringi::stri_startswith(.y, fixed =.x)]
        if (length(z) == 0)
          .y[1]
        else
          z
      })
      # Finally! Put the stem and vehicle
      paste(pstem, vext,sep=".")
    },
    vehicle
  )
}
x <- x |>
  dplyr::mutate(
    vehicle_scan_inferred = match_it(vehicle_scan_id4, perturbation_scan_id)
  )
saveRDS(x, file = here::here("data-raw/work/00-cmap_annotation.rds"))

