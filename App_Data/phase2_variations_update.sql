USE HimVeda;
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('CartItems') AND name = 'VariationID')
BEGIN
    ALTER TABLE CartItems ADD VariationID INT NULL FOREIGN KEY REFERENCES ProductVariations(VariationID) ON DELETE NO ACTION;
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('OrderItems') AND name = 'VariationID')
BEGIN
    ALTER TABLE OrderItems ADD VariationID INT NULL FOREIGN KEY REFERENCES ProductVariations(VariationID) ON DELETE NO ACTION;
END
GO
