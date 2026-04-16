-- Run once on existing HimVeda databases (SSMS: select DB, execute)
IF NOT EXISTS (
    SELECT 1
    FROM sysobjects
    WHERE name = 'ContactMessages' AND xtype = 'U'
)
BEGIN
    CREATE TABLE dbo.ContactMessages (
        ContactMessageID INT IDENTITY(1,1) PRIMARY KEY,
        FullName NVARCHAR(150) NOT NULL,
        Email NVARCHAR(150) NOT NULL,
        Phone NVARCHAR(30) NOT NULL,
        Subject NVARCHAR(120) NOT NULL,
        Message NVARCHAR(MAX) NOT NULL,
        SubmittedAt DATETIME DEFAULT GETDATE()
    );
END
GO
