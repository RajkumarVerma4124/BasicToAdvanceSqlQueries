-----------------------------Welcome To The BookStore DataBase---------------------------------

------------------------------------------ Using BikeStore DB
Use BikeStores;

--=================================================================================================================--
------------------------------------------------SQL Server INSERT statement------------------------------------------
--=================================================================================================================--

---------------SQL Server INSERT statement examples
CREATE TABLE sales.promotions (
    promotion_id INT PRIMARY KEY IDENTITY (1, 1),
    promotion_name VARCHAR (255) NOT NULL,
    discount NUMERIC (3, 2) DEFAULT 0,
    start_date DATE NOT NULL,
    expired_date DATE NOT NULL
); 

---------------Basic INSERT example
INSERT INTO sales.promotions ( promotion_name,discount,start_date,expired_date)
VALUES('2018 Summer Promotion',0.15,'20180601','20180901');

---------------Insert and return inserted values
INSERT INTO sales.promotions ( promotion_name, discount, start_date,expired_date) 
OUTPUT inserted.promotion_id
VALUES('2018 Fall Promotion',0.15,'20181001','20181101');

INSERT INTO sales.promotions (promotion_name,discount,start_date,expired_date) 
OUTPUT inserted.promotion_id, inserted.promotion_name,inserted.discount,inserted.start_date,inserted.expired_date
VALUES('2018 Winter Promotion',0.2,'20181201','20190101');

-------------------------Insert explicit values into the identity column
SET IDENTITY_INSERT sales.promotions ON;
INSERT INTO sales.promotions (promotion_id,promotion_name,discount,start_date,expired_date) 
OUTPUT inserted.promotion_id
VALUES(4,'2019 Spring Promotion',0.25,'20190201','20190301');
SET IDENTITY_INSERT sales.promotions OFF;

------------------------Inserting multiple rows and returning the inserted id list example
INSERT INTO sales.promotions ( promotion_name, discount, start_date, expired_date)
OUTPUT inserted.promotion_id
VALUES ('2020 Summer Promotion',0.25,'20200601','20200901'),
	('2020 Fall Promotion',0.10,'20201001','20201101'),
	('2020 Winter Promotion', 0.25,'20201201','20210101');
SELECT * FROM sales.promotions;

--=================================================================================================================--
------------------------------------------Server INSERT INTO SELECT examples-----------------------------------------
--=================================================================================================================--
---------Creating a table named addresses
CREATE TABLE sales.addresses (
    address_id INT IDENTITY PRIMARY KEY,
    street VARCHAR (255) NOT NULL,
    city VARCHAR (50),
    state VARCHAR (25),
    zip_code VARCHAR (5)
);   

-----------Insert all rows from another table example
INSERT INTO sales.addresses (street, city, state, zip_code) 
SELECT street,city,state,zip_code FROM sales.customers
ORDER BY first_name, last_name; 

------------Insert some rows from another table example
INSERT INTO sales.addresses (street, city, state, zip_code) 
SELECT street,city,state,zip_code FROM sales.customers
WHERE city IN ('Santa Cruz', 'Baldwin')

------------To delete all rows from the addresses table
TRUNCATE TABLE sales.addresses;

------------------- Insert the top N of rows
INSERT TOP (10) 
INTO sales.addresses (street, city, state, zip_code) 
SELECT street, city, state, zip_code FROM sales.customers
ORDER BY first_name,last_name;

--------------------Insert the top percent of rows
INSERT TOP (10) PERCENT
INTO sales.addresses (street, city, state, zip_code) 
SELECT street, city, state, zip_code FROM sales.customers
ORDER BY first_name,last_name;

SELECT * FROM sales.addresses;

