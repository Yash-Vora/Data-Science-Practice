-- DDL trigger
ALTER trigger [trMyFirstTrigger]
on database
for create_table, alter_table, drop_table, rename
as
begin
	print 'you are create, alter, rename or drop table'
end


-- DML trigger
	--insert trigger
ALTER trigger [dbo].[tr_cust_forInserted]
on [dbo].[cust]
for insert
as
begin
	declare @id int,@name varchar(20),@dob date
	select @id = id from inserted
	select @name = name from inserted
	select @dob = Dob from inserted
	insert into custAudit values('new customer with id : ' + cast(@id as nvarchar(5)) + ' ' + @name + ' and ' + 
	cast(@dob as nvarchar(30)) + ' is added as ' + cast(getdate() as nvarchar(30)))

	PRINT 'AFTER INSERT trigger fired.'
end

	--	delete trigger
ALTER trigger [dbo].[tr_cust_forDeleted]
on [dbo].[cust]
for delete
as
begin
	declare @id int,@name varchar(20)
	select @id = id from deleted
	select @name = Name from deleted
	insert into custAudit values('existing customer id : ' + cast(@id as nvarchar(5)) + ' and Name : ' + @name + ' is deleted at ' + cast(getdate() as nvarchar(30)))

	PRINT 'AFTER delete trigger fired.'
end

	--	update trigger
ALTER trigger [dbo].[tr_cust_forUpdated]
on [dbo].[cust]
for update
as
begin
	declare @id int
	declare @oldName nvarchar(50), @newName nvarchar(50)
	declare @oldDob date, @newDob date

	declare @auditString nvarchar(500)

	select * into #tempTable from inserted
	while(exists(select id from #tempTable))
	begin
		set @auditString = ''
		select top 1 @id = id, @newName = name, @newDob = dob from #tempTable
		select @oldName = name, @oldDob = dob from deleted where id = @id

		set @auditString = 'customer with id : ' + cast(@id as nvarchar(5)) + ' is changed '
		if(@oldName <> @newName)
			set @auditString = @auditString + ' name from ' + @oldName + ' to ' + @newName
		if(@oldDob <> @newDob)
			set @auditString = @auditString + ' dob from ' + cast(@oldDob as nvarchar(10)) + ' to ' + cast(@newDob as nvarchar(10))

		insert into custAudit values (@auditString)
		delete from #tempTable where id = @id

	end
	PRINT 'AFTER update trigger fired.'
end
