# ECO346 Assignment 1 — FA24-BEDS-029

## 1. Assignment Information

- **Course:** ECO346 — Data Visualization Techniques for Economists
- **Assignment:** Assignment 1 — Fall 2026
- **Registration Number:** FA24-BEDS-029
- **Name:** Hafiz Zohaib Arshad
- **Variant:** 5
- **Selected Population:** Khyber Pakhtunkhwa (KP), Urban
- **Age Range:** 15–64 years
- **Earnings Requirement:** Annual earnings greater than zero

## 2. Repository Structure

```text
ECO346-A1-FA24-BEDS-029/
├── README.md
├── data/
│   ├── pslm_person_subset.csv
│   └── pslm_hh_subset.csv
├── scripts/
│   ├── q2_weighted_histogram.R
│   ├── q3_earnings_vs_age.R
│   ├── q4_redesign.R
│   └── q5_reproduction.py
├── figures/
│   ├── Q2_weighted_histogram.svg
│   ├── Q3_earnings_vs_age.svg
│   ├── default.svg
│   ├── redesigned.svg
│   └── Q5_python_reproduction.svg
└── slides/
    └── FA24-BEDS-029.pptx
```

*Note: Update the filenames in this structure if your actual files use different names.*

## 3. Data and Sample Selection

The analysis focuses on urban households in Khyber Pakhtunkhwa, Pakistan. Person-level and household-level data are joined using `hhid`.

The sample includes individuals aged 15–64 with positive annual earnings. The analysis uses the household weight (`hhweight`) for weighted earnings statistics.

The selected population is identified using:
- `prov_code == 1`: Khyber Pakhtunkhwa
- `urban_rural == 2`: Urban

## 4. Question 2 — Weighted Earnings Distribution

A weighted histogram is used to examine the distribution of annual earnings. Earnings are displayed on a logarithmic scale using base-10 logarithms, with bin widths of 0.1 between log10 values of 4 and 7.

The figure reports the weighted median and weighted 90th percentile. Observations outside the displayed histogram range are excluded from the plotted distribution.

### Results

- **Number of eligible observations:** [Insert actual count]
- **Number excluded from histogram range:** [Insert actual count]
- **Weighted median annual earnings:** PKR [Insert value]
- **Weighted 90th percentile:** PKR [Insert value]
- **90th percentile-to-median ratio:** [Insert value]

### Interpretation

[Write an interpretation of no more than 80 words based on the actual histogram and calculated statistics.]

## 5. Question 3 — Annual Earnings versus Age

This figure examines the relationship between age and annual earnings. Individual observations are shown using semi-transparent jittered points, with earnings displayed on a logarithmic scale. Weighted mean earnings are calculated for five-year age bands and connected by a line. Bands containing fewer than 30 observations are indicated with hollow markers.

The age band with the highest weighted mean is annotated on the figure.

### Five-Year Age-Band Results

Insert the actual results from `Q3_age_band_means.csv` in the table below.

| Age band | Observation count | Weighted mean annual earnings (PKR) |
|---|---:|---:|
| 15–19 | [Insert] | [Insert] |
| 20–24 | [Insert] | [Insert] |
| 25–29 | [Insert] | [Insert] |
| 30–34 | [Insert] | [Insert] |
| 35–39 | [Insert] | [Insert] |
| 40–44 | [Insert] | [Insert] |
| 45–49 | [Insert] | [Insert] |
| 50–54 | [Insert] | [Insert] |
| 55–59 | [Insert] | [Insert] |
| 60–64 | [Insert] | [Insert] |

### Interpretation

[Write an interpretation of no more than 100 words. Discuss how weighted mean earnings vary with age, compare the 25–29 and 45–49 age bands, and identify the age band with the highest weighted mean. Use actual results.]

## 6. Question 4 — Default Figure and Redesign

The default figure was generated using:

```r
ggplot(data, aes(x = age, y = earn_annual)) +
  geom_point()
```

The default figure is saved as `figures/default.svg`. The redesigned figure is saved as `figures/redesigned.svg`.

### Redesign Changes

1. **Scale:** Earnings are displayed on a logarithmic scale to make the distribution easier to inspect.
2. **Transparency and jitter:** Points use transparency and jitter to reduce overplotting.
3. **Age-band summaries:** Weighted mean earnings are added to show the overall pattern across age groups.

### What the Default Figure Shows That the Redesign Hides

[Describe one feature visible in the default figure but less visible in the redesigned figure, based on comparing the two actual figures.]

## 7. Question 5 — Cross-Language Reproduction

The age-band results and figure are reproduced in Python to compare the output with the R analysis.

- **R weighted mean for ages 25–29:** PKR [Insert actual value]
- **Python weighted mean for ages 25–29:** PKR [Insert actual value]
- **Difference in default behavior:** [Describe one actual difference between R and Python.]

The results should agree to the rupee when both implementations use the same sample, household weights, age-band definitions, and calculation method.

## 8. Figures

- Question 2: `figures/Q2_weighted_histogram.svg`
- Question 3: `figures/Q3_earnings_vs_age.svg`
- Question 4 default: `figures/default.svg`
- Question 4 redesigned: `figures/redesigned.svg`
- Question 5 Python reproduction: `figures/Q5_python_reproduction.svg`

## 9. Reproducibility

The scripts in the `scripts/` directory document the analysis workflow. Run the scripts in the appropriate order to reproduce the figures and tables. The analysis uses the CSV files in the `data/` directory.

## 10. Presentation

The presentation is saved as `slides/FA24-BEDS-029.pptx`. It summarizes the selected population, the default and redesigned figures, and the main finding from the analysis.
