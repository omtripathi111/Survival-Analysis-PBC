# 1. Setup and loading data
library(survival)
library(dplyr)
set.seed(101)
data(pbc)

# 2. Check data structure and missing values
str(pbc)
colSums(is.na(pbc))

# 3. Defining the death event (status 2 is death, 0 and 1 are censored/transplant)
pbc$death_event <- ifelse(pbc$status == 2, 1, 0)

# 4. Converting treatment to labeled factor for plotting
pbc$group <- factor(pbc$trt, levels=c(1, 2), labels=c("Treated", "Placebo"))

# 5. Data cleaning: removing rows with NAs in main variables
pbc_final <- pbc %>% 
  filter(!is.na(death_event), !is.na(group), !is.na(age), !is.na(bili))

# 6. Quick histogram to check distribution of Bilirubin (Disease severity marker)
hist(pbc_final$bili, breaks=30, main="Distribution of Serum Bilirubin", col="gray")

# 7. Kaplan-Meier estimation by treatment group
km_analysis <- survfit(Surv(time, death_event) ~ group, data = pbc_final)

# 8. Survival plot using base R

plot(km_analysis, col=c("darkblue", "darkred"), lwd=2, 
     xlab="Days", ylab="Survival Probability", 
     main="KM Survival Curves: PBC Study")
legend("bottomleft", legend=c("Treated", "Placebo"), col=c("darkblue", "darkred"), lty=1, lwd=2)

# 9. Log-rank test to compare survival curves across treatment arms
logrank_res <- survdiff(Surv(time, death_event) ~ group, data = pbc_final)
print(logrank_res)

# 10. Fitting the Cox Proportional Hazards Model
# Adjusting treatment effect for age and bilirubin levels
cox_fit <- coxph(Surv(time, death_event) ~ group + age + bili, data = pbc_final)
summary(cox_fit)

# 11. Extracting Hazard Ratios and 95% Confidence Intervals
exp_results <- exp(cbind(HR = coef(cox_fit), confint(cox_fit)))
print(exp_results)

# 12. Testing the Proportional Hazards assumption (Schoenfeld residuals)
ph_assumption_check <- cox.zph(cox_fit)
print(ph_assumption_check)

# 13. Plotting Schoenfeld residuals for model diagnostics

plot(ph_assumption_check)