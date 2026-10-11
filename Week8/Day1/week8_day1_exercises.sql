/* Week 8 - Day 1: Data cleaning with SQL (PostgreSQL)
   Source tables: companies, employees, functions, salaries (all columns loaded as TEXT) */

-- ===== Exercise 1: build df_employee (LEFT JOINs) =====
CREATE TABLE df_employee AS
SELECT
    s.employee_id || '_' || TO_DATE(s.date, 'DD/MM/YYYY')::text AS id,
    TO_DATE(s.date, 'DD/MM/YYYY')   AS month_year,   -- text timestamp -> DATE
    s.employee_id,
    s.employee_name,
    e.gender,
    e.age::int                      AS age,
    REPLACE(s.salary, ',', '.')     AS salary,       -- decimal comma -> dot
    f.function_group,
    c.company_name,
    c.company_city,
    c.company_state,
    c.company_type,
    c.const_site_category
FROM salaries s
LEFT JOIN employees e ON s.employee_id = e.employee_code_emp
LEFT JOIN companies c ON s.comp_name   = c.company_name
LEFT JOIN functions f ON s.func_code   = f.function_code;

-- ===== Exercise 2: cleaning =====
-- 2.2 Remove unwanted spaces
UPDATE df_employee
SET id = TRIM(id), employee_id = TRIM(employee_id), employee_name = TRIM(employee_name),
    gender = TRIM(gender), salary = TRIM(salary), function_group = TRIM(function_group),
    company_name = TRIM(company_name), company_city = TRIM(company_city),
    company_state = TRIM(company_state), company_type = TRIM(company_type),
    const_site_category = TRIM(const_site_category);

-- 2.3 Check NULL / empty values (const_site_category is blank by design for some sites: kept)
SELECT
  COUNT(*) FILTER (WHERE salary IS NULL OR salary = '')                           AS missing_salary,
  COUNT(*) FILTER (WHERE function_group IS NULL OR function_group = '')           AS missing_function,
  COUNT(*) FILTER (WHERE company_city IS NULL OR company_city = '')               AS missing_city,
  COUNT(*) FILTER (WHERE gender IS NULL OR gender = '')                           AS missing_gender,
  COUNT(*) FILTER (WHERE const_site_category IS NULL OR const_site_category = '') AS missing_site_cat
FROM df_employee;

-- 2.4 Delete rows with a missing salary (70 rows), then convert salary to numeric
DELETE FROM df_employee WHERE salary = '' OR salary IS NULL;
ALTER TABLE df_employee ALTER COLUMN salary TYPE numeric USING salary::numeric;

-- Extra fixes found while checking the data
-- Typo in city ("Goianiaa") and inconsistent type ("Construction Sites")
UPDATE df_employee SET company_city = 'Goiania' WHERE company_city = 'Goianiaa';
UPDATE df_employee SET company_type = 'Construction Site' WHERE company_type = 'Construction Sites';

-- 186 exact duplicate rows (same employee + month): keep one copy
DELETE FROM df_employee a USING df_employee b WHERE a.id = b.id AND a.ctid > b.ctid;

-- 6 rows with salary = 1,000,000 (placeholder values, median is ~1,400): removed as outliers
DELETE FROM df_employee WHERE salary >= 1000000;

-- ===== Exercise 3: employees per company today (latest month) =====
SELECT company_name, COUNT(DISTINCT employee_id) AS employee_count
FROM df_employee
WHERE month_year = (SELECT MAX(month_year) FROM df_employee)
GROUP BY company_name
ORDER BY employee_count DESC;

-- ===== Exercise 4 =====
-- 4a. Employees per city (latest month) with percentage
SELECT company_city,
       COUNT(DISTINCT employee_id) AS employee_count,
       ROUND(100.0 * COUNT(DISTINCT employee_id)
             / SUM(COUNT(DISTINCT employee_id)) OVER (), 2) AS pct
FROM df_employee
WHERE month_year = (SELECT MAX(month_year) FROM df_employee)
GROUP BY company_city
ORDER BY employee_count DESC;

-- 4b. Employees per month
SELECT month_year, COUNT(DISTINCT employee_id) AS employee_count
FROM df_employee GROUP BY month_year ORDER BY month_year;

-- 4c. Average employees per month
SELECT ROUND(AVG(employee_count), 1) AS avg_employees_per_month
FROM (SELECT month_year, COUNT(DISTINCT employee_id) AS employee_count
      FROM df_employee GROUP BY month_year) monthly;

-- ===== Exercise 5 =====
-- 5a. Min and max monthly headcount, and the months
WITH monthly AS (
  SELECT month_year, COUNT(DISTINCT employee_id) AS n FROM df_employee GROUP BY month_year
)
SELECT 'min' AS kind, month_year, n FROM monthly WHERE n = (SELECT MIN(n) FROM monthly)
UNION ALL
SELECT 'max', month_year, n FROM monthly WHERE n = (SELECT MAX(n) FROM monthly);

-- 5b. Monthly average headcount by function group
SELECT function_group, ROUND(AVG(n), 1) AS avg_monthly_employees
FROM (SELECT month_year, function_group, COUNT(DISTINCT employee_id) AS n
      FROM df_employee GROUP BY month_year, function_group) m
GROUP BY function_group
ORDER BY avg_monthly_employees DESC;

-- 5c. Annual average salary (2023 contains January only)
SELECT EXTRACT(YEAR FROM month_year) AS year, ROUND(AVG(salary), 2) AS avg_salary
FROM df_employee GROUP BY 1 ORDER BY 1;
