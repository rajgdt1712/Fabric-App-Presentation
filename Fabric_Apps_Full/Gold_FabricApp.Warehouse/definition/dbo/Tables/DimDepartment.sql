CREATE TABLE [dbo].[DimDepartment] (
    [DepartmentKey]   BIGINT        IDENTITY NOT NULL,
    [DepartmentCode]  VARCHAR (50)  NOT NULL,
    [DepartmentName]  VARCHAR (200) NULL,
    [DepartmentGroup] VARCHAR (100) NULL,
    [ManagerName]     VARCHAR (200) NULL,
    [IsActive]        BIT           NULL,
    [EffectiveFrom]   DATE          NULL,
    [EffectiveTo]     DATE          NULL,
    [IsCurrent]       BIT           NULL,
    [CreatedDate]     DATETIME2 (6) NULL,
    [ModifiedDate]    DATETIME2 (6) NULL
);


GO