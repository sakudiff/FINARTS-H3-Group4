# Market Model Regression: R_i = B0 + B1 * R_m + u
# FINARTS HW 3 - Group 4 - Sison, Aaron Joshua E.

RANDOM_SEED <- 42L
set.seed(RANDOM_SEED)

library(dplyr)
library(tidyr)
library(readxl)
library(broom)

# Part 1: Select 5 stocks from 5 different sectors.
# Run a regression of the returns of each stock against the market returns.

company_returns <- read_excel("data/raw/Company_Returns.xlsx")
psei_return    <- read_excel("data/raw/PSEi_Return.xlsx")
company_info   <- read_excel("data/raw/Company Name.xlsx")

selected_rics <- c("BPI.PS", "CNPF.PS", "MER.PS", "ABS.PS", "TEL.PS")

stock_meta <- company_info |>
  filter(RIC %in% selected_rics) |>
  select(RIC, Name = Name, Sector, Full_Name = `Full Name`)

cat("DATA LOADED\n")
cat("Company_Returns:", nrow(company_returns), "rows\n")
cat("PSEi_Return:",    nrow(psei_return),    "rows\n")
cat("Company Info:",   nrow(company_info),   "rows\n\n")

cat("SELECTED STOCKS\n")
print(stock_meta, row.names = FALSE)
cat("\n")

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

cat("REGRESSION DATA (long format)\n")
cat("Rows:", nrow(reg_data_long), "\n")
cat("Date range:", format(min(reg_data_long$Date), "%Y-%m-%d"),
    "to", format(max(reg_data_long$Date), "%Y-%m-%d"), "\n\n")

# Part 1, Question 1: Create a dataframe for your regressions.
# It must contain the 5 stock returns, PSEi return, and date.

reg_data_wide <- reg_data_long |>
  select(Date, RIC, Return, PSEi_Return) |>
  pivot_wider(
    id_cols     = c(Date, PSEi_Return),
    names_from  = RIC,
    values_from = Return,
    names_prefix = ""
  ) |>
  mutate(across(all_of(selected_rics), ~ as.numeric(.)))

stopifnot(all(sapply(reg_data_wide[selected_rics], is.numeric)))

cat("REGRESSION DATAFRAME (wide format)\n")
cat("Dimensions:", nrow(reg_data_wide), "rows x", ncol(reg_data_wide), "cols\n")
cat("Columns:", colnames(reg_data_wide), "\n")
cat("First 5 rows:\n")
print(head(reg_data_wide, 5))
cat("\n")

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

cat("REGRESSION RESULTS\n")
cat("Model: R_i = B0 + B1 * R_m + u\n\n")

# Part 1, Question 2: Run the regressions and report your estimated parameters.

for (ric in selected_rics) {
  stock_data <- reg_data_long |> filter(RIC == ric)
  model <- lm(Return ~ PSEi_Return, data = stock_data)
  regression_results[[ric]] <- model

  coef_summary <- summary(model)$coefficients
  b0_est    <- coef_summary[1, 1]
  b1_est    <- coef_summary[2, 1]
  b0_pval   <- coef_summary[1, 4]
  b1_pval   <- coef_summary[2, 4]
  b0_sig    <- sig_stars(b0_pval)
  b1_sig    <- sig_stars(b1_pval)
  r_squared <- summary(model)$r.squared
  n_obs     <- nobs(model)

  cat("STOCK:", which(selected_rics == ric), "\n")
  cat("RIC:", ric, "\n")
  cat("Company Name:", stock_names[[ric]], "\n")
  cat("Sector:", stock_sectors[[ric]], "\n")
  cat("Estimated parameters:\n")
  cat("B0:", sprintf("%.6f", b0_est), b0_sig, "\n")
  cat("B1:", sprintf("%.6f", b1_est), b1_sig, "\n")
  cat("R-squared:", sprintf("%.4f", r_squared), "\n")
  cat("Observations:", n_obs, "\n\n")
}

# Part 1, Question 3: Discuss your findings. Discuss the results for each stock, and compare
# the estimated parameters for each of the stocks.
# Note: The full discussion and analysis is written in the H3.pdf document.

# Part 2: Compute the fitted values and residuals.

# Part 2, Question 1: Using the regression dataframe that you used in Part 1, create columns
# where you compute the fitted values of the 5 stocks that you analyzed.

reg_data_wide <- reg_data_wide |>
  mutate(
    BPI_Fitted   = fitted(regression_results[["BPI.PS"]]),
    CNPF_Fitted  = fitted(regression_results[["CNPF.PS"]]),
    MER_Fitted   = fitted(regression_results[["MER.PS"]]),
    ABS_Fitted   = fitted(regression_results[["ABS.PS"]]),
    TEL_Fitted   = fitted(regression_results[["TEL.PS"]])
  )

cat("FITTED VALUES ADDED\n")
cat("New columns:", grep("Fitted", colnames(reg_data_wide), value = TRUE), "\n\n")

# Part 2, Question 2: Still in the same dataframe, compute the residuals for each stock.

reg_data_wide <- reg_data_wide |>
  mutate(
    BPI_Residual   = BPI.PS   - BPI_Fitted,
    CNPF_Residual  = CNPF.PS  - CNPF_Fitted,
    MER_Residual   = MER.PS   - MER_Fitted,
    ABS_Residual   = ABS.PS   - ABS_Fitted,
    TEL_Residual   = TEL.PS   - TEL_Fitted
  )

cat("RESIDUALS ADDED\n")
cat("New columns:", grep("Residual", colnames(reg_data_wide), value = TRUE), "\n\n")

# Part 2, Question 3: What did you notice about the sum of the residuals for each stock?
# Note: The discussion on the residuals summing to approximately zero
# is written in the H3.pdf document.

residual_sums <- reg_data_wide |>
  summarise(
    BPI_Sum   = sum(BPI_Residual,   na.rm = TRUE),
    CNPF_Sum  = sum(CNPF_Residual,  na.rm = TRUE),
    MER_Sum   = sum(MER_Residual,   na.rm = TRUE),
    ABS_Sum   = sum(ABS_Residual,   na.rm = TRUE),
    TEL_Sum   = sum(TEL_Residual,   na.rm = TRUE)
  )

cat("SUM OF RESIDUALS\n")
print(t(residual_sums))
cat("\n")

# Submission: File 1. Using the write.csv function, export the final dataframe.

output_csv <- "H3_Group4_Regression_Output.csv"
write.csv(reg_data_wide, file = output_csv, row.names = FALSE)
cat("CSV EXPORTED\n")
cat("File:", output_csv, "\n")
cat("Dimensions:", nrow(reg_data_wide), "rows x", ncol(reg_data_wide), "cols\n")
cat("Columns:", paste(colnames(reg_data_wide), collapse = ", "), "\n\n")

