CREATE TABLE [dbo].[DimCompany] (
    [CompanyKey]           BIGINT        IDENTITY NOT NULL,
    [CompanyCode]          VARCHAR (30)  NOT NULL,
    [CompanyName]          VARCHAR (200) NOT NULL,
    [LegalEntityName]      VARCHAR (250) NULL,
    [CountryCode]          VARCHAR (10)  NULL,
    [CountryName]          VARCHAR (100) NULL,
    [StateCode]            VARCHAR (20)  NULL,
    [StateName]            VARCHAR (100) NULL,
    [BaseCurrencyCode]     VARCHAR (10)  NULL,
    [FiscalYearStartMonth] INT           NULL,
    [TaxRegistrationNo]    VARCHAR (100) NULL,
    [CompanyType]          VARCHAR (50)  NULL,
    [CompanyStatus]        VARCHAR (30)  NULL,
    [EffectiveFrom]        DATE          NULL,
    [EffectiveTo]          DATE          NULL,
    [IsCurrent]            BIT           NULL,
    [CreatedDate]          DATETIME2 (6) NULL,
    [ModifiedDate]         DATETIME2 (6) NULL
);


GO