/*
    Copyright 2014 Microsoft, Corp.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

-- Reference table that contains the same data on all shards
IF OBJECT_ID('Regions', 'U') IS NULL 
BEGIN
    CREATE TABLE [Regions] (
        [RegionId] [int] NOT NULL,
        [Name] [nvarchar](256) NOT NULL
     CONSTRAINT [PK_Regions_RegionId] PRIMARY KEY CLUSTERED (
        [RegionId] ASC
     ) 
    ) 

	INSERT INTO [Regions] ([RegionId], [Name]) VALUES (0, 'North America')
	INSERT INTO [Regions] ([RegionId], [Name]) VALUES (1, 'South America')
	INSERT INTO [Regions] ([RegionId], [Name]) VALUES (2, 'Europe')
	INSERT INTO [Regions] ([RegionId], [Name]) VALUES (3, 'Asia')
	INSERT INTO [Regions] ([RegionId], [Name]) VALUES (4, 'Africa')
	INSERT INTO [Regions] ([RegionId], [Name]) VALUES (5, 'Oceania')
END
GO

-- Reference table that contains the same data on all shards
IF OBJECT_ID('Products', 'U') IS NULL 
BEGIN
    CREATE TABLE [Products] (
        [ProductId] [int] NOT NULL,
        [Name] [nvarchar](256) NOT NULL
     CONSTRAINT [PK_Products_ProductId] PRIMARY KEY CLUSTERED (
        [ProductId] ASC
     ) 
    ) 

	INSERT INTO [Products] ([ProductId], [Name]) VALUES (0, 'Gizmos')
	INSERT INTO [Products] ([ProductId], [Name]) VALUES (1, 'Widgets')
END
GO

-- Sharded table containing our sharding key (CustomerId)
IF OBJECT_ID('Customers', 'U') IS NULL 
    CREATE TABLE [Customers] (
        [CustomerId] [int] NOT NULL, -- since we shard on this column, it cannot be an IDENTITY
        [Name] [nvarchar](256) NOT NULL,
        [RegionId] [int] NOT NULL
     CONSTRAINT [PK_Customer_CustomerId] PRIMARY KEY CLUSTERED (
        [CustomerID] ASC
     ),
     CONSTRAINT [FK_Customer_RegionId] FOREIGN KEY (
        [RegionId] 
     ) REFERENCES [Regions]([RegionId])
    ) 
GO

-- Sharded table that has a foreign key column containing our sharding key (CustomerId)
IF OBJECT_ID('Orders', 'U') IS NULL 
    CREATE TABLE [Orders](
        [CustomerId] [int] NOT NULL, -- since we shard on this column, it cannot be an IDENTITY
        [OrderId] [int] NOT NULL IDENTITY(1,1), 
        [OrderDate] [datetime] NOT NULL,
        [ProductId] [int] NOT NULL
     CONSTRAINT [PK_Orders_CustomerId_OrderId] PRIMARY KEY CLUSTERED (
        [CustomerID] ASC,
        [OrderID] ASC
     ),
     CONSTRAINT [FK_Orders_CustomerId] FOREIGN KEY (
        [CustomerId] 
     ) REFERENCES [Customers]([CustomerId]),
     CONSTRAINT [FK_Orders_ProductId] FOREIGN KEY (
        [ProductId] 
     ) REFERENCES [Products]([ProductId])
    ) 
GO
