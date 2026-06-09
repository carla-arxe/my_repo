# ==============================================================================
# AUTOMATED PIPELINE: FROM ATLAS JSON TO PHENOTYPER DIAGNOSTICS
# ==============================================================================

# 1. Load required libraries
library(CDMConnector)
library(PhenotypeR)

# 2. Read the JSON file from the folder
# This function automatically scans for .json files and maps them to R
cohort_definition <- readCohortSet(path = "your_path")

# Step B: Generate the cohort table in the database
cdm <- generateCohortSet(
  cdm       = cdm,               # Your active CDM connection object
  cohortSet = cohort_definition, # The definition loaded from the JSON file
  name      = "cohort_json"      # The target table name in your database
)