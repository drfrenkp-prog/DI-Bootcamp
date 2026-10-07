-- Week 7 Day 4 - Exercises XP: Advanced Olympic Data Analysis
-- Database: olympics_db, schema: olympics (PostgreSQL 17)
-- Note: temp tables only live in the current session, run the file in ONE Query Tool tab.
-- Medals: 1 Gold, 2 Silver, 3 Bronze, 4 NA (no medal)

-- ============================================================
-- Exercise 1: Complex Subquery Analysis
-- ============================================================

-- Task 1: Average age of competitors who won at least one medal, grouped by medal type
-- (correlated subquery on m.id)
SELECT m.medal_name,
       (SELECT AVG(gc.age)
        FROM olympics.games_competitor gc
        WHERE EXISTS (SELECT 1
                      FROM olympics.competitor_event ce
                      WHERE ce.competitor_id = gc.id
                        AND ce.medal_id = m.id)) AS avg_age
FROM olympics.medal m
WHERE m.medal_name <> 'NA';
-- Result: Gold 26.02, Silver 26.01, Bronze 25.89

-- Task 2: Top 5 regions by unique competitors who took part in more than 3 different events
-- (nested subqueries)
SELECT nr.region_name,
       COUNT(DISTINCT gc.person_id) AS unique_competitors
FROM olympics.games_competitor gc
JOIN olympics.person_region pr ON pr.person_id = gc.person_id
JOIN olympics.noc_region nr ON nr.id = pr.region_id
WHERE gc.id IN (
        SELECT ce.competitor_id
        FROM olympics.competitor_event ce
        GROUP BY ce.competitor_id
        HAVING COUNT(DISTINCT ce.event_id) > 3
      )
GROUP BY nr.region_name
ORDER BY unique_competitors DESC
LIMIT 5;

-- Task 3: Temp table with competitors who won more than 2 medals (subquery in FROM)
DROP TABLE IF EXISTS medal_totals;

CREATE TEMP TABLE medal_totals AS
SELECT t.competitor_id, t.total_medals
FROM (
    SELECT competitor_id, COUNT(*) AS total_medals
    FROM olympics.competitor_event
    WHERE medal_id <> 4
    GROUP BY competitor_id
) AS t
WHERE t.total_medals > 2;

SELECT COUNT(*) AS competitors_over_2_medals FROM medal_totals;
SELECT * FROM medal_totals ORDER BY total_medals DESC LIMIT 5;
-- Top result: 8 medals

-- Task 4: DELETE with a subquery on a temp table (remove competitors without medals)
DROP TABLE IF EXISTS competitor_analysis;

CREATE TEMP TABLE competitor_analysis AS
SELECT id AS competitor_id, person_id
FROM olympics.games_competitor;

DELETE FROM competitor_analysis ca
WHERE NOT EXISTS (
    SELECT 1
    FROM olympics.competitor_event ce
    WHERE ce.competitor_id = ca.competitor_id
      AND ce.medal_id <> 4
);

SELECT (SELECT COUNT(*) FROM olympics.games_competitor) AS before_delete,
       (SELECT COUNT(*) FROM competitor_analysis)        AS after_delete;
-- Result: 180252 before, 34315 after

-- ============================================================
-- Exercise 2: Advanced Data Manipulation and Optimization
-- ============================================================

-- Task 1: Update heights using the average height of the same region (correlated subquery in UPDATE)
-- Missing heights are stored as 0. We update a TEMP COPY, never the original table.
-- The regional averages are computed once (region_avg) to keep the UPDATE fast.
DROP TABLE IF EXISTS person_copy;
DROP TABLE IF EXISTS person_region_one;
DROP TABLE IF EXISTS region_avg;

CREATE TEMP TABLE person_copy AS
SELECT * FROM olympics.person;

-- one region per person (some people have two)
CREATE TEMP TABLE person_region_one AS
SELECT DISTINCT ON (person_id) person_id, region_id
FROM olympics.person_region
ORDER BY person_id, region_id;

CREATE INDEX ON person_region_one(person_id);

CREATE TEMP TABLE region_avg AS
SELECT pro.region_id, ROUND(AVG(p.height)) AS avg_h
FROM olympics.person p
JOIN person_region_one pro ON pro.person_id = p.id
WHERE p.height > 0
GROUP BY pro.region_id;

UPDATE person_copy pc
SET height = COALESCE(
    (SELECT ra.avg_h
     FROM region_avg ra
     JOIN person_region_one pro ON pro.region_id = ra.region_id
     WHERE pro.person_id = pc.id),
    pc.height)
WHERE pc.height = 0;

SELECT COUNT(*) FILTER (WHERE height = 0) AS still_zero,
       COUNT(*) FILTER (WHERE height > 0) AS now_real
FROM person_copy;
-- Result: 12 still zero, 128842 real

-- Task 2: Insert into a temp table the competitors with more than one event in the same Games
-- (one games_competitor row = one person at one Games) with their event count (nested subqueries)
DROP TABLE IF EXISTS multi_event_competitors;

CREATE TEMP TABLE multi_event_competitors (
    competitor_id INT,
    total_events  INT
);

INSERT INTO multi_event_competitors (competitor_id, total_events)
SELECT ce.competitor_id, COUNT(DISTINCT ce.event_id)
FROM olympics.competitor_event ce
WHERE ce.competitor_id IN (
        SELECT competitor_id
        FROM olympics.competitor_event
        GROUP BY competitor_id
        HAVING COUNT(DISTINCT event_id) > 1
      )
GROUP BY ce.competitor_id;

SELECT COUNT(*) AS rows_inserted, MAX(total_events) AS max_events
FROM multi_event_competitors;
-- Result: 45458 rows, max 15 events

-- Task 3: Regions where the average medals per competitor is above the overall average
-- (requires person_region_one from Task 1)
SELECT nr.region_name,
       ROUND(AVG(mc.medals), 3) AS avg_medals_per_competitor,
       (SELECT ROUND(
                 (SELECT COUNT(*) FROM olympics.competitor_event WHERE medal_id <> 4)::numeric
                 / (SELECT COUNT(*) FROM olympics.games_competitor), 3)) AS overall_avg
FROM (
    SELECT gc.id AS competitor_id,
           gc.person_id,
           COUNT(ce.medal_id) FILTER (WHERE ce.medal_id <> 4) AS medals
    FROM olympics.games_competitor gc
    LEFT JOIN olympics.competitor_event ce ON ce.competitor_id = gc.id
    GROUP BY gc.id, gc.person_id
) AS mc
JOIN person_region_one pro ON pro.person_id = mc.person_id
JOIN olympics.noc_region nr ON nr.id = pro.region_id
GROUP BY nr.region_name
HAVING AVG(mc.medals) > (
    (SELECT COUNT(*) FROM olympics.competitor_event WHERE medal_id <> 4)::numeric
    / (SELECT COUNT(*) FROM olympics.games_competitor)
)
ORDER BY avg_medals_per_competitor DESC
LIMIT 10;
-- Result: overall average 0.215; top: Soviet Union 0.647, Australasia 0.603, East Germany 0.575

-- Task 4: Temp table tracking participation per season, then people who played Summer AND Winter
DROP TABLE IF EXISTS season_participation;

CREATE TEMP TABLE season_participation AS
SELECT DISTINCT gc.person_id, g.season
FROM olympics.games_competitor gc
JOIN olympics.games g ON g.id = gc.games_id;

SELECT p.full_name, sp.person_id
FROM season_participation sp
JOIN olympics.person p ON p.id = sp.person_id
WHERE sp.person_id IN (
        SELECT person_id FROM season_participation WHERE season = 'Summer'
      )
  AND sp.person_id IN (
        SELECT person_id FROM season_participation WHERE season = 'Winter'
      )
GROUP BY p.full_name, sp.person_id
ORDER BY p.full_name
LIMIT 10;

SELECT COUNT(*) AS in_both_seasons
FROM (
    SELECT person_id
    FROM season_participation
    GROUP BY person_id
    HAVING COUNT(DISTINCT season) = 2
) AS x;
-- Result: 158 people competed in both Summer and Winter Games
