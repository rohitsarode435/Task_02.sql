SELECT * FROM public.departments
select * from employees

--Section A: Basic Concepts (20 Marks)

--1. Write a command to create a database named company_db.
CREATE DATABASE company_db

--2. Create a table employees & departments with the following structure
create table employees(
employee_id	int,first_name varchar,	last_name varchar,	salary varchar,	hire_date varchar,	dept_id varchar

)

select * from employees

copy employees(employee_id,	first_name, last_name,	salary,	hire_date,	dept_id
)
from 'D:\employees.csv'
delimiter','
csv header;

select * from employees

create table departments(dept_id int,	dept_name varchar
)
select * from departments

copy departments(dept_id,	dept_name
)
from 'D:\departments.csv'
delimiter','
csv header;

--3. Difference between Drop, Truncate & Delete.
--drop itean it basically drop the entire table.
--it cant role back.
--truncate it mean it delete all the rows from the table.
--it cant role back.
--Delete it mean it delete the specific row on the basis of specific condition.


--4. List all the numeric and string data types available in PostgreSQL
--numeric
--smallint	2-byte integer (-32,768 to 32,767)
--integer (int)	4-byte integer (-2,147,483,648 to 2,147,483,647)
--bigint	8-byte integer (-9 quintillion to 9 quintillion)
--decimal(p, s)	User-defined precision and scale (exact)
--numeric(p, s)	Same as decimal, arbitrary precision (exact)
--real (float4)	4-byte floating-point number (approximate)
--double precision (float8)	8-byte floating-point number (approximate)
--serial	Auto-incrementing 4-byte integer
--bigserial

--STRING
--char(n)	Fixed-length character string (padded with spaces)
--varchar(n)	Variable-length character string (up to n characters)
--text	Variable-length string (unlimited size)
--citext	Case-insensitive text extension (if installed


--5. Explain the difference between VARCHAR, TEXT, and CHAR data types
--CHAR(n) (Fixed-length)	Stores a fixed number of characters (n), padded with spaces if shorter.
--VARCHAR(n) (Variable-length)	Stores up to n characters, without padding extra spaces.	
--TEXT (Unlimited-length)	Stores unlimited characters without needing a length constraint.

--Section B: Data Manipulation (20 Marks)
--1. Insert the following records into the employee’s table:
--select * from employees
--ALTER TABLE employees ALTER COLUMN salary TYPE NUMERIC USING salary::NUMERIC;--
--2. Write a query to increase the salary of all employees by 10%.
UPDATE employees
SET salary = salary * 1.10;
--3. Write a query to delete employees hired before 2022.
DELETE FROM employees
WHERE hire_date < '2022-01-01';

--4. Retrieve all employees who earn between 50000 and 80000.
SELECT * FROM employees
WHERE salary BETWEEN 50000 AND 80000;

--5. Select employees whose first name starts with 'J' using the LIKEoperator
select * from employees 
where first_name like 'j%';

--6. Explain the RETURNING clause in PostgreSQL with an example.
--The RETURNING clause in PostgreSQL allows you to return values from rows that were modified by INSERT, UPDATE, or DELETE statements. This is useful when you need to retrieve data immediately after performing an operation without executing a separate SELECT query.
--
INSERT INTO employees (name, salary, hire_date)
VALUES ('John Doe', 60000, '2023-05-10')
RETURNING id, name;


--Section C: Sorting & Aggregation (20 Marks)
--1. Retrieve all employees and sort them by salary in descending order.
SELECT * FROM employees
ORDER BY salary DESC;
--2. Retrieve the top 3 highest-paid employees.
select * from employees
order by salary desc
limit 3
--3. Find the total salary expense of the company
select sum(salary) as total_salary from employees
--4. Find the average salary of employees and filter only those with an 
average salary greater than 70000 using the HAVING clause.
select avg(salary) from employees

--Section D: String & Date Functions (15 Marks)
--1. Concatenate the first_name and last_name with a space in between.
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM employees;
--2. Extract the year from the hire_date column.
SELECT hire_date, EXTRACT(YEAR FROM hire_date) AS hire_year FROM employees;

SELECT hire_date, EXTRACT(YEAR FROM hire_date::DATE) AS hire_year FROM employees;
--3. Convert all first_name values to uppercase.
select upper(first_name) from employees

--4. Find the difference in years between the current date and hire_date.
SELECT hire_date, (CURRENT_DATE - hire_date::DATE)/365 AS years_difference
FROM employees;
--5. Use DATE_TRUNC to round off hire_date to the nearest month.
SELECT hire_date, DATE_TRUNC('month', hire_date::DATE) AS rounded_hire_date
FROM employees;


--Section E: Advanced Filtering & Conditional Logic (10 Marks
--1. Use COALESCE to replace NULL salaries with 50000.
SELECT employee_id, first_name, COALESCE(salary, 50000) AS updated_salary  
FROM employees;
--2. Find the highest and lowest salaries using GREATEST and LEAST.
SELECT 
    GREATEST(MAX(salary), 0) AS highest_salary, 
    LEAST(MIN(salary), 1000000) AS lowest_salary
FROM employees;
--3. Use NULLIF to prevent division by zero when calculating salary percentages.
SELECT 
    employee_id, 
    first_name, 
    salary, 
    (salary / NULLIF(total_salary, 0)) * 100 AS salary_percentage
FROM employees, 
    (SELECT SUM(salary) AS total_salary FROM employees) AS total;
	

--Section F: Joins & Set Operations (15 Marks)
--1. Given a departments table with dept_id and dept_name,write a query to join employees and departments on dept_id using an INNER JOIN.
select d.dept_id,d.dept_name from departments as d inner join employees as e on d.dept_id=e.dept_id

--ALTER TABLE employees ALTER COLUMN dept_id TYPE INTEGER USING dept_id::INTEGER;
--2. Retrieve all employees, ensuring that those without a department are also included (use LEFT JOIN).
select * from employees as e left join departments as d on e.dept_id=d.dept_id 
--3. Find employees who are not present in another table using EXCEPT.
select employees.employee_id,employees.first_name from employees
except
select dept_id,dept_name
from departments
--4. Explain the difference between UNION and UNION ALL with an example.
--UNION removes duplicates and returns only distinct rows.
--UNION ALL includes all rows, including duplicates.
--ex.
SELECT dept_id FROM employees  
UNION  
SELECT dept_id FROM departments;  -- Removes duplicates  

SELECT dept_id FROM employees  
UNION ALL  
SELECT dept_id FROM departments;  -- Keeps duplicates  

