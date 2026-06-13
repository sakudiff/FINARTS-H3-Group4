# This document includes the raw or direct instructions from hw3. This also includes the checklist.

#FINARTS Class Activity #File description:

#1. Company_Returns - Contains the daily returns of all active listed #companies in the Philippine Stock Exchange (PSE) from January 1, 2023 to January 23, 2026 #in long format

in @data/raw/

#2. PSEi_Return - Contains the daily returns of the PSE index from January 1, 2023 \# to January 29, 2025

#3. Company Name - The details of the companies in the Company_Returns file.

#INSTRUCTIONS: Answer the questions. Make sure that you label your code properly #so that your answers can be verified.

#PART 1: Select 5 stocks from 5 different sectors. Run a regression of the returns #of each stock against the market returns #stock i: R_i = B0 + B1\*R_m + u

#Questions: #1. (2 pts) Create a dataframe for the your regressions #It must contain the 5 stock returns, PSEi return, and date.

#2. Run the regressions and report your estimated paramaters. Follow this format #when reporting

#STOCK 1 #RIC: XX #Company Name: XX #Sector: XX #Estimated parameters: #B0: XX (Note: make sure that you indicate the significance by including asterisks ***) #B1: xx (Note: make sure that you indicate the significance by including asterisks*** ) #(2 points for each stock for a total of 10 points)

#3. Discuss your findings. Discuss the results for each stock, and compare #the estimated paramaters for each of the stocks. (5 pts)

#PART 2: Compute the fitted values and residuals. #1. Using the regression dataframe that you used in Part 1, create columns #where you compute the fitted values of the 5 stocks that you analyzed. #(5 points)

#2. Still in the same dataframe, compute the residuals for each stock. #(5 points)

#3. What did you notice about the sum of the residuals for each stock? (3 pts)

#SUBMISSION: Submit the following files: #File 1. Using the write.csv function, export the final dataframe #that contains the stock return date, 5 stock returns, PSEi return, #5 fitted values for the 5 stocks, 5 residual values for the 5 stocks. #File 2: Submit the R Script that you used in your analysis. #Make sure that your code is properly labelled. #File 3: PDF File that contains your answers to the questions.

# Group Context:

Chosen companies: - Century Foods Pacific (Food Producers) - BPI (Banking) - Meralco (ENERGY) - ABS-CBN (Media) - PLDF Telecommunications

Group Members:

"Group 4 — Sison, Aaron Joshua E.; Opiana, Aimee Lorynne A.; Galedo, Enrique Lorenzo; Patajo, Juliana; Go, Keira; Cuenca, Raphael"