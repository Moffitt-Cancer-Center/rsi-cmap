x<-readRDS(file = here::here("data-raw/work/00-cmap_annotation.rds"))



celfiles <- tidyr::pivot_longer(x, cols=c("perturbation_scan_id","vehicle_scan_inferred"),
                                names_to="condition",
                                values_to="celfile") |>
  dplyr::mutate(
    celfile = paste0(here::here("data-raw/CEL"),"/", celfile, ".CEL.gz")
  )

present <- fs::file_exists(celfiles$celfile)
stopifnot(all(present))

# Uniquify for normalization
unique_cels <- celfiles |>
  dplyr::distinct(celfile, array3)

stopifnot(nrow(unique_cels) == length(fs::dir_ls(here::here("data-raw/CEL"))))


# The "array3" column indicates different platforms, so we need to normalize
# each independently.

u133 <- unique_cels |> dplyr::filter(array3=="HG-U133A")
rma_u133 <- affy::just.rma(
  filenames = u133$celfile,
  phenoData = Biobase::AnnotatedDataFrame(
    u133 |>
      dplyr::mutate(rn = basename(celfile)) |>
      tibble::column_to_rownames("rn"))
)
saveRDS(rma_u133, file = here::here("data-raw/work/01-rma_u133.rds"))

ea <- unique_cels |> dplyr::filter(array3=="HT_HG-U133A_EA")
rma_ea <-affy::just.rma(
  filenames = ea$celfile,
  phenoData = Biobase::AnnotatedDataFrame(
    ea |>
      dplyr::mutate(rn = basename(celfile)) |>
      tibble::column_to_rownames("rn")
  )
)
saveRDS(rma_ea, file=here::here("data-raw/work/01-rma_ea.rds"))


ht <- unique_cels |> dplyr::filter(array3=="HT_HG-U133A")
rma_ht <-affy::just.rma(
  filenames = ht$celfile,
  phenoData = Biobase::AnnotatedDataFrame(
    ht |>
      dplyr::mutate(rn = basename(celfile)) |>
      tibble::column_to_rownames("rn")
  )
)
saveRDS(rma_ht, file=here::here("data-raw/work/01-rma_ht.rds"))
