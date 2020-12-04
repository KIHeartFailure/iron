

# Variables for tabs/mods -------------------------------------------------

tabvars <- c(
  # demo
  "shf_sex",
  "shf_age",
  "shf_age_cat",
  "shf_location",
  "shf_indexyear",

  "shf_transferrin",
  "shf_ferritin",
  "shf_id",
  "shf_hb",
  "shf_anemia",
  "shf_aid",
  "shf_ferrocarboxymaltosis",
  "shf_ferrocarboxymaltosisdose",

  # clinical factors and lab measurments
  "shf_ef_cat",
  "shf_durationhf",
  "shf_nyha",

  "shf_map",
  "shf_map_cat",
  "shf_bpsys",
  "shf_bpdia",
  "shf_heartrate",
  "shf_heartrate_cat",
  "shf_bmi",
  "shf_bmi_cat",
  "shf_qrs",
  "shf_lbbb",
  "shf_potassium",
  "shf_potassium_cat",
  "shf_gfrckdepi",
  "shf_gfrckdepi_cat",
  "shf_ntpropbnp",
  "shf_ntpropbnp_cat",

  # comorbs
  "shf_smoking_cat",
  "shf_sos_com_diabetes",
  "shf_sos_com_af",
  "shf_sos_com_ihd",
  "shf_sos_com_hypertension",
  "sos_com_peripheralartery",
  "sos_com_stroke",
  "sos_com_valvular",
  "sos_com_liver",
  "sos_com_cancer3y",
  "sos_com_copd",
  "sos_com_bleed",
  "sos_com_charlsonci",

  # treatments
  "shf_rasarni",
  "shf_bbl",
  "shf_mra",
  "shf_device_cat",
  "shf_diuretic",
  "shf_digoxin",
  "shf_asaantiplatelet",
  "shf_anticoagulantia",
  "shf_statin",
  "shf_nitrate",

  # organizational
  "shf_followuphfunit",
  "shf_followuplocation",

  # socec
  "scb_famtype",
  "scb_child",
  "scb_education",
  "scb_dispincome_cat2"
)

# vars fox log reg and cox reg
tabvars_not_in_mod <- c(
  "shf_indexyear",

  "shf_transferrin",
  "shf_ferritin",
  "shf_id",
  "shf_hb",
  "shf_anemia",
  "shf_aid",
  "shf_ferrocarboxymaltosis",
  "shf_ferrocarboxymaltosisdose",

  "shf_bpsys",
  "shf_bpdia",

  "shf_age",
  "shf_map",
  "shf_heartrate",
  "shf_bmi",
  "shf_qrs",
  "shf_lbbb",
  "shf_potassium_cat",
  "shf_potassium",
  "shf_gfrckdepi",
  "shf_ntpropbnp",

  "sos_com_charlsonci"
)

modvars <- c(tabvars[!(tabvars %in% tabvars_not_in_mod)], "shf_indexmonth")

modvars_fcm <- c(modvars, "shf_anemia")

modvars_tf <- c(modvars, "shf_anemia")
