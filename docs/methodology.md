# Methodology Notes

Extended design rationale, assumption checks, and implementation decisions
for the analysis in `analysis/SOURAVSAMYUKTHAA.R`.

---

## 1. Dataset Selection Rationale

Both datasets were selected to satisfy four criteria simultaneously:

1. **Official government provenance** — traceable to primary US federal sources
   (DOJ/FBI UCR, NOAA PMEL), ensuring credibility and public-domain status.
2. **Non-standard** — neither dataset ships with base R or any standard
   R package (e.g., `datasets`, `MASS`), demonstrating generalisation beyond
   textbook examples.
3. **Syllabus coverage** — DS1 (n=51, cross-sectional, mixed normal/non-normal)
   is suited to single-sample inference, two-sample comparisons, and factorial
   designs; DS2 (n=732, balanced repeated monthly structure) is suited to
   one-way ANOVA with a strong seasonal signal.
4. **Pedagogical contrast** — DS1 exhibits substantive non-normality in most
   variables (justifying nonparametric methods in Unit III), while DS2's large
   balanced structure provides a clean showcase for ANOVA's robustness properties.

---

## 2. Normality Assessment Strategy

Shapiro–Wilk was applied to all six continuous crime variables prior to any
parametric inference (Unit I). Results guided the decision tree for every
downstream test:

| Decision point | Outcome |
|---------------|---------|
| SW p < 0.05 for `violent`, `murder`, `single`, `hs_grad` | Nonparametric alternatives (Sign, Wilcoxon) reported for `murder` in Unit III |
| SW p > 0.05 for `poverty`, `urban` | Pooled t-test, variance tests, and factorial ANOVA proceed on these variables |
| Central Limit Theorem invocation | Two-sample z-test and ANOVA for `violent` justified by n=51 and n=732 respectively |

---

## 3. Two-Sample z-Test: Assumed σ Values

Historical UCR inter-state standard deviations (σ₁ = 3.8, σ₂ = 2.1 for murder
by violence group) were used to demonstrate the two-sample z-test procedure.
These values represent published UCR ranges across comparable reporting periods
and are applied purely to illustrate the mechanics of the known-σ case. The
Welch t-test in the same unit treats σ as unknown, providing an appropriate
parallel comparison.

---

## 4. Chi-Square Independence: Low Expected Counts

The 2×4 contingency table (Violence group × Census Region) has minimum expected
cell count ≈ 4.4, below the conventional threshold of 5. The result (χ²(3) = 6.398,
p = 0.094) is therefore treated as approximate. Fisher's exact test was not applied
because it does not have a standard implementation for tables larger than 2×2 in
base R without external packages. The limitation is explicitly noted in the paper.

---

## 5. Sign Test Implementation

The exact binomial sign test is implemented manually using `pbinom()` rather than
via the `BSDA::SIGN.test()` function, to avoid an additional package dependency
and to make the test mechanics transparent:

```r
p_sign <- 2 * pbinom(min(n_plus, n_minus), n_eff, 0.5)
```

The two ties (observations exactly equal to the null median 4.7) are excluded
from `n_eff`, following standard practice.

---

## 6. ANOVA Assumption Checks

### SST by Season (NOAA)

- **Levene's test:** F = 8.07, p < 0.001 — heteroscedasticity is present.
- **Mitigating factor:** The design is perfectly balanced (nᵢ = 183 for all four
  seasons), and the F-test is known to be robust to variance heterogeneity under
  balanced designs (Lindman, 1974).
- **Shapiro–Wilk on residuals:** W < 0.95, p < 0.001 — residuals are non-normal,
  consistent with the bimodal seasonal structure. The large n (732) ensures
  approximate normality of group means by CLT.

### Violent Crime by Region

- Tukey HSD is applied post-hoc. With only n=51 observations across 4 groups,
  power for individual contrasts is modest, explaining why only the Northeast–South
  comparison (the largest mean difference, Δ = 236.4 per 100k) survives correction.

---

## 7. Latin Square: Constructed Response

The 4×4 Latin Square response is synthetic, constructed to be internally consistent
with the published Chalfin & McCrary (2018) effect-size range for policing
interventions (approximately −7% to −11% violent-crime reduction). The design is
presented as an illustrative factorial experiment, not as empirical field data. The
R code that generates the data is fully visible in lines 346–357 of
`analysis/SOURAVSAMYUKTHAA.R`.

---

## 8. Type II vs. Type III Sums of Squares

The 2² factorial uses **Type II SS** via `car::Anova(model, type = 2)`. Because
the design is unbalanced (cell sizes: 14, 12, 11, 14), Type I SS (base R `aov`)
is order-dependent and inappropriate. Type II SS is preferred over Type III SS
for models without a significant interaction (Fox & Weisberg, 2019), which is
confirmed by the non-significant A×B term (p = 0.708).

---

## 9. Effect Size Reporting

η² (eta-squared) is reported for both one-way ANOVA models:

- SST by Season: η² = SS_season / SS_total = 2246.0 / 3687.3 = **0.609** (large)
- Violent Crime by Region: η² = 410,979 / 2,163,563 = **0.190** (medium, per Cohen 1988)

For the 2² factorial, R² from `summary(lm())` is reported as the omnibus effect size.

---

## References

- Cohen, J. (1988). *Statistical Power Analysis for the Behavioral Sciences* (2nd ed.). Lawrence Erlbaum.
- Chalfin, A., & McCrary, J. (2018). Are U.S. cities underpoliced? *Review of Economics and Statistics*, 100(1), 167–186.
- Fox, J., & Weisberg, S. (2019). *An R Companion to Applied Regression* (3rd ed.). Sage.
- Lindman, H. R. (1974). *Analysis of Variance in Complex Experimental Designs*. Freeman.
