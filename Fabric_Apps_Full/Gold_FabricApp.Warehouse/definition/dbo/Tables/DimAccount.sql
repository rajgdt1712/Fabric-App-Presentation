CREATE TABLE [dbo].[DimAccount] (
    [AccountKey]         BIGINT        IDENTITY NOT NULL,
    [AccountCode]        VARCHAR (50)  NOT NULL,
    [AccountName]        VARCHAR (200) NOT NULL,
    [AccountType]        VARCHAR (50)  NULL,
    [AccountCategory]    VARCHAR (100) NULL,
    [ParentAccountCode]  VARCHAR (50)  NULL,
    [AccountLevel]       INT           NULL,
    [BalanceType]        VARCHAR (20)  NULL,
    [FinancialStatement] VARCHAR (50)  NULL,
    [FinancialSection]   VARCHAR (100) NULL,
    [IsControlAccount]   BIT           NULL,
    [IsPostingAccount]   BIT           NULL,
    [IsActive]           BIT           NULL,
    [EffectiveFrom]      DATE          NULL,
    [EffectiveTo]        DATE          NULL,
    [IsCurrent]          BIT           NULL,
    [CreatedDate]        DATETIME2 (6) NULL,
    [ModifiedDate]       DATETIME2 (6) NULL
);


GO