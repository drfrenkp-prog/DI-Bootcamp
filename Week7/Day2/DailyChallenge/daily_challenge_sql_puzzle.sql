-- Week 7 Day 2 - Daily Challenge: SQL Puzzle (NOT IN and NULL)
-- Database: public_di
-- For each question I wrote a prediction first, then ran the query.

CREATE TABLE FirstTab (
    id integer,
    name VARCHAR(10)
);

INSERT INTO FirstTab VALUES
(5,'Pawan'),
(6,'Sharlee'),
(7,'Krish'),
(NULL,'Avtaar');

CREATE TABLE SecondTab (
    id integer
);

INSERT INTO SecondTab VALUES
(5),
(NULL);

-- Q1
-- My prediction: 1 (wrong)
-- Result: 0
-- Why: the subquery returns one row, a NULL. "x NOT IN (NULL)" is unknown for every x,
-- and WHERE keeps only rows where the condition is true, so no row survives.
SELECT COUNT(*)
FROM FirstTab AS ft
WHERE ft.id NOT IN (SELECT id FROM SecondTab WHERE id IS NULL);

-- Q2
-- My prediction: 2 (ids 6 and 7)
-- Result: 2
-- Why: the list is (5). 6 and 7 are different from 5 (true); 5 is false; the NULL id is unknown.
SELECT COUNT(*)
FROM FirstTab AS ft
WHERE ft.id NOT IN (SELECT id FROM SecondTab WHERE id = 5);

-- Q3
-- My prediction: 0
-- Result: 0
-- Why: the list is (5, NULL). "6 <> 5 AND 6 <> NULL" is true AND unknown = unknown, so every row is dropped.
SELECT COUNT(*)
FROM FirstTab AS ft
WHERE ft.id NOT IN (SELECT id FROM SecondTab);

-- Q4
-- My prediction: 2
-- Result: 2
-- Why: IS NOT NULL removes the NULL from the list, so the list is (5) and it behaves like Q2.
SELECT COUNT(*)
FROM FirstTab AS ft
WHERE ft.id NOT IN (SELECT id FROM SecondTab WHERE id IS NOT NULL);
