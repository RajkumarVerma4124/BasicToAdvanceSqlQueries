-----------------------------Welcome To The BookStore DataBase---------------------------------

------------------------------------------ Using BikeStore DB
Use BikeStores;
--===================================================================================================================--
-------------------------------------- Basic SQL Server SELECT statement To Sort Result -------------------------------
--===================================================================================================================--
--------  SQL Server SELECT – retrieve some columns of a table example
Select First_Name, Last_Name From Sales.Customers;
Select First_Name, Last_Name, Email From Sales.Customers;

-------- SQL Server SELECT – retrieve all columns from a table example
Select * From Sales.Customers

-------- SQL Server SELECT – sort the result set
Select * From Sales.Customers Where State = 'CA';
Select * From Sales.Customers Where State = 'NY';

--=============================================================================================================================--
---------------------------------- SQL Server SELECT – Sort The Result Set Using Order By Clause --------------------------------
--=============================================================================================================================--
----------Using Sales Customers Table For Order By
Select * From Sales.Customers Where State = 'CA' Order by First_Name;
Select * From Sales.Customers Where State = 'NY' Order by First_Name;
Select * From Sales.Customers Order By Zip_code;
Select * From Sales.Customers Order By Zip_code Desc;
Select * From Sales.Customers Order By First_name Asc, Last_Name Desc;

--------Sort a result set by one column in ascending order
Select First_Name,Last_Name From Sales.Customers Order By First_name;

--------Sort a result set by one column in descending order
Select First_Name,Last_Name From Sales.Customers Order By First_name Desc;

--------Sort a result set by multiple columns
Select City,First_Name,Last_Name From Sales.Customers Order By City,First_name;
Select City,First_Name,Last_Name From Sales.Customers Order By City Desc,First_name Asc;

--------Sort a result set by a column that is not in the select list
Select City,First_Name,Last_Name From Sales.Customers Order By State;

--------Sort a result set by an expression
Select First_Name,Last_Name From Sales.Customers Order By Len(First_Name) Desc;

--------Sort by ordinal positions of columns
Select First_Name,Last_Name From Sales.Customers Order By 1,2;

--------------------------- Order By Clause As Group By Results
SELECT Customer_Id, YEAR (Order_Date) Order_Year FROM Sales.Orders WHERE Customer_Id IN (1, 2) ORDER BY Customer_Id;
SELECT DIstinct Customer_Id, YEAR (Order_Date) Order_Year FROM Sales.Orders WHERE Customer_Id IN (1, 2) ORDER BY Customer_Id;

--======================================================================================================================================--
------------------------------------- SQL Server GROUP BY Clause  ----------------------------------
--======================================================================================================================================--
------------ Using Sales Customers Table For Group By
Select City,Count(*) From Sales.Customers Where State = 'CA' Group By City Order by City;
Select Count(*) As CustomerCount,City As CityNames From Sales.Customers Where State = 'CA' Group By City Order by City;
Select Count(*) As CustomerCount,City As CityNames From Sales.Customers Where State = 'NY' Group By City Order by City;

------------ Using Sales Order Table For Group By
SELECT Customer_Id, YEAR (Order_Date) Order_Year FROM Sales.Orders WHERE Customer_Id IN (1, 2) 
GROUP BY Customer_Id, YEAR (Order_Date) ORDER BY Customer_Id;

SELECT Customer_Id, YEAR (Order_Date) Order_Year, COUNT (Order_Id) Order_Placed FROM Sales.Orders WHERE Customer_Id IN (1, 2) 
GROUP BY Customer_Id, YEAR (Order_Date) ORDER BY Customer_Id;

-------------------Using GROUP BY clause with the COUNT() function
------Query returns the number of customers in every city:
SELECT City, COUNT (Customer_Id) 'Customer Count' FROM Sales.Customers 
GROUP BY City ORDER BY City;

-----Query returns the number of customers by state and city.
SELECT City,State, COUNT (Customer_Id) 'Customer Count' FROM Sales.Customers 
GROUP BY State,City ORDER BY City,State;

-------------------Using GROUP BY clause with the MIN and MAX functions
-----Query to returns the minimum and maximum list prices of all products with the model 2018 by brand:
SELECT Brand_Name, MIN (Price)'Min Price', MAX (Price) 'Max Price'
FROM Production.Products p INNER JOIN Production.Brands b ON b.Brand_Id = p.Brand_Id
WHERE Model_Year = 2018 GROUP BY Brand_Name ORDER BY Brand_Name;

-------------------Using GROUP BY clause with the AVG() function
-----Query to return the average list price by brand for all products with the model year 2018:
SELECT Brand_Name, Cast(AVG (Price) As Decimal(10,2))'Average Price'
FROM Production.Products p INNER JOIN Production.Brands b ON b.Brand_Id = p.Brand_Id
WHERE Model_Year = 2018 GROUP BY Brand_Name ORDER BY Brand_Name;

-------------------Using GROUP BY clause with SUM function example
-----Query to use SUM() function to get the net value of every order
SELECT Order_Id, Cast(SUM (Quantity * Price * (1 - Discount)) As Decimal(10,2)) 'Net Value'
FROM  Sales.Order_Items GROUP BY Order_Id;


--========================================================================================================================================--
-------------------------------------- SQL Server SELECT – filter groups using Having Clause -----------------------------------------------
--========================================================================================================================================--
------------------------------ Using The Sales Customer Table For Having Clause
Select Count (*) As CustomerCount,City From Sales.Customers Where State = 'CA' Group By City Having Count (*) > 10 Order By City;
Select Count (*) As CustomerCount,City From Sales.Customers Where State = 'NY' Group By City Having Count (*) > 12 Order By City;

------------------------------ Using The Sales Orders Table For Having Clause
----Query to find the customers who placed at least two orders per year:
SELECT Customer_Id, YEAR (Order_Date) 'Ordered Year', COUNT (Order_Id) 'Order Count'
FROM Sales.Orders GROUP BY Customer_Id, YEAR (Order_Date) HAVING COUNT (Order_Id) >= 2
ORDER BY Customer_Id;

------------------------------ Using The Sales Order_Items Table For Having Clause
----Query to find the customers who placed at least two orders per year:
SELECT Order_Id, Cast(SUM (Quantity * Price * (1 - Discount)) As Decimal(10,2)) Net_Value
FROM Sales.Order_Items GROUP BY Order_Id HAVING SUM ( Quantity * Price * (1 - Discount) ) > 20000
ORDER BY Net_Value;

------------------------------ Using The Production Products Table For Having Clause
----- Query To find the maximum and minimum list prices in each product category. 
----- Then, to filters out the category which has the maximum list price greater than 4,000 or the minimum list price less than 500:
SELECT Category_Id, MAX (Price) 'Max Price',MIN (Price) 'Min Price'
FROM Production.Products GROUP BY Category_Id
HAVING MAX (Price) > 4000 OR MIN (price) < 500;

---------------SQL Server HAVING clause with AVG() function example
----- Query to find product categories whose average list prices are between 500 and 1,000:
SELECT Category_Id, Cast(AVG (Price) As Decimal(10,2)) 'Average Price'
FROM Production.Products GROUP BY Category_Id
HAVING AVG (Price) BETWEEN 500 AND 1000;

--=========================================================================================================================================--
------------------------------------------------------------------ SQL Server OFFSET FETCH --------------------------------------------------
--=========================================================================================================================================--
----------Using Production Products Table For Offset And Fetch
Select Product_Name, Price From Production.Products Order By Price, Product_Name;
----------To skip the first 10 products and return the rest
Select Product_Name, Price From Production.Products Order By Price, Product_Name Offset 10 Rows;
----------To skip the first 10 products and select the next 10 products
Select Product_Name, Price From Production.Products Order By Price, Product_Name Desc Offset 10 Rows Fetch First 10 Rows Only;
----------To get the top 10 most expensive products
Select Product_Name, Price From Production.Products Order By Price Desc, Product_Name Offset 0 Rows Fetch Next 10 Rows Only;

--==================================================================================================================================--
---------------------------------------------------------------SQL Server SELECT TOP -------------------------------------------------
--==================================================================================================================================--
-------------------Using TOP with a constant value
-------------------The following example uses a constant value to return the top 10 most expensive products.
Select Top 10 Product_Name, Price From Production.Products Order By Price Desc;

-------------------Using TOP to return a percentage of rows
Select Top 1 Percent Product_Name, Price From Production.Products Order By Price Desc;

-------------------Using TOP WITH And Without TIES to include rows that match the values in the last row
Select Top 3 Product_Name, Price From Production.Products Order By Price Desc;
Select Top 3 With Ties Product_Name, Price From Production.Products Order By Price Desc;

--===========================================================================================================================--
------------------------------------------------------SQL Server SELECT DISTINCT clause----------------------------------------
--============================================================================================================================--
------------------------------------Using Customer Table
----------------------DISTINCT one column example
----Will Return All Cities Of All Customers
Select City From Sales.Customers Order By City; 
----Will Return Distict Cities And Remove Duplicate Value
Select Distinct City From Sales.Customers Order By City; 

----------------------DISTINCT multiple columns example
Select City,State From Sales.Customers Order By City,State; 
Select Distinct City,State From Sales.Customers; 

----------------------DISTINCT with null values example
Select Distinct Phone,State From Sales.Customers Order By Phone; 
Select Distinct Phone From Sales.Customers Order By Phone; 

----------------------Distinct Vs Group By
Select City,State,Zip_code From Sales.Customers Group By City,State,Zip_code Order By City,State,Zip_code; 
Select Distinct City,State,Zip_code From Sales.Customers


--=====================================================================================================================--
----------------------------------------------------SQL Server WHERE clause----------------------------------------------
--=====================================================================================================================--
------------------------------ Using The Production Products Table

-----------Finding rows by using a simple equality
Select Product_Id, Product_Name, Category_Id, Model_Year, Price From Production.Products Where Category_Id = 2 Order By Price DESC;

-----------Finding rows that meet two conditions
Select Product_Id, Product_Name, Category_Id, Model_Year, Price From Production.Products Where Category_Id = 2 And Model_Year = 2018 Order By Price DESC;

-----------Finding rows by using a comparison operator
Select Product_Id, Product_Name, Category_Id, Model_Year, Price From Production.Products Where Price > 5499 And Model_Year = 2018 Order By Price DESC;

-----------Finding rows that meet any of two conditions
Select Product_Id, Product_Name, Category_Id, Model_Year, Price From Production.Products Where Price > 3000 Or Model_Year = 2018 Order By Price DESC;

-----------Finding rows with the value between two values
Select Product_Id, Product_Name, Category_Id, Model_Year, Price From Production.Products Where Price Between 1999.00 And 2999.99 Order By Price DESC;

-----------Finding rows that have a value in a list of values
Select Product_Id, Product_Name, Category_Id, Model_Year, Price From Production.Products Where Price In (299.99,369.99,489.99) Order By Price DESC;

-----------Finding rows whose values contain a string
Select Product_Id, Product_Name, Category_Id, Model_Year, Price From Production.Products Where Product_Name Like '%Cruiser%' Order By Price DESC;

--=====================================================================================================================--
----------------------------------------------------SQL Server NULL----------------------------------------------
--=====================================================================================================================--
--------------------------------------- Using Sales Customers table
----- The Where Condition Will Return Unkwown
Select Customer_Id, First_Name, Last_Name, Phone From Sales.Customers Where Phone = Null Order By First_Name, Last_Name;
----- The Where Condition Will Return True If Using (Is Null Operator)
Select Customer_Id, First_Name, Last_Name, Phone From Sales.Customers Where Phone Is Null Order By First_Name, Last_Name;
----- The Where Condition Will Return True If Using (Is Not Null Operator)
Select Customer_Id, First_Name, Last_Name, Phone From Sales.Customers Where Phone Is Not Null Order By First_Name, Last_Name;

--=====================================================================================================================--
----------------------------------------------------SQL Server AND operator	----------------------------------------------
--=====================================================================================================================--
--------------------------------------- Using Production Products Table
----- Using AND operator example
Select * From Production.Products Where Category_Id = 1 And Price > 400 Order By Price DESC;
----- Using multiple AND operators example
Select * From Production.Products Where Category_Id = 1 And Price > 400 And Brand_Id = 1 Order By Price DESC;
----- Using the AND operator with other logical operators
Select * From Production.Products Where Brand_Id = 1 Or Brand_Id = 2 And Price > 1000 Order By Price DESC;
Select * From Production.Products Where (Brand_Id = 1 Or Brand_Id = 2) And Price > 1000 Order By Price DESC;

--=====================================================================================================================--
----------------------------------------------------SQL Server Or operator	----------------------------------------------
--=====================================================================================================================--
--------------------------------------- Using Production Products Table
----- Using Or operator example
Select Product_Name,Price From Production.Products Where Price < 200 Or Price > 6000 Order By Price;
----- Using multiple Or operators example
Select Product_Name,Brand_Id From Production.Products Where Brand_Id = 1 Or Brand_Id = 2 Or Brand_Id = 4 Order By Brand_Id DESC;
Select Product_Name,Brand_Id From Production.Products Where Brand_Id In (1,2,4) Order By Brand_Id DESC;
----- Using OR operator with AND operator example
Select Product_Name,Brand_Id,Price From Production.Products Where Brand_Id = 1 Or Brand_Id = 2 And Price > 500 Order By Brand_Id DESC,Price;
Select Product_Name,Brand_Id,Price From Production.Products Where (Brand_Id = 1 Or Brand_Id = 2) And Price > 500 Order By Brand_Id DESC,Price;

--=====================================================================================================================--
----------------------------------------------------SQL Server In operator	----------------------------------------------
--=====================================================================================================================--
--------------Using SQL Server IN with a list of values example
Select Product_Name,Price From Production.Products Where Price In (89.99, 109.99, 159.99) Order By Price;
--------------Using SQL Server Not IN with a list of values example
Select Product_Name,Price From Production.Products Where Price Not In (89.99, 109.99, 159.99) Order By Price;
--------------Using SQL Server IN operator with a subquery example
-------The following query returns a list of product identification numbers of the products located in the store id one and has the quantity greater than or equal to 30
Select Product_Id From Production.Stocks Where Store_Id = 1 And Quantity >=30;

--=====================================================================================================================--
-----------------------------------------------------SQL Server subquery-------------------------------------------------
--=====================================================================================================================--
-------Using Above Query As Sub Query
Select Product_Name,Price From Production.Products Where Product_Id In ( Select Product_Id From Production.Stocks Where Store_Id = 1 And Quantity >=30 ) Order By Product_Name;

----------------------------- Using The Sales Orders And Customer Table
-----Query to find the sales orders of the customers located in New York
SELECT Order_Id,Order_Date,Customer_Id
FROM Sales.Orders WHERE Customer_Id IN ( SELECT Customer_Id FROM Sales.Customers WHERE City = 'New York')
ORDER BY Order_Date DESC;

---------- Nested Subqueries (Allow Upto 32 Nesting)
SELECT Product_Name, Price FROM Production.Products WHERE Price > (
	SELECT AVG (Price) FROM Production.Products WHERE Brand_Id IN (
		SELECT Brand_Id FROM Production.Brands WHERE Brand_Name = 'Strider' OR Brand_Name = 'Trek'
	)
) ORDER BY Price;

----------SQL Server subquery is used in place of an expression
SELECT Order_Id, Order_Date, (
	SELECT MAX (Price) FROM Sales.Order_Items i WHERE i.Order_Id = o.Order_Id) As 'Max Price'
FROM Sales.Orders o Order by Order_Date Desc;

----------SQL Server subquery is used with IN operator
SELECT Product_Id, Product_Name FROM Production.Products WHERE Category_Id IN (
	SELECT Category_Id FROM Production.Categories WHERE Category_Name = 'Mountain Bikes' OR Category_Name = 'Road Bikes'
);

---------SQL Server subquery is used with ALL operator
SELECT Product_Name, Price FROM Production.Products WHERE Price >= All (
	SELECT AVG (Price) FROM Production.Products GROUP BY Brand_Id
);

----------------SQL Server subquery is used with EXISTS or NOT EXISTS
----Query to finds the customers who bought products in 2017
SELECT Customer_Id, First_Name, Last_Name, City FROM Sales.customers c WHERE EXISTS ( 
	SELECT Customer_Id FROM Sales.Orders o WHERE o.Customer_Id = c.Customer_Id AND YEAR (Order_Date) = 2017
) ORDER BY First_Name,Last_Name;

----Query to finds the customers who didnt bought products in 2017
SELECT Customer_Id, First_Name, Last_Name, City FROM Sales.customers c WHERE NOT EXISTS ( 
	SELECT Customer_Id FROM Sales.Orders o WHERE o.Customer_Id = c.Customer_Id AND YEAR (Order_Date) = 2017
) ORDER BY First_Name,Last_Name;

-----------------SQL Server subquery in the FROM clause
SELECT AVG(Order_Count) 'Average Order Count By Staff' FROM (
SELECT  Staff_Id 'Staff Id', COUNT(Order_Id) As Order_Count FROM Sales.Orders
GROUP BY Staff_Id ) t;

--=====================================================================================================================--
----------------------------------------------------SQL Server Between operator	-----------------------------------------
--=====================================================================================================================--
----------------------------Using SQL Server BETWEEN with numbers example
Select Product_Id,Product_Name,Price From Production.Products Where Price Between 149.99 And 199.99 Order By Price;
Select Product_Id,Product_Name,Price From Production.Products Where Price Not Between 149.99 And 199.99 Order By Price;

----------------------------Using SQL Server BETWEEN with dates example
-----------Using Sales Order Table
Select Order_Id, Customer_Id, Order_Date, Order_Status From Sales.Orders Where Order_Date Between '20170115' And '20170117' Order By Order_Date;

--=====================================================================================================================--
----------------------------------------------------SQL Server LIKE operator overview	---------------------------------
--=====================================================================================================================--
------------------------Using Sales Customers Table
---------The % (percent) wildcard examples
Select Customer_Id,First_Name,Last_Name From Sales.Customers Where Last_Name Like 'z%' Order By First_Name;
Select Customer_Id,First_Name,Last_Name From Sales.Customers Where Last_Name Like '%er' Order By First_Name;
Select Customer_Id,First_Name,Last_Name From Sales.Customers Where Last_Name Like 't%s'Order By First_Name;

---------The _ (underscore) wildcard example
Select Customer_Id,First_Name,Last_Name From Sales.Customers Where Last_Name Like '_u%'Order By First_Name;

---------The [list of characters] wildcard example
Select Customer_Id,First_Name,Last_Name From Sales.Customers Where Last_Name Like '[YZ]%'Order By Last_Name;

---------The [character-character] wildcard example
Select Customer_Id,First_Name,Last_Name From Sales.Customers Where Last_Name Like '[A-C]%'Order By First_Name;

---------The [^Character List or Range] wildcard example
Select Customer_Id,First_Name,Last_Name From Sales.Customers Where Last_Name Like '[^A-X]%'Order By Last_Name;

---------The NOT LIKE operator example
Select Customer_Id,First_Name,Last_Name From Sales.Customers Where First_Name Not Like 'A%'Order By First_Name;

---------SQL Server LIKE with ESCAPE example
Select * From sales.feedbacks;
Select FeedBack_Id,Comment From Sales.Feedbacks Where Comment Like '%30%';
Select FeedBack_Id,Comment From Sales.Feedbacks Where Comment Like '%30!%%' Escape '!';

--=====================================================================================================================--
---------------------------------------------------- SQL Server column alias -------------------------------------------
--=====================================================================================================================--
Select Customer_Id,First_Name,Last_Name From Sales.Customers Order By First_Name;
Select Customer_Id, First_Name+' '+Last_Name As Full_Name From Sales.Customers Order By First_Name;
Select Customer_Id, First_Name+' '+Last_Name As 'Full Name' From Sales.Customers Order By First_Name;
Select Category_Name 'Product Category' From Production.Categories Order By Category_Name Desc;
Select Category_Name 'Product Category' From Production.Categories Order By 'Product Category' Desc;

-------------------SQL Server table alias
Select c.Customer_Id, First_Name, Last_Name, Order_Id
From Sales.Customers c Inner Join Sales.Orders o ON o.Customer_Id = c.Customer_Id;

--=====================================================================================================================--
----------------------------------------------------SQL Server correlated subquery---------------------------------------
--=====================================================================================================================--
---------------------------- Using The Production Products Table
----- Query to finds the products whose list price is equal to the highest list price of the products within the same category
SELECT Product_Name, Price, Category_Id FROM Production.Products p1 WHERE Price IN (
	SELECT MAX (Price) FROM Production.Products p2 WHERE p2.Category_Id = p1.Category_Id GROUP BY p2.Category_Id
) ORDER BY Category_Id,Product_Name;

--=====================================================================================================================--
----------------------------------------------------SQL Server EXISTS operator---------------------------------------
--=====================================================================================================================--
------Query to returns all rows from the  customers table
SELECT Customer_Id, First_Name, Last_Name FROM Sales.Customers WHERE
EXISTS (SELECT NULL) ORDER BY First_Name,Last_Name;

------Query to finds all customers who have placed more than two orders
SELECT Customer_Id, First_Name, Last_Name FROM Sales.Customers c WHERE EXISTS ( 
	SELECT COUNT (*) FROM Sales.Orders o WHERE Customer_Id = c.Customer_Id GROUP BY Customer_Id
        HAVING COUNT (*) > 2
) ORDER BY First_Name,Last_Name;

----------------------- In Vs Exist
SELECT * FROM Sales.Orders WHERE Customer_Id IN (
	SELECT Customer_Id FROM Sales.Customers WHERE City = 'San Jose'
) ORDER BY Customer_Id, Order_Date;

SELECT * FROM Sales.Orders o WHERE EXISTS (
	SELECT Customer_Id FROM Sales.Customers c WHERE o.Customer_Id = c.Customer_Id And City = 'San Jose'
) ORDER BY Customer_Id, Order_Date;

--=====================================================================================================================--
----------------------------------------------------SQL Server ANY operator---------------------------------------
--=====================================================================================================================--
----- Query to finds the products that were sold with more than two units in a sales order
SELECT Product_Name, Price FROM Production.Products WHERE Product_Id = ANY (
	SELECT Product_Id FROM Sales.Order_Items WHERE Quantity >= 2
) ORDER BY Product_Name;

--=====================================================================================================================--
----------------------------------------------------SQL Server All operator---------------------------------------
--=====================================================================================================================--
--------- Query to finds the products whose list prices are bigger than the average list price of products of all brands
SELECT Product_Name, Price FROM Production.Products WHERE Price > ALL (
	SELECT AVG (Price) avg_list_price FROM Production.Products GROUP BY Brand_Id
) ORDER BY Price;

---------- Query to finds the products whose list price is less than the smallest price in the average price list by brand
SELECT Product_Name, Price FROM Production.Products WHERE Price < ALL (
	SELECT AVG (Price) avg_list_price FROM Production.Products GROUP BY Brand_Id
) ORDER BY Price;