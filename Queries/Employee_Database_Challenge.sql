-- Deliverable 1
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
INTO retirement_titles
FROM employees AS e
INNER JOIN titles AS t
ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO unique_titles
FROM retirement_titles 
ORDER BY emp_no, to_date DESC;

-- Retrieve the number of employees by their most recent title who are about to retire.
SELECT COUNT(emp_no),title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT(emp_no) DESC;


-- Deliverable 2
-- Create a mentorship-eligibility table
SELECT DISTINCT ON (e.emp_no)
e.emp_no,
e.first_name,
e.last_name,
e.birth_date,
de.from_date,
de.to_date,
t.title
INTO mentorship_eligibilty
FROM employees AS e
	INNER JOIN dept_emp AS de
		ON (e.emp_no = de.emp_no)
	INNER JOIN titles AS t
		ON (e.emp_no = t.emp_no)
WHERE (de.to_date = '9999-01-01')
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY emp_no;

-- Deliverable 3
SELECT SUM(COUNT) FROM retiring_titles;

-- Retrieve the number of current employees by titles who is potential to be retired
SELECT COUNT(emp_no),
title
INTO current_retire_titles
FROM retirement_titles
WHERE (to_date = '9999-01-01')
GROUP BY title
ORDER BY COUNT(emp_no) DESC;

SELECT SUM(COUNT) FROM current_retire_titles;

-- mentorship eligibility by titles
SELECT COUNT(emp_no),
title
INTO mentor_titles
FROM mentorship_eligibilty
GROUP BY title
ORDER BY COUNT DESC;

SELECT SUM(COUNT) FROM mentor_titles;
-- mentorship eligibility by department
SELECT COUNT(e.emp_no),
d.dept_name
INTO mentorship_by_dept
FROM dept_emp AS de
	INNER JOIN employees AS e
		ON (de.emp_no = e.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no = d.dept_no)
WHERE (de.to_date = '9999-01-01')
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
GROUP BY dept_name
ORDER BY COUNT DESC;

-- potential retirees by department
SELECT COUNT(de.emp_no),
d.dept_name
INTO retiring_dept
FROM dept_emp AS de
	INNER JOIN employees AS e
		ON (de.emp_no = e.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no = d.dept_no)
WHERE (de.to_date = '9999-01-01')
AND (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
GROUP BY dept_name
ORDER BY COUNT DESC;

SELECT CAST(CAST(rd.COUNT AS FLOAT)/CAST(md.COUNT AS FLOAT) AS DECIMAL(4,2)) AS "Roles per Mentor",
md.dept_name AS "Department"
FROM mentorship_by_dept AS md
INNER JOIN retiring_dept AS rd
ON (md.dept_name = rd.dept_name);
