

# Propensity scores -------------------------------------------------------

ps <- data.frame(matrix(NA, nrow = nrow(pdata), ncol = 11))

for (i in 1:10) {
  impdata_ps <- mice::complete(imp, i)
  if (i == 1) ps[, 1] <- impdata_ps$LopNr
  pslog <- glm(formula(paste0(
    "shf_ferrocarboxymaltosisnum ~ ",
    paste(modvars_fcm,
      collapse = " + "
    )
  )),
  data = impdata_ps,
  family = binomial
  )
  ps[, i + 1] <- pslog$fitted
}

pdata <- left_join(pdata,
  ps %>%
    mutate(ps = rowSums(.[2:11]) / 10) %>%
    select(X1, ps),
  by = c("LopNr" = "X1")
)

pdata_fcm <- pdata %>% 
  filter(shf_id == "Yes" | shf_ferrocarboxymaltosis == "Yes")

cal <- c(0.01 / sd(pdata_fcm$ps))

set.seed(2334325)
match1 <- Match(
  Tr = pdata_fcm$shf_ferrocarboxymaltosisnum,
  X = pdata_fcm$ps,
  estimand = "ATT",
  caliper = cal,
  replace = F,
  ties = F,
  M = 1
)
set.seed(2334325)
match2 <- Match(
  Tr = pdata_fcm$shf_ferrocarboxymaltosisnum,
  X = pdata_fcm$ps,
  estimand = "ATT",
  caliper = cal,
  replace = F,
  ties = F,
  M = 2
)
set.seed(2334325)
match3 <- Match(
  Tr = pdata_fcm$shf_ferrocarboxymaltosisnum,
  X = pdata_fcm$ps,
  estimand = "ATT",
  caliper = cal,
  replace = F,
  ties = F,
  M = 3
)
set.seed(2334325)
match4 <- Match(
  Tr = pdata_fcm$shf_ferrocarboxymaltosisnum,
  X = pdata_fcm$ps,
  estimand = "ATT",
  caliper = cal,
  replace = F,
  ties = F,
  M = 4
)
set.seed(2334325)
match5 <- Match(
  Tr = pdata_fcm$shf_ferrocarboxymaltosisnum,
  X = pdata_fcm$ps,
  estimand = "ATT",
  caliper = cal,
  replace = F,
  ties = F,
  M = 5
)
matchingn <- paste0(
  "org data, N = ", sum(pdata_fcm$shf_ferrocarboxymaltosisnum), ", ",
  "1:1: N = ", match1$wnobs, ", ",
  "1:2: N = ", match2$wnobs, ", ",
  "1:3: N = ", match3$wnobs, ", ",
  "1:4: N = ", match4$wnobs, ", ",
  "1:5: N = ", match5$wnobs
)

pdata_fcm$par <- rep(NA, nrow(pdata_fcm))

pdata_fcm$par[c(unique(match1$index.treated), match1$index.control)] <- c(1:match1$wnobs, rep(1:match1$wnobs, each = 1))
matchp_fcm <- pdata_fcm[c(unique(match1$index.treated), match1$index.control), ]
