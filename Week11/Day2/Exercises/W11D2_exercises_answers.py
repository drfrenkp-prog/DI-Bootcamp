"""W11 D2 - Tableau exercises reproduced with pandas + matplotlib + plotly/dash.

How to run:
    python W11D2_exercises_answers.py          # everything (PNGs, HTML, CSV, printed output)
    python W11D2_exercises_answers.py --dash   # interactive dashboard in the browser

Requires pandas and matplotlib; plotly and dash are optional
(pip install plotly dash) - without them the plotly/dash parts are skipped.
"""
import sys
from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.colors import TwoSlopeNorm
import pandas as pd

try:
    import plotly.express as px
    import plotly.graph_objects as go
    from plotly.subplots import make_subplots
    HAVE_PLOTLY = True
except ImportError:
    HAVE_PLOTLY = False
    print("Note: plotly not installed - plotly HTML outputs will be skipped "
          "(pip install plotly dash)")
try:
    from dash import Dash, dcc, html, Input, Output, State, ctx
    HAVE_DASH = True
except ImportError:
    HAVE_DASH = False
    print("Note: dash not installed - interactive dashboard unavailable "
          "(pip install dash)")

HERE = Path(__file__).resolve().parent
CSV_PATH = HERE / "superstore_dataset.csv"
CSV_URL = ("https://raw.githubusercontent.com/drfrenkp-prog/DI-Bootcamp/main/"
           "Week11/Day2/Exercises/superstore_dataset.csv")
try:
    df = pd.read_csv(CSV_PATH, encoding="latin-1")
    print(f"Data source: local file {CSV_PATH}")
except FileNotFoundError:
    df = pd.read_csv(CSV_URL, encoding="latin-1")
    print(f"Data source: GitHub raw URL {CSV_URL}")
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
print(f"\nEx1 - per-customer scatter points: {len(cust)}")

# Ex1 (row level): every order line, no grouping
plt.figure(figsize=(8, 6))
plt.scatter(df["Sales"], df["Profit"], alpha=0.3, s=10)
plt.axhline(0, color="grey", lw=0.8)
plt.xlabel("Sales"); plt.ylabel("Profit")
plt.title("Ex1: Sales vs Profit (row level, all rows)")
save("ex1_row_level_scatter.png")
print(f"Ex1 - row-level scatter points: {len(df)}")

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

# Ex2 (hover tooltips): customer-level and row-level, needs plotly (optional)
HOVER_TMPL = ("<b>%{customdata[0]}</b><br>Sales: %{x:,.2f}<br>"
              "Profit: %{y:,.2f}<br>Profit Ratio: %{customdata[1]:.2%}"
              "<extra></extra>")
if HAVE_PLOTLY:
    hover_df = cust.reset_index()
    fig = px.scatter(
        hover_df, x="Sales", y="Profit", color="Profit Ratio",
        color_continuous_scale="RdYlGn", color_continuous_midpoint=0,
        hover_name="Customer Name",
        hover_data={"Sales": ":.2f", "Profit": ":.2f", "Profit Ratio": ":.4f"},
        title="Ex2: Sales vs Profit by customer (hover for details)")
    fig.write_html(str(HERE / "ex2_hover_tooltips.html"))
    print("Ex2 - wrote ex2_hover_tooltips.html")

    # row level: 9,994 points -> WebGL scatter (scattergl)
    row_ratio = df["Profit"] / df["Sales"]
    fig_rows = go.Figure(go.Scattergl(
        x=df["Sales"], y=df["Profit"], mode="markers",
        marker=dict(size=5, color=row_ratio, colorscale="RdYlGn", cmid=0,
                    cmin=-1, cmax=1, opacity=0.6,
                    colorbar=dict(title="Profit Ratio")),
        customdata=pd.DataFrame({"n": df["Customer Name"], "r": row_ratio}).values,
        hovertemplate=HOVER_TMPL))
    fig_rows.update_layout(title="Ex2: Sales vs Profit, row level (hover for details)",
                           xaxis_title="Sales", yaxis_title="Profit")
    fig_rows.write_html(str(HERE / "ex2_row_level_hover.html"))
    print(f"Ex2 - wrote ex2_row_level_hover.html ({len(df)} points, scattergl)")
else:
    print("Ex2 - plotly not installed: skipped hover HTML files")

# ---- Ex3: ranking by total sales
rank = cust[["Sales"]].sort_values("Sales", ascending=False)
rank["Rank"] = rank["Sales"].rank(method="min", ascending=False).astype(int)
rank = rank[["Rank", "Sales"]]
print("\nEx3 - top 10 customers by Sales:")
print(rank.head(10).round(2).to_string())
top20 = rank.head(20).iloc[::-1]
plt.figure(figsize=(9, 7))
bars = plt.barh(top20.index, top20["Sales"], color="#4e79a7")
# rank label on each bar, e.g. "#1  25,043"
plt.bar_label(bars, labels=[f"#{r}  {s:,.0f}" for r, s in
                            zip(top20["Rank"], top20["Sales"])], padding=3)
plt.xlim(0, top20["Sales"].max() * 1.15)
plt.xlabel("SUM(Sales)"); plt.title("Ex3: Top 20 customers by Sales")
save("ex3_top20_customers.png")

# Ex3 (all customers): full ranking table + tall horizontal bar chart
rank.to_csv(HERE / "ex3_customer_rank_all.csv")
print(f"Ex3 - rows in full ranking: {len(rank)} (saved ex3_customer_rank_all.csv)")
all_c = rank.iloc[::-1]
plt.figure(figsize=(10, max(8, len(all_c) * 0.22)))
bars = plt.barh(all_c.index, all_c["Sales"], color="#4e79a7")
plt.bar_label(bars, labels=[f"#{r}  {s:,.0f}" for r, s in
                            zip(all_c["Rank"], all_c["Sales"])],
              padding=2, fontsize=5)
plt.xlim(0, all_c["Sales"].max() * 1.12)
plt.ylim(-1, len(all_c))
plt.yticks(fontsize=6)
plt.xlabel("SUM(Sales)"); plt.title("Ex3: All customers ranked by Sales")
save("ex3_all_customers.png")


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


def region_table(data):
    """Per region: Profit Ratio, total Sales, top customer by Sales (name + sales)."""
    g = data.groupby("Region")[["Sales", "Profit"]].sum()
    g["Profit Ratio"] = g["Profit"] / g["Sales"]
    cs = data.groupby(["Region", "Customer Name"])["Sales"].sum()
    top = cs.groupby(level=0).idxmax()
    g["Top Customer"] = [t[1] for t in top.reindex(g.index)]
    g["Top Customer Sales"] = [cs[t] for t in top.reindex(g.index)]
    return g.sort_index()


def region_bar_figure(data, selected_region=None):
    """Plotly region profit-ratio bar with rich hover tooltip."""
    t = region_table(data).reset_index()
    colors = ["#e15759" if (selected_region and r == selected_region) else "#4e79a7"
              for r in t["Region"]]
    fig = go.Figure(go.Bar(
        x=t["Region"], y=t["Profit Ratio"], marker_color=colors,
        customdata=t[["Sales", "Top Customer", "Top Customer Sales"]].values,
        hovertemplate=("<b>%{x}</b><br>Profit Ratio: %{y:.2%}<br>"
                       "Total Sales: %{customdata[0]:,.0f}<br>"
                       "Top customer: %{customdata[1]} "
                       "(%{customdata[2]:,.0f})<extra></extra>")))
    fig.update_layout(title="Profit Ratio by Region (click a bar to filter)",
                      yaxis_title="Profit Ratio", yaxis_tickformat=".0%")
    return fig


if HAVE_PLOTLY:
    region_bar_figure(df).write_html(str(HERE / "ex4_region_hover.html"))
    print("Ex4 - wrote ex4_region_hover.html")
    print(region_table(df)[["Sales", "Top Customer", "Top Customer Sales"]]
          .round(2).to_string())


# ---- Ex5/6: dashboard-style filters
# =====================================================================
# What was built in Tableau (workbook: Week11/Day2/Exercises/W11D2_exercises.twb on GitHub)
# ---------------------------------------------------------------------
# * 3 worksheets: Sheet 1, Sheet 2, Sheet 3
# * Calculated field: Profit Ratio = SUM([Profit]) / SUM([Sales])
# * Dashboard "Dashboard 1" containing the three sheets
# * Filters Year of Order Date, Segment and Category, applied to all
#   worksheets using this data source
# * Filter action "Filter 1": from the region bar chart, run on select
# * Highlight action "Highlight customer": from the customer ranking
#   sheet to the scatter plot, on field Customer Name
# The functions below simulate these interactions in pandas.
# =====================================================================
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


# =====================================================================
# Ex5/6: ONE interactive dashboard (Dash) with filters + filter/highlight actions
# =====================================================================
def scatter_figure(data, highlight=None):
    """Customer scatter colored by Profit Ratio (diverging red-green, centre 0).
    If `highlight` (a Customer Name) is given, that dot is emphasised and the
    others are faded."""
    c = per_customer(data).reset_index()
    if highlight in set(c["Customer Name"]):
        is_hl = c["Customer Name"] == highlight
        opacity = [1.0 if h else 0.12 for h in is_hl]
        size = [16 if h else 7 for h in is_hl]
        line = dict(width=[2 if h else 0 for h in is_hl], color="black")
    else:
        opacity, size, line = 0.8, 7, dict(width=0)
    fig = go.Figure(go.Scatter(
        x=c["Sales"], y=c["Profit"], mode="markers",
        marker=dict(color=c["Profit Ratio"], colorscale="RdYlGn", cmid=0,
                    size=size, opacity=opacity, line=line,
                    colorbar=dict(title="Profit Ratio")),
        customdata=c[["Customer Name", "Profit Ratio"]].values,
        hovertemplate=HOVER_TMPL))
    fig.update_layout(title="Sales vs Profit per customer",
                      xaxis_title="SUM(Sales)", yaxis_title="SUM(Profit)")
    return fig


def rank_figure(data, highlight=None, top_n=20):
    """Customer ranking bar chart (top 20 for display) with rank labels."""
    s = data.groupby("Customer Name")["Sales"].sum().sort_values(ascending=False)
    r = s.rank(method="min", ascending=False).astype(int)
    top = s.head(top_n).iloc[::-1]
    colors = ["#e15759" if n == highlight else "#4e79a7" for n in top.index]
    fig = go.Figure(go.Bar(
        x=top.values, y=top.index, orientation="h", marker_color=colors,
        text=[f"#{r[n]}  {v:,.0f}" for n, v in top.items()],
        textposition="outside", cliponaxis=False,
        hovertemplate="<b>%{y}</b><br>Sales: %{x:,.2f}<extra></extra>"))
    fig.update_layout(title=f"Top {top_n} customers by Sales (click to highlight)",
                      xaxis_title="SUM(Sales)")
    return fig


def build_figures(year=None, segment=None, category=None, region=None, customer=None):
    """Single place where all three charts are built from the dropdown filters
    (Year of Order Date, Segment, Category), the region click and the
    customer click. Used by the Dash callback AND by the normal script run."""
    base = filter_data(year=year, category=category, segment=segment)
    region_fig = region_bar_figure(base, selected_region=region)   # all regions shown
    shown = filter_by_region(base, region) if region else base      # click filter
    return (scatter_figure(shown, customer), rank_figure(shown, customer),
            region_fig, shown)


def dashboard_update(year, segment, category, region_click, cust_click,
                     trigger, region_state, cust_state):
    """Pure callback logic: returns (scatter, rank, region figs, region, customer)."""
    year = None if year in (None, "All") else int(year)
    segment = None if segment in (None, "All") else segment
    category = None if category in (None, "All") else category
    region, customer = region_state, cust_state
    if trigger == "clear-btn":
        region = customer = None
    elif trigger == "region-bar" and region_click:
        clicked = region_click["points"][0]["x"]
        region = None if clicked == region else clicked      # click again = reset
        customer = None
    elif trigger == "rank-bar" and cust_click:
        clicked = cust_click["points"][0]["y"]
        customer = None if clicked == customer else clicked
    sc, rk, rg, _ = build_figures(year, segment, category, region, customer)
    return sc, rk, rg, region, customer


def build_dashboard_app():
    """Return the Dash app (one page, three charts, three filters, click actions)."""
    if not (HAVE_PLOTLY and HAVE_DASH):
        raise ImportError("plotly and dash are required: pip install plotly dash")
    app = Dash(__name__)

    def opts(vals):
        return [{"label": "All", "value": "All"}] + \
               [{"label": str(v), "value": v} for v in vals]

    def dropdown(label, comp_id, vals):
        return html.Div(
            [html.Label(label),
             dcc.Dropdown(id=comp_id, options=opts(vals), value="All", clearable=False)],
            style={"width": "200px", "display": "inline-block", "margin": "4px"})

    app.layout = html.Div([
        html.H2("W11 D2 - Superstore dashboard"),
        html.Div([
            dropdown("Year of Order Date", "year", sorted(int(y) for y in df["Year"].unique())),
            dropdown("Segment", "segment", sorted(df["Segment"].unique())),
            dropdown("Category", "category", sorted(df["Category"].unique())),
            html.Button("Clear selection", id="clear-btn", n_clicks=0,
                        style={"margin": "4px"}),
        ]),
        html.Div([dcc.Graph(id="scatter", style={"width": "49%", "display": "inline-block"}),
                  dcc.Graph(id="region-bar", style={"width": "49%", "display": "inline-block"})]),
        dcc.Graph(id="rank-bar", style={"height": "650px"}),
        dcc.Store(id="region-state"), dcc.Store(id="cust-state"),
    ])

    @app.callback(
        Output("scatter", "figure"), Output("rank-bar", "figure"),
        Output("region-bar", "figure"),
        Output("region-state", "data"), Output("cust-state", "data"),
        Input("year", "value"), Input("segment", "value"), Input("category", "value"),
        Input("region-bar", "clickData"), Input("rank-bar", "clickData"),
        Input("clear-btn", "n_clicks"),
        State("region-state", "data"), State("cust-state", "data"))
    def update(year, segment, category, region_click, cust_click, _n, region_s, cust_s):
        return dashboard_update(year, segment, category, region_click, cust_click,
                                ctx.triggered_id, region_s, cust_s)

    return app


# ---- normal run: exercise the same figure/callback logic with example filters
if HAVE_PLOTLY:
    ex_rows = build_figures(year=2017, segment="Consumer", category="Technology")[3]
    print("\nDashboard example filters: Year 2017, Category Technology, Segment Consumer")
    print(f"  rows after filters: {len(ex_rows)}")
    print("  region profit ratios:")
    print(region_ratio(ex_rows).round(4).to_string())
    # simulate a region click + customer click through the callback logic
    reg_sel = dashboard_update(2017, "Consumer", "Technology",
                               {"points": [{"x": "West"}]}, None,
                               "region-bar", None, None)[3]
    print(f"  after clicking region bar: region = {reg_sel}")
    top_in_region = ex_rows[ex_rows["Region"] == reg_sel].groupby(
        "Customer Name")["Sales"].sum().idxmax()
    cust_sel = dashboard_update(2017, "Consumer", "Technology", None,
                                {"points": [{"y": top_in_region}]},
                                "rank-bar", reg_sel, None)[4]
    print(f"  after clicking ranking bar: highlighted customer = {cust_sel}")

    # static snapshot of the three charts (no server)
    s_fig, r_fig, g_fig, _ = build_figures()
    snap = make_subplots(rows=1, cols=3, column_widths=[0.4, 0.35, 0.25],
                         subplot_titles=("Sales vs Profit per customer",
                                         "Top 20 customers by Sales",
                                         "Profit Ratio by Region"))
    for i, f in enumerate((s_fig, r_fig, g_fig), start=1):
        for tr in f.data:
            snap.add_trace(tr, row=1, col=i)
    snap.update_layout(height=700, showlegend=False,
                       title="W11 D2 dashboard snapshot (static)")
    snap.write_html(str(HERE / "dashboard_snapshot.html"))
    print("Wrote dashboard_snapshot.html")
else:
    print("\nDashboard skipped: plotly not installed")

if "--dash" in sys.argv:
    build_dashboard_app().run(debug=False)
