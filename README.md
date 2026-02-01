# Survival Analysis of Chronic Liver Disease (PBC)

## Overview
This project performs a complete time-to-event analysis using the Primary Biliary Cholangitis (PBC) dataset from the Mayo Clinic. The objective is to study survival patterns and identify clinically meaningful prognostic factors while accounting for right-censored observations.

The analysis follows a classical clinical statistics workflow commonly used in pharmaceutical and epidemiological studies.

---

## Dataset
- **Source:** Mayo Clinic PBC dataset (`survival` package in R)
- **Sample Size:** 418 patients (312 after preprocessing)
- **Outcome:** Time to death (in days)
- **Censoring:** Right-censored observations included

### Key Variables
- `time` – Follow-up time (days)
- `status` – Event indicator (0 = censored, 1 = transplant, 2 = death)
- `trt` – Treatment group (Treated vs Placebo)
- `age` – Age at baseline
- `bili` – Serum bilirubin (disease severity marker)

---

## Methodology
The analysis pipeline consists of the following steps:

1. **Data Preprocessing**
   - Defined death as the event of interest
   - Re-coded treatment groups
   - Performed complete-case filtering for selected covariates

2. **Descriptive Analysis**
   - Examined censoring proportion
   - Assessed event distribution across treatment groups

3. **Kaplan–Meier Survival Analysis**
   - Estimated survival probabilities over time
   - Visualized survival curves by treatment group

4. **Log-Rank Test**
   - Compared survival curves between treatment arms

5. **Cox Proportional Hazards Model**
   - Estimated adjusted hazard ratios for treatment, age, and bilirubin
   - Interpreted clinical risk factors

6. **Model Diagnostics**
   - Verified proportional hazards assumption using Schoenfeld residuals

---

## Key Findings
- Treatment group did not show a statistically significant difference in survival.
- Age and serum bilirubin were identified as strong prognostic factors.
- Higher bilirubin levels were associated with increased risk of mortality.
- Proportional hazards assumptions were assessed and interpreted.

---

## Tools & Libraries
- **Language:** R
- **Packages:** `survival`, `dplyr`
- **Techniques:** Kaplan–Meier estimation, Log-rank test, Cox regression

---

## How to Run
1. Open R or RStudio
2. Install required packages:
   ```r
   install.packages(c("survival", "dplyr"))
