# Pewlett-Hackard-Analysis
## Overview
Helping the company management to prepare for the upcoming "silver tsunami". Find out the retiring employees and retreive their infomation for the manager. Also, retrieve information of employees who are eligible to participate in a mentorship program.

## Results
### After retrieved the number of employees by their most recent job title who are about to retire, we got the Retiring Titles table as below:

![Screen Shot 2021-08-07 at 1 47 08 PM](https://user-images.githubusercontent.com/66225050/128613676-24003538-5b16-4073-ad19-68cdb4e55b65.png)

- There are **90398** employees are eligible to retire.
- Most of the eligible retirees are Senior Engineer and Senior Staff, which are 29414 and 28254 of them respectively. Total number of potential retirees in these 2 titles accounts for more than half of the whole retiring employee group. However, there are only **2** employees titled as **Manager** are going to be retire, which stands in sharp contrast to all other titles.
- But, these potential retirees includes employees had left. Excluding the left employees we got: total **72458** current employees are potential to be retired. Script and table are as following:
```SQL
SELECT COUNT(emp_no),
title
INTO current_retire_titles
FROM retirement_titles
WHERE (to_date = '9999-01-01')
GROUP BY title
ORDER BY COUNT(emp_no) DESC;
```
![Screen Shot 2021-08-07 at 3 50 14 PM](https://user-images.githubusercontent.com/66225050/128650410-ad5b46f4-81f2-43f9-81d2-c3fe24a31569.png)

After identified the mentorship eligibility, we got a table that holds the employees who are eligible to participate in a mentorship program. Grouping them by job titles we can get:

![mentor_per_role](https://user-images.githubusercontent.com/66225050/128652247-33d2badf-7281-4ee4-8de4-46b959a79ff9.png)

- There are total **1549** current employees are eligible to participate mentorship program.

## Summary
### How many roles will need to be filled as the "silver tsunami" begins to make an impact?
Running additional queries below:
```SQL
SELECT COUNT(emp_no),
title
INTO current_retire_titles
FROM retirement_titles
WHERE (to_date = '9999-01-01')
GROUP BY title
ORDER BY COUNT(emp_no) DESC;

SELECT SUM(COUNT) FROM current_retire_titles;
```
We get the updated Retiring Titles Table for only current employees, `current_retire_titles`.

![Screen Shot 2021-08-07 at 3 50 14 PM](https://user-images.githubusercontent.com/66225050/128615718-1549f6dd-c7f2-4509-bf50-517af05d4369.png)

And, sum of the count:

![Screen Shot 2021-08-07 at 3 50 39 PM](https://user-images.githubusercontent.com/66225050/128615722-54a7c52f-9232-4c10-a8bf-05fc03b6a728.png)

Therefore, there are 72458 roles will need to be filled as the "silver tsunami" begins to make an impact.

### Are there enough qualified, retirement-ready employees in the departments to mentor the next generation of Pewlett Hackard employees?
Running additional queries below:
```SQL
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
```
We get the number of eligible mentorship employees by each departments versus retiring employees count per departments:

![mentorship_by_dept](https://user-images.githubusercontent.com/66225050/128624035-c56aea2a-f72b-477e-8971-9fc925b4847c.png)![retiring_dept](https://user-images.githubusercontent.com/66225050/128624041-1038e23a-08f9-4f8d-9119-c06b0f88845a.png)

Then, perform the aggregate and get the Roles per Mentor ratio as following:
```SQL
SELECT CAST(CAST(rd.COUNT AS FLOAT)/CAST(md.COUNT AS FLOAT) AS DECIMAL(4,2)) AS "Roles per Mentor",
md.dept_name AS "Department"
FROM mentorship_by_dept AS md
INNER JOIN retiring_dept AS rd
ON (md.dept_name = rd.dept_name);
```
![roles_per_mentor](https://user-images.githubusercontent.com/66225050/128649872-cb0d4060-26d5-4bb9-b97b-93fe1fa940b7.png)

Base on the ratio we get from above, each eligible retirement_ready employee will mentor about 40 to 60 next generation of Pewlett Hackard employees per department.


