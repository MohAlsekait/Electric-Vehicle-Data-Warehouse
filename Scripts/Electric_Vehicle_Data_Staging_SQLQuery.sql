/****** Object:  Database [Electric_Vehicle_Data_Staging]    Script Date: 04/07/2024 17:12:10 ******/
CREATE DATABASE [Electric_Vehicle_Data_Staging]
 
USE [Electric_Vehicle_Data_Staging]
GO

/****** Object:  Table [dbo].[Category]    Script Date: 04/07/2024 17:11:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Category](
	[Category_Id] [int] primary key NOT NULL,
	[Category_Name] [nvarchar](50) NOT NULL,
 )
CREATE TABLE [dbo].[Customer](
	[Customer_Id] [int] Primary Key NOT NULL,
	[Customer_Name] [nvarchar](50) NOT NULL,
	[Customer_Zip] [nvarchar](50),
)
GO

CREATE TABLE [dbo].[Region](
	[Region_Id] [int] Primary Key NOT NULL,
	[Region_Name] [nvarchar](50) NOT NULL,
)
Go
CREATE TABLE [dbo].[Vendor](
	[Vendor_Id] [int] primary key NOT NULL,
	[Vendor_Name] [nvarchar](50) NOT NULL,
)
Go
CREATE TABLE [dbo].[Store](
	[Store_Id] [int] primary key NOT NULL,
	[Store_zip] [nvarchar](50),
	[Region_Id] [int] NOT NULL,
	constraint fk_RegionId foreign key (Region_Id) references [dbo].[Region]([Region_Id])
)
Go

CREATE TABLE [dbo].[Transaction](
	[Transaction_Id] [int] primary key NOT NULL,
	[Transaction_Date] [date] NOT NULL,
	[Store_Id] [int] NOT NULL,
	[Customer_Id] [int] NOT NULL,
	constraint fk_Store_Id foreign key (Store_Id) references [dbo].[Store]([Store_Id]),
	constraint fk_Customer_Id foreign key (Customer_Id) references [dbo].[Customer]([Customer_Id])
)
Go
CREATE TABLE [dbo].[Vehicle](
	[Vehicle_Id] [int] primary key NOT NULL,
	[Vehicle_Model_Year] [int] NOT NULL,
	[Vehicle_Make] [nvarchar](50) NOT NULL,
	[Vehicle_Model] [nvarchar](50) NOT NULL,
	[Vehicle_Price] [money] NOT NULL,
	[Vendor_Id] [int] NOT NULL,
	[Category_Id] [int] NOT NULL,
	constraint fk_Vendor_Id foreign key (Vendor_Id) references [dbo].[Vendor]([Vendor_Id]),
	constraint fk_Category_Id foreign key (Category_Id) references [dbo].[Category]([Category_Id])
)
Go
CREATE TABLE [dbo].[VehicleSales](
	[Vehicle_Id] [int] NOT NULL,
	[Transaction_Id] [int] NOT NULL,
	[VehicleSales Quantity] [int] NOT NULL,
	primary key([Vehicle_Id],[Transaction_Id]),
	constraint fk_Vehicle_Id foreign key (Vehicle_Id) references [dbo].[Vehicle]([Vehicle_Id]),
	constraint fk_Transaction_Id foreign key (Transaction_Id) references [dbo].[Transaction]([Transaction_Id])
)
Go

CREATE VIEW [dbo].[Calendar_View]
AS
SELECT Transaction_Date AS Date, DATEPART(YEAR, Transaction_Date) AS Year, 
DATEPART(QUARTER, Transaction_Date) AS Quarter, DATENAME(MONTH, Transaction_Date) AS Month, 
DATEPART(DAY, Transaction_Date) AS DayOfMonth, DATENAME(WEEKDAY, Transaction_Date) AS DayOfWeek
FROM     dbo.[Transaction]
GO

CREATE VIEW [dbo].[Customer_View]
AS
SELECT Customer_Id, Customer_Name, Customer_Zip
FROM     dbo.Customer
GO

CREATE VIEW [dbo].[Store_View]
AS
SELECT dbo.Store.Store_Id, dbo.Store.Store_zip, dbo.Region.Region_Name
FROM     dbo.Store INNER JOIN
         dbo.Region ON dbo.Store.Region_Id = dbo.Region.Region_Id
GO

CREATE VIEW [dbo].[Vehicle_View]
AS
SELECT dbo.Vehicle.Vehicle_Id, dbo.Vehicle.Vehicle_Model_Year, dbo.Vehicle.Vehicle_Make, dbo.Vehicle.Vehicle_Model, 
	   dbo.Vehicle.Vehicle_Price, dbo.Vendor.Vendor_Name, dbo.Category.Category_Name
FROM     dbo.Vehicle INNER JOIN
         dbo.Vendor ON dbo.Vehicle.Vendor_Id = dbo.Vendor.Vendor_Id INNER JOIN
         dbo.Category ON dbo.Vehicle.Category_Id = dbo.Category.Category_Id
GO

CREATE VIEW [dbo].[Electric_Vehicle_FactTable_View]
AS
SELECT Electric_Vehicle_Data_DW.dbo.[Vehicle Dimension].Vehicle_Key, Electric_Vehicle_Data_DW.dbo.Calender_Dimension.Calender_Key, 
       Electric_Vehicle_Data_DW.dbo.Customer_Dimension.Customer_Key, Electric_Vehicle_Data_DW.dbo.Store_Dimension.Store_Key,
	   dbo.VehicleSales.[VehicleSales Quantity], dbo.VehicleSales.[VehicleSales Quantity] * dbo.Vehicle.Vehicle_Price AS Sold
FROM     dbo.Vehicle INNER JOIN
         dbo.VehicleSales ON dbo.Vehicle.Vehicle_Id = dbo.VehicleSales.Vehicle_Id INNER JOIN
         Electric_Vehicle_Data_DW.dbo.[Vehicle Dimension] ON dbo.VehicleSales.Vehicle_Id = Electric_Vehicle_Data_DW.dbo.[Vehicle Dimension].Vehicle_Id INNER JOIN
         dbo.[Transaction] ON dbo.VehicleSales.Transaction_Id = dbo.[Transaction].Transaction_Id INNER JOIN
         Electric_Vehicle_Data_DW.dbo.Calender_Dimension ON Electric_Vehicle_Data_DW.dbo.Calender_Dimension.Date = dbo.[Transaction].Transaction_Date INNER JOIN
         Electric_Vehicle_Data_DW.dbo.Customer_Dimension ON Electric_Vehicle_Data_DW.dbo.Customer_Dimension.Customer_ID = dbo.[Transaction].Customer_Id INNER JOIN
         Electric_Vehicle_Data_DW.dbo.Store_Dimension ON Electric_Vehicle_Data_DW.dbo.Store_Dimension.Store_ID = dbo.[Transaction].Store_Id
GO