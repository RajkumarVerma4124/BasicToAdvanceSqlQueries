-----------------------------Welcome To The BookStore DataBase---------------------------------

------------------------------------------ Using BikeStore DB
Use BikeStores;

--=================================================================================================================--
------------------------------------------------SQL Server Stored Procedure------------------------------------------
--=================================================================================================================--

------------------ Creating a stored procedure
CREATE PROCEDURE spProductList
AS
BEGIN
    SELECT product_name, price FROM production.products ORDER BY product_name;
END;

----------------- Modifying A Stored Procedure
ALTER PROCEDURE spProductList
AS
BEGIN
    SELECT product_name, price FROM production.products ORDER BY Price; 
END;

----------------- For Executing Stored Procedure
EXEC spProductList;

----------------- Deleting a stored procedure
DROP PROCEDURE spProductList;

--=================================================================================================================--
---------------------------------------------SQL Server Stored Procedure Parameters----------------------------------
--=================================================================================================================--
Create PROCEDURE spFindProducts
AS
BEGIN
    SELECT product_name, price FROM production.products ORDER BY Price; 
END;

----------Adding a parameter to the stored procedure to find the products whose list prices are greater than an input price
ALTER PROCEDURE spFindProducts(@min_price AS DECIMAL)
AS
BEGIN
    SELECT product_name,price FROM production.products WHERE Price >= @min_price
    ORDER BY Price;
END;

----------------- For Executing Stored Procedure
EXEC spFindProducts 200;

----------------- Creating a stored procedure with multiple parameters
ALTER PROCEDURE spFindProducts(
    @min_price AS DECIMAL,
    @max_price AS DECIMAL
)
AS
BEGIN
    SELECT product_name,price FROM production.products WHERE price >= @min_price AND price <= @max_price
    ORDER BY price;
END;

----------------- For Executing Stored Procedure
EXEC spFindProducts 900, 1000;

------------------Exec Using named parameters
EXECUTE spFindProducts 
    @min_price = 900, 
    @max_price = 1000;

------------------Creating text parameters
ALTER PROCEDURE spFindProducts(
    @min_price AS DECIMAL
    ,@max_price AS DECIMAL
    ,@name AS VARCHAR(max)
)
AS
BEGIN
    SELECT product_name,price FROM production.products 
	WHERE price >= @min_price AND price <= @max_price AND product_name LIKE '%'+@name+'%'
    ORDER BY price;
END;

------------------Exec Using named parameters
EXECUTE spFindProducts 
    @min_price = 900, 
    @max_price = 1000,
    @name = 'Trek';

------------------Creating optional parameters
ALTER PROCEDURE spFindProducts(
    @min_price AS DECIMAL = 0
    ,@max_price AS DECIMAL = 999999
    ,@name AS VARCHAR(max)
)
AS
BEGIN
    SELECT product_name,price FROM production.products 
	WHERE price >= @min_price AND price <= @max_price AND product_name LIKE '%'+@name+'%'
    ORDER BY price;
END;

------------------Exec Using named parameters
EXECUTE spFindProducts 
    @name = 'Trek';
EXECUTE spFindProducts 
    @min_price = 6000,
    @name = 'Trek';

-------------------Using NULL as the default value
ALTER PROCEDURE spFindProducts(
    @min_price AS DECIMAL = 0
    ,@max_price AS DECIMAL = NULL
    ,@name AS VARCHAR(max)
)
AS
BEGIN
    SELECT product_name,price FROM production.products 
	WHERE price >= @min_price AND (@max_price IS NULL OR price <= @max_price) AND product_name LIKE '%' + @name + '%'
    ORDER BY price;
END;

------------------Exec Using named parameters
EXECUTE spFindProducts 
    @min_price = 500,
    @name = 'Haro';

--=================================================================================================================--
---------------------------------------------SQL Server Stored Procedure Variables----------------------------------
--=================================================================================================================--

------Declare Multiple variables
DECLARE @model_year As SMALLINT; 
-------Assigning a value to a variable
SET @model_year = 2018;

-------Using variables in a query
SELECT product_name,model_year,price FROM production.products
WHERE model_year = @model_year
ORDER BY product_name;

-------Storing query result in a variable
DECLARE @product_count INT;
	SET @product_count = (SELECT COUNT(*) FROM production.products 
);
-------Output the content of the @product_count variable
--SELECT @product_count;
--PRINT @product_count;
PRINT 'The number of products is ' + CAST(@product_count AS VARCHAR(MAX));

--------------------------------Selecting a record into variables
--Declare variables that hold the product name and list price
DECLARE 
    @product_name VARCHAR(MAX),
    @list_price DECIMAL(10,2);
--Then assign the column names to the corresponding variables
SELECT 
    @product_name = product_name,
    @list_price = price
FROM
    production.products
WHERE
    product_id = 100;
--output the content of the variables
SELECT 
    @product_name AS product_name, 
    @list_price AS list_price;

-------------------------------Accumulating values into a variable
CREATE  PROC uspGetProductList(@model_year SMALLINT) 
AS 
BEGIN
    DECLARE @product_list VARCHAR(MAX);
    SET @product_list = '';
    SELECT @product_list = @product_list + product_name + CHAR(10)
    FROM production.products WHERE model_year = @model_year
    ORDER BY product_name;
    PRINT @product_list;
END;
EXEC uspGetProductList 2018

--=================================================================================================================--
---------------------------------------------Stored Procedure Output Parameters--------------------------------------
--=================================================================================================================--
CREATE PROCEDURE uspFindProductByModel (
	@model_year SMALLINT,
    @product_count INT OUTPUT
) AS
BEGIN
    SELECT product_name,price FROM production.products WHERE model_year = @model_year;
    SELECT @product_count = @@ROWCOUNT;
END;

------Excecuting Stored Procedure
DECLARE @count INT;
EXEC uspFindProductByModel
    @model_year = 2018,
    @product_count = @count OUTPUT;
SELECT @count AS 'Number of products found';

--=================================================================================================================--
------------------------------------------------------SQL Server BEGIN END-------------------------------------------
--=================================================================================================================--
BEGIN
    SELECT product_id,product_name FROM production.products WHERE price > 100000;
    IF @@ROWCOUNT = 0
        PRINT 'No product with price greater than 100000 found';
END

---------------------Nesting BEGIN... END
BEGIN
    DECLARE @name VARCHAR(MAX);
    SELECT TOP 1 @name = product_name FROM production.products ORDER BY price DESC;
    IF @@ROWCOUNT <> 0
    BEGIN
        PRINT 'The most expensive product is ' + @name
    END
    ELSE
    BEGIN
        PRINT 'No product found';
    END;
END

--=================================================================================================================--
---------------------------------------------------SQL Server IF ELSE-----------------------------------------------
--=================================================================================================================--
---------------------If Condition
BEGIN
    DECLARE @sales INT;
    SELECT @sales = SUM(price * quantity)
    FROM sales.order_items i
    INNER JOIN sales.orders o ON o.order_id = i.order_id
    WHERE YEAR(order_date) = 2018;
    SELECT @sales;
    IF @sales > 1000000
    BEGIN
        PRINT 'Great! The sales amount in 2018 is greater than 1,000,000';
    END
END
---------------------If Else Condition
BEGIN
    DECLARE @sales INT;
    SELECT @sales = SUM(price * quantity) FROM sales.order_items i
    INNER JOIN sales.orders o ON o.order_id = i.order_id
    WHERE YEAR(order_date) = 2017;
    SELECT @sales;
    IF @sales > 10000000
    BEGIN
        PRINT 'Great! The sales amount in 2018 is greater than 10,000,000';
    END
    ELSE
    BEGIN
        PRINT 'Sales amount in 2017 did not reach 10,000,000';
    END
END

-----------------------------Nested IF...ELSE
BEGIN
    DECLARE @x INT = 10,
            @y INT = 20;
    IF (@x > 0)
    BEGIN
        IF (@x < @y)
            PRINT 'x > 0 and x < y';
        ELSE
            PRINT 'x > 0 and x >= y';
    END			
END

--=================================================================================================================--
---------------------------------------------------SQL Server While-----------------------------------------------
--=================================================================================================================--

------------------------------ Using While
DECLARE @counter INT = 1;
WHILE @counter <= 5
BEGIN
    PRINT @counter;
    SET @counter = @counter + 1;
END

--=================================================================================================================--
---------------------------------------------------SQL Server Break-----------------------------------------------
--=================================================================================================================--
DECLARE @counter INT = 0;
WHILE @counter <= 5
BEGIN
    SET @counter = @counter + 1;
    IF @counter = 4
        BREAK;
    PRINT @counter;
END

--=================================================================================================================--
---------------------------------------------------SQL Server Continue-----------------------------------------------
--=================================================================================================================--
DECLARE @counter INT = 0;
WHILE @counter < 5
BEGIN
    SET @counter = @counter + 1;
    IF @counter = 3
        CONTINUE;	
    PRINT @counter;
END

--=================================================================================================================--
---------------------------------------------------SQL Server Cursor-----------------------------------------------
--=================================================================================================================--
DECLARE 
    @product_name VARCHAR(MAX), 
    @price DECIMAL;
DECLARE cursor_product CURSOR
FOR SELECT product_name, price FROM production.products;
OPEN cursor_product;
FETCH NEXT FROM cursor_product INTO @product_name, @price;
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @product_name + CAST(@price AS varchar);
    FETCH NEXT FROM cursor_product INTO @product_name, @price;
END;
CLOSE cursor_product;
DEALLOCATE cursor_product;

--=================================================================================================================--
---------------------------------------------------SQL Server Try Catch-----------------------------------------------
--=================================================================================================================--
CREATE PROC usp_divide(
    @a decimal,
    @b decimal,
    @c decimal output
) AS
BEGIN
    BEGIN TRY
        SET @c = @a / @b;
    END TRY
    BEGIN CATCH
        SELECT  
            ERROR_NUMBER() AS ErrorNumber  
            ,ERROR_SEVERITY() AS ErrorSeverity  
            ,ERROR_STATE() AS ErrorState  
            ,ERROR_PROCEDURE() AS ErrorProcedure  
            ,ERROR_LINE() AS ErrorLine  
            ,ERROR_MESSAGE() AS ErrorMessage;  
    END CATCH
END;
GO

-----Testing above stored procedure to divide 10 by 2
DECLARE @r decimal;
EXEC usp_divide 10, 2, @r output;
PRINT @r;

-----Testing above stored procedure to divide 20 by 0
DECLARE @r2 decimal;
EXEC usp_divide 20, 0, @r2 output;
PRINT @r2;

--=================================================================================================================--
----------------------------------------SQL Server TRY CATCH with transactions---------------------------------------
--=================================================================================================================--
------------------Creating Table
CREATE TABLE sales.persons
(
    person_id  INT
    PRIMARY KEY IDENTITY, 
    first_name NVARCHAR(100) NOT NULL, 
    last_name  NVARCHAR(100) NOT NULL
);

CREATE TABLE sales.deals
(
    deal_id   INT
    PRIMARY KEY IDENTITY, 
    person_id INT NOT NULL, 
    deal_note NVARCHAR(100), 
    FOREIGN KEY(person_id) REFERENCES sales.persons(
    person_id)
);

------------------Inserting Values Into Table
insert into sales.persons(first_name, last_name) values ('John','Doe'),('Jane','Doe');
insert into sales.deals(person_id, deal_note) values (1,'Deal for John Doe');

--Create a new stored procedure that will be used in a CATCH block to report the detailed information of an error
CREATE PROC usp_report_error
AS
    SELECT   
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_LINE () AS ErrorLine  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_MESSAGE() AS ErrorMessage;  
GO

--Created a new stored procedure that deletes a row from the sales.persons table
CREATE PROC usp_delete_person(@person_id INT) 
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        -- delete the person
        DELETE FROM sales.persons 
        WHERE person_id = @person_id;
        -- if DELETE succeeds, commit the transaction
        COMMIT TRANSACTION;  
    END TRY
    BEGIN CATCH
        -- report exception
        EXEC usp_report_error;    
        -- Test if the transaction is uncommittable.  
        IF (XACT_STATE()) = -1  
        BEGIN  
            PRINT  N'The transaction is in an uncommittable state.' + 'Rolling back transaction.'  
            ROLLBACK TRANSACTION;  
        END;  
 
        -- Test if the transaction is committable.  
        IF (XACT_STATE()) = 1  
        BEGIN  
            PRINT N'The transaction is committable.' + 'Committing transaction.'  
            COMMIT TRANSACTION;     
        END;  
    END CATCH
END;
GO

-------------Exec Above Stored Procedure
EXEC usp_delete_person 2;
EXEC usp_delete_person 1;


