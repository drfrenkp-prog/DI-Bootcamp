-- Week 7 Day 3 - Exercises XP (DVD Rental)
-- Database: dvdrental

-- ==============================
-- EXERCISE 1
-- ==============================

-- 1.1 All the languages
-- Outcome: 6 rows (English, Italian, Japanese, Mandarin, French, German)
SELECT * FROM language;

-- 1.2 Films joined with their languages
-- Outcome: 1000 rows, all English
SELECT f.title, f.description, l.name AS language_name
FROM film f
INNER JOIN language l ON l.language_id = f.language_id;

-- 1.3 All languages, even those with no films (LEFT JOIN starting from language)
-- Outcome: 1005 rows (1000 English films + 5 languages with empty film columns)
SELECT f.title, f.description, l.name AS language_name
FROM language l
LEFT JOIN film f ON f.language_id = l.language_id
ORDER BY l.language_id, f.title;

-- 1.4 New table new_film with some films
-- Outcome: 3 rows
CREATE TABLE new_film (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

INSERT INTO new_film (name) VALUES
('Midnight Harbor'),
('The Last Orange'),
('Desert Signal');

SELECT * FROM new_film;

-- 1.5 Table customer_review, with ON DELETE CASCADE on the film
CREATE TABLE customer_review (
    review_id SERIAL PRIMARY KEY,
    film_id INTEGER NOT NULL REFERENCES new_film (id) ON DELETE CASCADE,
    language_id INTEGER NOT NULL REFERENCES language (language_id),
    title VARCHAR(100) NOT NULL,
    score SMALLINT CHECK (score BETWEEN 1 AND 10),
    review_text TEXT,
    last_update TIMESTAMP DEFAULT now()
);

-- 1.6 Two reviews linked to valid films and languages
-- Outcome: 2 rows
INSERT INTO customer_review (film_id, language_id, title, score, review_text) VALUES
(1, 1, 'Moody and beautiful', 8, 'Great atmosphere and a slow, careful build-up. The ending could have been braver.'),
(2, 2, 'Una bella sorpresa', 7, 'Un film semplice ma ben fatto, con un finale che resta in mente.');

SELECT * FROM customer_review;

-- 1.7 Delete a film that has a review
-- Outcome: the review of the deleted film was deleted automatically (ON DELETE CASCADE); 1 review left
DELETE FROM new_film WHERE id = 1;

SELECT * FROM customer_review;
SELECT * FROM new_film;

-- ==============================
-- EXERCISE 2
-- ==============================

-- 2.1 UPDATE the language of some films (valid language ids only)
-- Outcome: film 1 Italian, film 2 Japanese, film 3 French
UPDATE film SET language_id = 2 WHERE film_id = 1;
UPDATE film SET language_id = 3 WHERE film_id = 2;
UPDATE film SET language_id = 5 WHERE film_id = 3;

SELECT f.film_id, f.title, l.name AS language_name
FROM film f
JOIN language l ON l.language_id = f.language_id
WHERE f.film_id IN (1, 2, 3)
ORDER BY f.film_id;

-- 2.2 Foreign keys of the customer table
-- Outcome: 1 foreign key, customer_address_id_fkey: address_id references address(address_id), ON UPDATE CASCADE ON DELETE RESTRICT
-- Effect on INSERT: the address must exist first, otherwise the insert is rejected (store_id has no foreign key here)
SELECT conname AS constraint_name,
       pg_get_constraintdef(oid) AS definition
FROM pg_constraint
WHERE conrelid = 'customer'::regclass
  AND contype = 'f';

-- 2.3 Drop customer_review
-- Check first: does any other table reference it? Outcome: 0 rows, so the drop is easy
SELECT conname AS constraint_name,
       conrelid::regclass AS referencing_table
FROM pg_constraint
WHERE confrelid = 'customer_review'::regclass
  AND contype = 'f';

DROP TABLE customer_review;

-- 2.4 Outstanding rentals (not returned yet)
-- Outcome: 183
SELECT COUNT(*) FROM rental WHERE return_date IS NULL;

-- 2.5 The 30 most expensive outstanding movies (expensive = rental_rate; film_id title as tie-breaker)
-- Outcome: 30 rows
SELECT DISTINCT f.film_id, f.title, f.rental_rate
FROM rental r
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film f ON f.film_id = i.film_id
WHERE r.return_date IS NULL
ORDER BY f.rental_rate DESC, f.title ASC
LIMIT 30;

-- 2.6 Clue 1: sumo wrestler film with the actor Penelope Monroe
-- Outcome: 1 row
SELECT f.film_id, f.title, f.description
FROM film f
JOIN film_actor fa ON fa.film_id = f.film_id
JOIN actor a ON a.actor_id = fa.actor_id
WHERE a.first_name = 'Penelope'
  AND a.last_name = 'Monroe'
  AND f.description ILIKE '%sumo%';

-- 2.7 Clue 2: short documentary (under 1 hour), rated R
-- Outcome: 1 row
SELECT f.film_id, f.title, f.length, f.rating
FROM film f
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
WHERE c.name = 'Documentary'
  AND f.length < 60
  AND f.rating = 'R';

-- 2.8 Clue 3: film rented by Matthew Mahan, paid over 4.00, returned between 28 July and 1 August 2005
-- Outcome: 2 rows, Sugar Wonka (859) and Kissing Dolls (501); both fit the clue
SELECT f.film_id, f.title, p.amount, r.return_date
FROM customer c
JOIN rental r ON r.customer_id = c.customer_id
JOIN payment p ON p.rental_id = r.rental_id
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film f ON f.film_id = i.film_id
WHERE c.first_name = 'Matthew'
  AND c.last_name = 'Mahan'
  AND p.amount > 4.00
  AND r.return_date >= '2005-07-28'
  AND r.return_date <  '2005-08-02';

-- 2.9 Clue 4: film Matthew Mahan watched, "boat" in the title or description, very expensive to replace
-- Outcome: Stone Fire (848, replacement cost 19.99) is the most expensive; the others are cheaper
SELECT DISTINCT f.film_id, f.title, f.replacement_cost
FROM customer c
JOIN rental r ON r.customer_id = c.customer_id
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film f ON f.film_id = i.film_id
WHERE c.first_name = 'Matthew'
  AND c.last_name = 'Mahan'
  AND (f.title ILIKE '%boat%' OR f.description ILIKE '%boat%')
ORDER BY f.replacement_cost DESC;

-- Optional cleanup: put the three updated films back to English
-- UPDATE film SET language_id = 1;
