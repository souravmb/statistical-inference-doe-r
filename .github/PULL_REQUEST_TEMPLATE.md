## Summary

<!-- One paragraph: what this PR does and why. -->



---

## Related issue

<!-- Every non-trivial PR must link to an open issue. -->
<!-- Use "Closes #N" to auto-close on merge, or "Relates to #N" if it's partial. -->

Closes #

---

## Type of change

- [ ] Bug fix — corrects a statistical error or code defect (no output changes other than the fix)
- [ ] Bug fix — corrects a reproducibility failure
- [ ] Documentation update — README, methodology notes, data provenance
- [ ] Refactor — code restructuring with **no change** to any reported output
- [ ] New analysis or feature — adds a test, plot, or procedure
- [ ] Dependency / environment update

---

## Statistical output checklist

> Complete this section for any change to `analysis/SOURAVSAMYUKTHAA.R`.

- [ ] I ran the **complete script** (`source("analysis/SOURAVSAMYUKTHAA.R")`) from a clean R session after my change.
- [ ] All reported statistics in the README **match my console output** — OR — I have documented the changed values below.

**If any reported statistic changes, list every change here:**

| Section | Quantity | Old value | New value | Reason |
|---------|----------|-----------|-----------|--------|
| | | | | |

---

## Reproducibility checklist

- [ ] No hard-coded absolute file paths — all data reads use `"data/statecrime_DOJ.csv"` and `"data/elnino_NOAA.csv"` (relative paths).
- [ ] `set.seed(516)` is still present at the top of the script.
- [ ] No new package dependencies introduced — OR — new packages are declared in `CONTRIBUTING.md` and the README dependencies table.
- [ ] Script runs without errors or warnings on R ≥ 4.2.0.

---

## Documentation checklist

- [ ] README updated if any reported value, table, or section heading changed.
- [ ] `docs/methodology.md` updated if a methodological decision changed.
- [ ] Inline comments in the R script explain *why* (not just *what*).

---

## Environment

| Item | Value |
|------|-------|
| R version | |
| OS | |
| `car` version | |
| `dplyr` version | |

---

## Reviewer notes

<!-- Anything specific you want the reviewer to pay attention to. -->
<!-- If this involves a statistical correction, paste the relevant before/after console output here. -->
