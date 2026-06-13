# FINARTS HW 3 — Market Model Regression

**Group 4** — Cuenca, Raphael; Galedo, Enrique Lorenzo; Go, Keira; Opiana, Aimee Lorynne A.; Patajo, Juliana; Sison, Aaron Joshua E.

------------------------------------------------------------------------

## How the Data is Loaded

**Note for Groupmates:** In our usual finance classes, we normally import data by clicking the "Import Dataset" button in the RStudio GUI. For this project, we automated that step! 

All the `.xlsx` datasets provided by our professor are saved inside the `data/raw/` folder. Because of this, you **do not** need to manually click "Import Dataset". As long as you open the R project file, the `H3_Analysis.R` script and the `H3.qmd` document will use the `read_excel()` function to automatically pull the data straight from that folder. 

## Files

| File | What |
|------------------------------------|------------------------------------|
| `H3.qmd` | Main Quarto document. Code plus the full academic write-up. |
| `H3_Analysis.R` | Standalone R script. Run it to reproduce the regressions and exports. |
| `H3_Group4_Regression_Output.csv` | Final dataframe with returns, fitted values, and residuals. |
| `H3.pdf` | Rendered PDF containing the final answers and parameter reports. |
| `data/raw/` | Contains the raw Excel data files provided by the professor. |

------------------------------------------------------------------------

## The model

$$R_i = \beta_0 + \beta_1 R_m + u$$

-   $R_i$ = daily return of stock $i$
-   $R_m$ = daily return of the PSEi
-   $\beta_1$ = stock sensitivity to the market (covariance over variance)
-   $\beta_0$ = return not explained by the market
-   $u$ = residual (idiosyncratic noise)

We pick 5 stocks from 5 sectors and compare their betas to see which are more defensive vs. cyclical at the daily level.

| RIC     | Company                        | Sector             |
|---------|--------------------------------|--------------------|
| BPI.PS  | Bank of the Philippine Islands | Banks              |
| CNPF.PS | Century Pacific Food           | Food Producers     |
| MER.PS  | Manila Electric (Meralco)      | Electricity        |
| ABS.PS  | ABS-CBN                        | Media              |
| TEL.PS  | PLDT                           | Telecommunications |

------------------------------------------------------------------------