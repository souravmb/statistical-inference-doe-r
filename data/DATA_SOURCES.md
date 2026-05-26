# Data Sources & Provenance

This document provides full attribution, access details, variable dictionaries,
and preprocessing notes for both datasets used in this analysis.

---

## DS1 — US State Crime Statistics

### Primary Source
- **Organisation:** Federal Bureau of Investigation (FBI)
- **Publication:** Crime in the United States: Uniform Crime Reports (UCR)
- **Year:** 2009
- **URL:** https://ucr.fbi.gov

### Supplementary Source
- **Organisation:** US Census Bureau
- **Publication:** American Community Survey (ACS) 2009
- **URL:** https://www.census.gov/programs-surveys/acs

### Access Method
Dataset retrieved via the Python `statsmodels` library:
```python
import statsmodels.api as sm
crime = sm.datasets.statecrime.load_pandas().data
crime.to_csv("statecrime_DOJ.csv", index=False)
```

### Copyright Status
Produced by agencies of the United States federal government.
In the public domain under 17 U.S.C. § 105. No copyright claimed.

### Variable Dictionary

| Variable | Type | Units | Description |
|----------|------|-------|-------------|
| `state` | character | — | State name (50 states + D.C.) |
| `violent` | numeric | crimes per 100,000 pop. | Total violent crimes |
| `murder` | numeric | crimes per 100,000 pop. | Murder and non-negligent manslaughter |
| `hs_grad` | numeric | % | Persons ≥25 with high school diploma |
| `poverty` | numeric | % | Persons below federal poverty line |
| `single` | numeric | % | Female-headed households with children |
| `white` | numeric | % | Non-Hispanic white population |
| `urban` | numeric | % | Population in urban areas |
| `region` | factor | — | US Census region: Northeast, Midwest, South, West |

### Derived Variables (computed in R)

| Variable | Definition |
|----------|-----------|
| `violence_grp` | `"High-Violence"` if `violent ≥ median(violent)`, else `"Low-Violence"` |
| `poverty_grp` | `"High-Poverty"` if `poverty ≥ median(poverty)`, else `"Low-Poverty"` |
| `urban_grp` | `"Urban"` if `urban ≥ median(urban)`, else `"Rural"` |

### Observations
n = 51 (all 50 US states + Washington D.C.)

---

## DS2 — NOAA El Niño Sea Surface Temperature

### Primary Source
- **Organisation:** National Oceanic and Atmospheric Administration (NOAA)
- **Division:** Pacific Marine Environmental Laboratory (PMEL)
- **Programme:** Tropical Atmosphere Ocean (TAO) / TRITON buoy array
- **URL:** https://www.pmel.noaa.gov/tao

### Access Method
Dataset retrieved via the Python `statsmodels` library:
```python
import statsmodels.api as sm
elnino = sm.datasets.elnino.load_pandas().data
# Reshape from wide (61 years × 12 months) to long format
import pandas as pd
elnino_long = elnino.melt(id_vars=["YEAR"],
                           var_name="month",
                           value_name="sst")
elnino_long.columns = ["year", "month", "sst"]
elnino_long.to_csv("elnino_NOAA.csv", index=False)
```

Decade and season columns were derived in R (see `analysis/SOURAVSAMYUKTHAA.R`).

### Copyright Status
Produced by NOAA, an agency of the United States federal government.
In the public domain under 17 U.S.C. § 105. No copyright claimed.

### Variable Dictionary

| Variable | Type | Units | Description |
|----------|------|-------|-------------|
| `year` | numeric | — | Calendar year (1950–2010) |
| `month` | factor | — | Month abbreviation (JAN–DEC) |
| `sst` | numeric | °C | Mean monthly sea surface temperature |
| `decade` | factor | — | Decade label (1950s, 1960s, …, 2000s) |
| `season` | factor | — | Meteorological season (Winter, Spring, Summer, Fall) |

### Season Mapping

| Months | Season |
|--------|--------|
| DEC, JAN, FEB | Winter |
| MAR, APR, MAY | Spring |
| JUN, JUL, AUG | Summer |
| SEP, OCT, NOV | Fall |

### Observations
n = 732 monthly observations (January 1950 – December 2010; 61 years × 12 months).

---

## Integrity Notes

- Both CSVs were exported without modification from the `statsmodels` source.
- No imputation was performed; no missing values are present in either dataset.
- The Latin Square response variable (`data/ls_data` constructed in R) is a
  synthetic response calibrated to Chalfin & McCrary (2018) and is not from
  an external file — it is defined inline in the R script (lines 346–357).
