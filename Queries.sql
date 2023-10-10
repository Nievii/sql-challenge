-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/

CREATE TABLE "Departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_Name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_Departments" PRIMARY KEY (
        "dept_no"
     )
);

SELECT * FROM "Departments"
-- Departments.csv

CREATE TABLE "Employees_dept_junction" (
    "emp_no" INTEGER   NOT NULL,
    "dept_no" VARCHAR   NOT NULL
);

SELECT * 
FROM "Employees_dept_junction"
-- dept_emp.csv

CREATE TABLE "Managers" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" INTEGER   NOT NULL
);

SELECT * FROM "Managers"
-- Dept_manager.csv 

CREATE TABLE "Employees" (
    "emp_no" INTEGER   NOT NULL,
    "emp_title_id" VARCHAR   NOT NULL,
    "birth_date" VARCHAR   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "sex" VARCHAR   NOT NULL,
    "hire_date" VARCHAR   NOT NULL,
    CONSTRAINT "pk_Employees" PRIMARY KEY (
        "emp_no"
     )
);

SELECT * FROM "Employees"
-- employees.csv


CREATE TABLE "Salaries" (
    "emp_no" INTEGER   NOT NULL,
    "salary" INTEGER   NOT NULL
);

SELECT * FROM "Salaries"
-- Salaries.csv 

CREATE TABLE "Titles" (
    "title_id" VARCHAR   NOT NULL,
    "title" VARCHAR   NOT NULL,
    CONSTRAINT "pk_Titles" PRIMARY KEY (
        "title_id"
     )
);

SELECT * FROM "Titles"
-- titles.csv

ALTER TABLE "Employees_dept_junctiom" ADD CONSTRAINT "fk_Employees_dept_junctiom_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");

ALTER TABLE "Employees_dept_junctiom" ADD CONSTRAINT "fk_Employees_dept_junctiom_dept_no" FOREIGN KEY("dept_no")
REFERENCES "Departments" ("dept_no");

ALTER TABLE "Managers" ADD CONSTRAINT "fk_Managers_dept_no" FOREIGN KEY("dept_no")
REFERENCES "Departments" ("dept_no");

ALTER TABLE "Managers" ADD CONSTRAINT "fk_Managers_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");

ALTER TABLE "Employees" ADD CONSTRAINT "fk_Employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "Titles" ("title_id");

ALTER TABLE "Salaries" ADD CONSTRAINT "fk_Salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");

-- Data Analysis

-- List the employee number, last name, first name, sex, and salary of each employee.

SELECT "Employees"."last_name", "Employees"."first_name", "Employees"."sex", "Salaries"."emp_no", "Salaries"."salary"
FROM "Employees"
INNER JOIN "Salaries" ON "Employees"."emp_no" = "Salaries"."emp_no";

-- List the first name, last name, and hire date for the employees who were hired in 1986.

SELECT "Employees"."emp_no", "Employees"."last_name", "Employees"."first_name", "Employees"."hire_date"
FROM "Employees"
WHERE SUBSTRING("hire_date", LENGTH(hire_date) - 3, 4) = '1986';

-- List the manager of each department along with their department number, department name, employee number, last name, and first name.

SELECT "Managers"."dept_no", "Departments"."dept_Name", "Managers"."emp_no", "Employees"."last_name", "Employees"."first_name"
FROM "Managers"
INNER JOIN "Departments"  ON "Managers"."dept_no" = "Departments"."dept_no"
INNER JOIN "Employees" ON "Managers"."emp_no" = "Employees"."emp_no";

-- List the department number for each employee along with that employee’s employee number, last name, first name, and department name.

SELECT "Employees"."emp_no", "Employees"."last_name" , "Employees"."first_name", "Departments"."dept_no", "Departments"."dept_Name" 
FROM "Employees"
JOIN "Employees_dept_junction" ON "Employees"."emp_no" = "Employees_dept_junction"."emp_no"
JOIN "Departments" ON "Employees_dept_junction"."dept_no" = "Departments"."dept_no";

-- List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.

SELECT
    "first_name" AS "First Name",
    "last_name" AS "Last Name",
    "sex" AS "Sex"
FROM "Employees"
WHERE "first_name" = 'Hercules'
    AND "last_name" LIKE 'B%';
	
-- List each employee in the Sales department, including their employee number, last name, and first name.

SELECT
    e."emp_no",
    e."last_name",
    e."first_name",
	d."dept_Name"
FROM
    "Employees" e
INNER JOIN
    "Employees_dept_junction" edj ON e."emp_no" = edj."emp_no"
INNER JOIN
    "Departments" d ON edj."dept_no" = d."dept_no"
WHERE
    d."dept_Name" = 'Sales';

-- List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.

SELECT
    e."emp_no" AS "Employee Number",
    e."last_name" AS "Last Name",
    e."first_name" AS "First Name",
    d."dept_Name" AS "Department Name"
FROM
    "Employees" e
INNER JOIN
    "Employees_dept_junction" edj ON e."emp_no" = edj."emp_no"
INNER JOIN
    "Departments" d ON edj."dept_no" = d."dept_no"
WHERE
    d."dept_Name" IN ('Sales', 'Development');

-- List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).

SELECT
    "last_name" AS "Last Name",
    COUNT(*) AS "Frequency"
FROM
    "Employees"
GROUP BY
    "last_name"
ORDER BY
    "Frequency" DESC;

