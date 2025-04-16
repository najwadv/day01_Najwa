with recursive hirarki as (
	select
	e.employee_id,
	e.first_name||' '||last_name as full_name,
	e.manager_id,
	d.department_name,
	1 as level
	from employees e join departments d on e.department_id=d.department_id 
	where manager_id is null
	
	union all
	
	select
	p.employee_id,
	p.first_name||' '||last_name as full_name,
	p.manager_id,
	d.department_name,
	h.level + 1
	from employees p
	join departments d on p.department_id = d.department_id
	join hirarki h on p.manager_id=h.employee_id
)
select * from hirarki
order by employee_id