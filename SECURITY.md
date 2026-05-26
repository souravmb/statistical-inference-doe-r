# Security Policy

## Overview

This is a **read-only statistical analysis repository** containing R scripts, CSV datasets sourced from US federal government publications, and a PDF research paper. It does not include a web application, API, authentication system, or executable binary.

The attack surface is minimal; however, the following policy applies to ensure responsible disclosure for any issue that could affect users who clone and execute this code.

---

## Supported versions

| Version | Supported |
|---------|-----------|
| `main` branch (latest) | ✅ Active |
| Older commits / forks | ❌ Not supported |

All fixes are applied directly to the `main` branch. No versioned release branches exist.

---

## What counts as a security concern here?

Given the nature of this repository, relevant security issues include:

- **Malicious code injection** — any commit or pull request that introduces code designed to exfiltrate data, execute remote commands, or cause harm when the R script is sourced.
- **Dependency confusion** — a package name in `install.packages()` that could be hijacked on CRAN or a mirror.
- **Data integrity** — tampering with the CSV datasets in a way that silently alters reported statistical results without disclosure.
- **Supply-chain concerns** — any third-party resource loaded by the code (currently none beyond CRAN packages) that is compromised.

Incorrect statistical results, typos, and reproducibility failures are **not** security issues — please report those via the standard [bug report issue template](https://github.com/souravmb/statistical-inference-doe-r/issues/new?template=bug_report.md).

---

## Reporting a vulnerability

**Do not open a public GitHub issue for security concerns.**

Please report security vulnerabilities privately by emailing the maintainer. Provide:

1. A clear description of the issue and its potential impact.
2. Steps to reproduce (R version, OS, exact code path).
3. Any proof-of-concept or affected file paths.

You will receive an acknowledgement within **72 hours** and a resolution or status update within **7 days**.

---

## Disclosure policy

- We follow **coordinated disclosure**: we ask that you give us reasonable time to investigate and patch before any public disclosure.
- Once resolved, we will publish a brief disclosure note in the repository's release notes or a pinned issue, crediting the reporter (unless anonymity is requested).

---

## Out of scope

- Theoretical attacks with no practical path to exploitation in a static analysis repository.
- Issues in R itself, CRAN infrastructure, or third-party packages — please report those to the respective maintainers.
- Social engineering attempts.

---

Thank you for helping keep this project and its users safe.
