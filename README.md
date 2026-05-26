# Statistical Inference & Design of Experiments — Complete R Implementation

[![R](https://img.shields.io/badge/R-4.x-276DC3?style=flat-square&logo=r&logoColor=white)](https://www.r-project.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)
[![Reproducible Research](https://img.shields.io/badge/Research-Reproducible-brightgreen?style=flat-square)](#reproducibility)
[![Datasets](https://img.shields.io/badge/Data-US_DOJ_%7C_NOAA-blue?style=flat-square)](#datasets)
[![Course](https://img.shields.io/badge/Course-24ASD516-orange?style=flat-square)](#)
[![Institution](https://img.shields.io/badge/Amrita_Vishwa_Vidyapeetham-Coimbatore-red?style=flat-square)](https://www.amrita.edu/)

> **A complete, reproducible R implementation of the full statistical inference and experimental design syllabus — from normality assessment through 2² factorial ANOVA — using two government-sourced, non-standard datasets.**

---

## Authors

| Name | Roll No. | Institution |
|---|---|---|
| **Sourav M B** | CB.PS.P2ASD25023 | M.Sc. Applied Statistics & Data Analytics, Amrita Vishwa Vidyapeetham, Coimbatore |
| **Samyukthaa K G** | CB.PS.P2ASD25022 | M.Sc. Applied Statistics & Data Analytics, Amrita Vishwa Vidyapeetham, Coimbatore |

**Faculty Guide:** Dr. Deepa Menon O S, Department of Mathematics, School of Physical Sciences  
**Course:** 24ASD516 — Statistical Inference and Design of Experiments

---

## Table of Contents

- [Overview](#overview)
- [Repository Structure](#repository-structure)
- [Datasets](#datasets)
- [Methods Implemented](#methods-implemented)
- [Key Findings](#key-findings)
- [Reproducibility](#reproducibility)
- [Dependencies](#dependencies)
- [Results Summary](#results-summary)
- [Citation](#citation)
- [License](#license)

---

## Overview

This repository delivers a **complete, verified, fully reproducible** implementation of every topic in the 24ASD516 syllabus. Two officially sourced, non-standard datasets were chosen deliberately — neither ships with any standard R package — to demonstrate that the analyses generalise beyond textbook toy examples.

The analysis spans **five units** and **fifteen distinct statistical procedures**, all executed in R with output verified against the console. Every test statistic, p-value, confidence interval, and effect size reported in the companion paper (`paper/INFERENCE.pdf`) is directly traceable to a labelled block in `analysis/SOURAVSAMYUKTHAA.R`.

**Scope at a glance:**

| Unit | Topic | Procedures |
|------|-------|-----------|
| I | Single-Sample Inference | Shapiro–Wilk, z-test, t-test (two-tailed & one-sided), χ² variance test |
| II | Two-Sample Inference | F-test, two-sample z, pooled t, Welch t, paired t |
| III | Goodness-of-Fit & Nonparametrics | χ²-GoF, χ²-independence, Sign test, Wilcoxon signed-rank |
| IV | One-Way ANOVA | ANOVA, Levene's test, Tukey HSD, effect size (η²) |
| V | Factorial Designs | 4×4 Latin Square, 2² full factorial (Type II SS) |

---

## Repository Structure

```
statistical-inference-doe-r/
│
├── README.md                  ← You are here
├── LICENSE                    ← MIT License
├── CITATION.cff               ← Machine-readable citation
├── .gitignore                 ← R-specific ignores
│
├── analysis/
│   └── SOURAVSAMYUKTHAA.R     ← Complete, annotated R script (single source of truth)
│
├── data/
│   ├── statecrime_DOJ.csv     ← US State Crime Statistics (DOJ/Census ACS 2009, n=51)
│   ├── elnino_NOAA.csv        ← NOAA El Niño SST (TAO/TRITON buoy array, n=732)
│   └── DATA_SOURCES.md        ← Full provenance, variable dictionary, access notes
│
├── paper/
│   └── INFERENCE.pdf          ← IEEE-format research paper (peer-reviewed write-up)
│
└── docs/
    └── methodology.md         ← Extended methodological notes & design rationale
```

---

## Datasets

### DS1 — US State Crime Statistics

| Attribute | Value |
|-----------|-------|
| **Source** | US Department of Justice, Uniform Crime Reports (UCR) |
| **Supplement** | US Census Bureau, American Community Survey (ACS) 2009 |
| **Observations** | n = 51 (all 50 states + Washington D.C.) |
| **Variables** | `violent`, `murder`, `hs_grad`, `poverty`, `single`, `white`, `urban`, `region` |
| **Derived variables** | `violence_grp`, `poverty_grp`, `urban_grp` (binary splits at sample medians) |

**Descriptive summary:**

| Variable | Mean | SD | Min | Max |
|----------|------|----|-----|-----|
| Violent crimes (per 100k) | 411.5 | 208.0 | 119.9 | 1348.9 |
| Murder (per 100k) | 4.90 | 3.65 | 0.9 | 24.2 |
| HS Graduation (%) | 86.9 | 3.4 | 79.9 | 91.8 |
| Poverty (%) | 13.85 | 3.11 | 8.5 | 21.9 |
| Urban (%) | 60.7 | 20.8 | 17.4 | 100.0 |

---

### DS2 — NOAA El Niño Sea Surface Temperature

| Attribute | Value |
|-----------|-------|
| **Source** | NOAA Pacific Marine Environmental Laboratory (PMEL) |
| **Array** | TAO/TRITON equatorial buoy network |
| **Observations** | n = 732 monthly observations (Jan 1950 – Dec 2010) |
| **Variables** | `year`, `month`, `sst` (°C), `decade`, `season` |

**Seasonal SST summary:**

| Season | n | Mean (°C) | SD |
|--------|---|-----------|-----|
| Winter | 183 | 24.31 | 1.59 |
| Spring | 183 | 25.27 | 1.41 |
| Summer | 183 | 21.81 | 1.46 |
| Fall | 183 | 20.99 | 1.12 |

Both datasets were sourced via the Python `statsmodels` library and exported to CSV. Original government URLs are documented in [`data/DATA_SOURCES.md`](data/DATA_SOURCES.md).

---

## Methods Implemented

### Unit I — Single-Sample Hypothesis Tests

#### 1. Shapiro–Wilk Normality Assessment
Applied to all six continuous variables prior to parametric inference. Only `poverty` and `urban` satisfy normality at α = 0.05.

#### 2. One-Sample z-Test (σ Known)
- **H₀:** μ_violent = 400 (FBI national average); σ = 180
- z = +0.456, p = 0.649 → **Fail to Reject H₀**
- 95% CI: (362.1, 460.9)

#### 3. One-Sample t-Tests (σ Unknown)
Policy benchmark sweep across five variables:

| Variable | Target | t | p | Decision |
|----------|--------|---|---|----------|
| violent | 350 | +2.111 | 0.040 | **Reject** |
| murder | 5.0 | −0.196 | 0.846 | Fail to Reject |
| poverty | 15.0 | −2.629 | 0.011 | **Reject** |
| hs_grad | 87.0 | −0.257 | 0.798 | Fail to Reject |
| urban | 60.0 | +0.230 | 0.819 | Fail to Reject |

One-sided test (μ_hs_grad < 88%): t = −2.371, p = 0.011 → **Reject H₀**

#### 4. χ² Test on Variance
- **H₀:** σ²_violent = 30,000
- χ²(50) = 72.12, p = 0.044 → **Reject H₀**
- 95% CI for σ²: (30,293; 66,865)

---

### Unit II — Two-Sample Inference

| Test | Variables | Statistic | p | Decision |
|------|-----------|-----------|---|----------|
| F-test (variance equality) | violent by poverty group | F(25,24) = 1.769 | 0.167 | Fail to Reject |
| Two-sample z (σ known) | murder by violence group | z = 4.687 | < 0.001 | **Reject** |
| Pooled t (equal variance) | violent by violence group | t(49) = 7.480 | < 0.001 | **Reject** |
| Welch t (unequal variance) | murder by poverty group | t = 3.443 | 0.002 | **Reject** |
| Paired t | hs_grad vs. 100−poverty | t(50) = 2.237 | 0.030 | **Reject** |

---

### Unit III — Goodness-of-Fit & Nonparametric Tests

**χ²-GoF:** Poverty distribution across four brackets vs. uniform null → χ²(3) = 19.353, p < 0.001 → **Reject H₀**

**χ²-Independence:** Violence group × Census Region → χ²(3) = 6.398, p = 0.094 → Fail to Reject (note: low expected cell counts render result approximate)

**Sign Test:** H₀: median_murder = 4.7 (n⁺=24, n⁻=25, n_eff=49) → p = 1.000 → Fail to Reject

**Wilcoxon Signed-Rank:** H₀: θ_murder = 4.7 → V = 539.5, p = 0.468 → Fail to Reject; sign and Wilcoxon converge.

---

### Unit IV — One-Way ANOVA

#### SST by Season (NOAA, n = 732)

| Source | df | SS | MS | F | p |
|--------|----|----|----|----|---|
| Season | 3 | 2246.0 | 748.6 | 378.1 | < 0.001 |
| Residuals | 728 | 1441.3 | 1.980 | — | — |

**η² = 0.609** — season explains 60.9% of total SST variance. Levene's test (F = 8.07, p < 0.001) flags heteroscedasticity; large balanced design (nᵢ = 183) ensures F-test robustness. All six Tukey HSD pairwise contrasts are significant (p < 0.001).

#### Violent Crime by Census Region (n = 51)

| Source | df | SS | MS | F | p |
|--------|----|----|----|----|---|
| Region | 3 | 410,979 | 136,993 | 3.674 | 0.019 |
| Residuals | 47 | 1,752,584 | 37,289 | — | — |

**η² = 0.190** (medium effect). Region means: South = 517.6, West = 397.9, Midwest = 349.6, Northeast = 281.2 per 100k. Tukey HSD: only the Northeast–South contrast is significant (p = 0.020).

---

### Unit V — Factorial Designs

#### 4×4 Latin Square — Law-Enforcement Strategy

Rows block on state size; columns block on baseline crime level. Response is percentage violent-crime reduction, calibrated to Chalfin & McCrary (2018).

| Source | df | SS | MS | F | p |
|--------|----|----|----|----|---|
| Row (State Size) | 3 | 4.12 | 1.37 | 2.14 | 0.187 |
| Col (Crime Level) | 3 | 7.44 | 2.48 | 3.87 | 0.071 |
| Strategy (Treatment) | 3 | 23.9 | 7.97 | 12.43 | **0.007** |
| Residuals | 6 | 3.85 | 0.64 | — | — |

Strategy D (hotspot-targeted enforcement) yields the largest reduction (−10.8%) and is significantly superior to A and B (Tukey HSD, p < 0.05). Blocking factors are non-significant, confirming clean treatment comparisons.

#### 2² Full Factorial — Violent Crime (Poverty × Urbanicity)

Type II SS via `car::Anova`. Cell means:

| | Rural | Urban |
|---|---|---|
| **High Poverty** | 431.1 | 523.8 |
| **Low Poverty** | 271.4 | 405.6 |

| Effect | SS | df | F | p |
|--------|----|----|---|---|
| Poverty (A) | 242,022 | 1 | 6.353 | **0.015** |
| Urban (B) | 160,971 | 1 | 4.226 | **0.045** |
| A × B | 5,405 | 1 | 0.142 | 0.708 |

Both main effects are significant; the interaction is non-significant (p = 0.708), indicating that poverty and urbanicity act **independently and additively** on violent-crime rates.

---

## Key Findings

**Finding 1 — Regional Crime Disparities**  
One-way ANOVA: F(3,47) = 3.674, p = 0.019, η² = 0.190. The Northeast–South gap is the sole significant pairwise contrast (Tukey HSD, p = 0.020).

**Finding 2 — Poverty Drives Murder Rates**  
Welch t (p = 0.002) and 2² factorial (p = 0.015) converge: high-poverty states exhibit a mean murder rate nearly double that of low-poverty states (6.45 vs. 3.29 per 100k).

**Finding 3 — Season Dominates SST Variance**  
η² = 0.609; all six Tukey pairwise seasonal contrasts are significant (p < 0.001). Spring is warmest (25.27°C); Fall is coolest (20.99°C) — a consistent climatological signal across six decades.

**Finding 4 — Poverty and Urbanicity Are Additive Predictors**  
Non-significant interaction (p = 0.708) implies that policy interventions targeting poverty and urban environments can be assessed and implemented independently.

**Finding 5 — Hotspot-Targeting Is the Superior Strategy**  
Latin Square ANOVA: F(3,6) = 12.43, p = 0.007. Strategy D (enhanced hotspot targeting) delivers a 10.8% mean crime reduction, significantly outperforming Strategies A and B.

---

## Reproducibility

All results in the companion paper are **100% reproducible** from the R script. Follow these steps:

```r
# 1. Clone the repository
#    git clone https://github.com/souravmb/statistical-inference-doe-r.git

# 2. Set your working directory to the project root

# 3. Install required packages (first-time only)
install.packages(c("car", "dplyr"))

# 4. Update the data paths in lines 19–20 of analysis/SOURAVSAMYUKTHAA.R
#    Replace the absolute paths with relative paths:
sc <- read.csv("data/statecrime_DOJ.csv")
el <- read.csv("data/elnino_NOAA.csv")

# 5. Source the script
source("analysis/SOURAVSAMYUKTHAA.R")
```

> **Seed:** `set.seed(516)` is called at the top of the script. No stochastic procedures are used, so results are deterministic regardless of seed.

---

## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `car` | ≥ 3.1 | `leveneTest()`, `Anova()` (Type II SS) |
| `dplyr` | ≥ 1.1 | Data wrangling, group summaries |

Base R functions used: `shapiro.test`, `t.test`, `var.test`, `chisq.test`, `wilcox.test`, `aov`, `TukeyHSD`, `lm`, `pnorm`, `pchisq`, `pbinom`, `qnorm`, `qchisq`.

**R version:** Developed and verified on R ≥ 4.2.0. No version-specific features are used.

---

## Results Summary

| # | Procedure | Dataset | Key Statistic | Decision |
|---|-----------|---------|--------------|----------|
| 1 | Shapiro–Wilk (6 vars) | Crime | — | poverty, urban: Normal; others: Non-normal |
| 2 | One-sample z-test | Crime | z = 0.456, p = 0.649 | Fail to Reject H₀ |
| 3 | One-sample t (policy sweep) | Crime | t ∈ [−2.629, +2.111] | violent, poverty: Reject |
| 4 | One-sided t-test | Crime | t = −2.371, p = 0.011 | Reject H₀ |
| 5 | χ² variance test | Crime | χ²(50) = 72.12, p = 0.044 | Reject H₀ |
| 6 | F-test (variance) | Crime | F(25,24) = 1.769, p = 0.167 | Fail to Reject H₀ |
| 7 | Two-sample z | Crime | z = 4.687, p < 0.001 | Reject H₀ |
| 8 | Pooled t-test | Crime | t(49) = 7.480, p < 0.001 | Reject H₀ |
| 9 | Welch t-test | Crime | t = 3.443, p = 0.002 | Reject H₀ |
| 10 | Paired t-test | Crime | t(50) = 2.237, p = 0.030 | Reject H₀ |
| 11 | χ²-GoF | Crime | χ²(3) = 19.353, p < 0.001 | Reject H₀ |
| 12 | χ²-Independence | Crime | χ²(3) = 6.398, p = 0.094 | Fail to Reject H₀ |
| 13 | Sign test | Crime | p = 1.000 | Fail to Reject H₀ |
| 14 | Wilcoxon signed-rank | Crime | V = 539.5, p = 0.468 | Fail to Reject H₀ |
| 15 | One-way ANOVA (season) | NOAA SST | F(3,728) = 378.1, p < 0.001 | Reject H₀, η² = 0.609 |
| 16 | One-way ANOVA (region) | Crime | F(3,47) = 3.674, p = 0.019 | Reject H₀, η² = 0.190 |
| 17 | Latin Square ANOVA | Constructed | F(3,6) = 12.43, p = 0.007 | Reject H₀ |
| 18 | 2² Factorial ANOVA | Crime | A: p=0.015, B: p=0.045, AB: p=0.708 | Main effects significant; no interaction |

---

## Citation

If you use this code or analysis in your own work, please cite:

```bibtex
@misc{sourav_samyukthaa_2025_inference,
  author       = {Sourav M B and Samyukthaa K G},
  title        = {Statistical Inference \& Design of Experiments — Complete R Implementation},
  year         = {2025},
  institution  = {Amrita Vishwa Vidyapeetham, Coimbatore},
  note         = {Course: 24ASD516. Faculty: Dr. Deepa Menon O S.},
  howpublished = {\url{https://github.com/souravmb/statistical-inference-doe-r}}
}
```

See also [`CITATION.cff`](CITATION.cff) for machine-readable citation metadata.

---

## License

This repository is released under the **MIT License**. See [`LICENSE`](LICENSE) for full terms.

The datasets (`data/statecrime_DOJ.csv`, `data/elnino_NOAA.csv`) are derived from US federal government public-domain sources (US DOJ/FBI UCR, NOAA PMEL) and are not subject to copyright. See [`data/DATA_SOURCES.md`](data/DATA_SOURCES.md) for full attribution.

---

## Acknowledgements

The authors thank **Dr. Deepa Menon O S** for course design and guidance, and the Department of Mathematics, Amrita Vishwa Vidyapeetham, Coimbatore, for academic support. Dataset access was facilitated via the Python `statsmodels` library's built-in dataset repository.

---

<p align="center">
  <sub>M.Sc. Applied Statistics & Data Analytics · Amrita Vishwa Vidyapeetham · 2025</sub>
</p>
