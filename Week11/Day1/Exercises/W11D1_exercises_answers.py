"""
W11 D1 - Tableau Part 1: Calculated Fields and Bins - Exercises XP
Dataset: Video Game Sales (vgsales.csv). Workbook: W11D1_Exercises.twbx (same folder).
"""

# Exercise 1 - Bins for EU Sales
# Field: EU Sales (bin), size 5, on Columns; Rows = count of records (vgsales.csv (Count)).
# After excluding the first bin, the 5-10 bin has the most games (about 23, read from the chart).

# Exercise 2 - Profitability Index
# Formula: ([Global Sales] - [Global Sales] * 0.30) / [Global Sales]
# It simplifies to 0.70 for every game (Global Sales cancels out), so every genre shows 0.70
# and it cannot rank profitability. A useful version would need a different cost per game.

# Exercise 3 - Sales Performance Index
# Formula: RANK(SUM([Global Sales]), 'desc'), Compute Using Name, one dot per Name.
# Rank must be aggregated per game (AVG or MIN), not SUM, because each game appears
# once per platform. With SUM the x-axis went far above the 16,598 rows of the dataset.

# Exercise 4 - Year-on-Year Growth Rate
# Formula: (SUM([Global Sales]) - LOOKUP(SUM([Global Sales]), -1)) / LOOKUP(SUM([Global Sales]), -1)
# Line chart by Year, Compute Using Table (Across). The Null year (rows with missing Year) was excluded.
# Growth is unreliable for years with very few games (1980, 2017, 2020) and across gaps in years.

# Exercise 5 - Genre Dominance Ratio
# Formula: SUM([Global Sales]) / TOTAL(SUM([Global Sales])), Compute Using Genre.
# The exercise text ends with "BY [Genre]", which is not valid Tableau syntax, so I left it out.
# Action is the top genre at about 19.6% of global sales (read from the chart, approximate).

# Exercise 6 - Custom calculation
# Formula: SUM([Global Sales]) / COUNT([Rank])
# I calculated average global sales per game (per game-platform row) by genre, to see which
# genres sell best per release rather than in total. Platform is on top at about 0.94M per row.
