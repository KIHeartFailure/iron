

# Inclusion/exclusion criteria --------------------------------------------------------

pdata <- rsdata315 %>%
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
