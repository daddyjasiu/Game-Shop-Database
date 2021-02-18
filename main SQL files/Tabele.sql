--Tworzenie tabel
IF OBJECT_ID('dbo.BonusSalary', 'U') IS NOT NULL 
	DROP TABLE BonusSalary
GO
CREATE TABLE BonusSalary (
    EmployeeId INT NOT NULL,
    ReceivedDate DATE DEFAULT GETDATE(),
	BonusWorth MONEY NOT NULL,
	ReceiveFor NVARCHAR(30) NOT NULL,
	PRIMARY KEY (EmployeeId,ReceivedDate)
)
GO

IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL 
	DROP TABLE Customers
GO
CREATE TABLE Customers (
    Login  INT NOT NULL,
	Password NVARCHAR(30) NOT NULL,
	PRIMARY KEY (Login)
)
GO

IF OBJECT_ID('dbo.CustomerContacts', 'U') IS NOT NULL 
	DROP TABLE CustomerContacts
GO
CREATE TABLE CustomerContacts (
    Login INT NOT NULL,
	Name NVARCHAR(30) NOT NULL,
	Surname NVARCHAR(30) NOT NULL,
	Email NVARCHAR(30) NOT NULL,
	Telephone NVARCHAR(30) NOT NULL,
	PRIMARY KEY (Login)
)
GO

IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL 
	DROP TABLE Employees
GO
CREATE TABLE Employees (
    EmployeeId INT NOT NULL,
	HireDate DATE DEFAULT GETDATE(),
	PositionId INT NOT NULL,
	BossId INT,
	PRIMARY KEY (EmployeeId)
)
GO

IF OBJECT_ID('dbo.EmployeesContacts', 'U') IS NOT NULL 
	DROP TABLE EmployeesContacts
GO
CREATE TABLE EmployeesContacts (
    EmployeeId INT NOT NULL,
	Name NVARCHAR(30) NOT NULL,
	Surname NVARCHAR(30) NOT NULL,
	Email NVARCHAR(30) NOT NULL,
	Telephone NVARCHAR(30) NOT NULL,
	PRIMARY KEY (EmployeeId)

)
GO

IF OBJECT_ID('dbo.ExpiredServices', 'U') IS NOT NULL 
	DROP TABLE ExpiredServices
GO
CREATE TABLE ExpiredServices (
    ServiceId INT NOT NULL,
	Login INT NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME DEFAULT GETDATE(),
	PRIMARY KEY (ServiceId,Login,EndDate)

)
GO

IF OBJECT_ID('dbo.Items', 'U') IS NOT NULL 
	DROP TABLE Items
GO
CREATE TABLE Items (
    ItemId INT NOT NULL,
	Name NVARCHAR(30) NOT NULL,
	CategoryId INT NOT NULL,
	TagId INT NOT NULL,
	PRIMARY KEY (ItemId)
)
GO

IF OBJECT_ID('dbo.ItemsInWarehouse', 'U') IS NOT NULL 
	DROP TABLE ItemsInWarehouse
GO
CREATE TABLE ItemsInWarehouse (
    ItemId INT NOT NULL,
	WarehouseId INT NOT NULL,
	Quantity INT NOT NULL,
	PRIMARY KEY (ItemId, WarehouseId)
)
GO

IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL 
	DROP TABLE Orders
GO
CREATE TABLE Orders (
    OrderId INT NOT NULL,
	PurchaseDate DATETIME DEFAULT GETDATE(),
	City NVARCHAR(30) NOT NULL,
	Country NVARCHAR(30) NOT NULL,
	Address NVARCHAR(30) NOT NULL,
	Login INT NOT NULL,
	PRIMARY KEY (OrderId)
)
GO

IF OBJECT_ID('dbo.OrderDetails', 'U') IS NOT NULL 
	DROP TABLE OrderDetails
GO
CREATE TABLE OrderDetails (  
	OrderId INT NOT NULL,
	ProductId INT NOT NULL,
	UnitPrice INT NOT NULL,
	Quantity INT NOT NULL,
	Discount INT NOT NULL,
	PRIMARY KEY (OrderId, ProductId)
)
GO

IF OBJECT_ID('dbo.PEGIRating', 'U') IS NOT NULL 
	DROP TABLE PEGIRating
GO
CREATE TABLE PEGIRating (
    TagId INT NOT NULL,
	TagName NVARCHAR(30) NOT NULL,
	PRIMARY KEY (TagId)
)
GO

IF OBJECT_ID('dbo.Positions', 'U') IS NOT NULL 
	DROP TABLE Positions
GO
CREATE TABLE Positions (
    PositionId INT NOT NULL,
	Name NVARCHAR(30) NOT NULL,
	Salary MONEY NOT NULL,
	PRIMARY KEY (PositionId)
)
GO

IF OBJECT_ID('dbo.ProductCategory', 'U') IS NOT NULL 
	DROP TABLE ProductCategory
GO
CREATE TABLE ProductCategory (
    CategoryId INT NOT NULL,
	Category NVARCHAR(30) NOT NULL,
	PRIMARY KEY (CategoryId)
)
GO

IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL 
	DROP TABLE Products
GO
CREATE TABLE Products (
    ProductId INT NOT NULL,
	Description TEXT,
	CategoryId INT NOT NULL,
	PublisherId INT NOT NULL,
	PRIMARY KEY (ProductId)
)
GO

IF OBJECT_ID('dbo.ProductsPrices', 'U') IS NOT NULL 
	DROP TABLE ProductsPrices 
GO
CREATE TABLE ProductsPrices (
    ProductId INT NOT NULL,
	StartDate DATETIME DEFAULT GETDATE(),
	UnitPrice MONEY NOT NULL,
	PRIMARY KEY (ProductID, StartDate)
)
GO

IF OBJECT_ID('dbo.PromoCodes', 'U') IS NOT NULL 
	DROP TABLE PromoCodes
GO
CREATE TABLE PromoCodes (
    PromoId INT NOT NULL,
	ProductId INT NOT NULL,
	Discount INT NOT NULL,
	Code NVARCHAR(30) NOT NULL,
	ExpireDate DATETIME NOT NULL,
	Login INT NOT NULL,
	OrderId INT NOT NULL,
	PRIMARY KEY (PromoId)
)
GO

IF OBJECT_ID('dbo.Publishers', 'U') IS NOT NULL 
	DROP TABLE Publishers
GO
CREATE TABLE Publishers (
	PublisherId INT NOT NULL,
    PublisherName VARCHAR(30) NOT NULL,
	PRIMARY KEY (PublisherId)
)
GO

IF OBJECT_ID('dbo.Ratings', 'U') IS NOT NULL 
	DROP TABLE Ratings
GO
CREATE TABLE Ratings (
    Login INT NOT NULL,
	ProductId INT NOT NULL,
	Rating SMALLINT NOT NULL,
	AddDate DATETIME DEFAULT GETDATE(),
	PRIMARY KEY (Login, ProductId)
)
GO

IF OBJECT_ID('dbo.Services', 'U') IS NOT NULL 
	DROP TABLE Services
GO
CREATE TABLE Services (
    ServiceId INT NOT NULL,
	Name NVARCHAR(30) NOT NULL,
	Time INT NOT NULL,
	CategoryId INT NOT NULL,
	PRIMARY KEY (ServiceId)
)
GO

IF OBJECT_ID('dbo.Warehouses', 'U') IS NOT NULL 
	DROP TABLE Warehouses
GO
CREATE TABLE Warehouses (
    WarehouseId INT NOT NULL,
	Name NVARCHAR(30) NOT NULL,
	Country NVARCHAR(30) NOT NULL,
	City NVARCHAR(30) NOT NULL,
	Address NVARCHAR(30) NOT NULL,
	Telephone NVARCHAR(30) NOT NULL,
	PRIMARY KEY (WarehouseId)
)
GO

-----------------------------------------------------------------------------------------------Klucze obce

ALTER TABLE BonusSalary
	ADD FOREIGN KEY (EmployeeId)
		REFERENCES Employees (EmployeeId)
		ON DELETE CASCADE
	ON UPDATE CASCADE
GO

ALTER TABLE CustomerContacts
	ADD FOREIGN KEY (Login)
		REFERENCES Customers (Login)
		ON DELETE CASCADE
	ON UPDATE CASCADE
GO

ALTER TABLE EmployeesContacts
	ADD FOREIGN KEY (EmployeeId)
		REFERENCES Employees (EmployeeId)
		ON DELETE CASCADE
	ON UPDATE CASCADE
GO

ALTER TABLE ExpiredServices 
	ADD FOREIGN KEY (ServiceId)
		REFERENCES Services (ServiceId)
GO

ALTER TABLE Items
	ADD FOREIGN KEY (ItemId)
	REFERENCES Products (ProductId)
	ON DELETE CASCADE
	ON UPDATE CASCADE
GO

ALTER TABLE ItemsInWarehouse
	ADD FOREIGN KEY (WarehouseId)
	REFERENCES Warehouses(WarehouseId)
	ON DELETE CASCADE
	ON UPDATE CASCADE
GO

ALTER TABLE ItemsInWarehouse
	ADD FOREIGN KEY (ItemId)
	REFERENCES Items (ItemId)
	ON DELETE CASCADE
	ON UPDATE CASCADE
GO

ALTER TABLE OrderDetails
	ADD FOREIGN KEY (OrderId)
	REFERENCES Orders (OrderId)
	ON DELETE CASCADE
	ON UPDATE CASCADE
GO

ALTER TABLE ProductsPrices
	ADD FOREIGN KEY (ProductId)
	REFERENCES Products (ProductId)
	ON DELETE CASCADE
	ON UPDATE CASCADE
GO

ALTER TABLE PromoCodes
	ADD FOREIGN KEY (ProductId)
	REFERENCES Products (ProductId)
	ON DELETE CASCADE
	ON UPDATE CASCADE
GO

ALTER TABLE Ratings 
	ADD FOREIGN KEY (Login)
	REFERENCES Customers (Login)
	ON DELETE CASCADE
	ON UPDATE CASCADE
GO

ALTER TABLE Ratings
	ADD FOREIGN KEY (ProductId)
	REFERENCES Products(ProductId)
	ON DELETE CASCADE
	ON UPDATE CASCADE
GO