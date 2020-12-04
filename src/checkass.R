
ProjectTemplate::reload.project()

dataass <- mice::complete(imp, 3)



# aid ---------------------------------------------------------------------

mod <- coxph(formula(paste0(
  "Surv(sos_outtime_hosphf, sos_out_deathhosphf == 'Yes') ~ shf_aid +",
  paste(modvars, collapse = " + ")
)), data = dataass)


# Checking for non-prop hazards --------------------------------------------

print(testpat <- cox.zph(mod))
(sig <- testpat$table[testpat$table[, 3] < 0.05, ])

# check spec for aid, ok
plot(testpat[1], resid = F, ylim = c(-4, 4))

# fcm ---------------------------------------------------------------------

mod <- coxph(formula(paste0(
  "Surv(sos_outtime_hosphf, sos_out_deathhosphf == 'Yes') ~ shf_ferrocarboxymaltosis +",
  paste(modvars, collapse = " + ")
)), data = dataass, subset = pdata$shf_id == "Yes" | pdata$shf_ferrocarboxymaltosis == "Yes")


# Checking for non-prop hazards --------------------------------------------

print(testpat <- cox.zph(mod))
(sig <- testpat$table[testpat$table[, 3] < 0.05, ])

# check spec for fcm, ok
plot(testpat[1], resid = F, ylim = c(-4, 4))


mod <- coxph(Surv(sos_outtime_hosphf, sos_out_deathhosphf == 'Yes') ~ shf_ferrocarboxymaltosis + strata(par),
             data = matchp_fcm
)

# Checking for non-prop hazards --------------------------------------------

print(testpat <- cox.zph(mod))
(sig <- testpat$table[testpat$table[, 3] < 0.05, ])

# check spec for fcm, ok
plot(testpat[1], resid = F, ylim = c(-4, 4))


# Outliers ---------------------------------------------------------------

modvars_fcmpred <- c(modvars_fcm[modvars_fcm != "shf_indexmonth"], "shf_indexyear")

modlm <- glm(formula(paste0("shf_ferrocarboxymaltosis == 'Yes' ~ ", paste(modvars_fcmpred, collapse = " + "))),
                                family = binomial(link = "logit"), data = dataass, 
             subset = c(pdata$shf_id == "Yes" | pdata$shf_ferrocarboxymaltosis == "Yes"))


plot(modlm, which = 4, id.n = 3)


# Multicollinearity -------------------------------------------------------

car::vif(modlm)


# Outliers ---------------------------------------------------------------

dataass <- mice::complete(imp_tf, 3)

modvars_tfpred <- c(modvars_tf[modvars_tf != "shf_indexmonth"], "shf_indexyear")

modlm <- glm(formula(paste0("shf_tf2 == 'Yes' ~ ", paste(modvars_tfpred, collapse = " + "))),
             family = binomial(link = "logit"), data = dataass)

plot(modlm, which = 4, id.n = 3)


# Multicollinearity -------------------------------------------------------

car::vif(modlm)
