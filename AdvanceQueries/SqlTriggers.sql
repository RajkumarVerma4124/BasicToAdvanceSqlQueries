-----------------------------Welcome To The BookStore DataBase---------------------------------

------------------------------------------ Using BikeStore DB
Use BikeStores;

--=================================================================================================================--
------------------------------------------------SQL Server Triggers------------------------------------------
--=================================================================================================================--
---------------------------------------------SQL Server CREATE TRIGGER------------------------------------------
--=================================================================================================================--
------------Creating a table for logging the changes
CREATE TABLE production.product_audits(
    change_id INT IDENTITY PRIMARY KEY,
    product_id INT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    model_year SMALLINT NOT NULL,
    list_price DEC(10,2) NOT NULL,
    updated_at DATETIME NOT NULL,
    operation CHAR(3) NOT NULL,
    CHECK(operation = 'INS' or operation='DEL')
);

------------Creating an after DML trigger
CREATE TRIGGER production.trg_product_audit
ON production.products
AFTER INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO production.product_audits(product_id, product_name, brand_id, category_id, model_year, list_price, updated_at, operation)
    SELECT i.product_id, product_name, brand_id, category_id, model_year, i.price, GETDATE(), 'INS'
    FROM inserted i UNION ALL
    SELECT d.product_id, product_name, brand_id, category_id, model_year, d.price, GETDATE(), 'DEL'
    FROM deleted d;
END

---------------Testing The Trigger
INSERT INTO production.products(product_name, brand_id, category_id, model_year, price)
VALUES ('Test product', 1, 1, 2018, 599);

---------------Examining the contents of the production.product_audits table after insertion into production.products
SELECT * FROM production.product_audits;

---------------Query to delete a row from the production.products table
DELETE FROM production.products WHERE product_id = 322;

--=================================================================================================================--
-----------------------------------------------SQL Server INSTEAD OF Trigger-----------------------------------------
--=================================================================================================================--

-----------Creating a new table named production.brand_approvals for storing pending approval brands
CREATE TABLE production.brand_approvals(
    brand_id INT IDENTITY PRIMARY KEY,
    brand_name VARCHAR(255) NOT NULL
);

----------- Creating a new view named production.vw_brands against the production.brands and production.brand_approvals tables
CREATE VIEW production.vw_brands 
AS
SELECT brand_name, 'Approved' approval_status
FROM production.brands
UNION
SELECT brand_name, 'Pending Approval' approval_status
FROM production.brand_approvals;

-----Once a row is inserted into the production.vw_brands view, 
-----we need to route it to the production.brand_approvals table via the following INSTEAD OF trigger
CREATE TRIGGER production.trg_vw_brands 
ON production.vw_brands
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO production.brand_approvals ( brand_name )
    SELECT i.brand_name FROM inserted i
    WHERE i.brand_name NOT IN ( SELECT brand_name FROM production.brands );
END

------The trigger inserts the new brand name into the production.brand_approvals 
------if the brand name does not exist in the production.brands.
------Inserting a new brand into the production.vw_brands view:
INSERT INTO production.vw_brands(brand_name) VALUES('Eddy Merckx');

------This INSERT statement fired the INSTEAD OF trigger to insert a new row into the production.brand_approvals table.
SELECT brand_name, approval_status FROM production.vw_brands;

------Query to show the contents of the production.brand_approvals table
SELECT * FROM production.brand_approvals;

--=================================================================================================================--
-----------------------------------------------SQL Server DDL Trigger-----------------------------------------
--=================================================================================================================--

----- Creating a new table named index_logs to log the index changes
CREATE TABLE index_logs (
    log_id INT IDENTITY PRIMARY KEY,
    event_data XML NOT NULL,
    changed_by SYSNAME NOT NULL
);
GO

---- Creating a DDL trigger to track index changes and insert events data into the index_logs table
CREATE TRIGGER trg_index_changes
ON DATABASE
FOR	
    CREATE_INDEX,
    ALTER_INDEX, 
    DROP_INDEX
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO index_logs (event_data,changed_by)
    VALUES ( EVENTDATA(), USER );
END;
GO

---- Creating indexes for the first_name and last_name columns of the sales.customers table
CREATE NONCLUSTERED INDEX nidx_fname
ON sales.customers(first_name);
GO

CREATE NONCLUSTERED INDEX nidx_lname
ON sales.customers(last_name);
GO

---- Checking whether the index creation event was captured by the trigger properly
SELECT * FROM index_logs;

--=================================================================================================================--
-----------------------------------------------SQL Server DISABLE TRIGGER-----------------------------------------
--=================================================================================================================--
---------------Creating a new table named sales.members
CREATE TABLE sales.members (
    member_id INT IDENTITY PRIMARY KEY,
    customer_id INT NOT NULL,
    member_level CHAR(10) NOT NULL
);

----- The following statement creates a trigger that is fired whenever a new row is inserted into the sales.members table
CREATE TRIGGER sales.trg_members_insert
ON sales.members
AFTER INSERT
AS
BEGIN
    PRINT 'A new member has been inserted';
END;

------ The following statement inserts a new row into the sales.members table
INSERT INTO sales.members(customer_id, member_level) VALUES(1,'Silver');

------Query To disable the sales.trg_members_insert trigger
DISABLE TRIGGER sales.trg_members_insert ON sales.members;

------ The following statement inserts a new row into the sales.members table
INSERT INTO sales.members(customer_id, member_level) VALUES(2,'Gold');

----- The following statement creates a trigger that is fired whenever a new row is delted into the sales.members table
CREATE TRIGGER sales.trg_members_delete
ON sales.members
AFTER DELETE
AS
BEGIN
    PRINT 'A new member has been deleted';
END;

------ Disable all trigger on a table
DISABLE TRIGGER ALL ON sales.members;

------ Disable all triggers on a database
DISABLE TRIGGER ALL ON DATABASE;

--=================================================================================================================--
-----------------------------------------------SQL Server ENABLE TRIGGER-----------------------------------------
--=================================================================================================================--
-----Query to enable the sales.sales.trg_members_insert trigger
ENABLE TRIGGER sales.trg_members_insert
ON sales.members;

----- Enable all triggers of a table
ENABLE TRIGGER ALL ON sales.members;

----- Enable all triggers of a database
ENABLE TRIGGER ALL ON DATABASE; 

--=================================================================================================================--
-------------------------------------------SQL Server View Trigger Definition---------------------------------------
--=================================================================================================================--
-------Getting trigger definition by querying from a system view
SELECT definition FROM sys.sql_modules WHERE object_id = OBJECT_ID('sales.trg_members_delete'); 

-------Getting trigger definition using OBJECT_DEFINITION function
SELECT OBJECT_DEFINITION ( OBJECT_ID( 'sales.trg_members_delete' )) AS trigger_definition;

-------Getting trigger definition using sp_helptext stored procedure
EXEC sp_helptext 'sales.trg_members_delete' ;

--=================================================================================================================--
-------------------------------------------SQL Server List All Triggers---------------------------------------
--=================================================================================================================--
------ To list all triggers in a SQL Server, you query data from the sys.triggers view
SELECT name, is_instead_of_trigger FROM sys.triggers WHERE type = 'TR';

--=================================================================================================================--
-------------------------------------------SQL Server Drop Triggers---------------------------------------
--=================================================================================================================--

---- SQL Server DROP TRIGGER – drop a DML trigger
DROP TRIGGER IF EXISTS sales.trg_member_insert;

---- SQL Server DROP TRIGGER – drop a DDL trigger
DROP TRIGGER IF EXISTS trg_index_changes;



