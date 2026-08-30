# Global Power Plant Database — Analysis

Analysis of the World Resources Institute Global Power Plant Database (34,936 power plants worldwide) using NumPy, Pandas, Matplotlib, and Seaborn.

## Key Insights

1. **Extreme skew in plant size** — global capacity skewness is 8.90 (median 16.7 MW, mean 163 MW). A handful of massive plants (up to 22,500 MW) pull the average far above what's typical.
2. **Solar vs. Hydro capacity differs significantly** (t-test, p ≈ 0) — Hydro plants average 147 MW vs. Solar's 18 MW, reflecting centralized dam infrastructure vs. flexible small-scale solar.
3. **Renewables exploded after 2000** — Solar went from 0 new plants in the 1970s-80s to 3,310 new plants in the 2010s alone; Wind shows a similar pattern.
4. **"Flat" global Coal growth was actually China-driven** — China alone added 269 net new Coal plants (1990s→2010s), over 3x every other growing country combined.
5. **Coal growth correlates strongly with GDP** (r = 0.986) across major countries — likely reflecting shared industrialization/population scale rather than direct causation.
6. **Plant capacity is geographically independent** — eigenvalue analysis of capacity/latitude/longitude shows no dominant hidden pattern (all eigenvalues ≈ 1).

See `global_power_plants.ipynb` for full analysis, code, and visualizations.