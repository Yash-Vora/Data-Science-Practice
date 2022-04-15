select * from emp2
select * from emp

-- Display the data of employee with the same salary.
select * from emp where emp_salary in 
(select emp_salary from emp group by emp_salary having count(*) > 1)

-- Display the 5th highest salary using aggregate or subquery.
alter proc n_highest_salary
@n nvarchar(50)
as
begin
	declare @sql nvarchar(max)
	set @sql = 
	'
	with non_dup
	as (
		select *, ROW_NUMBER() OVER(partition by emp_salary order by emp_salary) as rno 
		from emp
	)
	select top 1 * from 
	(select top '+ @n +' * from non_dup where rno = 1 order by emp_salary desc) as nd 
	order by nd.emp_salary
	'
	exec sp_sqlexec @sql
end
exec n_highest_salary @n = 5

-- Display all employees who work at the same department with employee id 5, not including employee id 5. 
select * from emp
where dep_id = (select dep_id from emp where emp_id = 5) and emp_id != 5

-- The employees who earn more than the average salary in department id 2.
select * from emp where emp_salary > (select avg(emp_salary) from emp) and dep_id = 2

-- Retrieve the average summary of all departments whose average salary is greater than the average salary in department id 2.
select * from emp where emp_salary > (select avg(emp_salary) from emp where dep_id = 2)

-- Retrieve all employees who earn more than employee id 3 and work at the same department as employee id 1, not including employee id 1.
select * from emp 
where emp_salary > (select emp_salary from emp where emp_id = 3) and dep_id = (select dep_id from emp where emp_id = 1) and emp_id != 1

-- Display the average salary for each departments from employee. without display the department id.
select d.d_name, avg(e.emp_salary) Avg_Salary_Each_Department 
from emp e join department d 
on e.dep_id = d.d_id 
group by d.d_name
