---
name: Bug report
about: Report an incorrect statistic, reproducibility failure, or code error
title: "[BUG] "
labels: bug
assignees: souravmb
---

## Summary

<!-- One sentence: what is wrong and where. -->
<!-- Example: "The Wilcoxon V statistic in Unit III is reported as 539.5 but running the script gives 612.0" -->



---

## Affected section

<!-- Tick all that apply -->

- [ ] Unit I — Single-sample inference (z, t, χ², normality)
- [ ] Unit II — Two-sample inference (F, z, pooled t, Welch t, paired t)
- [ ] Unit III — Goodness-of-fit / Nonparametric (χ²-GoF, χ²-indep, Sign, Wilcoxon)
- [ ] Unit IV — One-way ANOVA (SST by season, violent crime by region)
- [ ] Unit V — Factorial designs (Latin Square, 2² factorial)
- [ ] README / documentation
- [ ] Data file (`statecrime_DOJ.csv` or `elnino_NOAA.csv`)
- [ ] Other (describe below)

**Specific line(s) in `SOURAVSAMYUKTHAA.R`:** <!-- e.g. lines 214–219 -->

---

## Reported value vs. obtained value

| | Reported in repo | Value you obtained |
|---|---|---|
| Statistic | | |
| p-value | | |
| Degrees of freedom | | |
| Other | | |

---

## Steps to reproduce

```r
# Paste the exact R code you ran
```

---

## Full console output

```
# Paste the complete output from your R console
```

---

## Environment

| Item | Value |
|------|-------|
| R version | <!-- e.g. R 4.3.2 --> |
| OS | <!-- e.g. macOS 14.4, Windows 11, Ubuntu 22.04 --> |
| `car` version | <!-- packageVersion("car") --> |
| `dplyr` version | <!-- packageVersion("dplyr") --> |

---

## Additional context

<!-- Any other information that helps diagnose the issue. -->
