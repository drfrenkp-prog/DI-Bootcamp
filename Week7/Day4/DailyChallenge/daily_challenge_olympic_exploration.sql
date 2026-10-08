-- Week 7 Day 4 - Daily Challenge: Olympic Data Exploration
-- Database: olympics_db, schema: olympics (PostgreSQL 17)
-- Note: temp tables only live in the current session, run each task in the same Query Tool tab.
-- Medals: 1 Gold, 2 Silver, 3 Bronze, 4 NA (no medal)
-- "Competitor" = a person (person_id), counted across all the Games they attended.

-- ============================================================
-- Exercise 1: Detailed Medal Analysis
-- ============================================================

-- Task 1: Competitors with at least one medal in BOTH Summer and Winter Games,
-- stored in a temp table with their medal counts per season, then displayed.
DROP TABLE IF EXISTS summer_winter_medalists;

CREATE TEMP TABLE summer_winter_medalists AS
SELECT gc.person_id,
       COUNT(*) FILTER (WHERE g.season = 'Summer') AS summer_medals,
       COUNT(*) FILTER (WHERE g.season = 'Winter') AS winter_medals
FROM olympics.games_competitor gc
JOIN olympics.games g ON g.id = gc.games_id
JOIN olympics.competitor_event ce ON ce.competitor_id = gc.id
WHERE ce.medal_id <> 4
GROUP BY gc.person_id
HAVING COUNT(*) FILTER (WHERE g.season = 'Summer') > 0
   AND COUNT(*) FILTER (WHERE g.season = 'Winter') > 0;

SELECT p.full_name, s.summer_medals, s.winter_medals,
       s.summer_medals + s.winter_medals AS total_medals
FROM summer_winter_medalists s
JOIN olympics.person p ON p.id = s.person_id
ORDER BY total_medals DESC, p.full_name;
-- Top rows: Clara Hughes (2 Summer, 4 Winter = 6), Christa Rothenburger-Luding (1+4 = 5)

-- Task 2: Temp table of competitors with medals in exactly 2 different sports,
-- then a subquery to identify the top 3 by total medals.
DROP TABLE IF EXISTS two_sport_medalists;

CREATE TEMP TABLE two_sport_medalists AS
SELECT gc.person_id,
       COUNT(*)                   AS total_medals,
       COUNT(DISTINCT e.sport_id) AS sports_count
FROM olympics.games_competitor gc
JOIN olympics.competitor_event ce ON ce.competitor_id = gc.id
JOIN olympics.event e ON e.id = ce.event_id
WHERE ce.medal_id <> 4
GROUP BY gc.person_id
HAVING COUNT(DISTINCT e.sport_id) = 2;

SELECT p.full_name, t.sports_count, t.total_medals
FROM two_sport_medalists t
JOIN olympics.person p ON p.id = t.person_id
WHERE t.person_id IN (
        SELECT person_id
        FROM two_sport_medalists
        ORDER BY total_medals DESC, person_id
        LIMIT 3
      )
ORDER BY t.total_medals DESC, p.full_name;
-- Result: Eric Lemming 7, Clara Hughes 6, Johan Grottumsbraaten 6

-- ============================================================
-- Exercise 2: Region and Competitor Performance
-- ============================================================

-- Task 1: Top 5 regions by medals. Reading of the task:
--   innermost subquery: medals per person per event
--   middle subquery:    each person's best event (most medals in a single event)
--   outer query:        sum those best-event counts per region, top 5
SELECT nr.region_name,
       SUM(best.max_medals_in_one_event) AS total_medals
FROM (
    SELECT per.person_id,
           MAX(per.medals) AS max_medals_in_one_event
    FROM (
        SELECT gc.person_id, ce.event_id, COUNT(*) AS medals
        FROM olympics.games_competitor gc
        JOIN olympics.competitor_event ce ON ce.competitor_id = gc.id
        WHERE ce.medal_id <> 4
        GROUP BY gc.person_id, ce.event_id
    ) AS per
    GROUP BY per.person_id
) AS best
JOIN olympics.person_region pr ON pr.person_id = best.person_id
JOIN olympics.noc_region nr ON nr.id = pr.region_id
GROUP BY nr.region_name
ORDER BY total_medals DESC
LIMIT 5;
-- Result: USA 4355, Soviet Union 2216, Germany 1987, UK 1715, France 1412

-- Task 2: Temp table of competitors with more than 3 Games and no medals ever,
-- showing full name and number of Games.
DROP TABLE IF EXISTS no_medal_veterans;

CREATE TEMP TABLE no_medal_veterans AS
SELECT gc.person_id,
       COUNT(DISTINCT gc.games_id) AS games_count
FROM olympics.games_competitor gc
WHERE NOT EXISTS (
        SELECT 1
        FROM olympics.games_competitor gc2
        JOIN olympics.competitor_event ce ON ce.competitor_id = gc2.id
        WHERE gc2.person_id = gc.person_id
          AND ce.medal_id <> 4
      )
GROUP BY gc.person_id
HAVING COUNT(DISTINCT gc.games_id) > 3;

SELECT p.full_name, v.games_count
FROM no_medal_veterans v
JOIN olympics.person p ON p.id = v.person_id
ORDER BY v.games_count DESC, p.full_name;
-- Top rows: several competitors with 7 Games and no medal
