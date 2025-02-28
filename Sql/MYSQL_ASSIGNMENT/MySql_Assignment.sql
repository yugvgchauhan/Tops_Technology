use hrdb;
-- 1. display all information in the tables emp and dept.
select * from employees;  
select * from departments;  

-- 2. display only the hire date and employee name for each employee.
select hire_date, concat(first_name, ' ', last_name) as employee_name from employees;  

-- 3. display the ename concatenated with the job id, separated by a comma and space, and name the column employee and title.
select concat(first_name, ' ', last_name, ', ', job_id) as "employee and title" from employees;  

-- 4. display the hire date, name, and department number for all clerks.
select hire_date, concat(first_name, ' ', last_name) as employee_name, department_id  
from employees  
where job_id like '%clerk%';  

-- 5. create a query to display all the data from the emp table. separate each column by a comma. name the column the output.
select  
concat(employee_id, ', ', first_name, ', ', last_name, ', ', email, ', ', phone_number, ', ', hire_date, ', ',  
           job_id, ', ', salary, ', ', commission_pct, ', ', manager_id, ', ', department_id) as "the output"  
from employees;  

-- 6. display the names and salaries of all employees with a salary greater than 2000.
select concat(first_name, ' ', last_name) as employee_name, salary  
from employees  
where salary > 2000;  

-- 7. display the names and dates of employees with the column headers "name" and "start date".
select concat(first_name, ' ', last_name) as "name", hire_date as "start date"  
from employees;  

-- 8. display the names and hire dates of all employees in the order they were hired.
select concat(first_name, ' ', last_name) as employee_name, hire_date  
from employees  
order by hire_date;  

-- 9. display the names and salaries of all employees in reverse salary order.
select concat(first_name, ' ', last_name) as employee_name, salary  
from employees  
order by salary desc;  

-- 10. display "ename" and "deptno" who are all earned commission and display salary in reverse order.
select concat(first_name, ' ', last_name) as ename, department_id as deptno, salary  
from employees  
where commission_pct is not null  
order by salary desc;  

-- 11. display the last name and job title of all employees who do not have a manager.
select last_name, job_id  
from employees  
where manager_id is null;  

-- 12. display the last name, job, and salary for all employees whose job is sales representative or stock clerk and whose salary is not equal to $2,500, $3,500, or $5,000.
select last_name, job_id, salary  
from employees  
where job_id in ('sa_rep', 'st_clerk')  
and salary not in (2500, 3500, 5000);  

-- 1. display the maximum, minimum and average salary and commission earned.
select max(salary) as max_salary, min(salary) as min_salary, avg(salary) as avg_salary, 
       max(commission_pct) as max_commission, min(commission_pct) as min_commission, avg(commission_pct) as avg_commission  
from employees;  

-- 2. display the department number, total salary payout and total commission payout for each department.
select department_id, sum(salary) as total_salary_payout, sum(commission_pct * salary) as total_commission_payout  
from employees  
group by department_id;  

-- 3. display the department number and number of employees in each department.
select department_id, count(*) as num_employees  
from employees  
group by department_id;  

-- 4. display the department number and total salary of employees in each department.
select department_id, sum(salary) as total_salary  
from employees  
group by department_id;  

-- 5. display the employee's name who doesn't earn a commission. order the result set without using the column name.
select concat(first_name, ' ', last_name)  
from employees  
where commission_pct is null  
order by 1;  

-- 6. display the employees name, department id and commission. if an employee doesn't earn the commission, then display as 'no commission'. name the columns appropriately.
select concat(first_name, ' ', last_name) as employee_name, department_id,  
       ifnull(commission_pct, 'no commission') as commission  
from employees;  

-- 7. display the employee's name, salary and commission multiplied by 2. if an employee doesn't earn the commission, then display as 'no commission'. name the columns appropriately.
select concat(first_name, ' ', last_name) as employee_name, salary,  
       ifnull(commission_pct * 2, 'no commission') as doubled_commission  
from employees;  

-- 8. display the employee's name, department id who have the first name same as another employee in the same department.
select e1.first_name, e1.last_name, e1.department_id  
from employees e1  
join employees e2 on e1.first_name = e2.first_name and e1.department_id = e2.department_id and e1.employee_id <> e2.employee_id;  

-- 9. display the sum of salaries of the employees working under each manager.
select manager_id, sum(salary) as total_salary_under_manager  
from employees  
where manager_id is not null  
group by manager_id;  

-- 10. select the managers name, the count of employees working under and the department id of the manager.
select concat(m.first_name, ' ', m.last_name) as manager_name, count(e.employee_id) as num_employees, m.department_id  
from employees e  
join employees m on e.manager_id = m.employee_id  
group by m.employee_id, m.first_name, m.last_name, m.department_id;  

-- 11. select the employee name, department id, and the salary. group the result with the manager name and the employee last name should have second letter 'a'.
select concat(e.first_name, ' ', e.last_name) as employee_name, e.department_id, e.salary  
from employees e  
join employees m on e.manager_id = m.employee_id  
where e.last_name like '_a%'  
group by m.first_name, m.last_name, e.first_name, e.last_name, e.department_id, e.salary;  

-- 12. display the average of sum of the salaries and group the result with the department id. order the result with the department id.
select department_id, avg(salary) as average_salary  
from employees  
group by department_id  
order by department_id;  

-- 13. select the maximum salary of each department along with the department id.
select department_id, max(salary) as max_salary  
from employees  
group by department_id;  

-- 14. display the commission, if not null display 10% of salary, if null display a default value 1.
select employee_id,  
       if(commission_pct is not null, salary * 0.10, 1) as commission_value  
from employees;  

-- 1. display the maximum, minimum and average salary and commission earned.
select max(salary) as max_salary, min(salary) as min_salary, avg(salary) as avg_salary, max(commission_pct) as max_commission,
min(commission_pct) as min_commission, avg(commission_pct) as avg_commission  
from employees;  

-- 2. display the department number, total salary payout and total commission payout for each department.
select department_id, sum(salary) as total_salary_payout, sum(commission_pct * salary) as total_commission_payout  
from employees  
group by department_id;  

-- 3. display the department number and number of employees in each department.
select department_id, count(*) as num_employees  
from employees  
group by department_id;  

-- 4. display the department number and total salary of employees in each department.
select department_id, sum(salary) as total_salary  
from employees  
group by department_id;  

-- 5. display the employee's name who doesn't earn a commission. order the result set without using the column name.
select concat(first_name, ' ', last_name)  
from employees  
where commission_pct is null  
order by 1;  

-- 6. display the employees name, department id and commission. if an employee doesn't earn the commission, then display as 'no commission'. name the columns appropriately.
select concat(first_name, ' ', last_name) as employee_name, department_id,  
ifnull(commission_pct, 'no commission') as commission  
from employees;  

-- 7. display the employee's name, salary and commission multiplied by 2. if an employee doesn't earn the commission, then display as 'no commission'. name the columns appropriately.
select concat(first_name, ' ', last_name) as employee_name, salary,  
ifnull(commission_pct * 2, 'no commission') as doubled_commission  
from employees;  

-- 8. display the employee's name, department id who have the first name same as another employee in the same department.
select e1.first_name, e1.last_name, e1.department_id  
from employees e1  
join employees e2 on e1.first_name = e2.first_name and e1.department_id = e2.department_id and e1.employee_id <> e2.employee_id;  

-- 9. display the sum of salaries of the employees working under each manager.
select manager_id, sum(salary) as total_salary_under_manager  
from employees  
where manager_id is not null  
group by manager_id;  

-- 10. select the managers name, the count of employees working under and the department id of the manager.
select concat(m.first_name, ' ', m.last_name) as manager_name, count(e.employee_id) as num_employees, m.department_id  
from employees e  
join employees m on e.manager_id = m.employee_id  
group by m.employee_id, m.first_name, m.last_name, m.department_id;  

-- 11. select the employee name, department id, and the salary. group the result with the manager name and the employee last name should have second letter 'a'.
select concat(e.first_name, ' ', e.last_name) as employee_name, e.department_id, e.salary  
from employees e  
join employees m on e.manager_id = m.employee_id  
where e.last_name like '_a%'  
group by m.first_name, m.last_name, e.first_name, e.last_name, e.department_id, e.salary;  

-- 12. display the average of sum of the salaries and group the result with the department id. order the result with the department id.
select department_id, avg(salary) as average_salary  
from employees  
group by department_id  
order by department_id;  

-- 13. select the maximum salary of each department along with the department id.
select department_id, max(salary) as max_salary  
from employees  
group by department_id;  

-- 14. display the commission, if not null display 10% of salary, if null display a default value 1.
select employee_id,  
       if(commission_pct is not null, salary * 0.10, 1) as commission_value  
from employees;  



-- 1. write a query that displays the employee's last names only from the string's 2-5th position with the first letter capitalized and all other letters lowercase. give each column an appropriate label.
select concat(upper(substring(last_name, 2, 1)), lower(substring(last_name, 3, 3))) as formatted_last_name  
from employees;  

-- 2. write a query that displays the employee's first name and last name along with a " - " in between. also displays the month on which the employee has joined.
select concat(first_name, '-', last_name) as employee_name, monthname(hire_date) as joining_month  
from employees;  

-- 3. write a query to display the employee's last name and if half of the salary is greater than ten thousand then increase the salary by 10% else by 11.5% along with the bonus amount of 1500 each. provide each column an appropriate label.
select last_name,salary,  
       case  
           when salary/2>10000 then (salary+(salary * 0.1 )) 
           else salary+(salary * 0.115)
       end as updated_salary,  
       1500 as bonus_amount  
from employees;  

-- 4. display the employee id by appending two zeros after 2nd digit and 'e' in the end, department id, salary and the manager name all in upper case, if the manager name consists of 'z' replace it with '$'.
select concat(left(employee_id, 2), '00', right(employee_id, length(employee_id) - 2), 'e') as modified_employee_id,  
       department_id,  
       salary,  
       upper(replace(manager_id, 'z', '$')) as manager_name  
from employees;  

-- 5. write a query that displays the employee's last names with the first letter capitalized and all other letters lowercase, and the length of the names, for all employees whose name starts with j, a, or m. give each column an appropriate label. sort the results by the employees' last names.
select concat(upper(left(last_name, 1)), lower(substring(last_name, 2))) as formatted_last_name,  
       length(last_name) as name_length  
from employees  
where last_name like 'j%' or last_name like 'a%' or last_name like 'm%'  
order by last_name;  

-- 6. create a query to display the last name and salary for all employees. format the salary to be 15 characters long, left-padded with $. label the column salary.
select last_name, lpad(salary, 15, '$') as salary  
from employees;  

-- 7. display the employee's name if it is a palindrome.
select first_name  
from employees  
where lower(first_name) = reverse(lower(first_name));  

-- 8. display first names of all employees with initcaps.
select concat(upper(left(first_name, 1)), lower(substring(first_name, 2))) as formatted_first_name  
from employees;  

-- 9. from locations table, extract the word between first and second space from the street address column.
select substring_index(substring_index(street_address, ' ', 2), ' ', -1) as extracted_word  
from locations;  

-- 10. extract first letter from first name column and append it with the last name. also add "@systechusa.com" at the end. name the column as e-mail address. all characters should be in lower case. display this along with their first name.
select first_name,  
       lower(concat(left(first_name, 1), last_name, '@systechusa.com')) as email_address  
from employees;  

-- 11. display the names and job titles of all employees with the same job as trenna.
select first_name, last_name, job_id  
from employees  
where job_id = (select job_id from employees where first_name = 'trenna' limit 1);  

-- 12. display the names and department name of all employees working in the same city as trenna.
select e.first_name, e.last_name, d.department_name  
from employees e  
join departments d on e.department_id = d.department_id  
join locations l on d.location_id = l.location_id  
where l.city = (select l.city from employees e  
                join departments d on e.department_id = d.department_id  
                join locations l on d.location_id = l.location_id  
                where e.first_name = 'trenna' limit 1);  

-- 13. display the name of the employee whose salary is the lowest.
select first_name, last_name, salary  
from employees  
where salary = (select min(salary) from employees);  

-- 14. display the names of all employees except the lowest paid.
select first_name, last_name, salary  
from employees  
where salary > (select min(salary) from employees);  

-- 1. write a query to display the last name, department number, department name for all employees.
select e.last_name, e.department_id, d.department_name  
from employees e  
join departments d on e.department_id = d.department_id;  

-- 2. create a unique list of all jobs that are in department 4. include the location of the department in the output.
select distinct j.job_title, l.location_id, l.city  
from jobs j  
join employees e on j.job_id = e.job_id  
join departments d on e.department_id = d.department_id  
join locations l on d.location_id = l.location_id  
where d.department_id = 4;  

-- 3. write a query to display the employee last name, department name, location id, and city of all employees who earn commission.
select e.last_name, d.department_name, l.location_id, l.city  
from employees e  
join departments d on e.department_id = d.department_id  
join locations l on d.location_id = l.location_id  
where e.commission_pct is not null;  

-- 4. display the employee last name and department name of all employees who have an 'a' in their last name.
select e.last_name, d.department_name  
from employees e  
join departments d on e.department_id = d.department_id  
where e.last_name like '%a%';  

-- 5. write a query to display the last name, job, department number, and department name for all employees who work in atlanta.
select e.last_name, e.job_id, d.department_id, d.department_name  
from employees e  
join departments d on e.department_id = d.department_id  
join locations l on d.location_id = l.location_id  
where lower(l.city) = 'atlanta';  

-- 6. display the employee last name and employee number along with their manager's last name and manager number.
select e.last_name as employee_last_name, e.employee_id,  
       m.last_name as manager_last_name, e.manager_id  
from employees e  
join employees m on e.manager_id = m.employee_id;  

-- 7. display the employee last name and employee number along with their manager's last name and manager number (including the employees who have no manager).
select e.last_name as employee_last_name, e.employee_id,  
       coalesce(m.last_name, 'no manager') as manager_last_name,  
       coalesce(e.manager_id, 'no manager') as manager_id  
from employees e  
left join employees m on e.manager_id = m.employee_id;  

-- 8. create a query that displays employees last name, department number, and all the employees who work in the same department as a given employee.
select e1.last_name as employee_last_name, e1.department_id, e2.last_name as colleague_last_name  
from employees e1  
join employees e2 on e1.department_id = e2.department_id  
where e1.employee_id <> e2.employee_id  
order by e1.last_name;  

-- 9. create a query that displays the name, job, department name, salary, grade for all employees. derive grade based on salary(>=50000=a, >=30000=b,<30000=c).
select e.first_name, e.last_name, j.job_title, d.department_name, e.salary,  
       case  
           when e.salary >= 50000 then 'A'  
           when e.salary >= 30000 then 'B'  
           else 'C'  
       end as grade  
from employees e  
join jobs j on e.job_id = j.job_id  
join departments d on e.department_id = d.department_id;  

-- 10. display the names and hire date for all employees who were hired before their managers along with their manager names and hire date. label the columns as employee name, emp_hire_date, manager name, man_hire_date.
select concat(e.first_name, ' ', e.last_name) as employee_name, e.hire_date as emp_hire_date,  
       concat(m.first_name, ' ', m.last_name) as manager_name, m.hire_date as man_hire_date  
from employees e  
join employees m on e.manager_id = m.employee_id  
where e.hire_date < m.hire_date;  

-- 1. write a query to display the last name and hire date of any employee in the same department as sales.
select e.last_name, e.hire_date  
from employees e  
join departments d on e.department_id = d.department_id  
where lower(d.department_name) = 'sales';  

-- 2. create a query to display the employee numbers and last names of all employees who earn more than the average salary. sort the results in ascending order of salary.
select employee_id, last_name  
from employees  
where salary > (select avg(salary) from employees)  
order by salary asc;  

-- 3. write a query that displays the employee numbers and last names of all employees who work in a department with any employee whose last name contains 'u'.
select distinct e1.employee_id, e1.last_name  
from employees e1  
join employees e2 on e1.department_id = e2.department_id  
where e2.last_name like '%u%';  

-- 4. display the last name, department number, and job id of all employees whose department location is atlanta.
select e.last_name, e.department_id, e.job_id  
from employees e  
join departments d on e.department_id = d.department_id  
join locations l on d.location_id = l.location_id  
where lower(l.city) = 'atlanta';  

-- 5. display the last name and salary of every employee who reports to fillmore.
select e.last_name, e.salary  
from employees e  
join employees m on e.manager_id = m.employee_id  
where lower(m.last_name) = 'fillmore';  

-- 6. display the department number, last name, and job id for every employee in the operations department.
select e.department_id, e.last_name, e.job_id  
from employees e  
join departments d on e.department_id = d.department_id  
where lower(d.department_name) = 'operations';  

-- 7. modify the above query to display the employee numbers, last names, and salaries of all employees 
-- who earn more than the average salary and who work in a department with any employee with a 'u' in their name.
select distinct e1.employee_id, e1.last_name, e1.salary  
from employees e1  
join employees e2 on e1.department_id = e2.department_id  
where e1.salary > (select avg(salary) from employees)  
and e2.last_name like '%u%';  

-- 8. display the names of all employees whose job title is the same as anyone in the sales department.
select e.first_name, e.last_name  
from employees e  
join jobs j on e.job_id = j.job_id  
where e.job_id in (  
    select distinct e2.job_id  
    from employees e2  
    join departments d on e2.department_id = d.department_id  
    where lower(d.department_name) = 'sales'  
);  

-- 9. write a compound query to produce a list of employees showing raise percentages, employee ids, and salaries.
with salary_raise as (
    select employee_id, 
           salary, 
           department_id,
           case 
               when department_id in (1, 3) then 0.05
               when department_id = 2 then 0.10
               when department_id in (4, 5) then 0.15
               else 0
           end as raise_percentage
    from employees
)
select employee_id, 
       salary, 
       concat(raise_percentage * 100, '%') as raise_percentage, 
       salary * (1 + raise_percentage) as new_salary
from salary_raise;


-- 10. write a query to display the top three earners in the employees table. display their last names and salaries.
create view top_earners as 
select last_name, salary 
from employees 
order by salary desc 
limit 3;
select*from top_earners;


-- 11. display the names of all employees with their salary and commission earned. employees with a null commission should have 0 in the commission column.
select first_name, last_name, salary, coalesce(commission_pct, 0) as commission_earned  
from employees;  

-- 12. display the managers (name) with top three salaries along with their salaries and department information.
with manager_salary as (
    select e.first_name, 
           e.last_name, 
           e.salary, 
           d.department_name, 
           rank() over (order by e.salary desc) as salary_rank
    from employees e
    join departments d on e.department_id = d.department_id
    where e.employee_id in (select distinct manager_id from employees where manager_id is not null)
)
select first_name, last_name, salary, department_name 
from manager_salary 
where salary_rank <= 3;

create table if not exists date_function(Emp_ID int primary key not null auto_increment,hire_date date,Resignation_Date Date);
INSERT INTO date_function (hire_date, Resignation_Date) 
VALUES 
    ('2000-01-01', '2013-07-10'),
    ('2003-12-04', '2017-08-03'),
    ('2012-09-22', '2015-06-21'),
    ('2015-04-13', NULL),
    ('2016-06-03', NULL),
    ('2017-08-08', NULL),
    ('2016-11-13', NULL);


---------- -Date Function-------------
-- 1) Find the date difference between the hire date and resignation date for all employees in years, months, and days.
select timestampdiff(day,hire_date,Resignation_Date) as day,
timestampdiff(month,hire_date,Resignation_Date)%12 as month,
timestampdiff(year,hire_date,Resignation_Date) as year 
from date_function;

-- 2) Format the hire date as mm/dd/yyyy and resignation_date as Mon DD, YYYY. Display NULL as DEC, 01th 1900.
select date_format(hire_date,'%m/%d/%y') as hire_date,ifNULL(date_format(Resignation_Date,'%b %e, %y') ,'Dec 01th, 1900') as Regination_date 
from date_function;

-- 3) Calculate experience of the employee till today in years and months.
SELECT 
    CONCAT(
        IFNULL(TIMESTAMPDIFF(YEAR, hire_date, Resignation_Date), TIMESTAMPDIFF(YEAR, hire_date, CURDATE())), " year ",
        IFNULL(TIMESTAMPDIFF(MONTH, hire_date, Resignation_Date) % 12, TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) % 12), " month"
    ) AS experience
FROM date_function;

-- 4) Display the count of days in the previous quarter.
SELECT 
    TIMESTAMPDIFF(DAY, 
        DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-%m-01'), INTERVAL 3 MONTH), 
        DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-%m-01'), INTERVAL 0 MONTH)
    ) AS days_in_previous_quarter;
    
-- 5) Fetch the previous quarter's second week's first day's date.
SELECT 
    DATE_ADD(
        DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-%m-01'), INTERVAL 3 MONTH), 
        INTERVAL 7 DAY
    ) AS second_week_first_day_previous_quarter;

-- 6) Fetch the financial year’s 15th week’s starting date in format Mon DD YYYY.
SELECT 
    DATE_FORMAT(
        DATE_ADD(
            STR_TO_DATE(CONCAT(YEAR(CURDATE()), '-04-01'), '%Y-%m-%d'), 
            INTERVAL (15 - 1) WEEK
        ), 
        '%a %d %Y'
    ) AS first_day_15th_week,
    DATE_FORMAT(
        DATE_ADD(
            DATE_ADD(
                STR_TO_DATE(CONCAT(YEAR(CURDATE()), '-04-01'), '%Y-%m-%d'), 
                INTERVAL (15 - 1) WEEK
            ),
            INTERVAL 6 DAY
        ), 
        '%a %d %Y'
    ) AS last_day_15th_week;

-- 7) Find out the date that corresponds to the last Saturday of January, 2015 using WITH clause.
WITH last_day_january_2015 AS (
    SELECT '2015-01-31' AS last_day
)
SELECT 
    DATE_SUB(last_day, INTERVAL (DAYOFWEEK(last_day) + 1) % 7 DAY) AS last_saturday_january_2015
FROM last_day_january_2015;

-- 8) Find the number of days elapsed between the first and last flights of a passenger in the Airport database.

-- 9) Find the total duration in minutes and in seconds of the flight from Rostov to Moscow.
