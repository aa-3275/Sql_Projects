SELECT* FROM public.hr_table;
-- Change id to Employee_id
ALTER TABLE Hr_table
ALTER COLUMN id SET NOT NULL;
--  Change name of id column
ALTER TABLE Hr_table
RENAME COLUMN id TO emp_id;

UPDATE Hr_table
SET termdate = NULL
WHERE termdate IS NULL;

-- Create and age Columm
ALTER TABLE Hr_table
ADD COLUMN age int;

Update Hr_table
set age=DATE_PART('year', AGE(CURRENT_DATE, birthdate))
Update hr_table
Set termdate = null
where termdate> Current_Date;
-- Q1-What is the gender breakdown of the employees in the company;
Select gender, count(gender) as gender_count
from Hr_table
group by gender;
-- Q2-Calculate the race breakdownin the company.
Select race, count(race) as race_count
from Hr_table
where termdate isnull
group by race;
-- Q3- What is the age distribution of employees in the company
Select
	case
	when age>=18 and age<=24 then '18-24'
	when age>=25 and age<=34 then '25-34'
	when age>=35 and age<=44 then '35-44'
	when age>=45 and age<=54 then '45-54'
	when age>=55 and age<=60 then '55-60'
	when age>60 then '60+'
	End
	as age_group,
	count(age) 
	from hr_table
	where termdate isnull
	group by age_group
	order by age_group;
-- 	Q4- How many employees working headquarter versus remote.
Select location, count(location)
from hr_table
where termdate isnull
group by location;
-- Q5- What is the employement age duration of the employees who get terminated.
SELECT
    ROUND(AVG(DATE_PART('year', AGE(termdate, hire_date))::NUMERIC), 2) AS employment_duration
FROM
    hr_table
WHERE
    termdate IS NOT NULL;

-- Q6- How is the gender variation across department and the jobtitle.
SELECT
    department,
    jobtitle,
    COUNT(*) FILTER (WHERE gender='Male') AS Male,
    COUNT(*) FILTER (WHERE gender='Female') AS Female,
    COUNT(*) FILTER (WHERE gender='Non-Conforming') AS "Non-Conforming"
FROM
    hr_table
Where termdate isnull
GROUP BY
    department,
    jobtitle
Order BY
department,
    jobtitle;
-- Q7- Distribution of job title across company
Select jobtitle, count(jobtitle) distribution
from hr_table 
where termdate isnull
group by jobtitle
order by jobtitle;
-- Q8- Which department have highest termination rateS

WITH cte AS (
    SELECT
        department
        ,COUNT(*) AS total_count,
        COUNT(CASE WHEN termdate IS NOT NULL THEN 1 END) AS termination_count
    FROM
        hr_table
    GROUP BY
        department
    ORDER BY
        termination_count DESC
)
SELECT
    department, total_count,
    termination_count,
    Round((termination_count::numeric / total_count * 100)::numeric,2) AS termination_rate
FROM
    cte
ORDER BY
    termination_rate desc;

	
-- What is the distribution of employee across location_state
Select location_state
,count(*) as employee_count 
from hr_table
where termdate is null
group by location_state
order by employee_count desc;
-- What is the distribution of employee across location_city
Select location_state,location_city
,count(*) as employee_count 
from hr_table
where termdate is null
group by location_state,location_city
order by employee_count desc;
-- How the count of employees changes based on hire rate and termination rate?
with cte as (Select Date_part('Year',hire_date) as year, 
count(*) as hire_count,COUNT(CASE WHEN termdate IS NOT NULL THEN 1 END) as termination_count,(count(*)- 
COUNT(CASE WHEN termdate IS NOT NULL THEN 1 END)) AS net_change
from hr_table
group by year
order by year desc)

Select *,round(100*(net_change)/hire_count::numeric,2)
as hire_rate, round(100*(termination_count)/hire_count::numeric,2)
as termination_rate from
cte;
-- What is ther tenure distribution in each department

Select department, 
Round(Avg((Date_part('year',termdate))-(Date_part('year',hire_date)))::numeric,1) as tenure
from hr_table
where termdate is not null
group by department
order by tenure desc;









