DECLARE @uid INT = (SELECT TOP 1 UserID FROM Users);
DECLARE @pid1 INT = (SELECT TOP 1 ProductID FROM Products);
DECLARE @vid1 INT = (SELECT TOP 1 VendorID FROM Products WHERE ProductID = @pid1);
DECLARE @price1 DECIMAL(10,2) = (SELECT TOP 1 Price FROM Products WHERE ProductID = @pid1);

DECLARE @pid2 INT = (SELECT TOP 1 ProductID FROM Products WHERE ProductID != @pid1);
DECLARE @vid2 INT = (SELECT TOP 1 VendorID FROM Products WHERE ProductID = @pid2);
DECLARE @price2 DECIMAL(10,2) = (SELECT TOP 1 Price FROM Products WHERE ProductID = @pid2);

-- Order 1: Pending
INSERT INTO Orders (UserID, TotalAmount, ShippingAddress, PaymentMethod, PaymentStatus) VALUES (@uid, @price1 * 2, '123 Test St, Kathmandu', 'Cash on Delivery', 'Pending');
DECLARE @oid1 INT = SCOPE_IDENTITY();
INSERT INTO OrderItems (OrderID, ProductID, VendorID, Quantity, UnitPrice, SubTotal, OrderStatus) VALUES (@oid1, @pid1, @vid1, 2, @price1, @price1 * 2, 'Pending');
INSERT INTO DeliveryTracking (OrderID, DeliveryStatus) VALUES (@oid1, 'Pending');

-- Order 2: Shipped
INSERT INTO Orders (UserID, TotalAmount, ShippingAddress, PaymentMethod, PaymentStatus) VALUES (@uid, @price2, '456 Sample Rd, Lalitpur', 'Online', 'Completed');
DECLARE @oid2 INT = SCOPE_IDENTITY();
INSERT INTO OrderItems (OrderID, ProductID, VendorID, Quantity, UnitPrice, SubTotal, OrderStatus) VALUES (@oid2, @pid2, @vid2, 1, @price2, @price2, 'Shipped');
INSERT INTO DeliveryTracking (OrderID, DeliveryStatus) VALUES (@oid2, 'Shipped');
INSERT INTO Payments (OrderID, PaymentMethod, Amount, PaymentStatus) VALUES (@oid2, 'Online', @price2, 'Completed');

-- Order 3: Delivered
INSERT INTO Orders (UserID, TotalAmount, ShippingAddress, PaymentMethod, PaymentStatus) VALUES (@uid, @price1 + @price2, '789 Demo Ave, Bhaktapur', 'Cash on Delivery', 'Completed');
DECLARE @oid3 INT = SCOPE_IDENTITY();
INSERT INTO OrderItems (OrderID, ProductID, VendorID, Quantity, UnitPrice, SubTotal, OrderStatus) VALUES (@oid3, @pid1, @vid1, 1, @price1, @price1, 'Delivered');
INSERT INTO OrderItems (OrderID, ProductID, VendorID, Quantity, UnitPrice, SubTotal, OrderStatus) VALUES (@oid3, @pid2, @vid2, 1, @price2, @price2, 'Delivered');
INSERT INTO DeliveryTracking (OrderID, DeliveryStatus) VALUES (@oid3, 'Delivered');
