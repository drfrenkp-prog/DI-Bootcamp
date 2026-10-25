# W11 D1 - Analyzing Regional Sales Trends (Tableau)

Files: W11D1_RegionalSalesTrends.twbx (packaged Tableau workbook with the vgsales.csv data inside; open in Tableau Public or Desktop).

## What I built
- Calculated fields per game: EU Share, NA Share, JP Share, Other Share = region sales / Global Sales.
- Calculated fields per year: EU/NA/JP/Other Yearly Share = SUM(region sales) / SUM(Global Sales). I used yearly shares because per-game shares weight small games too heavily.
- Sheet "Regional Share by Year": 4 line panels, share of global sales by year.
- Sheet "Total Sales by Region": area charts of total sales by region by year.

## Findings
- NA share falls over time, from about 50% to about 40%.
- EU and Other shares rise.
- JP share peaks in the mid-90s, then declines.
- Total sales by region peak in the mid-2000s, then all regions drop.

## Data caveats
- The earliest and latest years have few games, so those points are less reliable.
- Some games have no year, and 2018-2019 are missing from the data.
