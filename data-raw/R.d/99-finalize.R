# 99-finalize

projcycle::use_data(here::here("data-raw/work/05-annotation_cmap.rds"))
projcycle::use_data(here::here("data-raw/work/01-rma_ea.rds"))
projcycle::use_data(here::here("data-raw/work/01-rma_ht.rds"))
projcycle::use_data(here::here("data-raw/work/01-rma_u133.rds"))

projcycle::use_data(here::here("data-raw/work/10-cmap_no_expression.arrow"), dest = "cmap.arrow", data_dir="reports/Explorer")
