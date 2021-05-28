
# Additional variables from NPR -------------------------------------------

sosvarfunc <- function(data) {
  data <- data %>%
    mutate(censdtm = shf_indexdtm + sos_outtime_death)

  data <- create_sosvar(
    sosdata = patreg %>% filter(sos_source == "sv"),
    cohortdata = data,
    patid = LopNr,
    indexdate = shf_indexdtm,
    sosdate = INDATUM,
    diavar = HDIA,
    type = "out",
    noof = TRUE,
    name = "nohosphf",
    diakod = " I110| I130| I132| I255| I420| I423| I425| I426| I427| I428| I429| I43| I50| J81| K761| R57",
    censdate = censdtm,
    valsclass = "num",
    warnings = FALSE,
    meta_reg = "NPR (in)"
  )

  data <- create_sosvar(
    sosdata = patreg %>% filter(sos_source == "sv"),
    cohortdata = data,
    patid = LopNr,
    indexdate = shf_indexdtm,
    sosdate = INDATUM,
    diavar = HDIA,
    noof = TRUE,
    type = "out",
    name = "nohospany",
    diakod = " ",
    censdate = censdtm,
    valsclass = "num",
    warnings = FALSE,
    meta_reg = "NPR (in)"
  )

  data <- create_sosvar(
    sosdata = patreg %>% filter(sos_source == "ov"),
    cohortdata = data,
    patid = LopNr,
    indexdate = shf_indexdtm,
    sosdate = INDATUM,
    diavar = HDIA,
    type = "out",
    noof = TRUE,
    name = "novishf",
    diakod = " I110| I130| I132| I255| I420| I423| I425| I426| I427| I428| I429| I43| I50| J81| K761| R57",
    censdate = censdtm,
    valsclass = "num",
    warnings = FALSE,
    meta_reg = "NPR (out)"
  )

  data <- create_sosvar(
    sosdata = patreg %>% filter(sos_source == "ov"),
    cohortdata = data,
    patid = LopNr,
    indexdate = shf_indexdtm,
    sosdate = INDATUM,
    diavar = HDIA,
    type = "out",
    noof = FALSE,
    name = "vishf",
    diakod = " I110| I130| I132| I255| I420| I423| I425| I426| I427| I428| I429| I43| I50| J81| K761| R57",
    censdate = censdtm,
    valsclass = "num",
    warnings = FALSE,
    meta_reg = "NPR (out)"
  )

  data <- data %>%
    mutate(sos_out_vishf = factor(if_else(sos_out_vishf == 1, "Yes", "No")))
}

pdata <- sosvarfunc(pdata)
pdata_tf <- sosvarfunc(pdata_tf)
