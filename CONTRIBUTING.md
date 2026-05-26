# Contributing

Thank you for your interest in contributing to this project. This is a reproducible academic analysis repository for the 24ASD516 Statistical Inference and Design of Experiments course. Contributions that improve correctness, reproducibility, clarity, or coverage are welcome.

---

## Table of Contents

- [What kind of contributions are welcome?](#what-kind-of-contributions-are-welcome)
- [What is out of scope?](#what-is-out-of-scope)
- [Before you start](#before-you-start)
- [Setting up the project locally](#setting-up-the-project-locally)
- [Making changes to the R script](#making-changes-to-the-r-script)
- [Reporting a statistical error](#reporting-a-statistical-error)
- [Submitting a pull request](#submitting-a-pull-request)
- [Style guide](#style-guide)
- [Commit message conventions](#commit-message-conventions)

---

## What kind of contributions are welcome?

| Type | Examples |
|------|---------|
| **Bug fixes** | Incorrect test statistic, wrong degrees of freedom, copy-paste error in R output |
| **Reproducibility fixes** | Hard-coded absolute paths, missing `set.seed()`, undeclared package dependency |
| **Code quality** | Clearer variable names, better inline comments, redundant code removal |
| **Documentation** | Typos in README, missing citation, broken link, unclear methodology note |
| **Extended analyses** | Additional post-hoc tests, effect size calculations, assumption diagnostic plots — provided they follow the same datasets and syllabus scope |
| **Portability** | Verified compatibility with a newer R version or a different OS |

---

## What is out of scope?

- Changing the datasets. Both datasets are official government sources chosen deliberately; substitutions will not be merged.
- Rewriting the analysis in Python, Julia, or any language other than R.
- Adding new datasets not referenced in the 24ASD516 syllabus.
- Changes that alter reported numerical results without a documented correction (see [Reporting a statistical error](#reporting-a-statistical-error)).

---

## Before you start

1. **Search existing issues** — check whether the bug or suggestion has already been raised.
2. **Open an issue first** for any non-trivial change. This allows discussion before you invest time writing code. For small typo fixes, a direct pull request is fine.
3. **Read the paper** (`paper/INFERENCE.pdf`) — every reported statistic in the README traces back to a verified console output. Any change to a reported number requires a corresponding correction to the paper or an explicit note explaining the discrepancy.

---

## Setting up the project locally

```r
# 1. Fork and clone the repository from github.com/souravmb/statistical-inference-doe-r

# 2. Install required packages
install.packages(c("car", "dplyr"))

# 3. Set working directory to the project root
setwd("/path/to/statistical-inference-doe-r")

# 4. Source the script — all output should reproduce exactly
source("analysis/SOURAVSAMYUKTHAA.R")
```

**Expected R version:** ≥ 4.2.0  
**Expected packages:** `car` ≥ 3.1, `dplyr` ≥ 1.1

If you encounter a reproducibility failure (your output does not match the values in the README), please open a [bug report](https://github.com/souravmb/statistical-inference-doe-r/issues/new?template=bug_report.md) before making any changes.

---

## Making changes to the R script

- Work on a dedicated branch: `git checkout -b fix/description` or `git checkout -b feat/description`.
- Keep the logical section structure of `SOURAVSAMYUKTHAA.R` intact (Unit I through Unit V, in order).
- Every code block must produce visible console output — do not add silent chunks.
- Run the full script from top to bottom after your change to confirm nothing downstream breaks.
- If a reported statistic changes, update the corresponding value in `README.md` and note it explicitly in your pull request description.

---

## Reporting a statistical error

If you believe a test statistic, p-value, confidence interval, or interpretation in the paper or README is incorrect:

1. Open an issue using the **Bug report** template.
2. Provide:
   - The section (e.g. "Unit II — Welch t-Test")
   - The reported value vs. the value you obtain
   - The exact R code you ran and the full console output
   - Your R version (`R.version.string`) and OS
3. Do not open a pull request correcting a statistic until the issue has been acknowledged by a maintainer — this ensures the correction is deliberate and traceable.

---

## Submitting a pull request

1. Ensure your branch is up to date with `main`.
2. Run the complete script and confirm all output is unchanged (or document what changed and why).
3. Fill in the pull request template completely — incomplete PRs will be returned.
4. Link the related issue in your PR description using `Closes #<issue-number>`.
5. Keep PRs focused — one logical change per PR.

---

## Style guide

**R code:**
- 2-space indentation
- `snake_case` for all variable and function names
- Lines ≤ 100 characters
- One blank line between logical blocks; two blank lines between Unit sections
- Inline comments explain *why*, not *what*: `# Welch t: variances unequal per F-test above` ✓ vs. `# t-test` ✗
- Use `<-` for assignment, not `=`

**Markdown:**
- Sentence case for all headings
- Wrap lines at 100 characters in `.md` files
- Tables for structured comparisons; prose for narrative

---

## Commit message conventions

```
<type>(<scope>): <short imperative summary>

[optional body — what and why, not how]

[optional footer — Closes #N]
```

| Type | Use for |
|------|---------|
| `fix` | Correcting a bug or statistical error |
| `docs` | README, methodology, data provenance |
| `refactor` | Code restructuring with no output change |
| `feat` | New analysis or test added |
| `chore` | Dependency, CI, or tooling update |

**Examples:**
```
fix(analysis): correct Wilcoxon V statistic sign convention
docs(readme): add session info to reproducibility section
feat(analysis): add Kruskal-Wallis as nonparametric ANOVA alternative
```

---

By contributing, you agree that your contributions will be licensed under the [MIT License](LICENSE) and that any data you introduce is either in the public domain or licensed compatibly.
