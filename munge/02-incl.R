

# Inclusion/exclusion criteria --------------------------------------------------------

pdata <- rsdata320 %>%
  filter(casecontrol == "Case")

flow <- c("Number of posts (cases) in SHFDB3", nrow(pdata))

pdata <- pdata %>%
  filter(shf_indexdtm >= ymd("2017-01-01"))
flow <- rbind(flow, c("Indexdate >= 1 Jan 2017 (ferritin/transferrin collected during this time)", nrow(pdata)))

pdata <- pdata %>%
  filter(!is.na(shf_transferrin) & !is.na(shf_ferritin) & !is.na(shf_ferrocarboxymaltosis) & !is.na(shf_hb))
flow <- rbind(flow, c("No missing ferritin/transferrin/hb/FCM", nrow(pdata)))

pdata <- pdata %>%
  group_by(LopNr) %>%
  arrange(shf_indexdtm) %>%
  slice(1) %>%
  ungroup()

flow <- rbind(flow, c("First post / patient", nrow(pdata)))

colnames(flow) <- c("Criteria", "N")


# For % measure on ferritin/transferrin -----------------------------------

pdata_tf <- rsdata320 %>%
  filter(casecontrol == "Case")

flow_tf <- c("Number of posts (cases) in SHFDB3", nrow(pdata_tf))

pdata_tf <- pdata_tf %>%
  filter(shf_indexdtm >= ymd("2017-01-01"))
flow_tf <- rbind(flow_tf, c("Indexdate >= 1 Jan 2017 (ferritin/transferrin collected during this time)", nrow(pdata_tf)))

pdata_tf <- pdata_tf %>%
  mutate(tmp_tf_measure = case_when(
    !is.na(shf_transferrin) & !is.na(shf_ferritin) ~ 2,
    !is.na(shf_transferrin) | !is.na(shf_ferritin) ~ 1,
    TRUE ~ 0
  )) %>%
  group_by(LopNr) %>%
  arrange(desc(tmp_tf_measure), shf_indexdtm) %>%
  slice(1) %>%
  ungroup()

flow_tf <- rbind(flow_tf, c("First post / patient where a post with non-missing ferritin &/or transferrin is selected even if the date is later", nrow(pdata_tf)))

colnames(flow_tf) <- c("Criteria", "N")
