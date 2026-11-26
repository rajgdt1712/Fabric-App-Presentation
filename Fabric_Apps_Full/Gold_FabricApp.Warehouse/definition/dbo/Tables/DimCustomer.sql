CREATE TABLE [dbo].[DimCustomer] (
    [CustomerKey]       BIGINT          IDENTITY NOT NULL,
    [CustomerCode]      VARCHAR (50)    NOT NULL,
    [CustomerName]      VARCHAR (250)   NOT NULL,
    [CustomerType]      VARCHAR (50)    NULL,
    [Industry]          VARCHAR (100)   NULL,
    [AddressLine1]      VARCHAR (250)   NULL,
    [AddressLine2]      VARCHAR (250)   NULL,
    [City]              VARCHAR (100)   NULL,
    [State]             VARCHAR (100)   NULL,
    [Country]           VARCHAR (100)   NULL,
    [PostalCode]        VARCHAR (20)    NULL,
    [CurrencyCode]      VARCHAR (10)    NULL,
    [PaymentTerms]      VARCHAR (50)    NULL,
    [CreditLimit]       DECIMAL (19, 4) NULL,
    [TaxRegistrationNo] VARCHAR (100)   NULL,
    [CustomerStatus]    VARCHAR (30)    NULL,
    [IsActive]          BIT             NULL,
    [EffectiveFrom]     DATE            NULL,
    [EffectiveTo]       DATE            NULL,
    [IsCurrent]         BIT             NULL,
    [CreatedDate]       DATETIME2 (6)   NULL,
    [ModifiedDate]      DATETIME2 (6)   NULL
);


GO