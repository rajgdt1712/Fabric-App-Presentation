CREATE TABLE [dbo].[FactAccountsPayable] (
    [APTransactionKey]  BIGINT          IDENTITY NOT NULL,
    [DateKey]           INT             NOT NULL,
    [CompanyKey]        BIGINT          NOT NULL,
    [VendorKey]         BIGINT          NOT NULL,
    [AccountKey]        BIGINT          NULL,
    [InvoiceNumber]     VARCHAR (100)   NULL,
    [DocumentNumber]    VARCHAR (100)   NULL,
    [DocumentType]      VARCHAR (50)    NULL,
    [InvoiceDate]       DATE            NULL,
    [DueDate]           DATE            NULL,
    [PaymentDate]       DATE            NULL,
    [InvoiceAmount]     DECIMAL (19, 4) NULL,
    [TaxAmount]         DECIMAL (19, 4) NULL,
    [PaidAmount]        DECIMAL (19, 4) NULL,
    [OutstandingAmount] DECIMAL (19, 4) NULL,
    [CurrencyCode]      VARCHAR (10)    NULL,
    [ExchangeRate]      DECIMAL (19, 8) NULL,
    [AgingDays]         INT             NULL,
    [AgingBucket]       VARCHAR (50)    NULL,
    [Status]            VARCHAR (30)    NULL,
    [SourceSystem]      VARCHAR (100)   NULL,
    [SourceRecordID]    VARCHAR (100)   NULL,
    [CreatedDate]       DATETIME2 (6)   NULL,
    [ModifiedDate]      DATETIME2 (6)   NULL,
    [BillID]            VARCHAR (100)   NULL,
    [BillDate]          DATE            NULL,
    [Amount]            DECIMAL (19, 4) NULL
);


GO