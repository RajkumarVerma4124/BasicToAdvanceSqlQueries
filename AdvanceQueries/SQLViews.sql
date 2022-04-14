-----------------------------Welcome To The BookStore DataBase---------------------------------

------------------------------------------ Using BikeStore DB
Use BikeStores;

--=================================================================================================================--
------------------------------------------------SQL Server Views------------------------------------------
--=================================================================================================================--
--------------------------Creating A View
CREATE VIEW sales.product_info
AS
SELECT product_name, brand_name, price FROM production.products p
INNER JOIN production.brands b ON b.brand_id = p.brand_id;

-----Accessing records through view
SELECT * FROM sales.product_info;

------------------Using orders, order_items, and products tables
---The following statement creates a view named daily_sales based on the orders, order_items, and products tables
CREATE VIEW sales.daily_sales
AS
SELECT
    year(order_date) AS y,
    month(order_date) AS m,
    day(order_date) AS d,
    p.product_id,
    product_name,
    quantity * i.price AS sales
FROM sales.orders AS o INNER JOIN sales.order_items AS i ON o.order_id = i.order_id
INNER JOIN production.products AS p ON p.product_id = i.product_id;

-------------------------Redefining Or Modifying the view example
CREATE OR ALTER View sales.daily_sales (year, month, day, customer_name, product_id, product_name, sales)
AS
SELECT year(order_date), month(order_date), day(order_date), concat(first_name,' ',last_name), p.product_id, product_name, quantity * i.price
FROM sales.orders AS o INNER JOIN sales.order_items AS i ON o.order_id = i.order_id
    INNER JOIN production.products AS p ON p.product_id = i.product_id
    INNER JOIN sales.customers AS c ON c.customer_id = o.customer_id;

----------Accessing Records Through View
SELECT * FROM sales.daily_sales ORDER BY y, m, d, product_name;
SELECT * FROM sales.daily_sales ORDER BY year, month, day, customer_name;

-------------------------Creating a view using aggregate functions example
CREATE VIEW sales.staff_sales (first_name, last_name, year, amount)
AS 
SELECT first_name, last_name, YEAR(order_date), SUM(price * quantity) amount
FROM sales.order_items i INNER JOIN sales.orders o ON i.order_id = o.order_id
INNER JOIN sales.staffs s ON s.staff_id = o.staff_id
GROUP BY first_name, last_name, YEAR(order_date);

------Accessing Records Through View
SELECT  * FROM sales.staff_sales ORDER BY first_name, last_name, year;


--============================================================================================================--
-----------------------------------------------SQL Server DROP VIEW --------------------------------------------
--============================================================================================================--
-----------------SQL Server DROP VIEW examples
----Removing one view
DROP VIEW IF EXISTS sales.daily_sales;

--- Creating A New View
CREATE VIEW sales.product_catalog
AS
SELECT product_name, category_name, brand_name, price
FROM production.products p
INNER JOIN production.categories c ON c.category_id = p.category_id
INNER JOIN production.brands b ON b.brand_id = p.brand_id;

--------------------------------SQL Server rename view using Transact-SQL
EXEC sp_rename 
	@objname = 'sales.product_catalog',
    @newname = 'product_list';

Select * From sales.product_list 

----Removing multiple views
DROP VIEW IF EXISTS sales.staff_sales, sales.product_catalogs;

--============================================================================================================--
-------------------------------------------------SQL Server List Views------------------------------------------
--============================================================================================================--
------Query To list all views in a SQL Server Database
SELECT OBJECT_SCHEMA_NAME(v.object_id) schema_name, v.name
FROM sys.views as v;

------Query to returns a list of views through the sys.objects view
SELECT OBJECT_SCHEMA_NAME(o.object_id) schema_name, o.name
FROM sys.objects as o WHERE o.type = 'V';

-------------Creating a stored procedure to show views in SQL Server Database
CREATE PROC sp_list_views(
	@schema_name AS VARCHAR(MAX) = NULL,
	@view_name AS VARCHAR(MAX) = NULL
)
AS
SELECT OBJECT_SCHEMA_NAME(v.object_id) schema_name, v.name view_name
FROM sys.views as v
WHERE (@schema_name IS NULL OR OBJECT_SCHEMA_NAME(v.object_id) LIKE '%' + @schema_name + '%') 
	AND (@view_name IS NULL OR v.name LIKE '%' + @view_name + '%');

---- List Views Using Stored Porcedure
EXEC sp_list_views @view_name = 'sales'

--============================================================================================================--
------------------------------How to Get Information About a View in SQL Server---------------------------------
--============================================================================================================--
--------------------Getting the view information using the sql.sql_module catalog
SELECT definition, uses_ansi_nulls, uses_quoted_identifier, is_schema_bound
FROM sys.sql_modules
WHERE object_id = object_id('sales.daily_sales');

--------------------Getting view information using the sp_helptext stored procedure
EXEC sp_helptext 'sales.product_list' ;

-------------------Getting the view information using OBJECT_DEFINITION() function
SELECT OBJECT_DEFINITION(OBJECT_ID('sales.staff_sales')) view_info;

--============================================================================================================--
---------------------------------------------SQL Server Indexed View--------------------------------------------
--============================================================================================================--
-----creating a view that uses the WITH SCHEMABINDING option which binds the view to the schema of the underlying tables
CREATE VIEW production.product_master
WITH SCHEMABINDING
AS 
SELECT product_id, product_name, model_year, price, brand_name, category_name
FROM production.products p
INNER JOIN production.brands b ON b.brand_id = p.brand_id
INNER JOIN production.categories c ON c.category_id = p.category_id;

-----Examining the query I/O cost statistics by querying data from a regular view and using the SET STATISTICS IO command
SET STATISTICS IO ON
GO
SELECT * FROM production.product_master
ORDER BY product_name;
GO 

-----Adding a unique clustered index to the view
CREATE UNIQUE CLUSTERED INDEX 
    ucidx_product_id 
ON production.product_master(product_id);

-----Adding a non-clustered index on the product_name column of the view
CREATE NONCLUSTERED INDEX 
    ucidx_product_name
ON production.product_master(product_name);


SELECT * FROM production.product_master WITH (NOEXPAND) ORDER BY product_name;

