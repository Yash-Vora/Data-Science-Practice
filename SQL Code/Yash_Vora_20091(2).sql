-- Name - Yash Vora
-- Emp Id - 20091

-- 1. Create Table Students
create table emp3 (
	e_id varchar(10),
	e_name varchar(20),
	e_dob date,
	e_salary numeric(10),
	e_city varchar(30)
)

-- 2. Insert Data
insert into emp3 values ('E01','Tulsi', '1982/01/26', 12000, 'Ahmedabad'),
						('E02','Gopi', '1983/08/15', 15000, 'Anand'),
						('E03','Rajshree', '1984/10/31', 20000, 'Vadodara'),
						('E04','Vaishali', '1985/03/23', 25000, 'Surat'),
						('E05','Laxmi', '1983/02/14', 18000, 'Anand')
insert into emp3 (e_id, e_name, e_dob, e_salary) values ('E06','Shivali', '1984/09/5', 20000)

-- Show Table
select * from emp3

-- 3.
select e_dob from emp3 where e_id in ('E01','E03')

-- 4.
select * from emp3 where e_salary in (18000, 20000)

-- 5.
select * from emp3 where e_city in ('Ahmedabad', 'Surat')

-- 6.
select * from emp3 where e_city like('%d')

-- 7.
alter table emp3
add constraint chk_salary check(e_salary > 10000)

-- 8.
select * from emp3 where e_dob between '1982/01/01' and '1983/12/31'

-- 9.
select e_city, avg(e_salary) Avg_Salary from emp3 group by e_city

-- 10.
select count(*) Cnt_Of_Emp_Earn_More_Then_16000 from emp3 where e_salary > 16000