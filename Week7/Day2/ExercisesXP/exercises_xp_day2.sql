-- Week 7 Day 2 - Exercises XP
-- Exercise 1 runs in the database public_di (tables items and customers from Day 1).
-- Exercise 2 runs in the database dvdrental (restored with pg_restore from the sample dump).

-- ==============================
-- EXERCISE 1: Items and customers
-- ==============================

-- 1.1 All items, ordered by price (lowest to highest)
-- Outcome: Fan 80, Small Desk 100, Large desk 300
SELECT * FROM items ORDER BY price ASC;

-- 1.2 Items with a price of 80 or more (80 included), highest to lowest
-- Outcome: Large desk 300, Small Desk 100, Fan 80
SELECT * FROM items WHERE price >= 80 ORDER BY price DESC;

-- 1.3 First 3 customers by first name A-Z, without the primary key column
-- Outcome: Greg Jones, Melanie Johnson, Sandra Jones
SELECT first_name, last_name FROM customers ORDER BY first_name ASC LIMIT 3;

-- 1.4 Only the last names, reverse alphabetical order
-- Outcome: Scott, Jones, Jones, Johnson, Green
SELECT last_name FROM customers ORDER BY last_name DESC;

-- ==============================
-- EXERCISE 2: dvdrental database
-- ==============================

-- 2.1 All columns from the customer table
-- Outcome: 599 rows
SELECT * FROM customer;

-- 2.2 Names with the alias full_name
-- Outcome: 599 rows, one column called full_name
SELECT first_name || ' ' || last_name AS full_name
FROM customer;

-- 2.3 All account creation dates, no duplicates
-- Outcome: 1 row (2006-02-14), all customers were created on the same date
SELECT DISTINCT create_date FROM customer;

-- 2.4 All customer details, descending order by first name
-- Outcome: 599 rows, the top row is Zachary
SELECT * FROM customer ORDER BY first_name DESC;

-- 2.5 Film id, title, description, release year and rental rate, ascending by rental rate
-- Outcome: 1000 rows, the lowest rate is 0.99
SELECT film_id, title, description, release_year, rental_rate
FROM film
ORDER BY rental_rate ASC;

-- 2.6 Address and phone of the addresses in the Texas district
-- Outcome: 5 rows
SELECT address, phone FROM address WHERE district = 'Texas';

-- 2.7 Film details where the film id is 15 or 150
-- Outcome: 2 rows (15 Alien Center, 150 Cider Desire)
SELECT * FROM film WHERE film_id = 15 OR film_id = 150;

-- 2.8 Check whether a favorite movie exists (exact title; example title: Alien Center)
-- Outcome: 1 row (film 15, length 46, rate 2.99)
SELECT film_id, title, description, length, rental_rate
FROM film
WHERE title = 'Alien Center';

-- 2.9 Films whose title starts with the first two letters of the favorite movie (example: Al)
-- Outcome: 10 rows, including Alien Center
SELECT film_id, title, description, length, rental_rate
FROM film
WHERE title LIKE 'Al%';

-- 2.10 The 10 cheapest movies (film_id as a tie-breaker, because many films cost 0.99)
-- Outcome: 10 rows, all at 0.99
SELECT film_id, title, rental_rate
FROM film
ORDER BY rental_rate ASC, film_id ASC
LIMIT 10;

-- 2.11 The next 10 cheapest movies
-- Outcome: 10 rows, first title Arabia Dogma
SELECT film_id, title, rental_rate
FROM film
ORDER BY rental_rate ASC, film_id ASC
LIMIT 10 OFFSET 10;

-- 2.11 Bonus: the same without LIMIT
-- Outcome: same rows as the LIMIT/OFFSET version (first title Arabia Dogma)
SELECT film_id, title, rental_rate
FROM film
ORDER BY rental_rate ASC, film_id ASC
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;

-- 2.12 Join customer and payment: names, amount and date of every payment, by customer id
-- Outcome: 14596 rows, first customer Mary Smith
SELECT c.first_name, c.last_name, p.amount, p.payment_date
FROM customer c
INNER JOIN payment p ON p.customer_id = c.customer_id
ORDER BY c.customer_id ASC, p.payment_date ASC;

-- 2.13 Movies that are not in inventory
-- Outcome: 42 rows
SELECT f.film_id, f.title
FROM film f
LEFT JOIN inventory i ON i.film_id = f.film_id
WHERE i.inventory_id IS NULL
ORDER BY f.film_id;

-- 2.14 Which city is in which country
-- Outcome: 600 rows, first row Kabul, Afghanistan
SELECT ci.city, co.country
FROM city ci
INNER JOIN country co ON co.country_id = ci.country_id
ORDER BY co.country, ci.city;

-- Bonus (customer, payment and staff ordering): skipped
