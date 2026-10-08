-- Week 7 Day 5 - Exercises XP: Window Functions on the Movies Database
-- Database: movies_db, schema: movies (PostgreSQL 17)
-- Tables used: movie, genre, movie_genres, production_company, movie_company,
--              movie_cast, movie_crew, person

-- ============================================================
-- Exercise 1: Movie Rankings and Analysis
-- ============================================================

-- Task 1: Rank movies by popularity within each genre (RANK)
SELECT g.genre_name,
       m.title,
       m.popularity,
       RANK() OVER (PARTITION BY g.genre_id
                    ORDER BY m.popularity DESC NULLS LAST) AS popularity_rank
FROM movies.movie m
JOIN movies.movie_genres mg ON mg.movie_id = m.movie_id
JOIN movies.genre g ON g.genre_id = mg.genre_id
ORDER BY g.genre_name, popularity_rank
LIMIT 15;
-- Result: Action #1 Deadpool, #2 Guardians of the Galaxy, #3 Mad Max: Fury Road

-- Task 2: Divide each production company's movies into quartiles by revenue (NTILE)
-- Quartile 1 = highest-revenue 25% of that company's movies.
SELECT pc.company_name,
       m.title,
       m.revenue,
       NTILE(4) OVER (PARTITION BY pc.company_id
                      ORDER BY m.revenue DESC NULLS LAST) AS revenue_quartile
FROM movies.movie m
JOIN movies.movie_company mc ON mc.movie_id = m.movie_id
JOIN movies.production_company pc ON pc.company_id = mc.company_id
ORDER BY pc.company_name, revenue_quartile, m.revenue DESC
LIMIT 15;

-- Task 3: Running total of movie budgets within each genre (SUM with a ROWS frame)
SELECT g.genre_name,
       m.title,
       m.release_date,
       m.budget,
       SUM(m.budget) OVER (PARTITION BY g.genre_id
                           ORDER BY m.release_date NULLS LAST, m.movie_id
                           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_budget
FROM movies.movie m
JOIN movies.movie_genres mg ON mg.movie_id = m.movie_id
JOIN movies.genre g ON g.genre_id = mg.genre_id
ORDER BY g.genre_name, m.release_date NULLS LAST, m.movie_id
LIMIT 15;

-- Task 4: Most recent movie for each genre (FIRST_VALUE with a named window)
SELECT DISTINCT
       g.genre_name,
       FIRST_VALUE(m.title)        OVER w AS most_recent_movie,
       FIRST_VALUE(m.release_date) OVER w AS release_date
FROM movies.movie m
JOIN movies.movie_genres mg ON mg.movie_id = m.movie_id
JOIN movies.genre g ON g.genre_id = mg.genre_id
WINDOW w AS (PARTITION BY g.genre_id
             ORDER BY m.release_date DESC NULLS LAST, m.movie_id)
ORDER BY g.genre_name;
-- Result: 20 genres, e.g. Action -> Suicide Squad (2016-08-02), Comedy -> Growing Up Smith (2017-02-03)

-- ============================================================
-- Exercise 2: Cast and Crew Performance Analysis
-- ============================================================

-- Task 1: Rank actors by the number of movies they appeared in (DENSE_RANK)
SELECT p.person_name,
       COUNT(DISTINCT mc.movie_id) AS movie_count,
       DENSE_RANK() OVER (ORDER BY COUNT(DISTINCT mc.movie_id) DESC) AS actor_rank
FROM movies.movie_cast mc
JOIN movies.person p ON p.person_id = mc.person_id
GROUP BY p.person_id, p.person_name
ORDER BY actor_rank, p.person_name
LIMIT 15;
-- Result: Samuel L. Jackson 67 (rank 1), Robert De Niro 57, Bruce Willis 51

-- Task 2: Director with the highest average movie rating (CTE + RANK)
-- Note: no minimum number of movies is required, so a director with one film rated 10 wins.
WITH director_ratings AS (
    SELECT p.person_id,
           p.person_name,
           AVG(m.vote_average)         AS avg_rating,
           COUNT(DISTINCT m.movie_id)  AS movies_directed
    FROM movies.movie_crew mc
    JOIN movies.movie m ON m.movie_id = mc.movie_id
    JOIN movies.person p ON p.person_id = mc.person_id
    WHERE mc.job = 'Director'
    GROUP BY p.person_id, p.person_name
),
ranked AS (
    SELECT *,
           RANK() OVER (ORDER BY avg_rating DESC) AS rating_rank
    FROM director_ratings
)
SELECT person_name,
       ROUND(avg_rating, 2) AS avg_rating,
       movies_directed
FROM ranked
WHERE rating_rank = 1
ORDER BY person_name;
-- Result: Gary Sinyor, 10.00, 1 movie

-- Task 3: Cumulative revenue of the movies each actor acted in (SUM window)
-- Shown here for one actor to keep the output readable; remove the WHERE line for all actors.
SELECT p.person_name,
       m.title,
       m.release_date,
       m.revenue,
       SUM(m.revenue) OVER (PARTITION BY p.person_id
                            ORDER BY m.release_date NULLS LAST, m.movie_id
                            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_revenue
FROM (SELECT DISTINCT person_id, movie_id FROM movies.movie_cast) mc
JOIN movies.person p ON p.person_id = mc.person_id
JOIN movies.movie m ON m.movie_id = mc.movie_id
WHERE p.person_name = 'Samuel L. Jackson'
ORDER BY m.release_date NULLS LAST, m.movie_id
LIMIT 15;

-- Task 4: Director whose movies have the highest total budget (CTE + RANK window)
WITH director_budgets AS (
    SELECT p.person_id,
           p.person_name,
           SUM(m.budget) AS total_budget
    FROM (SELECT DISTINCT movie_id, person_id
          FROM movies.movie_crew
          WHERE job = 'Director') d
    JOIN movies.movie m ON m.movie_id = d.movie_id
    JOIN movies.person p ON p.person_id = d.person_id
    GROUP BY p.person_id, p.person_name
),
ranked AS (
    SELECT *,
           RANK() OVER (ORDER BY total_budget DESC) AS budget_rank
    FROM director_budgets
)
SELECT person_name, total_budget
FROM ranked
WHERE budget_rank = 1;
-- Result: Steven Spielberg, total budget 1667500000
