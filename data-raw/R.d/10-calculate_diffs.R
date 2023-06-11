
ht <- readRDS(here::here("data-raw/work/02-rma_ht.rds"))
cmap <- readRDS(here::here("data-raw/work/05-annotation_cmap.rds"))

cmap <- cmap |>
  dplyr::rowwise() |>
  dplyr::mutate(
    diffs =
      if (perturbation_celfile %in% colnames(ht)) {
        z <- Biobase::exprs(ht[,perturbation_celfile]) -
          Biobase::exprs(ht[,vehicle_celfile])
        list(z)
      } else {
        z<-as.matrix(rep(0, nrow(ht)))
        rownames(z) <- rownames(ht)
        list(z)
      }
  )

saveRDS(cmap, file = here::here("data-raw/work/10-annotation_cmap.rds"))
