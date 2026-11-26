CREATE TABLE [dbo].[SecurityUserCompany] (
    [UserEmail]   VARCHAR (255) NOT NULL,
    [CompanyKey]  BIGINT        NOT NULL,
    [AccessLevel] VARCHAR (50)  NULL,
    [IsActive]    BIT           NULL
);


GO