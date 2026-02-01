# ============================================================
# MSc Statistics – Placement Project 3
# Title: Survival Analysis of Chronic Liver Disease (PBC)
# Dataset: Primary Biliary Cholangitis (Mayo Clinic)
# Study Type: Time-to-Event Analysis with Right Censoring
# ============================================================

# OBJECTIVE:
# To analyze survival patterns and identify significant
# prognostic factors associated with mortality using
# classical survival analysis techniques.

# ------------------------------------------------------------
# 1. Setup
# ------------------------------------------------------------

rm(list = ls())
set.seed(101)

library(survival)
library(dplyr)

# ------------------------------------------------------------
# 2. Load Dataset
# ------------------------------------------------------------

data("pbc", package = "survival")

# Inspect structure
head(pbc)
dim(pbc)
str(pbc)

# Key variables:
# time   -> follow-up time (days)
# status -> 0 = censored, 1 = transplant, 2 = death
# trt    -> treatment group (1 = treated, 2 = placebo)
# age    -> age in years
# bili   -> serum bilirubin (marker of disease severity)

# ------------------------------------------------------------
# 3. Data Preparation
# ------------------------------------------------------------

# Define event of interest: death only
pbc$event <- ifelse(pbc$status == 2, 1, 0)

# Convert treatment to factor
pbc$trt <- factor(
  pbc$trt,
  levels = c(1, 2),
  labels = c("Treated", "Placebo")
)

# Check missing values
colSums(is.na(pbc))

# Complete-case dataset for modeling
pbc_clean <- pbc %>%
  filter(
    !is.na(time),
    !is.na(event),
    !is.na(trt),
    !is.na(age),
    !is.na(bili)
  )

dim(pbc_clean)

# ------------------------------------------------------------
# 4. Censoring Overview
# ------------------------------------------------------------

table(pbc_clean$event)
prop.table(table(pbc_clean$event))

# Interpretation:
# 1 = death (event)
# 0 = right-censored (alive or transplanted at last follow-up)

# ------------------------------------------------------------
# 5. Kaplan–Meier Survival Analysis
# ------------------------------------------------------------

# Create survival object
surv_object <- Surv(
  time = pbc_clean$time,
  event = pbc_clean$event
)

# KM curves by treatment group
km_fit <- survfit(surv_object ~ trt, data = pbc_clean)

# Print summary
summary(km_fit)

# Plot (base R – interview safe)
plot(
  km_fit,
  col = c("blue", "red"),
  lwd = 2,
  xlab = "Time (days)",
  ylab = "Survival Probability",
  main = "Kaplan–Meier Survival Curves by Treatment Group"
)
legend(
  "bottomleft",
  legend = levels(pbc_clean$trt),
  col = c("blue", "red"),
  lwd = 2
)

# ------------------------------------------------------------
# 6. Log-Rank Test
# ------------------------------------------------------------

logrank_test <- survdiff(
  surv_object ~ trt,
  data = pbc_clean
)

logrank_test

# Interpretation:
# Tests whether survival curves differ between treatment arms

# ------------------------------------------------------------
# 7. Cox Proportional Hazards Model
# ------------------------------------------------------------

# Model adjusted for clinical covariates
cox_model <- coxph(
  surv_object ~ trt + age + bili,
  data = pbc_clean
)

summary(cox_model)

# Hazard Ratios with 95% Confidence Intervals
exp(
  cbind(
    HR = coef(cox_model),
    confint(cox_model)
  )
)

# Interpretation:
# HR > 1 : increased risk of death
# HR < 1 : protective effect

# ------------------------------------------------------------
# 8. Proportional Hazards Assumption Check
# ------------------------------------------------------------

ph_test <- cox.zph(cox_model)
ph_test

# Schoenfeld residual plots
plot(ph_test)

# Interpretation:
# p > 0.05 suggests PH assumption is reasonable

# ------------------------------------------------------------
# 9. Conceptual Summary (For Interview Defense)
# ------------------------------------------------------------

# - Kaplan–Meier: describes survival experience over time
# - Log-rank test: compares survival curves across groups
# - Cox model: estimates adjusted hazard ratios
# - Schoenfeld residuals: verify proportional hazards assumption
#
# This pipeline follows standard clinical survival analysis practice
# and appropriately accounts for right-censored observations.
