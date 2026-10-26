
library(readr)
library(dplyr)
library(ggplot2)
library(scales)

# Read both CSV files
person <- read_csv("data/pslm_person_subset.csv",
                   show_col_types = FALSE)

household <- read_csv("data/pslm_hh_subset.csv",
                      show_col_types = FALSE)

# Join household columns to person data
df <- person %>%
  left_join(
    household %>% select(hhid, prov_code, urban_rural, hhweight),
    by = "hhid"
  )

# Variant 5: KP Urban
df <- df %>%
  filter(
    prov_code == 1,
    urban_rural == 2,
    age >= 15,
    age <= 64,
    !is.na(earn_annual),
    earn_annual > 0,
    !is.na(hhweight),
    hhweight > 0
  )

# Weighted quantile function
weighted_quantile <- function(x, w, p) {
  ok <- !is.na(x) & !is.na(w) & w > 0
  x <- x[ok]
  w <- w[ok]
  ord <- order(x)
  x <- x[ord]
  w <- w[ord]
  x[which(cumsum(w) >= p * sum(w))[1]]
}

median_w <- weighted_quantile(df$earn_annual, df$hhweight, 0.5)
p10_w <- weighted_quantile(df$earn_annual, df$hhweight, 0.1)
p90_w <- weighted_quantile(df$earn_annual, df$hhweight, 0.9)
median_unweighted <- median(df$earn_annual)

cat("Variant: 5 - KP Urban\n")
cat("Unweighted earners:", nrow(df), "\n")
cat("Weighted median:", median_w, "\n")
cat("Unweighted median:", median_unweighted, "\n")
cat("Weighted 10th percentile:", p10_w, "\n")
cat("Weighted 90th percentile:", p90_w, "\n")
cat("P90 / weighted median ratio:", round(p90_w / median_w, 2), "\n")

# Histogram with log10 bins from 4 to 7 in steps of 0.1
breaks <- 10^(seq(4, 7, by = 0.1))

p <- ggplot(df, aes(x = earn_annual, weight = hhweight)) +
  geom_histogram(
    breaks = breaks,
    fill = "#4C78A8",
    color = "white",
    closed = "left"
  ) +
  scale_x_log10(
    breaks = 10^(4:7),
    labels = label_number(big.mark = ",")
  ) +
  labs(
    title = "Annual Earnings of Urban Workers in KP",
    subtitle = "Ages 15–64 with positive annual earnings",
    x = "Annual earnings (rupees, log scale)",
    y = "Weighted number of people"
  ) +
  theme_minimal(base_size = 12)

dir.create("figures", showWarnings = FALSE)

ggsave(
  "figures/Q2_weighted_histogram.svg",
  plot = p,
  width = 9,
  height = 5
)

print(p)

# Count observations outside histogram range
cat("Excluded outside histogram range:",
    sum(df$earn_annual < 10000 | df$earn_annual > 10000000),
    "\n")



# ECO346 Assignment 1
# Registration: FA24-BEDS-029
# Variant 5: KP Urban
# Q3: Annual earnings versus age

library(readr)
library(dplyr)
library(ggplot2)
library(scales)

# 1. Read data
person <- read_csv(
  "data/pslm_person_subset.csv",
  show_col_types = FALSE
)

household <- read_csv(
  "data/pslm_hh_subset.csv",
  show_col_types = FALSE
)

# 2. Join household information and filter KP Urban
df <- person %>%
  left_join(
    household %>%
      select(hhid, prov_code, urban_rural, hhweight),
    by = "hhid"
  ) %>%
  filter(
    prov_code == 1,
    urban_rural == 2,
    age >= 15,
    age <= 64,
    !is.na(earn_annual),
    earn_annual > 0,
    !is.na(hhweight),
    hhweight > 0
  )

# 3. Create five-year age bands
df <- df %>%
  mutate(
    band_start = floor(age / 5) * 5,
    age_band = paste0(band_start, "-", band_start + 4)
  )

# 4. Calculate weighted mean for each age band
band_means <- df %>%
  group_by(band_start, age_band) %>%
  summarise(
    observations = n(),
    weighted_mean = weighted.mean(earn_annual, hhweight),
    .groups = "drop"
  ) %>%
  mutate(
    mid_age = band_start + 2,
    low_count = observations < 30
  ) %>%
  arrange(band_start)

# Print full table for README
print(band_means, n = Inf)

write_csv(
  band_means,
  "figures/Q3_age_band_means.csv"
)

# 5. Find highest mean age band
highest_band <- band_means %>%
  slice_max(weighted_mean, n = 1, with_ties = FALSE)

print(highest_band)

# 6. Report required age-band means
cat(
  "Weighted mean, ages 25-29:",
  band_means$weighted_mean[band_means$band_start == 25],
  "\n"
)

cat(
  "Weighted mean, ages 45-49:",
  band_means$weighted_mean[band_means$band_start == 45],
  "\n"
)

cat(
  "Highest mean age band:",
  highest_band$age_band,
  "\n"
)

cat(
  "Highest weighted mean:",
  highest_band$weighted_mean,
  "\n"
)

# 7. Plot earnings against age
p <- ggplot(df, aes(x = age, y = earn_annual)) +
  geom_point(
    alpha = 0.18,
    color = "grey35",
    position = position_jitter(width = 0.2, height = 0)
  ) +
  geom_line(
    data = band_means,
    aes(x = mid_age, y = weighted_mean, group = 1),
    color = "#C44E52",
    linewidth = 1
  ) +
  geom_point(
    data = filter(band_means, !low_count),
    aes(x = mid_age, y = weighted_mean),
    color = "#C44E52",
    size = 2.5
  ) +
  geom_point(
    data = filter(band_means, low_count),
    aes(x = mid_age, y = weighted_mean),
    shape = 1,
    color = "#C44E52",
    size = 3,
    stroke = 1
  ) +
  geom_label(
    data = highest_band,
    aes(
      x = mid_age,
      y = weighted_mean,
      label = paste("Highest mean:", age_band)
    ),
    nudge_y = 0.15,
    size = 3,
    show.legend = FALSE
  ) +
  scale_y_log10(
    labels = label_number(big.mark = ",")
  ) +
  scale_x_continuous(
    breaks = seq(15, 65, by = 5)
  ) +
  labs(
    title = "Annual Earnings by Age — KP Urban",
    subtitle = "Workers aged 15–64 with positive annual earnings",
    x = "Age (years)",
    y = "Annual earnings (rupees, log scale)",
    caption = "Red line: weighted mean by five-year age band. Hollow markers: bands with fewer than 30 observations."
  ) +
  theme_minimal(base_size = 12)

# 8. Save SVG
dir.create("figures", showWarnings = FALSE)

ggsave(
  "figures/Q3_earnings_vs_age.svg",
  plot = p,
  width = 10,
  height = 6
)

print(p)

#Q4

# ECO346 Assignment 1
# Registration: FA24-BEDS-029
# Variant 5: KP Urban
# Q4: Default plot and redesigned plot

library(readr)
library(dplyr)
library(ggplot2)

# Read data
person <- read_csv(
  "data/pslm_person_subset.csv",
  show_col_types = FALSE
)

household <- read_csv(
  "data/pslm_hh_subset.csv",
  show_col_types = FALSE
)

# Join and filter KP Urban earners
df <- person %>%
  left_join(
    household %>%
      select(hhid, prov_code, urban_rural, hhweight),
    by = "hhid"
  ) %>%
  filter(
    prov_code == 1,
    urban_rural == 2,
    age >= 15,
    age <= 64,
    !is.na(earn_annual),
    earn_annual > 0,
    !is.na(hhweight),
    hhweight > 0
  )

dir.create("figures", showWarnings = FALSE)

# Q4A: Default ggplot
p_default <- ggplot(df, aes(age, earn_annual)) +
  geom_point()

ggsave(
  "figures/default.svg",
  plot = p_default,
  width = 9,
  height = 5
)

# Q4B: Redesigned graph
p_redesigned <- ggplot(
  df,
  aes(x = age, y = earn_annual)
) +
  geom_point(
    alpha = 0.16,
    color = "#477A68",
    position = position_jitter(width = 0.18, height = 0)
  ) +
  scale_y_log10(
    labels = scales::label_number(big.mark = ",")
  ) +
  scale_x_continuous(
    breaks = seq(15, 65, by = 5)
  ) +
  labs(
    title = "Annual Earnings Across Working Ages",
    subtitle = "KP Urban | People aged 15–64 with positive annual earnings",
    x = "Age (years)",
    y = "Annual earnings (rupees, log scale)",
    caption = "Source: PSLM person and household data"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  )

ggsave(
  "figures/redesigned.svg",
  plot = p_redesigned,
  width = 9,
  height = 5
)

print(p_default)
print(p_redesigned)
