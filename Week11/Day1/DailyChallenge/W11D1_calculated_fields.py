"""
W11 D1 - Analyzing Regional Sales Trends (Tableau)
Dataset: vgsales.csv
Workbook: W11D1_RegionalSalesTrends.twbx (same folder)
"""

# Calculated fields per game (Tableau syntax)
EU_SHARE = "[EU Sales] / [Global Sales]"
NA_SHARE = "[NA Sales] / [Global Sales]"
JP_SHARE = "[JP Sales] / [Global Sales]"
OTHER_SHARE = "[Other Sales] / [Global Sales]"

# Calculated fields per year (weights large sellers properly)
EU_YEARLY_SHARE = "SUM([EU Sales]) / SUM([Global Sales])"
NA_YEARLY_SHARE = "SUM([NA Sales]) / SUM([Global Sales])"
JP_YEARLY_SHARE = "SUM([JP Sales]) / SUM([Global Sales])"
OTHER_YEARLY_SHARE = "SUM([Other Sales]) / SUM([Global Sales])"

# Sheets
# 1. "Regional Share by Year": 4 line panels, yearly share of global sales
# 2. "Total Sales by Region": area charts of total sales by region by year

# Findings
# - NA share falls over time, from about 50% to about 40%.
# - EU and Other shares rise.
# - JP share peaks in the mid-90s, then declines.
# - Total sales by region peak in the mid-2000s, then all regions drop.

# Data caveats
# - The earliest and latest years have few games, so those points are less reliable.
# - Some games have no year, and 2018-2019 are missing from the data.
