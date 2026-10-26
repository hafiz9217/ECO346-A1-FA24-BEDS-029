
import pandas as pd
import matplotlib.pyplot as plt

# Read datasets
person = pd.read_csv("data/pslm_person_subset.csv")
household = pd.read_csv("data/pslm_hh_subset.csv")

# Join household information
df = person.merge(
    household[["hhid", "prov_code", "urban_rural", "hhweight"]],
    on="hhid",
    how="left"
)

# Variant 5: KP Urban
df = df[
    (df["prov_code"] == 1) &
    (df["urban_rural"] == 2) &
    (df["age"] >= 15) &
    (df["age"] <= 64) &
    (df["earn_annual"] > 0) &
    (df["earn_annual"].notna()) &
    (df["hhweight"].notna()) &
    (df["hhweight"] > 0)
].copy()

# Five-year age bands
df["band_start"] = (df["age"] // 5) * 5
df["age_band"] = (
    df["band_start"].astype(int).astype(str) + "-" +
    (df["band_start"] + 4).astype(int).astype(str)
)

# Weighted mean by age band
table = df.groupby(
    ["band_start", "age_band"], as_index=False
).apply(
    lambda g: pd.Series({
        "observations": len(g),
        "weighted_mean": (
            (g["earn_annual"] * g["hhweight"]).sum()
            / g["hhweight"].sum()
        )
    }),
    include_groups=False
).reset_index(drop=True)

table["mid_age"] = table["band_start"] + 2
table = table.sort_values("band_start")

print("\nQ3 reproduction — Python")
print(table.to_string(index=False))

for start in [25, 45]:
    result = table.loc[
        table["band_start"] == start, "weighted_mean"
    ]
    if not result.empty:
        print(f"Weighted mean, ages {start}-{start+4}: "
              f"{result.iloc[0]:.2f}")

# Save reproduced table
table.to_csv("figures/Q5_python_age_band_means.csv", index=False)

# Reproduced figure
plt.figure(figsize=(9, 5))
plt.scatter(df["age"], df["earn_annual"], alpha=0.15)

plt.plot(
    table["mid_age"],
    table["weighted_mean"],
    marker="o"
)

plt.yscale("log")
plt.xlabel("Age (years)")
plt.ylabel("Annual earnings (rupees, log scale)")
plt.title("Annual Earnings by Age — KP Urban")
plt.tight_layout()
plt.savefig("figures/Q5_python_reproduction.svg", format="svg")
plt.close()

print("\nSaved Python table and SVG figure.")
