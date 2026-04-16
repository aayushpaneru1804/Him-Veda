-- Run once on existing HimVeda databases (SSMS: select DB, execute)
IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID(N'dbo.Categories') AND name = N'CategoryImage'
)
BEGIN
    ALTER TABLE dbo.Categories ADD CategoryImage NVARCHAR(255) NULL;
END
GO
