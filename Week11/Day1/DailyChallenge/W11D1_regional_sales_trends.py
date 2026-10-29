"""
W11 D1 - Analyzing Regional Sales Trends (Python version of the Tableau workbook)
Dataset: vgsales.csv
Outputs: regional_share_by_year.png, total_sales_by_region.png (saved next to this script)
"""
from pathlib import Path

import matplotlib
matplotlib.use("Agg")  # save charts to files, no window
import matplotlib.pyplot as plt
import pandas as pd

HERE = Path(__file__).resolve().parent
# vgsales.csv is not in the repo: use a copy next to the script if present,
# otherwise the Kaggle download in Downloads
DATA_PATH = HERE / "vgsales.csv"
if not DATA_PATH.exists():
    DATA_PATH = Path.home() / "Downloads" / "vgsales" / "vgsales" / "vgsales.csv" / "vgsales.csv"

MIN_GAMES_PER_YEAR = 10  # keep a year only if it has at least this many games
REGIONS = ["EU", "NA", "JP", "Other"]

# a. Load
df = pd.read_csv(DATA_PATH)
print(f"Loaded {len(df)} rows, {df.shape[1]} columns from {DATA_PATH}")

# b. Clean
n0 = len(df)
df["Year"] = pd.to_numeric(df["Year"], errors="coerce")
df = df.dropna(subset=["Year"])
print(f"Dropped {n0 - len(df)} rows with missing Year")

n1 = len(df)
df = df.drop_duplicates()
print(f"Dropped {n1 - len(df)} exact duplicate rows")

# Sparse years (e.g. 1980, 2017, 2020) are unreliable, so drop them
games_per_year = df.groupby("Year").size()
keep_years = games_per_year[games_per_year >= MIN_GAMES_PER_YEAR].index
dropped_years = games_per_year[games_per_year < MIN_GAMES_PER_YEAR]
n2 = len(df)
df = df[df["Year"].isin(keep_years)].copy()
df["Year"] = df["Year"].astype(int)
print(f"Dropped {n2 - len(df)} rows from years with fewer than {MIN_GAMES_PER_YEAR} games: "
      f"{ {int(y): int(n) for y, n in dropped_years.items()} }")
print(f"Years kept: {df['Year'].min()}-{df['Year'].max()}, {len(df)} rows")

# c. Calculated fields per game (NaN where Global_Sales == 0)
safe_global = df["Global_Sales"].where(df["Global_Sales"] != 0)
for r in REGIONS:
    df[f"{r}_Share"] = df[f"{r}_Sales"] / safe_global

# d. Yearly share = SUM(region sales) / SUM(Global_Sales), not an average of per-game shares
yearly = df.groupby("Year")[[f"{r}_Sales" for r in REGIONS] + ["Global_Sales"]].sum()
shares = pd.DataFrame({r: yearly[f"{r}_Sales"] / yearly["Global_Sales"] for r in REGIONS})

# e. Chart 1: regional share by year
fig, ax = plt.subplots(figsize=(10, 5))
for r in REGIONS:
    ax.plot(shares.index, shares[r] * 100, marker="o", markersize=3, label=r)
ax.set_title("Regional Share of Global Sales by Year")
ax.set_xlabel("Year")
ax.set_ylabel("Share of global sales (%)")
ax.legend(title="Region")
ax.grid(alpha=0.3)
fig.tight_layout()
fig.savefig(HERE / "regional_share_by_year.png", dpi=150)
plt.close(fig)

# f. Chart 2: stacked area of total sales by region by year
fig, ax = plt.subplots(figsize=(10, 5))
ax.stackplot(yearly.index, [yearly[f"{r}_Sales"] for r in REGIONS], labels=REGIONS)
ax.set_title("Total Sales by Region by Year")
ax.set_xlabel("Year")
ax.set_ylabel("Sales (millions of units)")
ax.legend(title="Region", loc="upper left")
fig.tight_layout()
fig.savefig(HERE / "total_sales_by_region.png", dpi=150)
plt.close(fig)

# g. Summary tables
print("\nYearly share of global sales (%), every 5th year plus the first and last:")
show = shares.index[::5].union([shares.index[0], shares.index[-1]])
print((shares.loc[show] * 100).round(1).to_string())

print("\nPeak year per region (share / total sales):")
for r in REGIONS:
    print(f"  {r:5s} share peak {shares[r].idxmax()} ({shares[r].max() * 100:.1f}%), "
          f"sales peak {yearly[f'{r}_Sales'].idxmax()} ({yearly[f'{r}_Sales'].max():.1f}M)")
total = yearly["Global_Sales"]
print(f"  Total sales peak {total.idxmax()} ({total.max():.1f}M)")
first, last = shares.index[0], shares.index[-1]
print(f"\nShare {first} -> {last} (%):")
for r in REGIONS:
    print(f"  {r:5s} {shares.loc[first, r] * 100:.1f} -> {shares.loc[last, r] * 100:.1f}")

# Findings (from the numbers printed above, years 1981-2016)
# - NA share: 93.4% in 1981 (only 46 games, unreliable), 52.5% in 2001, 50.5% in 2006,
#   46.7% in 2011, 31.9% in 2016. So it is about 50% in the early 2000s and falls to
#   about 32% by 2016 (not 40%).
# - EU share rises from 5.5% (1981) to 37.7% (2016, its peak). Other rises from 0.9% to 10.9%
#   (share peak 12.7% in 2007).
# - JP share peaks at 55.1% in 1993 (early 90s, not mid-90s), then falls to 10.3% in 2011
#   and recovers a little to 19.3% in 2016. JP sales peak in 2006 (73.7M).
# - Total sales peak in 2008 (678.9M); NA 2008, EU 2009, JP 2006, Other 2008.
#   So the peak is the late 2000s, not the mid-2000s.
# - Caveat: 1980, 2017 and 2020 were dropped (fewer than 10 games), and 2016 is an
#   incomplete year, so its low sales and share values are less reliable.
