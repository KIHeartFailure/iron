# 1. Set options in config/global.dcf
# 2. Load packages listed in config/global.dcf
# 3. Import functions and code in lib directory
# 4. Load data in data directory
# 5. Run data manipulations in munge directory

memory.limit(size = 10000000000000)

ProjectTemplate::reload.project(
  reset = TRUE,
  data_ignore = '', 
  munging = TRUE
)

ProjectTemplate::cache("metaout")

ProjectTemplate::cache("flow")
ProjectTemplate::cache("flow_tf")

ProjectTemplate::cache("pdata")
ProjectTemplate::cache("pdata_fcm")
ProjectTemplate::cache("pdata_tf")

ProjectTemplate::cache("imp")
ProjectTemplate::cache("imp_fcm")
ProjectTemplate::cache("imp_tf")

ProjectTemplate::cache("matchp_fcm")
ProjectTemplate::cache("matchingn")

ProjectTemplate::cache("tabvars")
ProjectTemplate::cache("modvars")
ProjectTemplate::cache("modvars_fcm")
ProjectTemplate::cache("modvars_tf")