CREATE TABLE [dbo].[DimCostCenter] (
    [CostCenterKey]   BIGINT        IDENTITY NOT NULL,
    [CostCenterCode]  VARCHAR (50)  NOT NULL,
    [CostCenterName]  VARCHAR (200) NULL,
    [CostCenterGroup] VARCHAR (100) NULL,
    [ManagerName]     VARCHAR (200) NULL,
    [LocationCode]    VARCHAR (50)  NULL,
    [LocationName]    VARCHAR (150) NULL,
    [IsActive]        BIT           NULL,
    [EffectiveFrom]   DATE          NULL,
    [EffectiveTo]     DATE          NULL,
    [IsCurrent]       BIT           NULL,
    [CreatedDate]     DATETIME2 (6) NULL,
    [ModifiedDate]    DATETIME2 (6) NULL
);


GO