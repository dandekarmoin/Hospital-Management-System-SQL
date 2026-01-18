-- Create employees table
CREATE TABLE employees (
  emp_id SERIAL PRIMARY KEY,
  first_name VARCHAR(50),
  department VARCHAR(30),
  salary NUMERIC(10,2)
);

-- Insert sample data
INSERT INTO employees (first_name, department, salary) VALUES
('John', 'IT', 60000),
('Sara', 'HR', 50000),
('David', 'Finance', 55000),
('Emma', 'IT', 70000),
('Mike', NULL, 45000);


---2)Querying Data
-- a) Select all records
SELECT * FROM employees;

-- b) Unique department names
SELECT DISTINCT department FROM employees;

-- c) Employees earning above 55k
SELECT * FROM employees WHERE salary > 55000;

-- d) Limit results to 3 rows
SELECT * FROM employees LIMIT 3;

-- e) Fetch first 3 rows (ANSI standard)
SELECT * FROM employees FETCH FIRST 3 ROWS ONLY;


--3)Filtering Data
-- a) Pattern match (name starts with J)
SELECT * FROM employees WHERE first_name LIKE 'J%';

-- b) Department is HR or Finance
SELECT * FROM employees WHERE department IN ('HR', 'Finance');

-- c) Salary in range
SELECT * FROM employees WHERE salary BETWEEN 50000 AND 60000;

-- d) Department not assigned
SELECT * FROM employees WHERE department IS NULL;


--4)SQL Operators
-- a) AND
SELECT * FROM employees WHERE department = 'IT' AND salary > 60000;

-- b) OR
SELECT * FROM employees WHERE department = 'HR' OR department = 'Finance';

-- c) NOT
SELECT * FROM employees WHERE NOT department = 'IT';

--5)Sorting and Grouping
-- a) Sort employees by salary (descending)
SELECT * FROM employees ORDER BY salary DESC;

-- b) Group by department and count employees
SELECT department, COUNT(*) AS emp_count
FROM employees
GROUP BY department;

--6. Aggregation Functions
-- a) Count total employees
SELECT COUNT(*) FROM employees;

-- b) Total salary of all employees
SELECT SUM(salary) FROM employees;

-- c) Average salary
SELECT AVG(salary) FROM employees;

-- d) Minimum salary
SELECT MIN(salary) FROM employees;

-- e) Maximum salary
SELECT MAX(salary) FROM employees;

--7)Joins in postgres
-- Create departments table
CREATE TABLE departments (
  department_id SERIAL PRIMARY KEY,
  department_name VARCHAR(30)
);

-- Insert data
INSERT INTO departments (department_name) VALUES
('IT'), ('HR'), ('Finance'), ('Marketing');

-- Add department_id column to employees
ALTER TABLE employees ADD COLUMN department_id INT;

-- Assign department IDs
UPDATE employees
SET department_id = CASE
  WHEN department = 'IT' THEN 1
  WHEN department = 'HR' THEN 2
  WHEN department = 'Finance' THEN 3
END;

-- a) INNER JOIN
SELECT e.first_name, d.department_name
FROM employees e
INNER JOIN departments d
ON e.department_id = d.department_id;

-- b) LEFT JOIN
SELECT e.first_name, d.department_name
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id;

-- c) RIGHT JOIN
SELECT e.first_name, d.department_name
FROM employees e
RIGHT JOIN departments d
ON e.department_id = d.department_id;

-- d) FULL JOIN
SELECT e.first_name, d.department_name
FROM employees e
FULL JOIN departments d
ON e.department_id = d.department_id;

-- e) CROSS JOIN
SELECT e.first_name, d.department_name
FROM employees e
CROSS JOIN departments d;


--8)Indexes and transactions
-- a) Create index on department column
CREATE INDEX idx_department ON employees(department);

-- b) Drop index
DROP INDEX IF EXISTS idx_department;

-- c) Transaction example
BEGIN;

UPDATE employees SET salary = salary + 1000 WHERE department = 'IT';
DELETE FROM employees WHERE department IS NULL;

-- Undo delete (rollback)
ROLLBACK;

-- Try again with commit
BEGIN;
UPDATE employees SET salary = salary + 1000 WHERE department = 'IT';
COMMIT;


--recap of 🧠 Bonus: Quick Recap of Command Order

--SELECT → FROM → WHERE → GROUP BY → HAVING → ORDER BY → LIMIT

SELECT department, AVG(salary)
FROM employees
WHERE salary > 50000
GROUP BY department
HAVING AVG(salary) > 60000
ORDER BY AVG(salary) DESC
LIMIT 3;
