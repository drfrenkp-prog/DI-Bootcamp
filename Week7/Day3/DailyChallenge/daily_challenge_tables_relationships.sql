-- Week 7 Day 3 - Daily Challenge: Tables Relationships
-- Database: daily_db

-- ==============================
-- PART I: one-to-one (customer and customer_profile)
-- ==============================

CREATE TABLE customer (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL
);

-- UNIQUE on customer_id makes the relationship one-to-one: a customer can have only one profile
CREATE TABLE customer_profile (
    id SERIAL PRIMARY KEY,
    isLoggedIn BOOLEAN DEFAULT false,
    customer_id INTEGER UNIQUE REFERENCES customer (id)
);

INSERT INTO customer (first_name, last_name) VALUES
('John', 'Doe'),
('Jerome', 'Lalu'),
('Lea', 'Rive');

-- Profiles inserted with subqueries (John is logged in, Jerome is not, Lea has no profile)
INSERT INTO customer_profile (isLoggedIn, customer_id) VALUES
(TRUE,  (SELECT id FROM customer WHERE first_name = 'John'   AND last_name = 'Doe')),
(FALSE, (SELECT id FROM customer WHERE first_name = 'Jerome' AND last_name = 'Lalu'));

-- Query 1: first names of the logged-in customers (INNER JOIN)
-- Outcome: 1 row (John)
SELECT c.first_name
FROM customer c
INNER JOIN customer_profile p ON p.customer_id = c.id
WHERE p.isLoggedIn = TRUE;

-- Query 2: all customers with their login status, even without a profile (LEFT JOIN)
-- Outcome: John true, Jerome false, Lea NULL (no profile, so the status is unknown)
SELECT c.first_name, p.isLoggedIn
FROM customer c
LEFT JOIN customer_profile p ON p.customer_id = c.id
ORDER BY c.id;

-- Query 3: number of customers that are not logged in
-- I count customers with no profile as not logged in. IS NOT TRUE matches both false and NULL.
-- Outcome: 2 (Jerome and Lea)
SELECT COUNT(*) AS not_logged_in
FROM customer c
LEFT JOIN customer_profile p ON p.customer_id = c.id
WHERE p.isLoggedIn IS NOT TRUE;

-- Alternative reading: only customers whose profile says false
-- Outcome: 1 (Jerome)
-- SELECT COUNT(*) FROM customer c JOIN customer_profile p ON p.customer_id = c.id WHERE p.isLoggedIn = FALSE;

-- ==============================
-- PART II: many-to-many (book, student, library)
-- ==============================

CREATE TABLE book (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    author VARCHAR(100) NOT NULL
);

INSERT INTO book (title, author) VALUES
('Alice In Wonderland', 'Lewis Carroll'),
('Harry Potter', 'J.K Rowling'),
('To kill a mockingbird', 'Harper Lee');

-- The CHECK rule makes sure the age is never bigger than 15
CREATE TABLE student (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    age INTEGER CHECK (age <= 15)
);

INSERT INTO student (name, age) VALUES
('John', 12),
('Lera', 11),
('Patrick', 10),
('Bob', 14);

-- Junction table: the pair of foreign keys is the primary key
CREATE TABLE library (
    book_fk_id INTEGER NOT NULL
        REFERENCES book (book_id) ON DELETE CASCADE ON UPDATE CASCADE,
    student_fk_id INTEGER NOT NULL
        REFERENCES student (student_id) ON DELETE CASCADE ON UPDATE CASCADE,
    borrowed_date DATE,
    PRIMARY KEY (book_fk_id, student_fk_id)
);

-- 4 records, inserted with subqueries (dates written as year-month-day)
INSERT INTO library (book_fk_id, student_fk_id, borrowed_date) VALUES
((SELECT book_id FROM book WHERE title = 'Alice In Wonderland'),
 (SELECT student_id FROM student WHERE name = 'John'), '2022-02-15'),
((SELECT book_id FROM book WHERE title = 'To kill a mockingbird'),
 (SELECT student_id FROM student WHERE name = 'Bob'), '2021-03-03'),
((SELECT book_id FROM book WHERE title = 'Alice In Wonderland'),
 (SELECT student_id FROM student WHERE name = 'Lera'), '2021-05-23'),
((SELECT book_id FROM book WHERE title = 'Harry Potter'),
 (SELECT student_id FROM student WHERE name = 'Bob'), '2021-08-12');

-- Display 1: all the columns of the junction table
-- Outcome: 4 rows (1,1,2022-02-15) (3,4,2021-03-03) (1,2,2021-05-23) (2,4,2021-08-12)
SELECT * FROM library;

-- Display 2: name of the student and title of the borrowed books
-- Outcome: 4 rows (Bob/To kill a mockingbird, Lera/Alice In Wonderland, Bob/Harry Potter, John/Alice In Wonderland)
SELECT s.name, b.title
FROM library l
JOIN student s ON s.student_id = l.student_fk_id
JOIN book b ON b.book_id = l.book_fk_id
ORDER BY l.borrowed_date;

-- Display 3: average age of the children that borrowed Alice In Wonderland
-- Outcome: 11.5 (John is 12, Lera is 11)
SELECT AVG(s.age) AS average_age
FROM library l
JOIN student s ON s.student_id = l.student_fk_id
JOIN book b ON b.book_id = l.book_fk_id
WHERE b.title = 'Alice In Wonderland';

-- Display 4: delete a student and look at the junction table
-- Outcome: Bob's two records were deleted automatically (ON DELETE CASCADE); 2 rows are left
DELETE FROM student WHERE name = 'Bob';

SELECT * FROM library;
