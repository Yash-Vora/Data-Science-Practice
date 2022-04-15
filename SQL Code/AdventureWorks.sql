-- Adventure Works

select st.Name, soh.RevisionNumber, sod.CarrierTrackingNumber, DATEPART(yyyy, soh.OrderDate) year from 
Sales.SalesTerritory st join Sales.SalesOrderHeader soh
on st.TerritoryID = soh.TerritoryID
join Sales.SalesOrderDetail sod
on soh.SalesOrderID = sod.SalesOrderID

-- Tables List:
-- Sales.SalesOrderHeader 
-- Sales.SalesTerritory 
-- Sales.SalesOrderDetail 
-- Production.ProductCostHistory 
-- Person.CountryRegion 
-- Production.Product 
-- Production.ProductSubcategory 
-- Production.ProductCategory 
-- Person.Address
-- Person.StateProvince 
-- Sales.SalesPerson 
-- HumanResources.Employee 
-- Person.Person

select top 0 * from Sales.SalesTerritory
select top 1 * from Sales.SalesOrderHeader
select top 0 * from Sales.SalesOrderDetail
select top 0 * from Production.ProductCostHistory
select top 0 * from Person.CountryRegion 
select top 0 * from Production.Product
select top 0 * from Production.ProductSubcategory
select top 0 * from Production.ProductCategory
select top 0 * from Person.Address
select top 0 * from Person.StateProvince
select top 0 * from Sales.SalesPerson
select top 0 * from HumanResources.Employee
select top 0 * from Person.Person

select top 1 * from Sales.SalesTerritory
select top 1 * from Sales.SalesOrderHeader
select top 1 * from Sales.SalesPerson
select top 1 * from Person.Person


-- Sales.SalesTerritory -- Name
-- Sales.SalesOrderHeader -- SalesOrderNumber
-- Person.Person -- FirstName
select st.Name as Territory, p.FirstName + ' ' + p.LastName as [Sales Person], soh.SalesOrderNumber as [Order Number], st.SalesLastYear as [Total Sales] from 
Sales.SalesTerritory st join Sales.SalesOrderHeader soh
on st.TerritoryID = soh.TerritoryID
join Sales.SalesPerson sp
on soh.TerritoryID = sp.TerritoryID
join Person.Person p
on sp.BusinessEntityID = p.BusinessEntityID
-- or
select st.Name as Territory, p.FirstName + ' ' + p.LastName as [Sales Person], soh.SalesOrderNumber as [Order Number], sum(st.SalesLastYear) as [Total Sales] from 
Sales.SalesTerritory st join Sales.SalesOrderHeader soh
on st.TerritoryID = soh.TerritoryID
join Sales.SalesPerson sp
on soh.TerritoryID = sp.TerritoryID
join Person.Person p
on sp.BusinessEntityID = p.BusinessEntityID
group by st.Name, p.FirstName, p.LastName, soh.SalesOrderNumber


select * into [SalesOrderDetail] from [AdventureWorks2014].[Sales].[SalesOrderDetail]

select * from SalesOrderDetail where DATEPART(yyyy, ModifiedDate) = '2011'
select * from SalesOrderDetailDest