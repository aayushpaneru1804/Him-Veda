-- Create Database if not exists (Note: You can run this in SSMS directly)
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'HimVeda')
BEGIN
    CREATE DATABASE HimVeda;
END
GO

USE HimVeda;
GO

-- 1. Users Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Users' and xtype='U')
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(150) NOT NULL,
    Email NVARCHAR(150) NOT NULL UNIQUE,
    Phone NVARCHAR(20) NOT NULL,
    Password NVARCHAR(255) NOT NULL,
    Address NVARCHAR(250),
    City NVARCHAR(100),
    PostalCode NVARCHAR(20),
    CreatedAt DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(20) DEFAULT 'Active'
);

-- 2. Vendors Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Vendors' and xtype='U')
CREATE TABLE Vendors (
    VendorID INT IDENTITY(1,1) PRIMARY KEY,
    VendorName NVARCHAR(150) NOT NULL,
    BusinessName NVARCHAR(150) NOT NULL,
    Email NVARCHAR(150) NOT NULL UNIQUE,
    Phone NVARCHAR(20) NOT NULL,
    Password NVARCHAR(255) NOT NULL,
    BusinessAddress NVARCHAR(250),
    JoinedAt DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(20) DEFAULT 'Pending'
);

-- 3. Admins Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Admins' and xtype='U')
CREATE TABLE Admins (
    AdminID INT IDENTITY(1,1) PRIMARY KEY,
    AdminName NVARCHAR(150) NOT NULL,
    Email NVARCHAR(150) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL,
    Role NVARCHAR(50) DEFAULT 'Main',
    Status NVARCHAR(20) DEFAULT 'Active'
);

-- Default Admin Account
IF NOT EXISTS (SELECT * FROM Admins WHERE Email = 'admin@himveda.com')
INSERT INTO Admins (AdminName, Email, Password, Role, Status)
VALUES ('Super Admin', 'admin@himveda.com', 'admin123', 'Main', 'Active'); -- Remember to hash passwords during implementation!

-- 4. Categories Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Categories' and xtype='U')
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    CategoryImage NVARCHAR(255) NULL,
    IsActive BIT DEFAULT 1
);

-- 5. Products Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Products' and xtype='U')
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    VendorID INT FOREIGN KEY REFERENCES Vendors(VendorID) ON DELETE CASCADE,
    CategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID) ON DELETE CASCADE,
    ProductName NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    StockQty INT DEFAULT 0,
    MainImage NVARCHAR(255),
    IsFeatured BIT DEFAULT 0,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- 6. Product Images Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='ProductImages' and xtype='U')
CREATE TABLE ProductImages (
    ProductImageID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID) ON DELETE CASCADE,
    ImageUrl NVARCHAR(255) NOT NULL,
    SortOrder INT DEFAULT 0
);

-- 7. Cart Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Cart' and xtype='U')
CREATE TABLE Cart (
    CartID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT FOREIGN KEY REFERENCES Users(UserID) ON DELETE CASCADE,
    CreatedAt DATETIME DEFAULT GETDATE(),
    CartStatus NVARCHAR(20) DEFAULT 'Active'
);

-- 8. Cart Items Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='CartItems' and xtype='U')
CREATE TABLE CartItems (
    CartItemID INT IDENTITY(1,1) PRIMARY KEY,
    CartID INT FOREIGN KEY REFERENCES Cart(CartID) ON DELETE CASCADE,
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID) ON DELETE CASCADE,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    SubTotal DECIMAL(10,2) NOT NULL,
    VariationID INT NULL
);

-- 9. Wishlist Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Wishlist' and xtype='U')
CREATE TABLE Wishlist (
    WishlistID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT FOREIGN KEY REFERENCES Users(UserID) ON DELETE CASCADE,
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- 10. Wishlist Items Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='WishlistItems' and xtype='U')
CREATE TABLE WishlistItems (
    WishlistItemID INT IDENTITY(1,1) PRIMARY KEY,
    WishlistID INT FOREIGN KEY REFERENCES Wishlist(WishlistID) ON DELETE CASCADE,
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID) ON DELETE CASCADE,
    AddedAt DATETIME DEFAULT GETDATE()
);

-- 11. Coupons Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Coupons' and xtype='U')
CREATE TABLE Coupons (
    CouponID INT IDENTITY(1,1) PRIMARY KEY,
    Code NVARCHAR(50) NOT NULL UNIQUE,
    DiscountType NVARCHAR(20) NOT NULL, -- 'Percentage' or 'Fixed'
    DiscountValue DECIMAL(10,2) NOT NULL,
    MinOrderAmount DECIMAL(10,2) DEFAULT 0,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NOT NULL,
    IsActive BIT DEFAULT 1
);

-- 12. Orders Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Orders' and xtype='U')
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT FOREIGN KEY REFERENCES Users(UserID) ON DELETE NO ACTION,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2) NOT NULL,
    ShippingAddress NVARCHAR(MAX) NOT NULL,
    CouponID INT NULL FOREIGN KEY REFERENCES Coupons(CouponID) ON DELETE NO ACTION,
    DiscountAmount DECIMAL(10,2) DEFAULT 0,
    PaymentMethod NVARCHAR(50) NOT NULL,
    PaymentStatus NVARCHAR(50) DEFAULT 'Pending',
    OrderStatus NVARCHAR(50) DEFAULT 'Pending'
);

-- 13. Order Items Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='OrderItems' and xtype='U')
CREATE TABLE OrderItems (
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID) ON DELETE CASCADE,
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID) ON DELETE NO ACTION,
    VendorID INT FOREIGN KEY REFERENCES Vendors(VendorID) ON DELETE NO ACTION,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    SubTotal DECIMAL(10,2) NOT NULL,
    VariationID INT NULL
);

-- 14. Payments Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Payments' and xtype='U')
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID) ON DELETE CASCADE,
    PaymentMethod NVARCHAR(50) NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentDate DATETIME DEFAULT GETDATE(),
    TransactionRef NVARCHAR(100),
    PaymentStatus NVARCHAR(50) DEFAULT 'Pending'
);

-- 15. Delivery Tracking Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='DeliveryTracking' and xtype='U')
CREATE TABLE DeliveryTracking (
    TrackingID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID) ON DELETE CASCADE,
    DeliveryStatus NVARCHAR(50) DEFAULT 'Pending',
    UpdatedAt DATETIME DEFAULT GETDATE(),
    Remarks NVARCHAR(MAX)
);

-- 16. Feedback Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Feedback' and xtype='U')
CREATE TABLE Feedback (
    FeedbackID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT FOREIGN KEY REFERENCES Users(UserID) ON DELETE NO ACTION,
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID) ON DELETE CASCADE,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID) ON DELETE NO ACTION,
    Rating INT NOT NULL CHECK (Rating >= 1 AND Rating <= 5),
    Comment NVARCHAR(MAX),
    FeedbackDate DATETIME DEFAULT GETDATE()
);
GO

-- --- Phase 2 Additions ---

-- Alter Vendors table
-- (Already added: StoreLogo, PaymentInfo, StoreDescription, WalletBalance)

-- 17. Product Variations
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='ProductVariations' and xtype='U')
CREATE TABLE ProductVariations (
    VariationID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID) ON DELETE CASCADE,
    Size NVARCHAR(50) NULL,
    Color NVARCHAR(50) NULL,
    AdditionalPrice DECIMAL(10,2) DEFAULT 0,
    Stock INT DEFAULT 0,
    SKU NVARCHAR(100) NULL
);
GO

-- 18. Withdrawals Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Withdrawals' and xtype='U')
CREATE TABLE Withdrawals (
    WithdrawalID INT IDENTITY(1,1) PRIMARY KEY,
    VendorID INT FOREIGN KEY REFERENCES Vendors(VendorID) ON DELETE CASCADE,
    Amount DECIMAL(10,2) NOT NULL,
    Status NVARCHAR(50) DEFAULT 'Pending',
    RequestedAt DATETIME DEFAULT GETDATE(),
    ProcessedAt DATETIME NULL,
    AdminRemarks NVARCHAR(MAX) NULL
);
GO

-- 19. Platform Settings Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='PlatformSettings' and xtype='U')
CREATE TABLE PlatformSettings (
    SettingID INT IDENTITY(1,1) PRIMARY KEY,
    SettingKey NVARCHAR(100) NOT NULL UNIQUE,
    SettingValue NVARCHAR(MAX) NOT NULL
);
GO

-- 20. Contact Messages Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='ContactMessages' and xtype='U')
CREATE TABLE ContactMessages (
    ContactMessageID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(150) NOT NULL,
    Email NVARCHAR(150) NOT NULL,
    Phone NVARCHAR(30) NOT NULL,
    Subject NVARCHAR(120) NOT NULL,
    Message NVARCHAR(MAX) NOT NULL,
    SubmittedAt DATETIME DEFAULT GETDATE()
);
GO
