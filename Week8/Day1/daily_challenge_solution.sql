-- Daily Challenge Week 8 Day 1: setup (run in the NEW database "daily_challenge")
CREATE TABLE employees (
  employee_id INT PRIMARY KEY,
  employee_name VARCHAR(50),
  salary DECIMAL(10, 2),
  hire_date VARCHAR(20),
  department VARCHAR(50)
);

INSERT INTO employees (employee_id, employee_name, salary, hire_date, department) VALUES
(1, 'Amy West', 60000.00, '2021-01-15', 'HR'),
(2, 'Ivy Lee', 75000.50, '2020-05-22', 'Sales'),
(3, 'joe smith', 80000.75, '2019-08-10', 'Marketing'),
(4, 'John White', 90000.00, '2020-11-05', 'Finance'),
(5, 'Jane Hill', 55000.25, '2022-02-28', 'IT'),
(6, 'Dave West', 72000.00, '2020-03-12', 'Marketing'),
(7, 'Fanny Lee', 85000.50, '2018-06-25', 'Sales'),
(8, 'Amy Smith', 95000.25, '2019-11-30', 'Finance'),
(9, 'Ivy Hill', 62000.75, '2021-07-18', 'IT'),
(10, 'Joe White', 78000.00, '2022-04-05', 'Marketing'),
(11, 'John Lee', 68000.50, '2018-12-10', 'HR'),
(12, 'Jane West', 89000.25, '2017-09-15', 'Sales'),
(13, 'Dave Smith', 60000.75, '2022-01-08', NULL),
(14, 'Fanny White', 72000.00, '2019-04-22', 'IT'),
(15, 'Amy Hill', 84000.50, '2020-08-17', 'Marketing'),
(16, 'Ivy West', 92000.25, '2021-02-03', 'Finance'),
(17, 'Joe Lee', 58000.75, '2018-05-28', 'IT'),
(18, 'John Smith', 77000.00, '2019-10-10', 'HR'),
(19, 'Jane Hill', 81000.50, '2022-03-15', 'Sales'),
(20, 'Dave White', 70000.25, '2017-12-20', 'Marketing');

/* ===== Daily Challenge: cleaning and transforming employee record data (PostgreSQL) ===== */

-- 1. Missing values: only department of employee 13 was NULL.
--    Row kept (it has a valid salary and hire date); department marked 'Unknown'.
SELECT COUNT(*) FILTER (WHERE employee_name IS NULL) AS name_null,
       COUNT(*) FILTER (WHERE salary IS NULL)        AS salary_null,
       COUNT(*) FILTER (WHERE hire_date IS NULL)     AS date_null,
       COUNT(*) FILTER (WHERE department IS NULL)    AS dept_null
FROM employees;
UPDATE employees SET department = 'Unknown' WHERE department IS NULL;

-- 2. Duplicates: 'Jane Hill' appears twice (ids 5 and 19) but with different salary,
--    hire date and department, so they are treated as two different people and kept.
SELECT employee_name, COUNT(*) FROM employees GROUP BY employee_name HAVING COUNT(*) > 1;
-- Exact duplicates (all columns except id): returns 0 rows, nothing to delete.
SELECT employee_name, salary, hire_date, department, COUNT(*)
FROM employees
GROUP BY employee_name, salary, hire_date, department
HAVING COUNT(*) > 1;

-- 3. Structural issues: inconsistent naming ('joe smith' -> 'Joe Smith')
UPDATE employees SET employee_name = INITCAP(TRIM(employee_name));

-- 4. Data types: hire_date VARCHAR -> DATE
ALTER TABLE employees ALTER COLUMN hire_date TYPE DATE USING hire_date::date;

-- 5. Outliers: IQR rule (1.5 * IQR). Result: 0 outliers
--    (Q1 = 66500.56, Q3 = 84250.50, bounds 39875.66 - 110875.41), nothing removed.
WITH q AS (
  SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY salary) AS q1,
         percentile_cont(0.75) WITHIN GROUP (ORDER BY salary) AS q3
  FROM employees
)
SELECT q.q1, q.q3,
       q.q1 - 1.5 * (q.q3 - q.q1) AS lower_bound,
       q.q3 + 1.5 * (q.q3 - q.q1) AS upper_bound,
       (SELECT COUNT(*) FROM employees e
        WHERE e.salary < q.q1 - 1.5 * (q.q3 - q.q1)
           OR e.salary > q.q3 + 1.5 * (q.q3 - q.q1)) AS outliers
FROM q;

-- 6. Normalize: min-max scaling of salary to 0-1
ALTER TABLE employees ADD COLUMN salary_normalized NUMERIC(6,4);
UPDATE employees
SET salary_normalized = ROUND(
  (salary - (SELECT MIN(salary) FROM employees))
  / ((SELECT MAX(salary) FROM employees) - (SELECT MIN(salary) FROM employees)), 4);

-- Final check
SELECT * FROM employees ORDER BY salary_normalized;
