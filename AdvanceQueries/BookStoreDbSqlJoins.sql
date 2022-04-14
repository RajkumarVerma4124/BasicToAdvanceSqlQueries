-----------------------------Welcome To The BookStore DataBase---------------------------------

------------------------------------------ Using BikeStore DB
Use BikeStores;

--===================================================================================================================--
--------------------------------------------Table Creation For SQL Server Joins ---------------------------------------
--===================================================================================================================--

-----------------Setting up sample tables
CREATE SCHEMA hr;
GO

CREATE SCHEMA pm;
GO
-----------------Creating table for the hr schema and pm schema:
CREATE TABLE hr.candidates(
    id INT PRIMARY KEY IDENTITY,
    fullname VARCHAR(100) NOT NULL
);

CREATE TABLE hr.employees(
    id INT PRIMARY KEY IDENTITY,
    fullname VARCHAR(100) NOT NULL
);

CREATE TABLE pm.projects(
    id INT PRIMARY KEY IDENTITY,
    title VARCHAR(255) NOT NULL
);

CREATE TABLE pm.members(
    id INT PRIMARY KEY IDENTITY,
    name VARCHAR(120) NOT NULL,
    project_id INT,
    FOREIGN KEY (project_id) 
        REFERENCES pm.projects(id)
);


-------------Inserting values into the candidates, employees, project and members tables
--------------------------hr schema
---Left Table
INSERT INTO hr.candidates(fullname) VALUES ('John Doe'), ('Lily Bush'), ('Peter Drucker'), ('Jane Doe');
---Right Table
INSERT INTO hr.employees(fullname) VALUES ('John Doe'),('Jane Doe'),('Michael Scott'),('Jack Sparrow');

---------------------------pm schema
INSERT INTO pm.projects(title) VALUES ('New CRM for Project Sales'), ('ERP Implementation'), ('Develop Mobile Sales Platform');

INSERT INTO pm.members(name, project_id) VALUES ('John Doe', 1), ('Lily Bush', 1), ('Jane Doe', 2), ('Jack Daniel', null);

--------------Showing Data Using Select
SELECT * FROM hr.candidates;
SELECT * FROM hr.employees;
SELECT * FROM pm.projects;
SELECT * FROM pm.members;

--===================================================================================================================--
-------------------------------------------------------- SQL Server Inner Joins ---------------------------------------
--===================================================================================================================--
SELECT c.id candidate_id, c.fullname candidate_name, e.id employee_id, e.fullname employee_name
FROM hr.candidates c INNER JOIN hr.employees e ON e.fullname = c.fullname;

----------------------Using The Production Products And Categories Table
SELECT Product_Name As 'Product Name', Category_Name 'Category Name', Price 'Product Price'
FROM Production.Products p INNER JOIN Production.Categories c ON c.Category_Id = p.Category_Id
ORDER BY Product_Name DESC;

----------------------Using The Production Products,Categories And Brand Table
SELECT Product_Name As 'Product Name', Category_Name 'Category Name', Brand_Name 'Brand Name', Price 'Product Price'
FROM Production.Products p 
INNER JOIN Production.Categories c ON c.Category_Id = p.Category_Id
INNER JOIN Production.Brands b ON b.Brand_Id = p.Brand_Id
ORDER BY Product_Name DESC;

--===================================================================================================================--
-------------------------------------------------------- SQL Server Left Joins ---------------------------------------
--===================================================================================================================--
SELECT c.id candidate_id, c.fullname candidate_name, e.id employee_id, e.fullname employee_name
FROM hr.candidates c Left JOIN hr.employees e ON e.fullname = c.fullname;
----The Data Which Is Present Only On The Left Table And Not On The Right Table
SELECT c.id candidate_id, c.fullname candidate_name, e.id employee_id, e.fullname employee_name
FROM hr.candidates c Left JOIN hr.employees e ON e.fullname = c.fullname Where e.Id Is Null;

----------------------Using The Production Products, And Sales Order_Items Table
SELECT Product_Name As 'Product Name', Order_Id 'Order Id'
FROM Production.Products p 
LEFT JOIN Sales.Order_Items o ON o.Product_Id = p.Product_Id
ORDER BY [Order Id];
----The Data Which Is Present Only On The Left Table And Not On The Right Table
SELECT Product_Name As 'Product Name', Order_Id 'Order Id'
FROM Production.Products p 
LEFT JOIN Sales.Order_Items o ON o.Product_Id = p.Product_Id
Where Order_Id Is Null ORDER BY [Order Id];

----------------------Using The Production Products, Sales Order_Items And Sales Orders Table
SELECT p.Product_Name As 'Product Name', o.Order_Id 'Order Id', i.Item_Id 'Item Id', o.Order_Date 'Ordered Date'
FROM Production.Products p 
LEFT JOIN Sales.Order_Items i ON i.Product_Id = p.Product_Id
LEFT JOIN Sales.Orders o ON o.Order_Id = i.Order_Id
ORDER BY [Order Id];

----------------------SQL Server LEFT JOIN: conditions in ON vs. WHERE clause
--Query to finds the products that belong to the order id 100:
SELECT p.Product_Name As 'Product Name', o.Order_Id 'Order Id'
FROM Production.Products p 
LEFT JOIN Sales.Order_Items o ON o.Product_Id = p.Product_Id
WHERE Order_Id = 100
ORDER BY [Order Id];
--------------Query to finds the products that belong to the order id 100 in a diff way
SELECT p.Product_Id 'Product Id', Product_Name As 'Product Name', o.Order_Id 'Order Id'
FROM Production.Products p 
LEFT JOIN Sales.Order_Items o ON o.Product_Id = p.Product_Id And o.Order_Id = 100
ORDER BY [Order Id] Desc Offset 0 Rows Fetch First 5 Rows Only;

--===================================================================================================================--
-------------------------------------------------------- SQL Server Right Joins ---------------------------------------
--===================================================================================================================--
SELECT c.id candidate_id, c.fullname candidate_name, e.id employee_id, e.fullname employee_name
FROM hr.candidates c Right JOIN hr.employees e ON e.fullname = c.fullname;
----The Data Which Is Present Only On The Riight Table And Not On The Left Table
SELECT c.id candidate_id, c.fullname candidate_name, e.id employee_id, e.fullname employee_name
FROM hr.candidates c Right JOIN hr.employees e ON e.fullname = c.fullname Where c.Id Is Null;

----------------------Using The Production Products, And Sales Order_Items Table
SELECT Product_Name As 'Product Name', Order_Id 'Order Id'
FROM Sales.Order_Items o 
RIGHT JOIN Production.Products p ON o.Product_Id = p.Product_Id 
ORDER BY [Order Id];

SELECT Product_Name As 'Product Name', Order_Id 'Order Id'
FROM Sales.Order_Items o 
RIGHT JOIN Production.Products p ON o.Product_Id = p.Product_Id WHERE Order_Id Is NULL 
ORDER BY [Order Id];

SELECT Product_Name As 'Product Name', Order_Id 'Order Id'
FROM Sales.Order_Items o 
RIGHT JOIN Production.Products p ON o.Product_Id = p.Product_Id WHERE Order_Id Is Not NULL 
ORDER BY [Order Id];


--===================================================================================================================--
-------------------------------------------------------- SQL Server Full Joins ---------------------------------------
--===================================================================================================================--
SELECT c.id candidate_id, c.fullname candidate_name, e.id employee_id, e.fullname employee_name
FROM hr.candidates c Full JOIN hr.employees e ON e.fullname = c.fullname;

----To select rows that exist either left or right table, you exclude rows that are common to both tables
SELECT c.id candidate_id, c.fullname candidate_name, e.id employee_id, e.fullname employee_name
FROM hr.candidates c Full JOIN hr.employees e ON e.fullname = c.fullname Where c.id Is Null Or e.Id Is Null;


--------Query to find members who participate in projects, members who do not participate in any projects, 
--------and projects which do not have any members.
SELECT  m.name member, p.title project
FROM  pm.members m
FULL OUTER JOIN pm.projects p ON p.id = m.project_id;

---------Query to find the members who do not participate in any project and projects which do not have any members
SELECT  m.name member, p.title project
FROM  pm.members m
FULL OUTER JOIN pm.projects p ON p.id = m.project_id
WHERE m.id IS NULL Or p.id IS NULL;

--===================================================================================================================--
-------------------------------------------------------- SQL Server Cross Joins ---------------------------------------
--===================================================================================================================--
----------------------Using The Production Products, And Sales Stores Table
SELECT Product_Id, Product_Name, Store_Id, 0 AS quantity
FROM Production.Products CROSS JOIN Sales.Stores
ORDER BY Product_Name, Store_Id;

-----Query to finds the products that have no sales across the stores
SELECT s.Store_Id, p.Product_Id, ISNULL(sales, 0) sales
FROM Sales.Stores s
CROSS JOIN Production.Products p
LEFT JOIN ( SELECT s.Store_Id, p.Product_Id, SUM (Quantity * i.Price) sales FROM Sales.Orders o
	INNER JOIN Sales.Order_Items i ON i.Order_Id = o.Order_Id
    INNER JOIN sales.Stores s ON s.Store_Id = o.Store_Id
    INNER JOIN Production.Products p ON p.Product_Id = i.Product_Id
    GROUP BY s.Store_Id, p.Product_Id ) c ON c.Store_Id = s.Store_Id
AND c.product_id = p.product_id
WHERE Sales IS NULL
ORDER BY Product_Id, Store_Id;

--===================================================================================================================--
-------------------------------------------------------- SQL Server Self Joins ---------------------------------------
--===================================================================================================================--
------------------------------------ Using The Sales Staffs Table
----- Using self join to query hierarchical data
SELECT e.First_Name + ' ' + e.Last_Name 'Employee Name', m.First_Name + ' ' + m.Last_Name 'Manager Name'
FROM Sales.Staffs e INNER JOIN Sales.Staffs m ON m.Staff_Id = e.Manager_Id
ORDER BY [Manager Name];

SELECT e.First_Name + ' ' + e.Last_Name 'Employee Name', m.First_Name + ' ' + m.Last_Name 'Manager Name'
FROM Sales.Staffs e LEFT JOIN Sales.Staffs m ON m.Staff_Id = e.Manager_Id
ORDER BY [Manager Name];

------------------------------------ Using The Sales Customers Table
----------------- Using self join to compare rows within a table
----- Query to find the customers located in the same city
SELECT c1.City, c1.First_Name + ' ' + c1.Last_Name 'Customer 1', c2.First_Name + ' ' + c2.Last_Name 'Customer 2'
FROM Sales.Customers c1 INNER JOIN Sales.Customers c2 ON c1.Customer_Id > c2.Customer_Id And c1.City = c2.City
ORDER BY City,[Customer 1],[Customer 2];

SELECT c1.City, c1.First_Name + ' ' + c1.Last_Name 'Customer 1', c2.First_Name + ' ' + c2.Last_Name 'Customer 2'
FROM Sales.Customers c1 INNER JOIN Sales.Customers c2 ON c1.Customer_Id > c2.Customer_Id And c1.City <> c2.City
ORDER BY City,[Customer 1],[Customer 2];

SELECT c1.City, c1.First_Name + ' ' + c1.Last_Name 'Customer 1', c2.First_Name + ' ' + c2.Last_Name 'Customer 2'
FROM Sales.Customers c1 INNER JOIN Sales.Customers c2 ON c1.Customer_Id > c2.Customer_Id And c1.City = c2.City Where c1.City = 'Albany'
ORDER BY City,[Customer 1],[Customer 2];

SELECT c1.City, c1.First_Name + ' ' + c1.Last_Name 'Customer 1', c2.First_Name + ' ' + c2.Last_Name 'Customer 2'
FROM Sales.Customers c1 INNER JOIN Sales.Customers c2 ON c1.Customer_Id <> c2.Customer_Id And c1.City = c2.City Where c1.City = 'Albany'
ORDER BY City,[Customer 1],[Customer 2];
