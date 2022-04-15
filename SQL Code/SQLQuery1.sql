create table department (
	d_id int primary key identity(1,1),
	d_name varchar(20)
)

-- By default schema is dbo
select * from department

insert into department values ('HR'), ('IT'), ('Management')


-- Employeee Table
create table emp (
	emp_id int primary key identity(1,1),
	dep_id int foreign key references department(d_id),
	emp_name varchar(20),
	emp_city varchar(20) default('Ahmedabad'),
	emp_email varchar(100),
	emp_gender varchar(10) check(emp_gender = 'male' or emp_gender = 'female')
)

drop table emp

alter table emp add unique(emp_email)

insert into emp (dep_id, emp_name, emp_city, emp_email, emp_gender)
values (1, 'yash', 'ahmedabad', 'yash.vora@gmail.com', 'male'), 
	   (2, 'shubham', 'rajkot', 'shubham.shah@gmail.com', 'male'),
	   (3, 'ram', 'surat', 'ram.verma@gmail.com', 'male')

alter table emp add emp_mobile numeric(10)
alter table emp add unique(emp_mobile)

update emp set emp_mobile = 6547890721 where emp_id = 1
update emp set emp_mobile = 8976890721 where emp_id = 2
update emp set emp_mobile = 9876890721 where emp_id = 3

alter table emp add emp_salary numeric(6)
alter table emp add check(emp_salary >= 5000)

update emp set emp_salary = 15000 where emp_id = 1
update emp set emp_salary = 20000 where emp_id = 2
update emp set emp_salary = 30000 where emp_id = 3

delete from emp where emp_id = 3
delete from emp
truncate table emp

select * from emp

-- Check all databases and tables list
select * from sys.databases
select * from sys.tables
select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS

select emp_name, emp_city, emp_email from emp

-- Order By
select * from emp order by emp_id
select * from emp order by emp_id desc
select * from emp order by 1
select * from emp order by 1 desc
select * from emp order by 2 desc
select * from emp order by 3 desc

-- Clone of table
select * into employee_bkp from emp
select * from employee_bkp

-- Where Clause
select * from emp where emp_salary > 15000
select * from emp where emp_salary > 15000 and emp_salary < 40000
select * from emp where emp_salary > 15000 or emp_salary < 40000

-- Between Clause
select * from emp where emp_salary between 20000 and 30000

-- Null and Not Null
select * from employee_bkp where dep_id is null
select * from employee_bkp where dep_id is not null

-- like
select * from emp where emp_name like 'y%'
select * from emp where emp_name like '_a%'
select * from emp where emp_name like '%m'
select * from emp where emp_name like '%a%'

-- joins
select *
from emp e inner join department d
on e.dep_id = d.d_id
select *
from emp e left join department d
on e.dep_id = d.d_id
select *
from emp e right join department d
on e.dep_id = d.d_id
select *
from emp e full join department d
on e.dep_id = d.d_id
select *
from emp e cross join department d

-- distinct
select distinct emp_name from emp

--ranking function: (partition by --optional)
--rank,dense_rank,row_number,ntile
select *,
rank() over(order by mark desc) [rank],
dense_rank() over(order by mark desc) [dense rank],
row_number() over(order by name desc) [row_number],
ntile(2) over(order by name desc) [ntile]
from student
select *,
rank() over(partition by e_gender order by e_salary desc) [rank],
dense_rank() over(partition by e_gender order by e_salary desc) [dense rank],
row_number() over(partition by e_gender order by e_salary desc) [row_number],
ntile(2) over(partition by e_gender order by e_salary desc) [ntile]
from emp
select *,
rank() over(partition by e_gender order by e_salary desc) [rank],
dense_rank() over(partition by e_gender order by e_salary desc) [dense rank],
row_number() over(partition by e_gender order by e_salary desc) [row_number],
ntile(2) over(partition by e_gender order by e_salary desc) [ntile]
into emp5 from emp

--analytic function: (partition by --optional)
--lead,lag,first_value,last_value
select *,
LEAD(emp_salary, 1) over(order by emp_id) lead
from emp
select *,
LAG(emp_salary, 2) over(order by emp_id) lag
from emp
select *,
first_value(emp_salary) over(order by emp_id desc) first_value
from emp
select *,
last_value(emp_salary) over(order by emp_id desc) last_value
from emp

--String Functions : ascii, char, TRIM(2017), ltrim, rtrim, lower, upper, reverse, len, 
--DATALENGTH, left,right, charindex, patindex, substring, replicate, space, replace, 
--stuff, CONCAT, QUOTENAME
select ascii('a'), ascii('A'), ascii('asdfgh')
select emp_name, ascii(emp_name) ascii_value_of_name from emp
select char(65)
select TRIM('         Yash Vora                ')
select LTRIM('    Yash Vora')
select RTRIM('Yash Vora    ')
select LOWER('YASH')
select UPPER('yash')
select REVERSE('yash')
select LEN(' yash'),LEN(' yash ')
select DATALENGTH(' yash'),DATALENGTH(' yash ')
select LEFT('yash', 2)
select RIGHT('yash', 2)
select CHARINDEX('y','yash')
select CHARINDEX('s','yash',2)
select PATINDEX('%as%','yash')
select SUBSTRING('Hello World', 4, 9)
select REPLICATE('abc ', 3)
select 'Yash'+ SPACE(1) +'Vora'
select REPLACE('yash vora', 'yash', 'sparsh')
select STUFF('yash',1,2,'*')
select concat('yas','vqr')
select concat('yas','vqr',6)
select concat(6,4,5)
select QUOTENAME('yash','(')
select QUOTENAME('yash','}')

--math function : abs, ceiling, floor, power, rand, square, sqrt, round
select ABS(-6.5), ABS(6)
select CEILING(1.4), CEILING(5.6), CEILING(-6.7)
select FLOOR(1.4), FLOOR(5.6), FLOOR(-6.7)
select SQUARE(2), SQUARE(4)
select SQRT(4), SQRT(16)
select RAND(), RAND() * 10
select ROUND(122.24,1), ROUND(122.567,3), ROUND(122.24,0), ROUND(122.8974,3)

--date-time functions : CURRENT_TIMESTAMP,getdate,sysdatetime,DATEADD,datediff,
--DATEFROMPARTS,DATENAME,DATEPART,day,month,year,getutcdate,ISDATE
select GETDATE(), CURRENT_TIMESTAMP, SYSDATETIME(), GETUTCDATE()
select DATEADD(day,2,'2022/02/15')
select DATEADD(day,-2,'2022/02/15')
select DATEADD(month,2,'2022/02/15')
select DATEADD(year,2,'2022/02/15')
select DATEDIFF(day,'2022/02/15','2024/04/17')
select DATEPART(year,'2022/02/15')
select DATEPART(month,'2022/02/15')
select DATEPART(day,'2022/02/15')
select year('2022/02/15')
select month('2022/02/15')
select day('2022/02/15')
select ISDATE('2022/02/14')

--Advanced function : null, Coalesce, exists, Cast, Convert
-- isnull()
select * from emp
insert into emp (dep_id, emp_name, emp_city, emp_email, emp_gender, emp_mobile) 
values (2, 'gopal', 'surat', 'gopal.verma@gmail.com', 'female', 8765345609)
select emp_name, emp_city, isnull(emp_salary, 123) from emp
-- coalesce
select coalesce('a','b','c')
select coalesce('','b','c')
select coalesce(null,'b','c')
select *,coalesce(emp_salary, 123) from emp
--cast : (<column_name> as <datatype>)
select *,cast(emp_mobile as varchar(10)) emp_mob from emp
--convert : (<datatype>,<column_name>)
select *,convert(varchar(10),emp_mobile) emp_mob from emp

-- group by
select emp_name,emp_salary from emp 
group by emp_name, emp_salary

select d.d_name, sum(e.emp_salary) e_salary
from emp e join department d
on e.emp_id = d.d_id
group by d.d_name

select d.d_name, sum(e.emp_salary) e_salary
from emp e join department d
on e.emp_id = d.d_id
group by d.d_name
having e_salary > 15000

select d.d_name, sum(e.emp_salary) e_salary
from emp e join department d
on e.emp_id = d.d_id
group by d.d_name
having sum(e.emp_salary) > 15000

-- is null and is not null
select * from emp
select * from emp where emp_salary is null
select * from emp where emp_salary is not null

-- Set - Union, Union all, Intersect, Except
select * from emp
union
select * from emp
select * from emp
union all
select * from emp
select * from emp
intersect
select * from emp
select * from emp
except
select * from emp

-- Sub Query
-- Select second highest salary
select * from emp where emp_salary in
(select max(emp_salary) second_highest_salary from emp 
where emp_salary not in (select max(emp_salary) from emp))
select top 2 * from emp order by emp_salary desc

-- Declare Variables and Print
print 'xyz'
select 'xyz'
print 3+4

declare @name varchar(10) = 'hello'
print @name

declare @name varchar(10)
set @name = 'hello'
print @name

declare @name varchar(10)
select @name = 'hello'
print @name

declare @name varchar(10) = 'hii'
set @name = 'hello'
print @name

declare @c1 int = 1, @c2 int = 10
while @c1 <= @c2
begin
	print @c1
	break
set @c1 += 1
end

declare @c1 int = 1, @c2 int = 10
while @c1 <= @c2
begin
	print @c1
	set @c1 += 1
	continue
	print @c2
end

declare @c1 int = 1, @c2 int = 10
while @c1 <= @c2
begin
	print @c1
	set @c1 += 1
	if @c1 = 5
		continue
	print @c2
end

--with <cte_name>
--as
--()
--use of cte
with updated_sal
as
(select *, emp_salary+100 emp_sal from emp)
select * from updated_sal where emp_sal > 15100

select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'emp'

-- case when then else end
select *, 
case when emp_salary >= 25000 then 1 when emp_salary >= 16000 and emp_salary <= 25000 then 2 else 3 end new_salary 
from emp

-- iif
select *,iif(emp_gender='Male','M','F') newGender from emp

-- if-else, if-elseif-else
declare @val int = 1
if @val < 0
	print 'neg'
else
	print 'pos'

declare @val int = -1
if @val < 0
begin
	print 'neg'
end
else if @val > 0
begin
	print 'pos'
end
else if @val is null
begin
	print 'nan'
end
else
begin
	print 'zero'
end

-- 5 * 1 = 5
-- 5 * 2 = 10
-- ....
-- 5 * 10 = 50
declare @a int = 5, @b int = 1
while @b <= 10
begin
	print cast(@a as varchar(1))+ ' * ' + cast(@b as varchar(2))+ ' = ' + cast(@a * @b as varchar(2))
set @b += 1
end

--create view <view_name>
--as
--<query>
create view V_EMP
as
select * from emp

--temporary tables : local temporary table, global temporary table
select * from emp
create table #demo1
(
	id int identity(1,1),
	name varchar(10)
)
select * from #demo1

create table ##demo1
(
	id int identity(1,1),
	name varchar(10)
)
select * from ##demo1

-- Table Variable
declare @tbl as table
(
	id int
)
insert into @tbl values(1)
select * from @tbl

-- Exception Handling - try, catch
-- Syntax
-- begin try
-- end try
-- begin catch
-- end catch

begin try
	select 1/0
end try
begin catch
	SELECT ERROR_MESSAGE() AS [Error Message]
	      ,ERROR_LINE() AS ErrorLine
	      ,ERROR_NUMBER() AS [Error Number]  
          ,ERROR_SEVERITY() AS [Error Severity]  
          ,ERROR_STATE() AS [Error State]  
		  ,@@ERROR
end catch

-- Stored Procedure
-- Syntax
-- create/alter procedure/proc <sp_name>
-- <parameters> --optionally
-- as
-- begin
-- end
-- execute/exec <sp_name> <parameters-optional>

create proc all_emp
as 
begin
	select * from emp
end
exec all_emp

-- dynamic table name query
alter proc all_emp
@tbl_name nvarchar(50)
as
begin
	declare @sql nvarchar(max)
	set @sql = 
	'
	select * from ' + @tbl_name + '
	'
	exec sp_sqlexec @sql
end
exec all_emp emp

create proc emp_genderwise
@gender varchar(10)
as
begin
	select * from emp where emp_gender = @gender
end
exec emp_genderwise 'male'
exec emp_genderwise 'female'

alter proc emp_genderwise
@gender varchar(10) = null
as
begin
	if @gender is null
	begin
		select * from emp
	end
	else
	begin
		select * from emp where emp_gender = @gender
	end
end
exec emp_genderwise 'male'
exec emp_genderwise 'female'
exec emp_genderwise

alter proc emp_genderwise
@gender varchar(10) = null
as
begin
	select * from emp where emp_gender = @gender or @gender is null
end
exec emp_genderwise 'male'
exec emp_genderwise 'female'


-- Show duplicate records
with duplicate
as
(
	select *,ROW_NUMBER() over(partition by emp_name order by emp_name) dup from emp
)
select * from duplicate where dup > 1

-- Add data to another table when some data is inserted to any table with SP
create table product (
	pid int primary key identity(1,1),
	pname varchar(50),
	pqty numeric(20)
)
insert into product values ('apple', 5), ('mango', 10), ('grapes', 90)
create table productsell (
	psid int primary key identity(1,1),
	pid int foreign key references product(pid),
	psqty numeric(20)
)
select * from productsell
select * from product
create proc sp_product 
as
begin
	select * from product
end
alter proc sp_product
@pid int,
@pqty numeric(20)
as
begin
	update product set pqty = (select pqty from product where pid = @pid) - @pqty where pid = @pid
	insert into productsell values (@pid,@pqty)
end
exec sp_product 3,10

-- Add data to another table when some data is inserted to any table with Trigger


-- Dummy Value Generator
create table loop_tb(
id int identity,
name varchar(50),
email varchar(50)
)
declare @i int = 1
while @i<=200
begin
	if @i >= 101
	begin
		insert into loop_tb values ('shubham' + cast(@i as varchar(10)),'shubham'+cast(@i as varchar(10))+'@gmail.com')
		set @i+=1
		continue
	end
	insert into loop_tb values ('yash' + cast(@i as varchar(10)),'yash'+cast(@i as varchar(10))+'@gmail.com')
	set @i+=1
end
select * from loop_tb

-- 
declare @n int = 65, @n1 int = 97
while @n<=90 and @n1<=122
begin
	print(char(@n))
	set @n += 1
	print(char(@n1))
	set @n1 += 1
end

select * from Employee where FORMAT(employee_dob, 'MMM') = 'Oct'

select * from City
select * from Company
select * from Employee
select * from State

select e.employee_name, e.employee_dob, e.employee_salary, c.city_name, s.state_name, cm.company_name
from Employee e
join City c
on e.employee_city = c.city_id
join State s
on c.state = s.state_id
join Company cm
on cm.company_id = e.employee_company
where c.city_name in ('Ahmedabad', 'Gandhinagar') and s.state_name in ('Gujarat') and cm.company_name in ('TechMicra')

select distinct city_name
from City c
join State s
on c.state = s.state_id
where s.state_name in ('Gujarat')

select distinct state_name 
from State

select distinct company_name 
from Company cm
join Employee e
on cm.company_id = e.employee_company
join City c
on e.employee_city = c.city_id
where c.city_name in ('Ahmedabad')

select * from Sales.SalesTerritory
select CountryRegionCode, Name, sum(SalesYTD) Sales from Sales.SalesTerritory where CountryRegionCode in ('US','CA') and Name in ('Northwest','Southwest', 'Canada') group by CountryRegionCode, Name

select distinct CountryRegionCode 
from Sales.SalesTerritory

select distinct Name 
from Sales.SalesTerritory
where CountryRegionCode in ('US')