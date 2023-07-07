x <- readRDS(here::here("data-raw/work/05-annotation_cmap.rds")) |>
  dplyr::select(-diffs)

arrow::write_feather(x, here::here("data-raw/work/10-cmap_no_expression.arrow"))

