CREATE DATABASE [Electric_Vehicle_Data_DW]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Calender_Dimension](
	[Calender_Key] [int] primary key IDENTITY(1,1) NOT NULL,
	[Date] [date] NOT NULL,
	[Year] [int] NOT NULL,
	[Quarter] [int] NOT NULL,
	[Month] [nvarchar](50) NOT NULL,
	[DayOfMonth] [int] NOT NULL,
	[DayOfWeek] [nvarchar](50) NOT NULL,
)
Go

CREATE TABLE [dbo].[Customer_Dimension](
	[Customer_Key] [int] primary key IDENTITY(1,1) NOT NULL,
	[Customer_ID] [nvarchar](50) NOT NULL,
	[Customer_Name] [nvarchar](50) NOT NULL,
	[Customer_Zip] [nvarchar](50)
)
Go

CREATE TABLE [dbo].[Store_Dimension](
	[Store_Key] [int] primary key IDENTITY(1,1) NOT NULL,
	[Store_ID] [nvarchar](50) NOT NULL,
	[Store_Zip] [nvarchar](50) NOT NULL,
	[Store_Region_Name] [nvarchar](50) NOT NULL
)
Go

CREATE TABLE [dbo].[Vehicle Dimension](
	[Vehicle_Key] [int] primary key IDENTITY(1,1) NOT NULL,
	[Vehicle_Id] [int] NOT NULL,
	[Vehicle_Model_Year] [int] NOT NULL,
	[Vehicle_Make] [nvarchar](50) NOT NULL,
	[Vehicle_Model] [nvarchar](50) NOT NULL,
	[Vehicle_Price] [money] NOT NULL,
	[Vehicle_Vendor_Name] [nvarchar](50) NOT NULL,
	[Vehicle_Category_Name] [nvarchar](50) NOT NULL
)
Go
CREATE TABLE [dbo].[Electric_Vehicle_FactTable](
	[Customer_Key] [int] NOT NULL,
	[Store_Key] [int] NOT NULL,
	[Calender_Key] [int] NOT NULL,
	[Vehicle_Key] [int] NOT NULL,
	[Sold] [money] NOT NULL,
	[Quantity] [int] NOT NULL,
	primary key([Customer_Key]),
	constraint fk_Customer_Key foreign key (Customer_Key) references [dbo].[Customer_Dimension]([Customer_Key]),
	constraint fk_Store_Key foreign key (Store_Key) references [dbo].[Store_Dimension]([Store_Key]),
	constraint fk_Calender_Key foreign key (Calender_Key) references [dbo].[Calender_Dimension]([Calender_Key]),
	constraint fk_Vehicle_Key foreign key (Vehicle_Key) references [dbo].[Vehicle Dimension]([Vehicle_Key])
)
Go