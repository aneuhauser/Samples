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
END
GO

-- Sharded table containing our sharding key (TenantId)
IF OBJECT_ID('Tenants', 'U') IS NULL 
    CREATE TABLE [Tenants] (
        [TenantId] [int] NOT NULL, -- since we shard on this column, it cannot be an IDENTITY
        [Name] [nvarchar](256) NOT NULL,
        [RegionId] [int] NOT NULL
     CONSTRAINT [PK_Tenant_TenantId] PRIMARY KEY CLUSTERED (
        [TenantID] ASC
     ),
     CONSTRAINT [FK_Tenant_RegionId] FOREIGN KEY (
        [RegionId] 
     ) REFERENCES [Regions]([RegionId])
    ) 
GO

-- Sharded table that has a foreign key column containing our sharding key (TenantId)
IF OBJECT_ID('Things', 'U') IS NULL 
    CREATE TABLE [Things](
        [TenantId] [int] NOT NULL, -- since we shard on this column, it cannot be an IDENTITY
        [ThingId] [int] NOT NULL IDENTITY(1,1), 
        [Name] [nvarchar](60) NOT NULL,
		[Description] [nvarchar](256) NULL,
     CONSTRAINT [PK_Things_TenantId_ThingId] PRIMARY KEY CLUSTERED (
        [TenantID] ASC,
        [ThingID] ASC
     ),
     CONSTRAINT [FK_Things_TenantId] FOREIGN KEY (
        [TenantId] 
     ) REFERENCES [Tenants]([TenantId])
    ) 
GO