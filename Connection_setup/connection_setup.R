# ==============================================================================
# CONNECTION AUTOMATION SCRIPT
# Copy this code into your .Rprofile file.
# ==============================================================================

# 1. Custom Welcome Message
if (interactive()) {
  cat("\n---------------------------------------------------------")
  cat("\n[Project: ................")
  cat("\nType 'connect_hmar()' to establish CDM connection.")
  cat("\n---------------------------------------------------------\n\n")
}

# 2. Connection Shortcut Function
# This function reads credentials from your .Renviron file
connect_hmar <- function() {
  
  # Load required silent libraries
  suppressPackageStartupMessages({
    library(DBI)
    library(CDMConnector)
    library(RPostgreSQL)
  })
  
  tryCatch({
    # Establish database connection
    con <- dbConnect(
      RPostgreSQL::PostgreSQL(),
      dbname   = Sys.getenv("DB_NAME"),
      host     = Sys.getenv("DB_HOST"),
      user     = Sys.getenv("DB_USER"),
      password = Sys.getenv("DB_PASS"),
      port     = as.numeric(Sys.getenv("DB_PORT"))
    )
    
    # Create CDM reference
    cdm <- cdmFromCon(
      con         = con,
      cdmSchema   = Sys.getenv("CDM_SCHEMA"),
      writeSchema = Sys.getenv("WRITE_SCHEMA"),
      cdmName     = "cdm_name"
    )
    
    message("CDM connection successful. Object 'cdm' is ready.")
    return(cdm)
    
  }, error = function(e) {
    message("Connection failed. Check your .Renviron variables.")
    message(paste("Error:", e$message))
    return(NULL)
  })
}

# 3. Automatic Execution (Optional)
# Uncomment the line below if you want the connection to happen 
# IMMEDIATELY upon opening the project:
# cdm <- connect_hmar()