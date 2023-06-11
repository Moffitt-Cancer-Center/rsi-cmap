# 05-merge_annotation

x<-readRDS(file = here::here("data-raw/work/00-cmap_annotation.rds")) |>
  dplyr::mutate(
    perturbation_celfile = paste0(perturbation_scan_id,".CEL.gz"),
    vehicle_celfile = paste0(vehicle_scan_inferred, ".CEL.gz")
  )

u133 <- readRDS(here::here("data-raw/work/02-rma_u133.rds"))
ea <- readRDS(here::here("data-raw/work/02-rma_ea.rds"))
ht <- readRDS(here::here("data-raw/work/02-rma_ht.rds"))
p <- dplyr::bind_rows(
  Biobase::pData(u133),
  Biobase::pData(ea),
  Biobase::pData(ht)
) |>
  dplyr::rename(celfile_path = celfile) |>
  tibble::rownames_to_column("celfile")


x <- x |>
  dplyr::left_join(
      dplyr::rename_with(p, \(.x){paste0("vehicle_",.x)}),
    by = c("vehicle_celfile"="vehicle_celfile")
  ) |>
  dplyr::left_join(
    dplyr::rename_with(p, \(.x){paste0("perturbation_",.x)}),
    by = c("perturbation_celfile" = "perturbation_celfile")
  ) |>
  dplyr::mutate(
    deltaRSI = perturbation_rsi - vehicle_rsi
  )

saveRDS(x, file = here::here("data-raw/work/05-annotation_cmap.rds"))
