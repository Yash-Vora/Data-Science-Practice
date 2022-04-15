select * into [dbo].[SalesOrderDetail] from [AdventureWorks2014].[Sales].[SalesOrderDetail]

declare @MaxID int
set @MaxID = (select max(SalesOrderDetailID) from [dbo].[SalesOrderDetail])
SET IDENTITY_INSERT [dbo].[SalesOrderDetail] ON
insert into [dbo].[SalesOrderDetail]
(SalesOrderDetailID, SalesOrderID, CarrierTrackingNumber, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount,
LineTotal, rowguid, ModifiedDate)
select ROW_NUMBER() over(order by SalesOrderDetailID) + @MaxID as SalesOrderDetailID, SalesOrderDetailID, CarrierTrackingNumber, OrderQty, ProductID, 
SpecialOfferID, UnitPrice, UnitPriceDiscount, LineTotal, rowguid, DATEADD(YEAR, 10, ModifiedDate) ModifiedDate
from [dbo].[SalesOrderDetail]
where YEAR(ModifiedDate) = 2011
SET IDENTITY_INSERT [dbo].[SalesOrderDetail] OFF

select * from [dbo].[SalesOrderDetail] where YEAR(ModifiedDate) = 2021
select * from [dbo].[SalesOrderDetailDest] where YEAR(ModifiedDate) = 2021
select * from emp