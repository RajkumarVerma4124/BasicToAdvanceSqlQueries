-----------------------------Welcome To The BookStore DataBase---------------------------------

------------------------------------------ Using BikeStore DB
Use BikeStores;

--=================================================================================================================--
------------------------------------------------SQL Server Clustered Indexes------------------------------------------
--=================================================================================================================--

-------------------------Creating Table
CREATE TABLE production.parts(
    part_id INT NOT NULL, 
    part_name VARCHAR(100)
);

-------------------------Inserting some rows into the production.parts table
INSERT INTO production.parts(part_id, part_name)
VALUES (1,'Frame'),
    (2,'Head Tube'),
    (3,'Handlebar Grip'),
    (4,'Shock Absorber'),
    (5,'Fork');

-------------- Retreive Records Of Unordered Structure
SELECT part_id, part_name FROM production.parts WHERE part_id = 5;

-----Creating a new table named production.part_prices with a primary key that includes two columns: part_id and valid_from
CREATE TABLE production.part_prices(
    part_id int,
    valid_from date,
    price decimal(18,4) not null,
    PRIMARY KEY(part_id, valid_from) 
);

-----Query to defines a primary key for the production.parts table
ALTER TABLE production.parts
ADD PRIMARY KEY(part_id);

--------------------------------Using SQL Server CREATE CLUSTERED INDEX statement to create a clustered index.
-----Query to create a clustered index for the production.parts table
CREATE CLUSTERED INDEX ix_parts_id
ON production.parts (part_id);  

-------------- Retreive Records Of Unordered Structure
SELECT part_id, part_name FROM production.parts WHERE part_id = 5;

--=================================================================================================================--
------------------------------------------------SQL Server Non Clustered Indexes------------------------------------
--=================================================================================================================--

--Query to finds customers who locate in Atwater
SELECT customer_id, city FROM sales.customers WHERE city = 'Atwater';

--To improve the speed of the above query, creating a new index named ix_customers_city for the city column
------Using Sales.Customer Tables Which is a clustered Table
------Using the SQL Server CREATE INDEX statement to create a nonclustered index for one column
CREATE INDEX ix_customers_city
ON sales.customers(city);

--Query to finds the customer whose last name is Berg and first name is Monika
SELECT customer_id, first_name, last_name FROM sales.customers WHERE last_name = 'Berg' AND first_name = 'Monika';

-- Using SQL Server CREATE INDEX statement to create a nonclustered index for multiple columns
CREATE INDEX ix_customers_name 
ON sales.customers(last_name, first_name);

-----------------
SELECT customer_id, first_name, last_name FROM sales.customers WHERE last_name = 'Albert';
SELECT customer_id, first_name, last_name FROM sales.customers WHERE first_name = 'Adam';

--=================================================================================================================--
--------------------------------------------------SQL Server Rename Index-------------------------------------------
--=================================================================================================================--
-------Renaming non clusteres index
EXEC sp_rename 
        @objname = N'sales.customers.ix_customers_city',
        @newname = N'ix_cust_city' ,
        @objtype = N'INDEX';

--------In Short
EXEC sp_rename 
        N'sales.customers.ix_cust_city',
        N'ix_customer_city' ,
        N'INDEX';

--=================================================================================================================--
--------------------------------------------SQL Server unique index overview-----------------------------------------
--=================================================================================================================--
-------Creating a SQL Server unique index for the email column
CREATE UNIQUE INDEX ix_cust_email 
ON sales.customers(email);

--This query finds the customer with the email 'caren.stephens@msn.com'
SELECT customer_id, email FROM sales.customers WHERE email = 'caren.stephens@msn.com';
--Query to check duplicate values in the email column first:
SELECT email, COUNT(email) FROM sales.customers GROUP BY email HAVING COUNT(email) > 1;

-----------------------Creating a SQL Server unique index for multiple columns
---- Creating a table named t1 that has two columns
CREATE TABLE t1 (
    a INT, 
    b INT
);

---- create a unique index that includes both a and b columns
CREATE UNIQUE INDEX ix_uniq_ab 
ON t1(a, b);

---- Inserting a new row into the t1 table
-----No Duplicate Data In Unique Index
INSERT INTO t1(a,b) VALUES(1,1);
INSERT INTO t1(a,b) VALUES(1,2);
INSERT INTO t1(a,b) VALUES(1,2);

---------------------------SQL Server unique index and NULL
CREATE TABLE t2(
    a INT
);

CREATE UNIQUE INDEX a_uniq_t2
ON t2(a);
-----Only One Null Is Allowed In Unique Index
INSERT INTO t2(a) VALUES(NULL);
INSERT INTO t2(a) VALUES(NULL);

--=================================================================================================================--
--------------------------------------------SQL Server Disable Indexes-----------------------------------------
--=================================================================================================================--
--------------Disabling an index
ALTER INDEX ix_customer_city 
ON sales.customers 
DISABLE;

---------As a result, the following query, which finds customers who locate in San Jose , cannot leverage the disabled index
SELECT first_name, last_name, city FROM sales.customers WHERE city = 'San Jose';

---------------Disabling all indexes of a table example
ALTER INDEX ALL ON sales.customers
DISABLE;

--Hence, you cannot access data in the table anymore.
SELECT * FROM sales.customers;

--=================================================================================================================--
--------------------------------------------SQL Server Enables Indexes-----------------------------------------
--=================================================================================================================--
------------------Enable index using ALTER INDEX and CREATE INDEX statements
-------To enable all indexes on the sales.customers table from the sample database
ALTER INDEX ALL ON sales.customers
REBUILD;

------To enable or rebuild an index on a table
ALTER INDEX ix_customer_city 
ON sales.customers  
REBUILD;

--=================================================================================================================--
-----------------------------------------------------Drop Indexes---------------------------------------------------
--=================================================================================================================--
------------------------SQL Server DROP INDEX statement 

-----------Using SQL Server DROP INDEX to remove one index
DROP INDEX IF EXISTS ix_cust_email
ON sales.customers;

----------Using SQL Server DROP INDEX to remove multiple indexes example
DROP INDEX 
    ix_customer_city ON sales.customers,
    ix_customers_name ON sales.customers;

------------------------------------SQL Server Indexes with Included Columns--------------------------------------------
SELECT first_name, last_name, email FROM  sales.customers WHERE email = 'aide.franco@msn.com';

--After Dropping ix_cust_email created a new index ix_cust_email_inc that includes two columns first name and last name
CREATE UNIQUE INDEX ix_cust_email_inc
ON sales.customers(email)
INCLUDE(first_name,last_name);
