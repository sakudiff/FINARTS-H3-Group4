# FINARTS HW 3 — Market Model Regression

**Group 4** — Sison, Opiana, Galedo, Patajo, Go, Cuenca

---

## Files

| File | What |
|------|------|
| `H3.qmd` | Main document. Code plus the blanks we need to fill in. Edit this. |
| `H3_Analysis.R` | Standalone R script. Run it to reproduce everything. |
| `H3_Group4_Regression_Output.csv` | Final dataframe with returns, fitted values, and residuals. |
| `H3.pdf` | Rendered PDF of the QMD. |
| `data/` | Contains the raw Excel data files (not tracked by git). |

---

## The model

$$R_i = \beta_0 + \beta_1 R_m + u$$

- $R_i$ = daily return of stock $i$
- $R_m$ = daily return of the PSEi
- $\beta_1$ = stock sensitivity to the market (covariance over variance)
- $\beta_0$ = return not explained by the market
- $u$ = residual (idiosyncratic noise)

We pick 5 stocks from 5 sectors and compare their betas to see which are more defensive vs. cyclical at the daily level.

| RIC | Company | Sector |
|-----|---------|--------|
| BPI.PS | Bank of the Philippine Islands | Banks |
| CNPF.PS | Century Pacific Food | Food Producers |
| MER.PS | Manila Electric (Meralco) | Electricity |
| ABS.PS | ABS-CBN | Media |
| TEL.PS | PLDT | Telecommunications |

---