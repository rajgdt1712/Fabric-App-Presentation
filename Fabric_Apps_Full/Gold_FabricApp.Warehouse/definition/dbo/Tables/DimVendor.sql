CREATE TABLE [dbo].[DimVendor] (
    [VendorKey]         BIGINT        IDENTITY NOT NULL,
    [VendorCode]        VARCHAR (50)  NOT NULL,
    [VendorName]        VARCHAR (250) NOT NULL,
    [VendorType]        VARCHAR (50)  NULL,
    [Industry]          VARCHAR (100) NULL,
    [AddressLine1]      VARCHAR (250) NULL,
    [AddressLine2]      VARCHAR (250) NULL,
    [City]              VARCHAR (100) NULL,
    [State]             VARCHAR (100) NULL,
    [Country]           VARCHAR (100) NULL,
    [PostalCode]        VARCHAR (20)  NULL,
    [CurrencyCode]      VARCHAR (10)  NULL,
    [PaymentTerms]      VARCHAR (50)  NULL,
    [TaxRegistrationNo] VARCHAR (100) NULL,
    [VendorStatus]      VARCHAR (30)  NULL,
    [IsActive]          BIT           NULL,
    [EffectiveFrom]     DATE          NULL,
    [EffectiveTo]       DATE          NULL,
    [IsCurrent]         BIT           NULL,
    [CreatedDate]       DATETIME2 (6) NULL,
    [ModifiedDate]      DATETIME2 (6) NULL
);


GO