# 2. Connection Shortcut Function
# This function reads credentials from your .Renviron file
connect_hmar <- function() {
  
  # 1. Carrega de llibreries modernes
  suppressPackageStartupMessages({
    library(DBI)
    library(CDMConnector)
    library(RPostgres) 
  })
  
  tryCatch({
    # 2. Connexió amb el driver nou
    con <- dbConnect(
      RPostgres::Postgres(), 
      dbname   = Sys.getenv("DB_NAME"),
      host     = Sys.getenv("DB_HOST"),
      user     = Sys.getenv("DB_USER"),
      password = Sys.getenv("DB_PASS"),
      port     = as.numeric(Sys.getenv("DB_PORT"))
    )
    
    # 3. Creació de la referència CDM
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
