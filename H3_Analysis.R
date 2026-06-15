# Market Model Regression: R_i = B0 + B1 * R_m + u
# FINARTS HW 3 - Group 4

# @knitr load-data
# This code block loads required libraries, sets the random seed for reproducibility,
# and reads the raw Excel data files. It then filters for the 5 selected companies
# across 5 different sectors and displays their metadata.
library(dplyr)   # Used for data manipulation (filtering, mutating, summarizing)
library(tidyr)   # Used for reshaping data (pivoting from long to wide format)
library(readxl)  # Used for reading the raw Excel datasets into R
library(broom)   # Standard library for tidying regression outputs

set.seed(42L)

company_returns <- read_excel("data/raw/Company_Returns.xlsx")
psei_return     <- read_excel("data/raw/PSEi_Return.xlsx")
company_info    <- read_excel("data/raw/Company Name.xlsx")

selected_rics <- c("BPI.PS", "CNPF.PS", "MER.PS", "ABS.PS", "TEL.PS")

stock_meta <- company_info |>
  filter(RIC %in% selected_rics) |>
  select(RIC, Name, Sector, Full_Name = `Full Name`)

knitr::kable(stock_meta, caption = "Selected Stocks Metadata")

# @knitr q1-dataframe
# This code block prepares the regression dataframe. It cleans the PSEi date column,
# joins it with the selected stock returns, and pivots the data into a wide format
# so each stock has its own column for daily returns.
psei <- psei_return |>
  mutate(Date = as.Date(Date)) |>
  rename(PSEi_Return = PSEi_Return) |>
  distinct(Date, .keep_all = TRUE)

stock_returns <- company_returns |>
  filter(RIC %in% selected_rics) |>
  rename(Return = Total_Return, Date = Date) |>
  mutate(Date = as.Date(Date))

reg_data_long <- stock_returns |>
  inner_join(psei, by = "Date")

reg_data_wide <- reg_data_long |>
  select(Date, RIC, Return, PSEi_Return) |>
  pivot_wider(
    id_cols      = c(Date, PSEi_Return),
    names_from   = RIC,
    values_from  = Return,
    names_prefix = ""
  ) |>
  mutate(across(all_of(selected_rics), as.numeric)) |>
  arrange(desc(Date))

knitr::kable(head(reg_data_wide, 5), digits = 4, 
             caption = "Preview of the Regression Dataframe")

# @knitr q2-regressions
# This code block runs ordinary least squares regression for each selected stock 
# against the PSEi market return. It extracts the intercept (B0) and slope (B1) 
# along with their statistical significance and prints them in the requested format.
stock_names <- list(
  "BPI.PS"  = "Bank of the Philippine Islands",
  "CNPF.PS" = "Century Pacific Food",
  "MER.PS"  = "Manila Electric (Meralco)",
  "ABS.PS"  = "ABS-CBN",
  "TEL.PS"  = "PLDT"
)

stock_sectors <- list(
  "BPI.PS"  = "Banks",
  "CNPF.PS" = "Food Producers",
  "MER.PS"  = "Electricity",
  "ABS.PS"  = "Media",
  "TEL.PS"  = "Telecommunications Service Providers"
)

sig_stars <- function(p_value) {
  if (is.na(p_value)) return("")
  if (p_value < 0.01) return("***")
  if (p_value < 0.05) return("**")
  if (p_value < 0.10) return("*")
  return("")
}

regression_results <- list()

for (ric in selected_rics) {
  stock_data <- reg_data_long |> filter(RIC == ric)
  model <- lm(Return ~ PSEi_Return, data = stock_data)
  regression_results[[ric]] <- model
  
  coef_summary <- summary(model)$coefficients
  b0_est <- coef_summary[1, 1]; b0_pval <- coef_summary[1, 4]
  b1_est <- coef_summary[2, 1]; b1_pval <- coef_summary[2, 4]

  cat("STOCK", which(selected_rics == ric), "\n")
  cat("RIC:", ric, "\n")
  cat("Company Name:", stock_names[[ric]], "\n")
  cat("Sector:", stock_sectors[[ric]], "\n")
  cat("Estimated parameters:\n")
  cat("B0:", sprintf("%.6f", b0_est), sig_stars(b0_pval), "\n")
  cat("B1:", sprintf("%.6f", b1_est), sig_stars(b1_pval), "\n\n")
}

# @knitr p2q1-fitted
# This code block computes the predicted (fitted) returns for all 5 stocks
# using the models estimated previously and adds them to the wide dataframe.
reg_data_wide <- reg_data_wide |>
  mutate(
    BPI_Fitted  = fitted(regression_results[["BPI.PS"]]),
    CNPF_Fitted = fitted(regression_results[["CNPF.PS"]]),
    MER_Fitted  = fitted(regression_results[["MER.PS"]]),
    ABS_Fitted  = fitted(regression_results[["ABS.PS"]]),
    TEL_Fitted  = fitted(regression_results[["TEL.PS"]])
  )

# @knitr p2q2-residuals
# This code block calculates the residuals for each stock by subtracting the 
# fitted values from the actual returns. The result is stored as new columns.
reg_data_wide <- reg_data_wide |>
  mutate(
    BPI_Residual  = BPI.PS  - BPI_Fitted,
    CNPF_Residual = CNPF.PS - CNPF_Fitted,
    MER_Residual  = MER.PS  - MER_Fitted,
    ABS_Residual  = ABS.PS  - ABS_Fitted,
    TEL_Residual  = TEL.PS  - TEL_Fitted
  )

# @knitr p2q3-sum-residuals
# This code block computes the sum of the residuals for each stock across all dates
# to demonstrate that the OLS residuals sum to approximately zero.
residual_sums <- reg_data_wide |>
  summarise(
    BPI_Sum  = sum(BPI_Residual, na.rm = TRUE),
    CNPF_Sum = sum(CNPF_Residual, na.rm = TRUE),
    MER_Sum  = sum(MER_Residual, na.rm = TRUE),
    ABS_Sum  = sum(ABS_Residual, na.rm = TRUE),
    TEL_Sum  = sum(TEL_Residual, na.rm = TRUE)
  )

knitr::kable(t(residual_sums), col.names = c("Sum of Residuals"), 
             digits = 14, caption = "Sum of Residuals by Stock")

# @knitr export
# This code block exports the final combined dataset containing stock returns, 
# market returns, fitted values, and residuals into a CSV file.
output_csv <- "H3_Group4_Regression_Output.csv"
write.csv(reg_data_wide, file = output_csv, row.names = FALSE)
