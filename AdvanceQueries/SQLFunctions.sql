-----------------------------Welcome To The BookStore DataBase---------------------------------

------------------------------------------ Using BikeStore DB
Use BikeStores;

--=================================================================================================================--
------------------------------------------------SQL Server Scalar Functions------------------------------------------
--=================================================================================================================--
-------Creating a scalar function
-------Creating a function that calculates the net sales based on the quantity, list price, and discount
CREATE FUNCTION sales.udfNetSale(
    @quantity INT,
    @price DEC(10,2),
    @discount DEC(4,2)
)
RETURNS DEC(10,2)
AS 
BEGIN
    RETURN @quantity * @price * (1 - @discount);
END;

-------Calling a scalar function
SELECT sales.udfNetSale(10,100,0.1) net_sale;

-------Query to use the sales.udfNetSale function to get the net sales of the sales orders in the order_items table
SELECT order_id, SUM(sales.udfNetSale(quantity, price, discount)) net_amount
FROM sales.order_items GROUP BY order_id ORDER BY net_amount DESC;

--------Removing a scalar function
DROP FUNCTION If Exists sales.udfNetSale;

------------------------------------SQL Server DROP FUNCTION with SCHEMABINDING example--------------------------------------
-------Creating the function sales.udf_get_discount_amountusing the WITH SCHEMABINDING option
CREATE OR ALTER FUNCTION sales.udf_get_discount_amount (
    @quantity INT,
    @price DEC(10,2),
    @discount DEC(4,2) 
)
RETURNS DEC(10,2) 
WITH SCHEMABINDING
AS 
BEGIN
    RETURN @quantity * @price * @discount
END

------------Creating a view that uses the sales.udf_get_discount_amount function
CREATE VIEW sales.discounts
WITH SCHEMABINDING
AS
SELECT order_id, SUM(sales.udf_get_discount_amount(quantity,price,discount)) AS discount_amount
FROM sales.order_items i GROUP BY order_id;

----------Try to remove the sales.udf_get_discount_amount function
DROP FUNCTION sales.udf_get_discount_amount;
------------------ Steps To Remove Function With SchemaBinding
DROP VIEW sales.discounts;
DROP FUNCTION sales.udf_get_discount_amount;

--=================================================================================================================--
---------------------------------------------SQL Server Table-valued Functions--------------------------------------
--=================================================================================================================--
------Creating and modifying a table-valued function
CREATE OR ALTER FUNCTION udfProductInYear (@start_year INT, @end_year INT)
RETURNS TABLE
AS
RETURN
    SELECT product_name, model_year,price
    FROM production.products
    WHERE model_year Between @start_year And @end_year;

------Executing a table-valued function
SELECT * FROM udfProductInYear(2017);

SELECT product_name,model_year,price
FROM udfProductInYear(2017,2018)
ORDER BY product_name;

------Specifying which columns to be returned from the table-valued function as follows
SELECT product_name, price FROM udfProductInYear(2018);

--==============================================================================================================--
----------------------------------------Aggregate Functions--------------------------------------------------------
--===============================================================================================================--
------------------------Average Function
SELECT AVG(price) avg_product_price FROM production.products;
SELECT CAST((AVG(price)) AS DEC(10,2)) avg_product_price FROM production.products;

------------------------Count Function
SELECT COUNT(*) product_count FROM production.products WHERE price > 500;

------------------------Max Function
SELECT MAX(price) max_price FROM production.products;

------------------------Min Function
SELECT MIN(price) min_price FROM production.products; 

------------------------Sum Function
SELECT product_id, SUM(quantity) stock_count FROM production.stocks GROUP BY product_id
ORDER BY stock_count DESC;

------------------------STDEV  Function
---function to calculate the statistical standard deviation of all list prices
SELECT CAST(ROUND(STDEV(price),2) as DEC(10,2)) stdev_price FROM production.products;










