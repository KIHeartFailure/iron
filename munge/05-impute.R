

# Impute missing values ---------------------------------------------------

noimpvars <- names(pdata)[!names(pdata) %in% modvars]

# Nelson-Aalen estimator
na <- basehaz(coxph(Surv(sos_outtime_hosphf, sos_out_deathhosphf == "Yes") ~ 1,
  data = pdata, method = "breslow"
))
pdata <- left_join(pdata, na, by = c("sos_outtime_hosphf" = "time"))

ini <- mice(pdata, maxit = 0, print = F)

pred <- ini$pred
pred[, noimpvars] <- 0
pred[noimpvars, ] <- 0 # redundant

# change method used in imputation to prop odds model
meth <- ini$method
meth[c("scb_education", "shf_nyha")] <- "polr"
meth[noimpvars] <- ""

## check no cores
cores_2_use <- detectCores() - 1
if (cores_2_use >= 10) {
  cores_2_use <- 10
  m_2_use <- 1
} else if (cores_2_use >= 5) {
  cores_2_use <- 5
  m_2_use <- 2
} else {
  stop("Need >= 5 cores for this computation")
}

cl <- makeCluster(cores_2_use)
clusterSetRNGStream(cl, 49956)
registerDoParallel(cl)

imp <-
  foreach(
    no = 1:cores_2_use,
    .combine = ibind,
    .export = c("meth", "pred", "pdata"),
    .packages = "mice"
  ) %dopar% {
    mice(pdata,
      m = m_2_use, maxit = 10, method = meth,
      predictorMatrix = pred,
      printFlag = FALSE
    )
  }
stopImplicitCluster()


# Imputed dataset for FCM pop ---------------------------------------------

imp_fcm <- subset_datlist(imp, subset = c(pdata$shf_id == "Yes" | pdata$shf_ferrocarboxymaltosis == "Yes"))


# Impute for tf2 pop ------------------------------------------------------

noimpvars <- names(pdata_tf)[!names(pdata_tf) %in% modvars_tf]

# Nelson-Aalen estimator
na <- basehaz(coxph(Surv(sos_outtime_hosphf, sos_out_deathhosphf == "Yes") ~ 1,
  data = pdata_tf, method = "breslow"
))
pdata_tf <- left_join(pdata_tf, na, by = c("sos_outtime_hosphf" = "time"))

ini <- mice(pdata_tf, maxit = 0, print = F)

pred <- ini$pred
pred[, noimpvars] <- 0
pred[noimpvars, ] <- 0 # redundant

# change method used in imputation to prop odds model
meth <- ini$method
meth[c("scb_education", "shf_nyha")] <- "polr"
meth[noimpvars] <- ""

cl <- makeCluster(cores_2_use)
clusterSetRNGStream(cl, 49956)
registerDoParallel(cl)

imp_tf <-
  foreach(
    no = 1:cores_2_use,
    .combine = ibind,
    .export = c("meth", "pred", "pdata_tf"),
    .packages = "mice"
  ) %dopar% {
    mice(pdata_tf,
      m = m_2_use, maxit = 10, method = meth,
      predictorMatrix = pred,
      printFlag = FALSE
    )
  }
stopImplicitCluster()

# Impute for tf2 pop HB groups ---------------------------------------------

noimpvars <- names(pdata_tf)[!names(pdata_tf) %in% c(modvars_tf[modvars_tf != "shf_anemia"], "shf_hb_cat")]

pred <- ini$pred
pred[, noimpvars] <- 0
pred[noimpvars, ] <- 0 # redundant

# change method used in imputation to prop odds model
meth <- ini$method
meth[c("scb_education", "shf_nyha")] <- "polr"
meth[noimpvars] <- ""

cl <- makeCluster(cores_2_use)
clusterSetRNGStream(cl, 49956)
registerDoParallel(cl)

imp_tfhb <-
  foreach(
    no = 1:cores_2_use,
    .combine = ibind,
    .export = c("meth", "pred", "pdata_tf"),
    .packages = "mice"
  ) %dopar% {
    mice(pdata_tf,
         m = m_2_use, maxit = 10, method = meth,
         predictorMatrix = pred,
         printFlag = FALSE
    )
  }
stopImplicitCluster()