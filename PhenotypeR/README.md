# PhenotypeR: Cohort Diagnostic and Validation Tool

Its primary mission is the comprehensive diagnostic evaluation and scientific validation of cohorts (phenotypes) mapped to the **OMOP CDM**. 

---

## 1. The Workflow

When executed, the package sequentially performs four deep analytical evaluations on the cohort. The resulting structured metrics are fully optimized for interactive visualization within the built-in Shiny application.

### A. Database Diagnostics
Evaluates whether the underlying data source possesses the data density and temporal consistency required for the study.
* **What it analyzes:** The distribution and continuity of patient observation windows (`observation_period`), overall database volume trends, and any unexpected drops or anomalies in data coverage across selected calendar years.

### B. Codelist Diagnostics
An exhaustive audit of the clinical definition to verify whether the chosen concept sets accurately reflect the intended clinical condition.
* **Standard vs. Active Concepts:** Analyzes which concept codes from the predefined lists actually triggered patient entry into the cohort and identifies codes that never appeared in the hospital database.
* The package scans the database for closely related clinical codes or hierarchical descendants that were omitted from the definition but appear frequently in similar patient profiles.

### C. Cohort Diagnostics
Audits patient trajectories and cohort composition once they pass through the inclusion criteria filters.
* **Attrition:** Automatically generates a classic step-by-step patient attrition table. It explicitly tracks how many individuals were present initially and precisely where sample size losses occurred due to specific criteria (e.g., applying a "minimum age of 18" or "at least 365 days of prior observation").
* **Cohort Overlap:** When evaluating multiple cohorts concurrently, it computes the exact overlap percentage between conditions and determines which clinical diagnosis occurred first chronologically.
* **Baseline Characteristics:** Automatically generates a table compiling baseline demographics at the cohort index date (e.g., age distribution, biological sex, and index calendar year).

### D. Population Diagnostics
Calculates native epidemiological metrics to contextualize the cohort within the background population.
* **Incidence and Prevalence:** Computes cumulative incidence, incidence rates (person-years), and point/period prevalence. These metrics are stratified automatically by age groups, biological sex, and calendar years, allowing to cross-reference the database's rates against established clinical literature.

---

## 2. Key Package Functions

`PhenotypeR` utilizes a clean, streamlined functional architecture designed to execute complex queries with minimal lines of code.

### `phenotypeDiagnostics()`
The core computational engine of the package. It ingests the OMOP CDM cohort table and simultaneously runs all four diagnostic layers detailed above, returning a unified, complex R object of class `summarised_result`.

### `exportCohortDiagnostics()`
Takes the output object from `phenotypeDiagnostics()` and exports it to a specified directory using formats such as zipped `.csv` or `.parquet` files. These files are strictly anonymized, aggregated, and formatted for seamless sharing with international study coordinators.

### `shinyDiagnostics()`
Launches the interactive Shiny web interface. It can process the live `summarised_result` object directly from the active R environment or read an export directory containing your previously saved data files.

---

## 3. Detailed Parameter Customization

The main engine function, `phenotypeDiagnostics()`, is configurable, giving a control over stratification profiles and epidemiological thresholds.

Below is the advanced configuration syntax detailing the key customizable parameters:

```r
results <- PhenotypeR::phenotypeDiagnostics(
  cohort = cdm$my_selected_cohort,       # The cohort table initialized in the OMOP CDM
  
  # 1. Concept-Level Detail Control
  codelistDiagnostics = TRUE,            # TRUE/FALSE: Enables/disables orphan concept scanning (memory intensive)
  
  # 2. Population-Level Metrics Configuration
  incidenceRate = TRUE,                  # TRUE/FALSE: Computes incidence rates (person-years)
  prevalence = TRUE,                     # TRUE/FALSE: Computes point and period prevalence
  
  # 3. Stratification & Data Slicing
  ageGroup = list(                       # Defines custom age bands for graphs and tables
    c(0, 17), 
    c(18, 64), 
    c(65, 100)
  ),
  sex = c("Male", "Female", "Both"),     # Dictates which biological sexes to analyze independently
  timeInterval = "years",                # "years", "months", or "overall": Sets temporal granularity
  
  # 4. Critical Epidemiological Adjustments
  washoutPeriod = 365,                   # Mandatory days required event-free before counting a "new case"
  completeDatabaseIntervals = TRUE       # TRUE: Discards incomplete calendar years to prevent calculation bias
)
```

Modifying the `washoutPeriod` drastically alters the study's epidemiological yield. Setting it to 0 means any recorded instance of a code counts as an event. Setting it to 365 guarantees that a patient must possess a full consecutive year of data completely free of that condition before a new entry is flagged as a true incident case. This boundary is vital to distinguish true new diagnoses from routine follow-up visits of a pre-existing chronic disease.

## 4.`summarised_result` Output
DARWIN-EU frameworks have transitioned fully to the standardized `summarised_result` object class format (managed via the `omopgenerics` utility package).

Consequently, the output generated by `PhenotypeR` is a strictly structured table bound to the following immutable columns:
| Column Name | Description | Example |
| :--- | :--- | :--- |
| **`cdm_name`** | The unique identifier of the source database (vital for multi-center data networks). | `"Hospital_Mar"`, `"Hospital_Clinic"` |
| **`result_type`** | The specific diagnostic module that produced the row. | `"cohort_attrition"`, `"incidence"` |
| **`variable_name`** | The specific covariate or demographic being evaluated. | `"Age"`, `"Sex"` |
| **`variable_level`**| The specific tier or category of the variable. | `"65-100"`, `"Female"` |
| **`estimate_name`** | The statistical metric type being reported. | `"count"`, `"median"`, `"percentage"` |
| **`estimate_value`**| The actual numerical or character result. | `"1240"`, `"45.2"` |
