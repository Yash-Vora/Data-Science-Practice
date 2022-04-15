-- ***** Find SP in any Database
SELECT name DatabaseName FROM sys.databases WHERE OBJECT_ID(QUOTENAME(name) + '.dbo.VP_SP_GetTableAllData', 'P') IS NOT NULL;

-- ***** List of the Database
exec sp_helpdb

-- ***** Print SP content
exec sp_helptext nSal

-- ***** List of the SP
SELECT DISTINCT o.name, o.xtype
FROM syscomments c
INNER JOIN sysobjects o ON c.id=o.id
WHERE o.xtype='P'

-- ***** Size of Tables
SELECT sob.name AS Table_Name, SUM(sys.length) AS [Size_Table(Bytes)]
FROM sysobjects sob, syscolumns sys
WHERE sob.xtype='u' AND sys.id=sob.id
GROUP BY sob.name

-- ***** List of tables with number of records
CREATE TABLE #Tab
(
	Table_Name [varchar](max),
	Total_Records int
)
EXEC sp_MSForEachTable @command1=' Insert Into #Tab(Table_Name, Total_Records) SELECT ''?'', COUNT(*) FROM ?'
SELECT * FROM #Tab t ORDER BY t.Total_Records DESC
DROP TABLE #Tab

-- ***** Disable All Trigger of a table
ALTER TABLE Table_Name DISABLE TRIGGER ALL

-- ***** Enable All Trigger of a table
ALTER TABLE Table_Name ENABLE TRIGGER ALL


-- ***** Disable All Trigger of a db
disable trigger all on database

-- ***** Enable All Trigger of a db
enable trigger all on database


IF EXISTS (SELECT * FROM sys.tables WHERE name = 'StaffHours')
	DROP TABLE StaffHours
else
	print 'not'

-- ***** grant
GRANT ALL ON emp TO hello -- (SELECT/INSERT/UPDATE/DELETE)

-- ***** revoke
REVOKE ALL ON emp FROM hello -- (SELECT/INSERT/UPDATE/DELETE)

-- ***** nth highest salary
select e_name,e_email,e_gender,e_salary,e_age,e_city from 
(Select Dense_Rank()over(order by e_salary desc) as Rnk, E.* from emp E) as a 
where Rnk = 2

-- ***** Display first 50% records from table
select * from emp1
where e_id <= (select count(*)/2 from emp1)

or

select top 50 percent * from sample.dbo.emp


-- ***** Display last 50% records from table
select * from emp1
except
select * from emp1
where e_id <= (select count(*)/2 from emp1)

-- ***** Display Odd/Even Records
select * from emp where e_id % 2 = 0

-- ***** increase the speed of a stored procedure
-- SET NOCOUNT ON at the beginning of a stored procedure

-- ***** find any null value in any column
exec sp_FindNull 'dbo.FinanceDimGroup2'

-- ***** nTH highest salary of Employees using Self join
select * from emp a where 2 in (select count (distinct e_salary) from emp b where a.e_salary <= b.e_salary)

-- ***** get the total row count of a table without usging count() function.
SELECT ROWS FROM SYSINDEXES
WHERE ID = OBJECT_ID('tmpProduct') AND INDID < 2
	--or
exec sp_spaceused 'tmpProduct'

-- ***** insert into a table with just one IDENTITY column
select * from abc
insert into abc default values

-- ***** get the database size
select name,size from sys.master_files order by size desc
	--or
exec sp_spaceused

SELECT 
database_name = DB_NAME(database_id)
, log_size_mb = CAST(SUM(CASE WHEN type_desc = 'LOG' THEN size END) * 8. / 1024 AS DECIMAL(8,2))
, row_size_mb = CAST(SUM(CASE WHEN type_desc = 'ROWS' THEN size END) * 8. / 1024 AS DECIMAL(8,2))
, total_size_mb = CAST(SUM(size) * 8. / 1024 AS DECIMAL(8,2))
FROM sys.master_files WITH(NOWAIT)
--WHERE database_id = DB_ID() -- for current db 
GROUP BY database_id
order by database_name


-- ***** get FileType,FileName,PhysicalFileName,Space
declare @Drive table(DriveName char, FreeSpaceInMegabytes int)
insert @Drive execute xp_fixeddrives
select 
mas.type_desc FileType, 
mas.name FileName, 
mas.physical_name PhysicalFileName, 
mas.size * 8 / 1024 FileSizeInMegabytes,
drv.DriveName, 
drv.FreeSpaceInMegabytes
from sys.master_files mas
left join @Drive drv on
left(mas.physical_name, 1) = drv.DriveName


-- ***** find the child table
EXEC sp_fkeys 'TableName'

-- ***** uniqueidentifier and its default value
CREATE TABLE [dbo].[demo1]
(
	[id] [uniqueidentifier] primary key DEFAULT (newid()),
	[name] [nvarchar](50) NULL
)


-- ***** dependecy find
SELECT * FROM sys.sql_expression_dependencies  
WHERE referencing_id = OBJECT_ID(N'FactTraTicketItems')

SELECT * FROM sys.sql_expression_dependencies  
WHERE referenced_id = OBJECT_ID(N'FactTraTicketItems')


-- ***** how to table type variable
Create Table Cars
(
    Id int primary key,
    Name nvarchar(50),
    company nvarchar(50)
)

CREATE TYPE CarTableType AS TABLE
(
    Id int primary key,
    Name nvarchar(50),
    company nvarchar(50)
)

CREATE PROCEDURE spInsertCars
@CarType CarTableType READONLY
AS
BEGIN
    INSERT INTO Cars
    SELECT * FROM @CarType
END

DECLARE @CarTableType CarTableType
INSERT INTO @CarTableType VALUES (1, 'Corrolla', 'Toyota')
INSERT INTO @CarTableType VALUES (2, 'Civic', 'Honda')
INSERT INTO @CarTableType VALUES (3, '6', 'Audi')
INSERT INTO @CarTableType VALUES (4, 'c100', 'Mercedez')
INSERT INTO @CarTableType VALUES (5, 'Mustang', 'Ford')

EXECUTE spInsertCars @CarTableType




select * from customer



;WITH CTE(EmpName , EmpId, Level,FullHierarchyName) AS (
     Select E.EmpName, E.EmpID, 0 Level
     ,Cast(E.EmpName+'.' as Varchar(MAX)) FullHierarchyName         
     From customer E Where E.ManagerID IS NULL
     UNION ALL
     Select E.EmpName, E.EmpID, c.Level + 1 , c.FullHierarchyName+'.'+E.EmpName+'.' FullHierarchyName  
     From customer E INNER JOIN CTE c on c.EmpID = e.ManagerID 
)
SELECT H.EmpName ,CAST(H.EmpID AS VARCHAR(2)) Hierarchy , FullHierarchyName FROM CTE H 
ORDER BY H.FullHierarchyName



-- ***** TableName,ColumnName,IndexName with total records and space
SELECT 
    t.name AS TableName,
	col.name ColumnName,
    i.name as IndexName,
    sum(p.rows) as RowCounts,
    sum(a.total_pages) as TotalPages, 
    sum(a.used_pages) as UsedPages, 
    sum(a.data_pages) as DataPages,
    (sum(a.total_pages) * 8) / 1024 as TotalSpaceMB, 
    (sum(a.used_pages) * 8) / 1024 as UsedSpaceMB, 
    (sum(a.data_pages) * 8) / 1024 as DataSpaceMB
FROM sys.tables t
INNER JOIN sys.indexes i ON t.object_id = i.object_id
INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id and i.index_id = ic.index_id
INNER JOIN sys.columns col ON ic.object_id = col.object_id and ic.column_id = col.column_id
INNER JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
WHERE 
    t.name NOT LIKE 'dt%' AND
    i.object_id > 255 AND  
    i.index_id <= 1
GROUP BY t.name, i.object_id, i.index_id, i.name,col.name
ORDER BY TableName,ColumnName 



-- check del performance
select rows from sys.partitions where index_id = 1 and object_id = OBJECT_ID('VP_History')


-- display procedure column_name and datatype
SELECT name, system_type_name
FROM sys.dm_exec_describe_first_result_set_for_object
(
  OBJECT_ID('bi.ActivtiesCompDataSheet'), 
  NULL
);


-- top level parent
;WITH cte AS(
      SELECT *, id AS topparent 
      FROM t 
      WHERE parentid = 0
  UNION ALL
      SELECT t.*, c.topparent 
      FROM t JOIN cte c ON c.id = t.parentid
      WHERE t.id <> t.parentid
)
SELECT * FROM cte


-- sql load analysis
SELECT      r.start_time [Start Time],session_ID [SPID],
            DB_NAME(database_id) [Database],
            SUBSTRING(t.text,(r.statement_start_offset/2)+1,
            CASE WHEN statement_end_offset=-1 OR statement_end_offset=0
            THEN (DATALENGTH(t.Text)-r.statement_start_offset/2)+1
            ELSE (r.statement_end_offset-r.statement_start_offset)/2+1
            END) [Executing SQL],
            Status,command,wait_type,wait_time,wait_resource,
            last_wait_type
FROM        sys.dm_exec_requests r
OUTER APPLY sys.dm_exec_sql_text(sql_handle) t
WHERE       session_id != @@SPID -- don't show this query
AND         session_id > 50
