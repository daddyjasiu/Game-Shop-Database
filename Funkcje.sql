IF OBJECT_ID('ProductSequence', 'SO') IS NOT NULL 
DROP SEQUENCE ProductSequence
GO

CREATE SEQUENCE ProductSequence 
    START WITH 1  
    INCREMENT BY 1
GO

IF OBJECT_ID('EmployeeSequence', 'SO') IS NOT NULL 
DROP SEQUENCE EmployeeSequence
GO

CREATE SEQUENCE EmployeeSequence 
    START WITH 1  
    INCREMENT BY 1
GO

IF OBJECT_ID('CustomerSequence', 'SO') IS NOT NULL 
DROP SEQUENCE CustomerSequence
GO

CREATE SEQUENCE CustomerSequence 
    START WITH 1  
    INCREMENT BY 1
GO
------------------------------------------------------------------------------------------------Funkcje
IF OBJECT_ID ('MostExpensiveInCategory','TF') IS NOT NULL 
DROP FUNCTION MostExpensiveInCategory
GO

CREATE FUNCTION MostExpensiveInCategory (@Category NVARCHAR(30))
RETURNS @Output TABLE (Name NVARCHAR(30),Price MONEY)
AS
BEGIN 
		INSERT INTO @Output
		SELECT TOP 1 A.ProductId, UnitPrice FROM Products A,ProductsPrices B,ProductCategory C
		WHERE A.ProductId=B.ProductId AND A.CategoryId=C.CategoryId AND C.Category LIKE @Category 
		ORDER BY UnitPrice DESC
		RETURN
END
GO

IF OBJECT_ID ('EmployeeSince','TF') IS NOT NULL
DROP FUNCTION EmployeeSince
GO

CREATE FUNCTION EmployeeSince (@StartDate DATETIME)
RETURNS @Output TABLE (Name NVARCHAR(30), HireDate DATETIME)
AS
BEGIN
		INSERT INTO @Output
		SELECT Name, HireDate FROM Employees A,EmployeesContacts B
		WHERE A.EmployeeId=B.EmployeeId AND A.HireDate>=@StartDate
		ORDER BY HireDate DESC
		RETURN
END
GO

IF OBJECT_ID ('WarehouseItems','TF') IS NOT NULL
DROP FUNCTION WarehouseItems
GO

CREATE FUNCTION WarehouseItems (@Item NVARCHAR(30))
RETURNS @Output TABLE (WarehouseName NVARCHAR(30), Quantity INT)
AS
BEGIN
		INSERT INTO @Output
		SELECT A.Name, Quantity FROM Warehouses A, ItemsInWarehouse B,Items C
		WHERE A.WarehouseId=B.WarehouseId AND B.ItemId=C.ItemId AND C.Name=@Item 
		ORDER BY Quantity DESC
		RETURN
END
GO

IF OBJECT_ID ('EmployeeOnPosition','FN') IS NOT NULL
DROP FUNCTION EmployeeOnPosition
GO

CREATE FUNCTION EmployeeOnPosition (@Position NVARCHAR(30))
RETURNS  INT
AS
BEGIN
		RETURN(SELECT COUNT(EmployeeId) FROM Employees A,Positions B
		WHERE A.PositionId=B.PositionId AND B.Name=@Position)
END
GO

IF OBJECT_ID ('DateIncome','FN') IS NOT NULL
DROP FUNCTION DateIncome
GO

CREATE FUNCTION DateIncome (@Date DATE)
RETURNS MONEY
AS
BEGIN
		RETURN(SELECT SUM(A.Quantity*A.UnitPrice)  FROM OrderDetails A, Orders B
		WHERE A.OrderId=B.OrderId AND B.PurchaseDate=@Date)
END
GO

-----------------------------------------------------------------------Widoki
IF OBJECT_ID ('EmployeeNumber','v') IS NOT NULL
DROP VIEW EmployeeNumber
GO

CREATE VIEW EmployeeNumber
AS
		SELECT COUNT(EmployeeId) Number FROM Employees
GO

IF OBJECT_ID ('CustomerNumber','v') IS NOT NULL
DROP VIEW CustomerNumber
GO

CREATE VIEW CustomerNumber
AS
		SELECT COUNT(Login) Number FROM Customers
GO

IF OBJECT_ID ('TOP5Category','v') IS NOT NULL
DROP VIEW TOP5Category
GO

CREATE VIEW TOP5Category
AS
		SELECT TOP 5 D.Category FROM 
		(SELECT SUM(B.Quantity*B.UnitPrice) Amount, A.Category  FROM ProductCategory A,OrderDetails B, Products C
		WHERE A.CategoryId=C.CategoryId AND B.ProductId=C.ProductId
		GROUP BY A.Category) D
		ORDER BY D.Amount
GO

---------------------------------------------------------------------------------------------Procedury
IF OBJECT_ID('AddItem','p') IS NOT NULL
DROP PROCEDURE Additem
GO

CREATE PROCEDURE AddItem (@Name NVARCHAR(30), @Category NVARCHAR(30), @Description TEXT, @Tag NVARCHAR(30),@PublisherName NVARCHAR(30),
							@StartDate DATETIME = NULL, @UnitPrice MONEY)
AS
				IF ((SELECT TOP 1 A.Name FROM Items A WHERE @Name LIKE A.Name) IS NULL
				AND (SELECT TOP 1 A.Category FROM ProductCategory A WHERE @Category LIKE A.Category)IS NOT NULL
				AND (SELECT TOP 1 A.TagName FROM PEGIRating A WHERE A.TagName LIKE @Tag) IS NOT NULL)
				BEGIN
						DECLARE @CategoryId INT
						DECLARE @ItemId INT
						DECLARE @TagId INT
						DECLARE @PublisherId INT
						SET @ItemId = NEXT VALUE FOR ProductSequence
						SET @CategoryId = (SELECT TOP 1 A.CategoryId FROM ProductCategory A WHERE A.Category LIKE @Category)
						SET @TagId = (SELECT TOP 1 A.TagId FROM PEGIRating A WHERE A.TagName LIKE @Tag)
						SET @PublisherId = (SELECT TOP 1 A.PublisherId FROM Publishers A WHERE A.PublisherName LIKE @PublisherName)
						INSERT INTO Products
						VALUES (@ItemId, @Description, @CategoryId, @PublisherId)
						INSERT INTO Items 
						VALUES (@ItemId, @Name, @CategoryId, @TagId)
						INSERT INTO ProductsPrices
						VALUES (@ItemId, @StartDate, @UnitPrice)
						
				END
		
GO

IF OBJECT_ID('AddEmployee','p') IS NOT NULL
DROP PROCEDURE AddEmployee
GO

CREATE PROCEDURE AddEmployee (@Name NVARCHAR(30), @Surname NVARCHAR(30), @Email NVARCHAR(30), @Position NVARCHAR(30),
								@Telephone NVARCHAR(30), @HireDate DATETIME = NULL, @BossId INT = NULL)
AS
				IF (SELECT TOP 1 A.Name FROM Positions A WHERE A.Name LIKE @Position) IS NOT NULL
				BEGIN
						DECLARE @PositionId INT
						DECLARE @EmployeeId INT
						SET @PositionId = (SELECT TOP 1 A.PositionId FROM Positions A WHERE A.Name LIKE @Position)
						SET @EmployeeId = NEXT VALUE FOR EmployeeSequence
						INSERT INTO Employees
						VALUES (@EmployeeId,@HireDate, @PositionId, @BossId)
						INSERT INTO EmployeeContacts
						VALUES (@EmployeeId,@Name, @Surname, @Email, @Telephone)
				END
		
GO

IF OBJECT_ID('AddCustomer','p') IS NOT NULL
DROP PROCEDURE AddCustomer
GO

CREATE PROCEDURE AddCustomer (@Password NVARCHAR(30), @Name NVARCHAR(30), @Surname NVARCHAR(30), @Email NVARCHAR(30), @Telephone NVARCHAR(30))
AS
				BEGIN
						DECLARE @CustomerId INT
						SET @CustomerId = NEXT VALUE FOR CustomerSequence
						INSERT INTO Customers
						VALUES (@CustomerId, @Password)
						INSERT INTO CustomerContacts
						VALUES (@CustomerId, @Name, @Surname, @Email, @Telephone)
				END
		
GO

IF OBJECT_ID('AddService','p') IS NOT NULL
DROP PROCEDURE AddService
GO

CREATE PROCEDURE AddService (@Name NVARCHAR(30), @Description TEXT, @Time INT, @Category NVARCHAR(30), @PublisherName NVARCHAR(30), 
							@StartDate DATETIME= NULL, @UnitPrice MONEY)
AS
				IF ((SELECT TOP 1 A.Name FROM Items A WHERE @Name LIKE A.Name) IS NULL
				AND (SELECT TOP 1 A.Category FROM ProductCategory A WHERE @Category LIKE A.Category)IS NOT NULL)
				BEGIN
						DECLARE @ServiceId INT
						DECLARE @CategoryId INT
						DECLARE @PublisherId INT
						SET @ServiceId = NEXT VALUE FOR ProductSequence
						SET @CategoryId = (SELECT TOP 1 A.CategoryId FROM ProductCategory A WHERE A.Category LIKE @Category)
						SET @PublisherId = (SELECT TOP 1 A.PublisherId FROM Publishers A WHERE A.PublisherName LIKE @PublisherName)
						INSERT INTO Products
						VALUES (@ServiceId, @Description, @CategoryId, @PublisherId)
						INSERT INTO Services
						VALUES (@ServiceId, @Name, @Time, @CategoryId)
						INSERT INTO ProductsPrices
						VALUES (@ServiceId, @StartDate, @UnitPrice)
				END
GO

IF OBJECT_ID('AddItemsToWarehouse','p') IS NOT NULL
DROP PROCEDURE AddItemsToWarehouse
GO

CREATE PROCEDURE AddItemsToWarehouse (@WarehouseName NVARCHAR(30), @ItemName NVARCHAR(30), @Quantity INT)
AS
				IF ((SELECT TOP 1 A.Name FROM Items A WHERE @ItemName LIKE A.Name) IS NOT NULL
				AND (SELECT TOP 1 A.Name FROM Warehouses A WHERE @WarehouseName LIKE A.Name)IS NOT NULL)
				BEGIN
						DECLARE @WarehouseId INT
						DECLARE @ItemId INT
						SET @WarehouseId = (SELECT TOP 1 A.WarehouseId FROM Warehouses A WHERE @WarehouseName LIKE A.Name)
						SET @ItemId = (SELECT TOP 1 A.ItemId FROM Items A WHERE @ItemName LIKE A.Name)
						IF (SELECT A.Quantity FROM ItemsInWarehouse A WHERE A.WarehouseId=@WarehouseId and A.ItemId=@ItemId) IS NOT NULL
						BEGIN
							UPDATE ItemsInWarehouse
							SET Quantity = Quantity + @Quantity
							WHERE WarehouseId=@WarehouseId and ItemId=@ItemId
						END
						ELSE
						BEGIN
							INSERT INTO ItemsInWarehouse
							VALUES (@ItemId, @WarehouseId, @Quantity)
						END						
				END
		
GO

-------------------------------------------------------------------------------------------------------------------Triggery
IF OBJECT_ID ('DeleteItem', 'TR') IS NOT NULL
   DROP TRIGGER DeleteItem;
GO

CREATE TRIGGER DeleteItem ON Items
AFTER DELETE 
AS 
	DELETE FROM Products
	WHERE ProductId IN (SELECT ItemId FROM DELETED)
	DELETE FROM ItemsInWarehouse
	WHERE ItemId IN (SELECT ItemId FROM DELETED)
GO

IF OBJECT_ID ('DeleteService', 'TR') IS NOT NULL
   DROP TRIGGER DeleteService;
GO

CREATE TRIGGER DeleteService ON Services
AFTER DELETE 
AS 
	DELETE FROM Products
	WHERE ProductId IN (SELECT ServiceId FROM DELETED)
GO

IF OBJECT_ID ('DeleteCustomer', 'TR') IS NOT NULL
   DROP TRIGGER DeleteCustomer;
GO

CREATE TRIGGER DeleteCustomer ON Customers
INSTEAD OF DELETE 
AS 
	DELETE FROM CustomerConstacts
	WHERE Login IN (SELECT Login FROM DELETED)
	DELETE FROM Customers
	WHERE Login IN (SELECT Login FROM DELETED)
GO

IF OBJECT_ID ('DeleteEmployee', 'TR') IS NOT NULL
   DROP TRIGGER DeleteEmployee;
GO

CREATE TRIGGER DeleteEmployee ON Employees
INSTEAD OF DELETE 
AS 
	DELETE FROM EmployeeContacts
	WHERE EmployeeId IN (SELECT EmployeeId FROM DELETED)
	DELETE FROM Employees
	WHERE EmployeeId IN (SELECT EmployeeId FROM DELETED)
GO

IF OBJECT_ID ('DeleteWarehouse', 'TR') IS NOT NULL
   DROP TRIGGER DeleteWarehouse;
GO

CREATE TRIGGER DeleteWarehouse ON Warehouses
INSTEAD OF DELETE 
AS 
	DELETE FROM ItemsInWarehouses
	WHERE WarehouseId IN (SELECT WarehouseId FROM DELETED)
	DELETE FROM Warehouses
	WHERE WarehouseId IN (SELECT WarehouseId FROM DELETED)
GO