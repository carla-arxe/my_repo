# Connection Automation Guide

This guide describes how to automate the connection to an OMOP CDM using R system files (*.Renviron* and *.Rprofile*). This configuration enables the automatic setup of the database connection upon opening the R project, or via a simple shortcut function.

## 1. Secure Credential Storage with .Renviron

The **.Renviron** file stores environment variables. It provides a secure location for credentials, keeping them separate from .R scripts and preventing accidental exposure when sharing code.

### Setup Steps:

1. Run *usethis::edit_r_environ()* in the R console to open the file.

2. Add the following lines (replacing with the actual credentials):

*DB_HOST="your_server_host"
DB_NAME="your_database_name"
DB_USER="your_username"
DB_PASS="your_password"
DB_PORT=5432
CDM_SCHEMA="your_cdm_schema"
WRITE_SCHEMA="your_write_schema"*

3. Restart R for the changes to take effect.

## 2. Auto-loading Logic with .Rprofile

The **.Rprofile** file contains R code that executes automatically at the start of every R session within the project. It is used here to define a shortcut function for the connection.

### Setup Steps:

1. Create a file named *.Rprofile* in the project root (if it does not exist).

2. Paste the automation script provided in *connection_setup.R.*

## 3. Workflow Options

Once configured, open R and execute:

*cdm <- connect_hmar()*

If you uncomment the last line in the *.Rprofile* script, the cdm object will be created instantly as soon as you open RStudio.

***Library Management:** Verify that DBI, CDMConnector, and the appropriate database driver (e.g., RPostgreSQL) are installed in the global or renv library.*
