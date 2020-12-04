

# Additional variables from mainly SHF ------------------------------------

fixdata <- function(data) {
  dataout <- data %>%
    mutate(
      shf_ferrocarboxymaltosisnum = if_else(shf_ferrocarboxymaltosis == "Yes", 1, 0),

      # Anemia
      shf_anemia = case_when(
        is.na(shf_hb) ~ NA_character_,
        shf_sex == "Female" & shf_hb < 120 | shf_sex == "Male" & shf_hb < 130 ~ "Yes",
        TRUE ~ "No"
      ),
      # iron def
      shf_id = case_when(
        shf_ferritin < 100 ~ "Yes",
        shf_ferritin <= 299 & shf_transferrin < 20 ~ "Yes",
        TRUE ~ "No"
      ),
      shf_aid = factor(case_when(
        shf_id == "Yes" & shf_anemia == "Yes" ~ 4,
        shf_id == "Yes" & shf_anemia == "No" ~ 3,
        shf_id == "No" & shf_anemia == "Yes" ~ 2,
        shf_id == "No" & shf_anemia == "No" ~ 1
      ),
      levels = 1:4,
      labels = c("A-/ID-", "A+/ID-", "A-/ID+", "A+/ID+")
      ),

      shf_age_cat = case_when(
        shf_age < 75 ~ "<75",
        shf_age >= 75 ~ ">=75"
      ),

      shf_ef_cat = factor(case_when(
        shf_ef == ">=50" ~ 3,
        shf_ef == "40-49" ~ 2,
        shf_ef %in% c("30-39", "<30") ~ 1
      ),
      labels = c("HFrEF", "HFmrEF", "HFpEF"),
      levels = 1:3
      ),

      shf_indexmonth = as.numeric(factor(ym(paste0(shf_indexyear, month(shf_indexdtm))))),
      shf_indexyear = as.factor(shf_indexyear),

      shf_smoking_cat = factor(case_when(
        shf_smoking %in% c("Never") ~ 1,
        shf_smoking %in% c("Former", "Current") ~ 2
      ),
      labels = c("Never", "Former/Current"),
      levels = 1:2
      ),

      shf_map_cat = case_when(
        shf_map <= 90 ~ "<=90",
        shf_map > 90 ~ ">90"
      ),

      shf_potassium_cat = factor(
        case_when(
          is.na(shf_potassium) ~ NA_real_,
          shf_potassium < 3.5 ~ 2,
          shf_potassium <= 5 ~ 1,
          shf_potassium > 5 ~ 3
        ),
        labels = c("normakalemia", "hypokalemia", "hyperkalemia"),
        levels = 1:3
      ),

      shf_heartrate_cat = case_when(
        shf_heartrate <= 70 ~ "<=70",
        shf_heartrate > 70 ~ ">70"
      ),

      shf_device_cat = factor(case_when(
        is.na(shf_device) ~ NA_real_,
        shf_device %in% c("CRT", "CRT & ICD", "ICD") ~ 2,
        TRUE ~ 1
      ),
      labels = c("No", "CRT/ICD"),
      levels = 1:2
      ),

      shf_bmi_cat = case_when(
        is.na(shf_bmi) ~ NA_character_,
        shf_bmi < 30 ~ "<30",
        shf_bmi >= 30 ~ ">=30"
      ),

      shf_gfrckdepi_cat = factor(case_when(
        is.na(shf_gfrckdepi) ~ NA_real_,
        shf_gfrckdepi >= 60 ~ 1,
        shf_gfrckdepi < 60 ~ 2,
      ),
      labels = c(">=60", "<60"),
      levels = 1:2
      ),

      shf_sos_com_af = case_when(
        sos_com_af == "Yes" |
          shf_af == "Yes" |
          shf_ekg == "Atrial fibrillation" ~ "Yes",
        TRUE ~ "No"
      ),

      shf_sos_com_ihd = case_when(
        sos_com_ihd == "Yes" |
          shf_revasc == "Yes" |
          sos_com_pci == "Yes" |
          sos_com_cabg == "Yes" ~ "Yes",
        TRUE ~ "No"
      ),

      shf_sos_com_hypertension = case_when(
        shf_hypertension == "Yes" |
          sos_com_hypertension == "Yes" ~ "Yes",
        TRUE ~ "No"
      ),

      shf_sos_com_diabetes = case_when(
        shf_diabetes == "Yes" |
          sos_com_diabetes == "Yes" ~ "Yes",
        TRUE ~ "No"
      ),
      # Outcomes

      # composite outcome
      sos_out_deathhosphf = case_when(
        sos_out_death == "Yes" |
          sos_out_hosphf == "Yes" ~ "Yes",
        TRUE ~ "No"
      )
    )


  # income

  inc <- dataout %>%
    group_by(shf_indexyear) %>%
    summarise(incmed = quantile(scb_dispincome,
      probs = 0.5,
      na.rm = TRUE
    ), .groups = "drop_last")

  dataout <- left_join(
    dataout,
    inc,
    by = "shf_indexyear"
  ) %>%
    mutate(
      scb_dispincome_cat2 = case_when(
        scb_dispincome < incmed ~ 1,
        scb_dispincome >= incmed ~ 2
      ),
      scb_dispincome_cat2 = factor(scb_dispincome_cat2,
        levels = 1:2,
        labels = c("Below medium", "Above medium")
      )
    ) %>%
    select(-incmed)

  # ntprobnp

  ntprobnp <- dataout %>%
    group_by(shf_ef_cat) %>%
    summarise(
      ntmed = quantile(shf_ntpropbnp,
        probs = 0.5,
        na.rm = TRUE
      ),
      .groups = "drop_last"
    )

  dataout <- left_join(
    dataout,
    ntprobnp,
    by = c("shf_ef_cat")
  ) %>%
    mutate(
      shf_ntpropbnp_cat = case_when(
        shf_ntpropbnp < ntmed ~ 1,
        shf_ntpropbnp >= ntmed ~ 2
      ),
      shf_ntpropbnp_cat = factor(shf_ntpropbnp_cat,
        levels = 1:2,
        labels = c("Below medium", "Above medium")
      )
    ) %>%
    select(-ntmed)

  dataout <- dataout %>%
    mutate_if(is_character, factor)
}


pdata <- fixdata(pdata)
pdata_tf <- fixdata(pdata_tf)

pdata_tf <- pdata_tf %>%
  mutate(
    shf_tf = factor(case_when(
      !is.na(shf_transferrin) & !is.na(shf_ferritin) ~ 4,
      is.na(shf_transferrin) & !is.na(shf_ferritin) ~ 3,
      !is.na(shf_transferrin) & is.na(shf_ferritin) ~ 2,
      is.na(shf_transferrin) & is.na(shf_ferritin) ~ 1,
    ),
    levels = 1:4,
    labels = c(
      "Transferrin-/Ferritin-",
      "Transferrin+/Ferritin-",
      "Transferrin-/Ferritin+",
      "Transferrin+/Ferritin+"
    )
    ),
    shf_tf2 = factor(case_when(
      shf_tf == "Transferrin-/Ferritin-" ~ "No",
      TRUE ~ "Yes"
    ))
  )