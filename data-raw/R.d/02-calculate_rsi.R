# 02-calculate_rsi

u133 <- readRDS(file = here::here("data-raw/work/01-rma_u133.rds"))
oa <- Biobase::annotation(u133)
Biobase::annotation(u133)<-"hgu133plus2"
u133$rsi <- rsi::rsi(u133)
Biobase::annotation(u133)<-oa
saveRDS(u133, file = here::here("data-raw/work/02-rma_u133.rds"))

ea <- readRDS(file=here::here("data-raw/work/01-rma_ea.rds"))
oa <- Biobase::annotation(ea)
Biobase::annotation(ea)<-"hgu133plus2"
ea$rsi <- rsi::rsi(ea)
Biobase::annotation(ea)<-oa
saveRDS(ea, file = here::here("data-raw/work/02-rma_ea.rds"))


ht <- readRDS(file=here::here("data-raw/work/01-rma_ht.rds"))
oa <- Biobase::annotation(ht)
Biobase::annotation(ht)<-"hgu133plus2"
ht$rsi <- rsi::rsi(ht)
Biobase::annotation(ht)<-oa
saveRDS(ht, file = here::here("data-raw/work/02-rma_ht.rds"))

