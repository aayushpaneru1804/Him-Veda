USE HimVeda;
GO

-- 1. Alter Vendors table
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Vendors') AND name = 'StoreLogo')
BEGIN
    ALTER TABLE Vendors ADD 
        StoreLogo NVARCHAR(255) NULL,
        PaymentInfo NVARCHAR(500) NULL,
        StoreDescription NVARCHAR(MAX) NULL,
        WalletBalance DECIMAL(10,2) DEFAULT 0;
END
GO

-- 2. Create ProductVariations
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='ProductVariations' and xtype='U')
BEGIN
    CREATE TABLE ProductVariations (
        VariationID INT IDENTITY(1,1) PRIMARY KEY,
        ProductID INT FOREIGN KEY REFERENCES Products(ProductID) ON DELETE CASCADE,
        Size NVARCHAR(50) NULL,
        Color NVARCHAR(50) NULL,
        AdditionalPrice DECIMAL(10,2) DEFAULT 0,
        Stock INT DEFAULT 0,
        SKU NVARCHAR(100) NULL
    );
END
GO

-- 3. Alter OrderItems table
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('OrderItems') AND name = 'OrderStatus')
BEGIN
    ALTER TABLE OrderItems ADD 
        OrderStatus NVARCHAR(50) DEFAULT 'Pending';
END
GO

-- 4. Create Withdrawals table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Withdrawals' and xtype='U')
BEGIN
    CREATE TABLE Withdrawals (
        WithdrawalID INT IDENTITY(1,1) PRIMARY KEY,
        VendorID INT FOREIGN KEY REFERENCES Vendors(VendorID) ON DELETE CASCADE,
        Amount DECIMAL(10,2) NOT NULL,
        Status NVARCHAR(50) DEFAULT 'Pending',
        RequestedAt DATETIME DEFAULT GETDATE(),
        ProcessedAt DATETIME NULL,
        AdminRemarks NVARCHAR(MAX) NULL
    );
END
GO

-- 5. Create PlatformSettings table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='PlatformSettings' and xtype='U')
BEGIN
    CREATE TABLE PlatformSettings (
        SettingID INT IDENTITY(1,1) PRIMARY KEY,
        SettingKey NVARCHAR(100) NOT NULL UNIQUE,
        SettingValue NVARCHAR(MAX) NOT NULL
    );

    INSERT INTO PlatformSettings (SettingKey, SettingValue) VALUES ('CommissionRate', '10');
END
GO

-- 6. Alter Coupons table
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Coupons') AND name = 'VendorID')
BEGIN
    ALTER TABLE Coupons ADD 
        VendorID INT NULL FOREIGN KEY REFERENCES Vendors(VendorID) ON DELETE NO ACTION;
END
GO
