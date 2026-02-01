# Project 3: Survival Analysis (PBC Liver Disease Study)

## Project Overview
In this analysis, I explored the Mayo Clinic Primary Biliary Cholangitis (PBC) dataset. My goal was to determine if the treatment (DPCA) actually improved survival times and to identify which clinical markers were the strongest predictors of mortality.

---

## My Analysis Steps
1.  **Event Definition:** I focused on mortality as the primary event. In the dataset, I filtered for `status == 2` to define my `death_event`.
2.  **KM Estimation:** I generated Kaplan-Meier survival curves to compare the Treated group vs. the Placebo group. 
3.  **Cox Modeling:** I moved beyond basic curves to fit a Cox Proportional Hazards model. I decided to adjust for **Age** and **Bilirubin** levels, as these are known clinical indicators of liver health.
4.  **Diagnostics:** I used Schoenfeld residuals to check the Proportional Hazards assumption. This is a step I added to ensure the model results are actually valid for this data.

---

## Key Findings & Interpretation
* **Treatment Effect:** Interestingly, the Log-Rank test ($p = 0.7$) and the Cox model showed that the treatment was not a significant predictor of survival. The Hazard Ratio for the Placebo group was $0.945$, meaning there was almost no difference between groups.
* **The Role of Bilirubin:** This was the strongest predictor in my model ($p < 2e-16$). For every 1-unit increase in Serum Bilirubin, the risk of death increases by about $16\%$ ($HR = 1.16$).
* **Age:** Age was also significant ($p = 1.33e-05$), with a $4\%$ increase in risk per year of age.
* **Assumptions:** While the group and age met the PH assumption, Bilirubin showed some non-proportionality ($p = 0.0044$), suggesting that its effect on risk might change over very long periods.

---

## Conclusion
This project taught me that in clinical data, biological markers (like Bilirubin) often have a much larger impact on survival than the specific treatment being tested. It also showed me the importance of testing model assumptions before trusting the Hazard Ratios.

---

## How to Run
```r
library(survival)
library(dplyr)
source("pbc_analysis.R")