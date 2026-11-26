CREATE TABLE [dbo].[DimDate] (
    [DateKey]             INT          NOT NULL,
    [FullDate]            DATE         NOT NULL,
    [DayNumber]           INT          NULL,
    [DayName]             VARCHAR (20) NULL,
    [WeekNumber]          INT          NULL,
    [WeekName]            VARCHAR (20) NULL,
    [MonthNumber]         INT          NULL,
    [MonthName]           VARCHAR (20) NULL,
    [MonthShortName]      VARCHAR (10) NULL,
    [QuarterNumber]       INT          NULL,
    [QuarterName]         VARCHAR (10) NULL,
    [CalendarYear]        INT          NULL,
    [FinancialYear]       VARCHAR (20) NULL,
    [FinancialYearNumber] INT          NULL,
    [FinancialQuarter]    VARCHAR (10) NULL,
    [FinancialQuarterNo]  INT          NULL,
    [FinancialMonth]      INT          NULL,
    [IsMonthStart]        BIT          NULL,
    [IsMonthEnd]          BIT          NULL,
    [IsQuarterStart]      BIT          NULL,
    [IsQuarterEnd]        BIT          NULL,
    [IsYearStart]         BIT          NULL,
    [IsYearEnd]           BIT          NULL,
    [IsWorkingDay]        BIT          NULL,
    [IsHoliday]           BIT          NULL
);


GO