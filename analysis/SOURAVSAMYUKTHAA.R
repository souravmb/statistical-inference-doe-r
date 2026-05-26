# 24ASD516 — Statistical Inference & Design of Experiments
# Authors : Sourav M B (CB.PS.P2ASD25023)
#           Samyukthaa K G (CB.PS.P2ASD25022)
# Faculty : Dr. Deepa Menon O S
# Dept.   : Mathematics, Amrita Vishwa Vidyapeetham, Coimbatore

# Datasets:
#   DS1 — US State Crime Statistics (DOJ / Census Bureau ACS 2009, n = 51)
#   DS2 — NOAA El Niño Sea Surface Temperature (PMEL TAO/TRITON, n = 732)

set.seed(516)

# ── Packages
library(car)       # leveneTest, Anova (Type II)
library(dplyr)     # data wrangling

# ── Data Loading 
sc <- read.csv("data/statecrime_DOJ.csv")
el <- read.csv("data/elnino_NOAA.csv")

# ── Factor Encoding 
sc$region <- factor(sc$region,
                    levels = c("Northeast", "Midwest", "South", "West"))

el$month  <- factor(el$month,
                    levels = c("JAN","FEB","MAR","APR","MAY","JUN",
                               "JUL","AUG","SEP","OCT","NOV","DEC"))
el$season <- factor(el$season,
                    levels = c("Winter", "Spring", "Summer", "Fall"))
el$decade <- factor(el$decade)

# ── Binary Grouping Variables (split at median)
sc$violence_grp <- factor(ifelse(sc$violent >= median(sc$violent),
                                 "High-Violence", "Low-Violence"))
sc$poverty_grp  <- factor(ifelse(sc$poverty >= median(sc$poverty),
                                 "High-Poverty",  "Low-Poverty"))
sc$urban_grp    <- factor(ifelse(sc$urban   >= median(sc$urban),
                                 "Urban", "Rural"))

# ── Dataset Preview
cat("\n===== HEAD: State Crime =====\n"); print(head(sc, 5))
cat("\n===== HEAD: NOAA SST =====\n");   print(head(el, 5))
cat("\n===== SUMMARY: State Crime =====\n"); print(summary(sc))
cat("\n===== SUMMARY: NOAA SST =====\n");   print(summary(el))


# UNIT I — SINGLE-SAMPLE HYPOTHESIS TESTS

cat("\n  UNIT I — SINGLE-SAMPLE TESTS")

# 1a. Shapiro–Wilk Normality Tests
cat("\n--- Shapiro–Wilk Normality Tests ---\n")
sw_vars <- c("violent", "murder", "hs_grad", "poverty", "single", "urban")
for (v in sw_vars) {
  res <- shapiro.test(sc[[v]])
  dec <- ifelse(res$p.value < 0.05, "Non-normal", "Normal")
  cat(sprintf("  %-8s  W = %.3f   p = %.4f   [%s]\n",
              v, res$statistic, res$p.value, dec))
}

# 1b. One-Sample z-Test (sigma known)
#     H0: mu_violent = 400  (FBI benchmark); sigma = 180

cat("\n--- One-Sample z-Test (violent vs 400, sigma = 180) ---\n")
mu0  <- 400;  sig <- 180
xbar <- mean(sc$violent);  n <- nrow(sc)
z    <- (xbar - mu0) / (sig / sqrt(n))
p_z  <- 2 * pnorm(-abs(z))
ci_lo <- xbar - qnorm(0.975) * sig / sqrt(n)
ci_hi <- xbar + qnorm(0.975) * sig / sqrt(n)
cat(sprintf("  xbar = %.2f   z = %.4f   p = %.4f\n", xbar, z, p_z))
cat(sprintf("  95%% CI: (%.1f, %.1f)\n", ci_lo, ci_hi))
cat(sprintf("  Decision: %s\n", ifelse(p_z < 0.05, "Reject H0", "Fail to Reject H0")))


# 1c. One-Sample t-Tests vs. Policy Benchmarks
cat("\n--- One-Sample t-Tests vs. Policy Benchmarks ---\n")
benchmarks <- list(
  list(var = "violent",  mu0 = 350),
  list(var = "murder",   mu0 = 5.0),
  list(var = "poverty",  mu0 = 15.0),
  list(var = "hs_grad",  mu0 = 87.0),
  list(var = "urban",    mu0 = 60.0)
)
for (b in benchmarks) {
  res <- t.test(sc[[b$var]], mu = b$mu0)
  dec <- ifelse(res$p.value < 0.05, "Reject H0", "Fail to Reject H0")
  cat(sprintf("  %-8s vs %-5g  t = %+.3f   p = %.4f   [%s]\n",
              b$var, b$mu0, res$statistic, res$p.value, dec))
}

# 1d. One-Sided t-Test
#     H0: mu_hs_grad >= 88  vs  H1: mu < 88 (left-tailed)

cat("\n--- One-Sided t-Test (hs_grad < 88) ---\n")
res_1s <- t.test(sc$hs_grad, mu = 88, alternative = "less")
cat(sprintf("  t = %.3f   df = %d   p = %.4f\n",
            res_1s$statistic, res_1s$parameter, res_1s$p.value))
cat(sprintf("  Decision: %s\n",
            ifelse(res_1s$p.value < 0.05, "Reject H0", "Fail to Reject H0")))


# 1e. Chi-Square Test on Variance
#     H0: sigma^2_violent = 30,000
cat("\n--- Chi-Square Test on Variance (violent, H0: sigma^2 = 30000) ---\n")
s2       <- var(sc$violent)
sigma2_0 <- 30000
chi2_v   <- (n - 1) * s2 / sigma2_0
p_chi2v  <- 2 * min(pchisq(chi2_v, n - 1),
                    pchisq(chi2_v, n - 1, lower.tail = FALSE))
ci_s2_lo <- (n - 1) * s2 / qchisq(0.975, n - 1)
ci_s2_hi <- (n - 1) * s2 / qchisq(0.025, n - 1)
cat(sprintf("  s^2 = %.1f   chi2 = %.3f   df = %d   p = %.4f\n",
            s2, chi2_v, n - 1, p_chi2v))
cat(sprintf("  95%% CI for sigma^2: (%.0f, %.0f)\n", ci_s2_lo, ci_s2_hi))
cat(sprintf("  Decision: %s\n", ifelse(p_chi2v < 0.05, "Reject H0", "Fail to Reject H0")))



# UNIT II — TWO-SAMPLE INFERENCE

cat("\n  UNIT II — TWO-SAMPLE INFERENCE")

# 2a. F-Test for Equality of Variances
#     H0: sigma^2_HighPov = sigma^2_LowPov  (violent crime)

cat("\n--- F-Test for Equality of Variances (violent by poverty_grp) ---\n")
res_f <- var.test(violent ~ poverty_grp, data = sc)
cat(sprintf("  F = %.3f   df = (%d, %d)   p = %.4f\n",
            res_f$statistic,
            res_f$parameter[1], res_f$parameter[2],
            res_f$p.value))
cat(sprintf("  Decision: %s\n",
            ifelse(res_f$p.value < 0.05, "Reject H0", "Fail to Reject H0")))
cat("  -> Equal variances assumed; pooled t-test appropriate.\n")


# 2b. Two-Sample z-Test (sigma1, sigma2 known)
#     Murder rate: High-Violence vs. Low-Violence states
#     sigma1 = 3.8, sigma2 = 2.1 (UCR historical)
cat("\n--- Two-Sample z-Test (murder by violence_grp, sigmas known) ---\n")
hi_m <- sc$murder[sc$violence_grp == "High-Violence"]
lo_m <- sc$murder[sc$violence_grp == "Low-Violence"]
sig1 <- 3.8;  sig2 <- 2.1
z2   <- (mean(hi_m) - mean(lo_m)) /
  sqrt(sig1^2 / length(hi_m) + sig2^2 / length(lo_m))
p_z2 <- 2 * pnorm(-abs(z2))
cat(sprintf("  High-Violence murder mean = %.2f (n = %d)\n",
            mean(hi_m), length(hi_m)))
cat(sprintf("  Low-Violence  murder mean = %.2f (n = %d)\n",
            mean(lo_m), length(lo_m)))
cat(sprintf("  z = %.3f   p = %.4f\n", z2, p_z2))
cat(sprintf("  Decision: %s\n", ifelse(p_z2 < 0.05, "Reject H0", "Fail to Reject H0")))


# 2c. Equal-Variance (Pooled) t-Test
#     Violent crime: High-Violence vs. Low-Violence states

cat("\n--- Equal-Variance t-Test (violent by violence_grp) ---\n")
res_teq <- t.test(violent ~ violence_grp, data = sc, var.equal = TRUE)
cat(sprintf("  t = %.3f   df = %.0f   p = %.4f\n",
            res_teq$statistic, res_teq$parameter, res_teq$p.value))
cat(sprintf("  Decision: %s\n",
            ifelse(res_teq$p.value < 0.05, "Reject H0", "Fail to Reject H0")))


# 2d. Welch t-Test (Unequal Variances)
#     Murder rate: High-Poverty vs. Low-Poverty states

cat("\n--- Welch t-Test (murder by poverty_grp) ---\n")
res_welch <- t.test(murder ~ poverty_grp, data = sc)
cat(sprintf("  High-Poverty murder mean = %.2f\n",
            mean(sc$murder[sc$poverty_grp == "High-Poverty"])))
cat(sprintf("  Low-Poverty  murder mean = %.2f\n",
            mean(sc$murder[sc$poverty_grp == "Low-Poverty"])))
cat(sprintf("  t = %.3f   p = %.4f\n",
            res_welch$statistic, res_welch$p.value))
cat(sprintf("  Decision: %s\n",
            ifelse(res_welch$p.value < 0.05, "Reject H0", "Fail to Reject H0")))


# 2e. Paired t-Test
#     HS graduation rate vs. socioeconomic complement (100 - poverty%)

cat("\n--- Paired t-Test (hs_grad vs 100 - poverty) ---\n")
res_pair <- t.test(sc$hs_grad, 100 - sc$poverty, paired = TRUE)
d_bar <- mean(sc$hs_grad - (100 - sc$poverty))
cat(sprintf("  d-bar = %.3f\n", d_bar))
cat(sprintf("  t = %.3f   df = %.0f   p = %.4f\n",
            res_pair$statistic, res_pair$parameter, res_pair$p.value))
cat(sprintf("  95%% CI for mu_d: (%.3f, %.3f)\n",
            res_pair$conf.int[1], res_pair$conf.int[2]))
cat(sprintf("  Decision: %s\n",
            ifelse(res_pair$p.value < 0.05, "Reject H0", "Fail to Reject H0")))



# UNIT III — GOODNESS-OF-FIT & NONPARAMETRIC TESTS


cat("\n  UNIT III — GOF & NONPARAMETRIC TESTS")

# 3a. Chi-Square Goodness-of-Fit
#     Poverty categorised into 4 brackets; uniform null

cat("\n--- Chi-Square GoF (poverty categories, uniform null) ---\n")
pov_cat <- cut(sc$poverty,
               breaks = c(0, 10, 14, 18, 30),
               labels = c("<10", "10-14", "14-18", ">18"),
               right  = TRUE)
obs <- table(pov_cat)
cat("  Observed counts:", paste(obs, collapse = "  "), "\n")
res_gof <- chisq.test(obs)   # uniform null by default
cat(sprintf("  chi^2 = %.3f   df = %d   p = %.4f\n",
            res_gof$statistic, res_gof$parameter, res_gof$p.value))
cat(sprintf("  Decision: %s\n",
            ifelse(res_gof$p.value < 0.05, "Reject H0", "Fail to Reject H0")))


# 3b. Chi-Square Test of Independence
#     Violence group × Census Region (2 × 4)

cat("\n--- Chi-Square Independence (violence_grp x region) ---\n")
ct <- table(sc$violence_grp, sc$region)
print(ct)
res_ind <- chisq.test(ct)
cat(sprintf("  chi^2 = %.3f   df = %d   p = %.4f\n",
            res_ind$statistic, res_ind$parameter, res_ind$p.value))
cat("  Expected counts:\n"); print(round(res_ind$expected, 1))
cat(sprintf("  Decision: %s (low expected counts — result approximate)\n",
            ifelse(res_ind$p.value < 0.05, "Reject H0", "Fail to Reject H0")))


# 3c. Sign Test
#     H0: median_murder = 4.7 (two-sided, exact binomial)

cat("\n--- Sign Test (murder, H0: median = 4.7) ---\n")
med0    <- 4.7
n_plus  <- sum(sc$murder > med0)
n_minus <- sum(sc$murder < med0)
n_ties  <- sum(sc$murder == med0)
n_eff   <- n_plus + n_minus
p_sign  <- 2 * pbinom(min(n_plus, n_minus), n_eff, 0.5)
cat(sprintf("  n+ = %d   n- = %d   ties = %d   n_eff = %d\n",
            n_plus, n_minus, n_ties, n_eff))
cat(sprintf("  p = %.4f\n", p_sign))
cat(sprintf("  Decision: %s\n",
            ifelse(p_sign < 0.05, "Reject H0", "Fail to Reject H0")))


# 3d. Wilcoxon Signed-Rank Test
#     H0: theta_murder = 4.7

cat("\n--- Wilcoxon Signed-Rank Test (murder, H0: median = 4.7) ---\n")
res_wsr <- wilcox.test(sc$murder, mu = 4.7)
cat(sprintf("  V = %.1f   p = %.4f\n",
            res_wsr$statistic, res_wsr$p.value))
cat(sprintf("  Decision: %s\n",
            ifelse(res_wsr$p.value < 0.05, "Reject H0", "Fail to Reject H0")))


# UNIT IV — ONE-WAY ANOVA

cat("\n  UNIT IV — ONE-WAY ANOVA")


# 4a. One-Way ANOVA: SST by Season

cat("\n--- One-Way ANOVA: SST by Season (NOAA, n = 732) ---\n")

# Seasonal descriptives
cat("  Season means:\n")
season_stats <- el %>%
  group_by(season) %>%
  summarise(n    = n(),
            mean = round(mean(sst), 2),
            sd   = round(sd(sst),   2),
            .groups = "drop")
print(as.data.frame(season_stats))

aov_sst <- aov(sst ~ season, data = el)
cat("\n  ANOVA Table:\n")
print(summary(aov_sst))

ss_season <- sum(summary(aov_sst)[[1]]$`Sum Sq`[1])
ss_total  <- sum((el$sst - mean(el$sst))^2)
eta2_sst  <- ss_season / ss_total
cat(sprintf("  eta^2 = %.3f\n", eta2_sst))

# Levene's Test
cat("\n  Levene's Test for Homogeneity of Variance:\n")
print(leveneTest(sst ~ season, data = el))

# Tukey HSD
cat("\n  Tukey HSD Post-Hoc:\n")
print(TukeyHSD(aov_sst))

# Shapiro-Wilk on residuals
sw_res <- shapiro.test(residuals(aov_sst))
cat(sprintf("\n  Shapiro-Wilk on residuals: W = %.3f   p = %.3f\n",
            sw_res$statistic, sw_res$p.value))


# 4b. One-Way ANOVA: Violent Crime by Region

cat("\n--- One-Way ANOVA: Violent Crime by Region (n = 51) ---\n")

cat("  Region means:\n")
region_stats <- sc %>%
  group_by(region) %>%
  summarise(n    = n(),
            mean = round(mean(violent), 1),
            sd   = round(sd(violent),   1),
            .groups = "drop")
print(as.data.frame(region_stats))

aov_region <- aov(violent ~ region, data = sc)
cat("\n  ANOVA Table:\n")
print(summary(aov_region))

ss_region  <- sum(summary(aov_region)[[1]]$`Sum Sq`[1])
ss_total_v <- sum((sc$violent - mean(sc$violent))^2)
eta2_reg   <- ss_region / ss_total_v
cat(sprintf("  eta^2 = %.3f\n", eta2_reg))

# Tukey HSD
cat("\n  Tukey HSD Post-Hoc:\n")
print(TukeyHSD(aov_region))


# UNIT V — FACTORIAL DESIGNS

cat("\n  UNIT V — FACTORIAL DESIGNS")


# 5a. Latin Square Design (4 x 4)
#     Factors: Row = State Size, Col = Baseline Crime Level
#     Treatment: Law-Enforcement Strategy (A, B, C, D)
#     Response: % violent crime reduction
#     Note: Constructed illustrative experiment
#           calibrated to Chalfin & McCrary (2018).

cat("\n--- Latin Square: Law-Enforcement Strategy (4x4) ---\n")

ls_data <- data.frame(
  row      = factor(rep(1:4, each = 4)),
  col      = factor(rep(1:4, times = 4)),
  strategy = factor(c("A","B","C","D",
                      "B","A","D","C",
                      "C","D","A","B",
                      "D","C","B","A")),
  response = c(-7.3, -7.9, -9.2,-11.1,
               -7.0, -8.1, -9.0,-10.6,
               -7.4, -7.8, -9.3,-10.7,
               -7.1, -8.2, -8.9,-10.8)
)

cat("  Design layout:\n")
print(ls_data)

aov_ls <- aov(response ~ row + col + strategy, data = ls_data)
cat("\n  ANOVA Table:\n")
print(summary(aov_ls))

cat("\n  Strategy means (% reduction):\n")
print(tapply(ls_data$response, ls_data$strategy, mean))

cat("\n  Tukey HSD on Strategy:\n")
print(TukeyHSD(aov_ls, which = "strategy"))


# 5b. 2^2 Full Factorial (Two-Way ANOVA)
#     A: Poverty group (High / Low)
#     B: Urban group   (Urban / Rural)
#     Response: Violent crime rate (per 100,000)
#     Type II SS via car::Anova

cat("\n--- 2^2 Factorial ANOVA: Violent ~ Poverty x Urbanicity ---\n")

cat("  Cell means:\n")
cell_means <- sc %>%
  group_by(poverty_grp, urban_grp) %>%
  summarise(n    = n(),
            mean = round(mean(violent), 1),
            .groups = "drop")
print(as.data.frame(cell_means))

model_f22 <- lm(violent ~ poverty_grp * urban_grp, data = sc)
cat("\n  ANOVA Table (Type II SS):\n")
print(Anova(model_f22, type = 2))
cat(sprintf("\n  R^2 = %.4f\n", summary(model_f22)$r.squared))

cat("\n  Model Summary:\n")
print(summary(model_f22))
