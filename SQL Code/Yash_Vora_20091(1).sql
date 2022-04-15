-- Name - Yash Vora
-- Emp Id - 20091

-- 1. Create Table Students
create table students (
	s_id int primary key identity(1,1),
	s_name varchar(20),
	s_subject varchar(20),
	s_mark numeric(3)
)

-- 2. Insert Data
insert into students values ('Yash', 'English', 80),
							('Yash', 'Maths', 90),
							('Yash', 'Science', 75),
							('Ram', 'English', 85),
							('Ram', 'Maths', 89),
							('Ram', 'Science', 90),
							('Shubham', 'English', 85),
							('Shubham', 'Maths', 90),
							('Shubham', 'Science', 65),
							('Ankit', 'Science', 70)

-- Show Table
select * from students

-- 3.
select * from students where s_mark between 50 and 90 and s_subject = 'Science'

-- 4.
select *, iif(s_mark > 90, 'A', 'F') s_grade from students
-- or
select *, case when then end from students

-- 5.
declare @subject varchar(20) = 'English', @total numeric(3) = 90
print(@subject + ' total marks is ' + cast(@total as varchar(3)))