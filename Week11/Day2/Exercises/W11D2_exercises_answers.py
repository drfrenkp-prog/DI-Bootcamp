"""W11 D2 - Tableau exercises reproduced with pandas + matplotlib."""
from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.colors import TwoSlopeNorm
import pandas as pd

HERE = Path(__file__).resolve().parent
df = pd.read_csv(HERE / "superstore_dataset.csv", encoding="latin-1")
df["Order Date"] = pd.to_datetime(df["Order Date"], format="%m/%d/%Y")
df["Year"] = df["Order Date"].dt.year
print(f"Rows: {len(df)}, customers: {df['Customer ID'].nunique()}, "
      f"years: {sorted(df['Year'].unique())}")


def save(name):
    plt.tight_layout()
    plt.savefig(HERE / name, dpi=120)
    plt.close()


def per_customer(data):
    g = data.groupby("Customer Name")[["Sales", "Profit"]].sum()
    g["Profit Ratio"] = g["Profit"] / g["Sales"]
    return g


cust = per_customer(df)

# ---- Ex1: Sales vs Profit per customer
plt.figure(figsize=(8, 6))
plt.scatter(cust["Sales"], cust["Profit"], alpha=0.7)
plt.axhline(0, color="grey", lw=0.8)
plt.xlabel("SUM(Sales)"); plt.ylabel("SUM(Profit)")
plt.title("Ex1: Sales vs Profit per customer")
save("ex1_sales_vs_profit.png")

# ---- Ex2: colored by profit ratio
plt.figure(figsize=(9, 6))
norm = TwoSlopeNorm(vcenter=0, vmin=cust["Profit Ratio"].min(), vmax=cust["Profit Ratio"].max())
sc = plt.scatter(cust["Sales"], cust["Profit"], c=cust["Profit Ratio"],
                 cmap="RdYlGn", norm=norm, alpha=0.85)
plt.colorbar(sc, label="Profit Ratio")
plt.axhline(0, color="grey", lw=0.8)
plt.xlabel("SUM(Sales)"); plt.ylabel("SUM(Profit)")
plt.title("Ex2: Sales vs Profit colored by Profit Ratio")
save("ex2_profit_ratio_scatter.png")
print("\nEx2 - 5 lowest profit ratio:")
print(cust["Profit Ratio"].nsmallest(5).round(4).to_string())
print("\nEx2 - 5 highest profit ratio:")
print(cust["Profit Ratio"].nlargest(5).round(4).to_string())

# ---- Ex3: ranking by total sales
rank = cust[["Sales"]].sort_values("Sales", ascending=False)
rank["Rank"] = rank["Sales"].rank(method="min", ascending=False).astype(int)
rank = rank[["Rank", "Sales"]]
print("\nEx3 - top 10 customers by Sales:")
print(rank.head(10).round(2).to_string())
top20 = rank.head(20).iloc[::-1]
plt.figure(figsize=(9, 7))
plt.barh(top20.index, top20["Sales"], color="#4e79a7")
plt.xlabel("SUM(Sales)"); plt.title("Ex3: Top 20 customers by Sales")
save("ex3_top20_customers.png")


# ---- Ex4: profit ratio by region
def region_ratio(data):
    g = data.groupby("Region")[["Sales", "Profit"]].sum()
    return (g["Profit"] / g["Sales"]).sort_index()


reg = region_ratio(df)
print("\nEx4 - Profit Ratio by Region:")
print(reg.round(4).to_string())
colors = ["#4e79a7", "#f28e2b", "#59a14f", "#e15759"]
plt.figure(figsize=(7, 5))
plt.bar(reg.index, reg.values, color=colors[:len(reg)])
plt.ylabel("Profit Ratio"); plt.title("Ex4: Profit Ratio by Region")
save("ex4_region_profit_ratio.png")


# ---- Ex5/6: dashboard-style filters
def filter_data(year=None, category=None, segment=None):
    """Mimic dashboard filters: Year of Order Date, Category, Segment."""
    out = df
    if year is not None:
        out = out[out["Year"] == year]
    if category is not None:
        out = out[out["Category"] == category]
    if segment is not None:
        out = out[out["Segment"] == segment]
    return out


def filter_by_region(data, region):
    """Mimic clicking a region on the bar chart."""
    return data[data["Region"] == region]


def highlight_customer(data, name, filename):
    c = per_customer(data)
    plt.figure(figsize=(8, 6))
    others = c.drop(index=name, errors="ignore")
    plt.scatter(others["Sales"], others["Profit"], color="grey", alpha=0.2)
    if name in c.index:
        plt.scatter(c.loc[[name], "Sales"], c.loc[[name], "Profit"],
                    color="red", s=120, zorder=3, label=name)
        plt.legend()
    plt.xlabel("SUM(Sales)"); plt.ylabel("SUM(Profit)")
    plt.title(f"Highlight: {name}")
    save(filename)


example_year = int(sorted(df["Year"].unique())[-1])
before = region_ratio(df)
after = region_ratio(filter_data(year=example_year))
cmp = pd.DataFrame({"All years": before, f"Year {example_year}": after})
cmp["Change"] = cmp[f"Year {example_year}"] - cmp["All years"]
print(f"\nEx5/6 - Region profit ratios, all years vs {example_year}:")
print(cmp.round(4).to_string())

first_region = cmp.index[0]
clicked = filter_by_region(filter_data(year=example_year), first_region)
print(f"\nClick-filter {first_region}, {example_year}: {len(clicked)} rows, "
      f"profit ratio {clicked['Profit'].sum() / clicked['Sales'].sum():.4f}")

top_name = rank.index[0]
highlight_customer(df, top_name, "ex6_highlight_customer.png")
print(f"Highlighted customer: {top_name}")
