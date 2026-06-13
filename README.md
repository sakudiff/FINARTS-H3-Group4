# FINARTS HW 3 — Market Model Regression

**Group 4:**

-   Cuenca, Raphael
-   Galedo, Enrique Lorenzo
-   Go, Keira
-   Opiana, Aimee Lorynne A.
-   Patajo, Juliana
-   Sison, Aaron Joshua E.

------------------------------------------------------------------------

## How to Navigate This GitHub Page

**Note for Groupmates:** If you haven't used GitHub much before, don't worry! It's essentially just a secure cloud folder where we collaborate on our code.

-   You can download all these files to your laptop by clicking the green **"\<\> Code"** button near the top right and selecting **"Download ZIP"**.
-   The `H3.qmd` file is just a fancy `.Rmd` (RMarkdown) file, exactly like the ones we used back in our **FINLYTS** course. You can open and run it in RStudio just like any normal script.

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

## Advanced: Contributing via Branch/PR Workflow

**Note for Groupmates:** If you want to go beyond the "Download ZIP" method and actually collaborate on this project like a developer, you can use the Terminal (Mac) or Command Prompt/Git Bash (Windows).

### 1. Cloning the Repository
To pull a live copy of the code onto your machine, open your Terminal and run:
```bash
git clone https://github.com/sakudiff/FINARTS-H3-Group4.git
cd FINARTS-H3-Group4
```

### 2. Creating a Branch
Never make changes directly on the `main` branch! Always create your own branch first to keep the main project safe.
```bash
# Create and switch to a new branch (e.g., named after your task)
git checkout -b feature/my-analysis
```
*(Tip: You can always check which branch you are currently viewing by running `git branch`.)*

### 3. Making Changes & Rendering the PDF
Open the folder in RStudio and edit the `H3.qmd` or `H3_Analysis.R` files. 

**🚨 CRITICAL NOTE:** Your text/code changes will **NOT** automatically show up in the `H3.pdf` file! You must re-render the document in RStudio (by clicking the "Render" button on the top panel) *before* you commit your files. If you don't render it, the PDF will just show the old version.

### 4. Committing and Opening a Pull Request (PR)
Instead of pushing directly, we use **Pull Requests (PRs)**. A PR is basically a staging area where you ask the group to review your code before it officially gets merged into the final `main` document.

When you are ready to upload your changes, run these commands:

```bash
# 1. Stage your changes (tells Git which files you want to update)
git add .

# 2. Commit your changes (saves a local snapshot with a message)
git commit -m "update: added my analysis for question 3"

# 3. Pull the latest main updates (rebasing prevents messy history!)
git pull --rebase origin main

# 4. Push your branch to GitHub
git push -u origin feature/my-analysis
```

### 5. Dealing with Conflicts
If someone else edited the exact same line of code as you while you were working, step #3 (`git pull --rebase`) will pause and warn you about a **Merge Conflict**. 
To fix this:
1. Open the conflicting file in your editor. You will see both versions of the text.
2. Delete the version you don't want and save the file.
3. Tell Git you fixed it by running:
```bash
git add .
git rebase --continue
```

Once your branch is successfully pushed, go to the GitHub website. You'll see a big green button that says **"Compare & pull request"**. Click it, and the group can review your work!