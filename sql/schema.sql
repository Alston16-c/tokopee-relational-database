SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS InvoiceDetail;
DROP TABLE IF EXISTS Invoice;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS CustomerAddress;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS City;
DROP TABLE IF EXISTS Province;
DROP TABLE IF EXISTS Country;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. WILAYAH
CREATE TABLE Country (
    CountryID INT PRIMARY KEY,
    CountryName VARCHAR(100) NOT NULL
);

CREATE TABLE Province (
    ProvinceID INT PRIMARY KEY,
    ProvinceName VARCHAR(100) NOT NULL,
    CountryID INT NOT NULL,
    CONSTRAINT FK_Province_Country FOREIGN KEY (CountryID)
        REFERENCES Country(CountryID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE City (
    CityID INT PRIMARY KEY,
    CityName VARCHAR(100) NOT NULL,
    Type VARCHAR(50) DEFAULT 'Kota',
    ProvinceID INT NOT NULL,
    CONSTRAINT FK_City_Province FOREIGN KEY (ProvinceID)
        REFERENCES Province(ProvinceID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 2. USER
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    CustomerEmail VARCHAR(100),
    CustomerPhone VARCHAR(50),
    RegisteredDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE CustomerAddress (
    AddressID INT PRIMARY KEY,
    LabelAddress VARCHAR(50) DEFAULT 'Home',
    ReceiverName VARCHAR(100),
    ReceiverPhone VARCHAR(50),
    StreetDetail TEXT,
    PostalCode VARCHAR(20),
    IsActive BOOLEAN DEFAULT TRUE,
    CustomerID INT NOT NULL,
    CityID INT NOT NULL,
    CONSTRAINT FK_Address_Customer FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Address_City FOREIGN KEY (CityID)
        REFERENCES City(CityID) ON UPDATE CASCADE
);

-- 3. PRODUCT
CREATE TABLE Product (
    StockCode VARCHAR(50) PRIMARY KEY,
    ProductName VARCHAR(255) NOT NULL,
    CurrentPrice DECIMAL(15, 2) NOT NULL CHECK (CurrentPrice >= 0),
    Description TEXT,
    CurrentStock INT NOT NULL DEFAULT 10000,
    CONSTRAINT Chk_Stock_Not_Negative CHECK (CurrentStock >= 0)
);

-- 4. INVOICE & DETAIL
CREATE TABLE Invoice (
    InvoiceID VARCHAR(50) PRIMARY KEY,
    InvoiceDate DATETIME NOT NULL,
    CustomerID INT,
    TotalAmount DECIMAL(15, 2) DEFAULT 0,
    Status VARCHAR(50) DEFAULT 'Completed',
    AddressID INT,
    CONSTRAINT FK_Invoice_Customer FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT FK_Invoice_Address FOREIGN KEY (AddressID)
        REFERENCES CustomerAddress(AddressID) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE InvoiceDetail (
    InvoiceID VARCHAR(50) NOT NULL,
    StockCode VARCHAR(50) NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity != 0),
    UnitPrice DECIMAL(15, 2) NOT NULL CHECK (UnitPrice >= 0),

    CONSTRAINT PK_InvoiceDetail PRIMARY KEY (InvoiceID, StockCode),

    CONSTRAINT FK_Detail_Invoice FOREIGN KEY (InvoiceID)
        REFERENCES Invoice(InvoiceID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Detail_Product FOREIGN KEY (StockCode)
        REFERENCES Product(StockCode) ON DELETE RESTRICT ON UPDATE CASCADE
);