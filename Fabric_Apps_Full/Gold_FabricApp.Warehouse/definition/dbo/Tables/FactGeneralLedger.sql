CREATE TABLE [dbo].[FactGeneralLedger] (
    [GLTransactionKey]   BIGINT          IDENTITY NOT NULL,
    [DateKey]            INT             NOT NULL,
    [CompanyKey]         BIGINT          NOT NULL,
    [AccountKey]         BIGINT          NOT NULL,
    [CostCenterKey]      BIGINT          NULL,
    [DepartmentKey]      BIGINT          NULL,
    [JournalNumber]      VARCHAR (50)    NULL,
    [JournalLineNumber]  INT             NULL,
    [DocumentNumber]     VARCHAR (100)   NULL,
    [DocumentType]       VARCHAR (50)    NULL,
    [TransactionDate]    DATE            NULL,
    [PostingDate]        DATE            NULL,
    [Description]        VARCHAR (500)   NULL,
    [DebitAmount]        DECIMAL (19, 4) NULL,
    [CreditAmount]       DECIMAL (19, 4) NULL,
    [BaseCurrencyAmount] DECIMAL (19, 4) NULL,
    [CurrencyCode]       VARCHAR (10)    NULL,
    [ExchangeRate]       DECIMAL (19, 8) NULL,
    [ReferenceNumber]    VARCHAR (100)   NULL,
    [SourceSystem]       VARCHAR (100)   NULL,
    [SourceRecordID]     VARCHAR (100)   NULL,
    [CreatedDate]        DATETIME2 (6)   NULL,
    [ModifiedDate]       DATETIME2 (6)   NULL
);


GO