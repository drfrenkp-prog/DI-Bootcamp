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
