
ProjectTemplate::load.project(list(munging = FALSE, data_loading = FALSE))

# Patient registry from SHFDB3 v 3.1.2, prepared in 08-prep_sosdata.R -----

load(file = "C:/Users/Lina/STATISTIK/Projects/20200225_shfdb3/dm/data/patreg.RData")

# Store as RData in /data folder ------------------------------------------

save(file = "./data/patreg.RData", list = c("patreg"))


# Get map data ------------------------------------------------------------

swedenmap <- getData("GADM", country="SWE", level=1)

saveRDS("swedenmap", file = "./data/swedenmap.rds")
