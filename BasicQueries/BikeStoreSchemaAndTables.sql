-----------------------------Welcome To The BikeStore DataBase---------------------------------

------------------------------------------ Create DB
CREATE DATABASE BikeStores;
Use BikeStores;

--------------------------------------- Create Schemas
CREATE SCHEMA Production;
Go

CREATE SCHEMA Sales;
Go

--------------------------------------------------- Creating Tables -----------------------------------------------------------
-------- Creating Production Category Table
CREATE TABLE Production.Categories (
	Category_Id INT IDENTITY (1, 1) PRIMARY KEY,
	Category_Name VARCHAR (255) NOT NULL
);

-------- Creating Production Brand Table
CREATE TABLE Production.Brands (
	Brand_Id INT IDENTITY (1, 1) PRIMARY KEY,
	Brand_Name VARCHAR (255) NOT NULL
);

-------- Creating Production Product Table
CREATE TABLE Production.Products (
	Product_Id INT IDENTITY (1, 1) PRIMARY KEY,
	Product_Name VARCHAR (255) NOT NULL,
	Brand_Id INT NOT NULL,
	Category_Id INT NOT NULL,
	Model_Year SMALLINT NOT NULL,
	Price DECIMAL (10, 2) NOT NULL,
	FOREIGN KEY (Category_Id) REFERENCES Production.Categories (Category_Id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Brand_Id) REFERENCES Production.Brands (Brand_Id) ON DELETE CASCADE ON UPDATE CASCADE
);

-------- Creating Sales Customer Table
CREATE TABLE Sales.Customers (
	Customer_Id INT IDENTITY (1, 1) PRIMARY KEY,
	First_Name VARCHAR (255) NOT NULL,
	Last_Name VARCHAR (255) NOT NULL,
	Phone VARCHAR (25),
	Email VARCHAR (255) NOT NULL,
	Street VARCHAR (255),
	City VARCHAR (50),
	State VARCHAR (25),
	Zip_code VARCHAR (5)
);

-------- Creating Sales Store Table
CREATE TABLE Sales.Stores (
	Store_Id INT IDENTITY (1, 1) PRIMARY KEY,
	Store_Name VARCHAR (255) NOT NULL,
	Phone VARCHAR (25),
	Email VARCHAR (255),
	Street VARCHAR (255),
	City VARCHAR (255),
	State VARCHAR (10),
	Zip_Code VARCHAR (5)
);

-------- Creating Sales Staffs Table
CREATE TABLE Sales.Staffs (
	Staff_Id INT IDENTITY (1, 1) PRIMARY KEY,
	First_Name VARCHAR (50) NOT NULL,
	Last_Name VARCHAR (50) NOT NULL,
	Email VARCHAR (255) NOT NULL UNIQUE,
	Phone VARCHAR (25),
	Active tinyint NOT NULL,
	Store_Id INT NOT NULL,
	Manager_Id INT,
	FOREIGN KEY (Store_Id) REFERENCES Sales.Stores (Store_Id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Manager_Id) REFERENCES Sales.Staffs (Staff_Id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

-------- Creating Sales Orders Table
CREATE TABLE Sales.Orders (
	Order_Id INT IDENTITY (1, 1) PRIMARY KEY,
	Customer_Id INT,
	-- Order status: 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed
	Order_Status tinyint NOT NULL,
	Order_Date DATE NOT NULL,
	Required_Date DATE NOT NULL,
	Shipped_Date DATE,
	Store_Id INT NOT NULL,
	Staff_Id INT NOT NULL,
	FOREIGN KEY (Customer_Id) REFERENCES Sales.Customers (Customer_Id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Store_Id) REFERENCES Sales.Stores (Store_Id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Staff_Id) REFERENCES Sales.Staffs (Staff_Id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

-------- Creating Sales Orders Items Table
CREATE TABLE Sales.Order_Items (
	Order_Id INT,
	Item_Id INT,
	Product_Id INT NOT NULL,
	Quantity INT NOT NULL,
	Price DECIMAL (10, 2) NOT NULL,
	Discount DECIMAL (4, 2) NOT NULL DEFAULT 0,
	PRIMARY KEY (Order_Id, Item_Id),
	FOREIGN KEY (Order_Id) REFERENCES Sales.Orders (Order_Id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Product_Id) REFERENCES Production.Products (Product_Id) ON DELETE CASCADE ON UPDATE CASCADE
);

-------- Creating Production Stocks Table
CREATE TABLE Production.Stocks (
	Store_Id INT,
	Product_Id INT,
	Quantity INT,
	PRIMARY KEY (Store_Id, Product_Id),
	FOREIGN KEY (Store_Id) REFERENCES Sales.Stores (Store_Id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Product_Id) REFERENCES Production.Products (Product_Id) ON DELETE CASCADE ON UPDATE CASCADE
);

-------- Creating Sales Feedback Table
CREATE TABLE Sales.Feedbacks (
	Feedback_Id INT IDENTITY(1, 1) PRIMARY KEY, 
    Comment VARCHAR(255) NOT NULL
);