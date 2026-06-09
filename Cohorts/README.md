# Importing ATLAS JSON Cohorts into OMOP R Ecosystem

This guide demonstrates how to import a cohort definition exported as a JSON file from OHDSI ATLAS and instantiate it as a physical cohort table within your OMOP CDM database. Once instantiated, this cohort becomes a standard object compatible with the entire R-based OHDSI and DARWIN-EU analytical ecosystem.

## Repository Directory Structure

Your folder or project directory should be organized as follows:

```
project-root/
│
├── cohorts/
│   ├── cohort_1.json        # Exported from ATLAS
│   └── cohort_2.json        # You can place multiple JSON files here
│
├── import_json_script.R         # The execution automation script
└── README.md                    # This documentation file
```

## Execution Workflow

The pipeline implemented in the R script follows 2 standardized database setup steps:

1. **Read JSON Definitions (`CDMConnector::readCohortSet`)**: Scans the designated `./cohorts` folder for all `.json` files, extracts their metadata, and prepares an R object containing the logical rules.
2. **Instantiate Cohorts (`CDMConnector::generateCohortSet`)**: Translates those logical rules into optimized native SQL queries, executes them against your target database connection, and stores the table inside your database `writeSchema`.

---

## Configuration Quick Start

1. Place your exported ATLAS `.json` files inside the `cohorts/` folder.
2. Ensure your active database connection (`con`) and your `cdm` object are properly initialized.
3. Run the import_json_script.R pipeline.
4. Pass the resulting reference (`cdm$your_cohort_table_name`) to any analytics package of your choice.
