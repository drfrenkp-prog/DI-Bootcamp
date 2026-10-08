-- Week 7 Day 5 - Daily Challenge: Advanced Movie Data Analysis
-- Database: movies_db, schema: movies (PostgreSQL 17)

-- ============================================================
-- Task 1: Average budget growth rate for each production company
-- ============================================================
-- For each company, order its movies by release date, use LAG() to get the previous
-- movie's budget, compute growth = (budget - previous) / previous * 100, then average it.
-- Movies with budget 0 (unknown) are left out, otherwise growth would be meaningless.
-- Note: the data has tiny placeholder budgets, so some averages are extreme outliers
-- (see "comparisons" for how many growth steps each average is based on).
WITH company_movies AS (
    SELECT pc.company_id,
           pc.company_name,
           m.movie_id,
           m.release_date,
           m.budget,
           LAG(m.budget) OVER (PARTITION BY pc.company_id
                               ORDER BY m.release_date, m.movie_id) AS prev_budget
    FROM movies.movie m
    JOIN movies.movie_company mc ON mc.movie_id = m.movie_id
    JOIN movies.production_company pc ON pc.company_id = mc.company_id
    WHERE m.budget > 0
      AND m.release_date IS NOT NULL
),
growth AS (
    SELECT company_name,
           (budget - prev_budget)::numeric / prev_budget * 100 AS growth_pct
    FROM company_movies
    WHERE prev_budget IS NOT NULL
)
SELECT company_name,
       ROUND(AVG(growth_pct), 2) AS avg_growth_pct,
       COUNT(*)                  AS comparisons
FROM growth
GROUP BY company_name
ORDER BY avg_growth_pct DESC
LIMIT 15;
-- Top result: Artists Production Group (APG), about 142857058.48 %, 2 comparisons

-- ============================================================
-- Task 2: Most consistently high-rated actor
-- ============================================================
-- Actor with the most movies rated above the average rating of all movies.
-- AVG(...) OVER () is a window with no partition, so every row sees the overall average.
WITH rated AS (
    SELECT movie_id,
           vote_average,
           AVG(vote_average) OVER () AS overall_avg
    FROM movies.movie
),
above_avg AS (
    SELECT movie_id
    FROM rated
    WHERE vote_average > overall_avg
),
actor_counts AS (
    SELECT mc.person_id,
           COUNT(DISTINCT mc.movie_id) AS high_rated_movies
    FROM movies.movie_cast mc
    JOIN above_avg a ON a.movie_id = mc.movie_id
    GROUP BY mc.person_id
),
ranked AS (
    SELECT *,
           RANK() OVER (ORDER BY high_rated_movies DESC) AS actor_rank
    FROM actor_counts
)
SELECT p.person_name, r.high_rated_movies
FROM ranked r
JOIN movies.person p ON p.person_id = r.person_id
WHERE r.actor_rank = 1
ORDER BY p.person_name;
-- Result: Samuel L. Jackson, 45 movies

-- ============================================================
-- Task 3: Rolling average revenue for each genre (last three movies)
-- ============================================================
-- Frame: the current movie and the two before it, within the genre, by release date.
SELECT g.genre_name,
       m.title,
       m.release_date,
       m.revenue,
       ROUND(AVG(m.revenue) OVER (PARTITION BY g.genre_id
                                  ORDER BY m.release_date, m.movie_id
                                  ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 0) AS rolling_avg_revenue
FROM movies.movie m
JOIN movies.movie_genres mg ON mg.movie_id = m.movie_id
JOIN movies.genre g ON g.genre_id = mg.genre_id
WHERE m.release_date IS NOT NULL
ORDER BY g.genre_name, m.release_date, m.movie_id
LIMIT 15;
-- Example: Action, Hell's Angels (1930) 8000000 -> 8000000; The Charge of the Light Brigade -> 5368000

-- ============================================================
-- Task 4: Highest-grossing movie series (based on shared keywords)
-- ============================================================
-- Assumption: a keyword shared by 2 to 12 movies marks a series; very common keywords
-- (hundreds of movies) are generic labels, not series. Window functions attach the movie
-- count and total revenue to each keyword, then RANK() orders keywords by total revenue.
WITH keyword_movies AS (
    SELECT k.keyword_id,
           k.keyword_name,
           m.movie_id,
           m.revenue,
           COUNT(*)       OVER (PARTITION BY k.keyword_id) AS movies_in_keyword,
           SUM(m.revenue) OVER (PARTITION BY k.keyword_id) AS total_revenue
    FROM movies.keyword k
    JOIN movies.movie_keywords mk ON mk.keyword_id = k.keyword_id
    JOIN movies.movie m ON m.movie_id = mk.movie_id
),
series AS (
    SELECT DISTINCT keyword_id, keyword_name, movies_in_keyword, total_revenue
    FROM keyword_movies
    WHERE movies_in_keyword BETWEEN 2 AND 12
),
ranked AS (
    SELECT *,
           RANK() OVER (ORDER BY total_revenue DESC) AS series_rank
    FROM series
)
SELECT keyword_name, movies_in_keyword, total_revenue, series_rank
FROM ranked
ORDER BY series_rank
LIMIT 10;
-- Result: "elves" (10 movies, 6563021456) is #1, then "orcs" and "wizard" (Middle-earth and Harry Potter series)
