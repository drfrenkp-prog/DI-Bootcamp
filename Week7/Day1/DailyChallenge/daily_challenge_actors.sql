-- Week 7 Day 1 - Daily Challenge: Actors
-- Database: Hollywood, table: actors (actor_id, first_name, last_name, age, number_oscars)
-- All four columns except actor_id are NOT NULL.

-- Task 1: count how many actors are in the table
-- Outcome: 7
SELECT COUNT(*) FROM actors;

-- Task 2, test A: add an actor with fields left out (age and number_oscars missing)
-- Outcome: ERROR 23502, null value in column "age" violates not-null constraint. Nothing is inserted.
-- (The failed attempt still uses up a SERIAL id, so ids will have a gap.)
INSERT INTO actors (first_name, last_name)
VALUES ('Tom', 'Hanks');

-- Task 2, test B: add an actor with empty text instead of missing values
-- Outcome: succeeds. An empty string '' is a value, not NULL, so NOT NULL accepts it.
INSERT INTO actors (first_name, last_name, age, number_oscars)
VALUES ('', '', '2000-01-01', 0);

-- Cleanup: remove the junk row created by test B (it received actor_id 10)
DELETE FROM actors WHERE actor_id = 10;

-- Check: back to the original size
-- Outcome: 7
SELECT COUNT(*) FROM actors;
