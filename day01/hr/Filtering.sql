select *
from employees where extract(MONTH from hire_date)=08

select employee_id,first_name||' '||last_name as
full_name,hire_date,TO_CHAR(salary, 'FM999999.00') as salary
from HR.employees
where hire_date between '1997-08-17' and '1998-04-23'

select * from employees
where lower(last_name) like lower('king')

select * from employees
where department_id in (9,10)