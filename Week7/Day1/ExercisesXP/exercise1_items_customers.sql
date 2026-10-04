-- Week 7 Day 1 - Exercises XP - Exercise 1: Items and customers
-- Database: public_di (named instead of "public", which is already the default schema name in Postgres)
-- Created in pgAdmin with: CREATE DATABASE public_di;

-- Table 1: items
CREATE TABLE items (
    item_id SERIAL PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    price INTEGER NOT NULL
);

INSERT INTO items (item_name, price)
VALUES
('Small Desk', 100),
('Large desk', 300),
('Fan', 80);

-- Table 2: customers
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(100) NOT NULL
);

INSERT INTO customers (first_name, last_name)
VALUES
('Greg', 'Jones'),
('Sandra', 'Jones'),
('Scott', 'Scott'),
('Trevor', 'Green'),
('Melanie', 'Johnson');

-- Query 1: all the items
-- Outcome: 3 rows (Small Desk 100, Large desk 300, Fan 80)
SELECT * FROM items;

-- Query 2: items with a price above 80 (80 not included)
-- Outcome: 2 rows (Small Desk, Large desk); the Fan costs exactly 80, so it is excluded
SELECT * FROM items WHERE price > 80;

-- Query 3: items with a price below 300 (300 included)
-- Outcome: 3 rows; the Large desk costs exactly 300, so it stays in
SELECT * FROM items WHERE price <= 300;

-- Query 4: customers whose last name is 'Smith'
-- Outcome: 0 rows, because there is no customer named Smith in the table
SELECT * FROM customers WHERE last_name = 'Smith';

-- Query 5: customers whose last name is 'Jones'
-- Outcome: 2 rows (Greg Jones, Sandra Jones)
SELECT * FROM customers WHERE last_name = 'Jones';

-- Query 6: customers whose first name is not 'Scott'
-- Outcome: 4 rows (Greg, Sandra, Trevor, Melanie); Scott Scott is excluded
SELECT * FROM customers WHERE first_name <> 'Scott';
