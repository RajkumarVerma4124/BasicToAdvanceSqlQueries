-----------------------------Welcome To The Employee PayRoll Service DataBase---------------------------------

------------------------------------------ Create And Use DB
CREATE DATABASE Sales;
use Sales;

--------------------------------------- Insert Data Into DB Table

-------------Insert Data Into DB Table Using Coulmn Name
Insert Into Customer(First_Name, Last_Name,Email_Id, Address,City,State,Zip_Code) 
	Values ('Debra', 'Burks', 'debra.burks@yahoo.com', '9273 Thorne Ave', 'Orchard Park', 'NY', 14127),
	('Kasha', 'Todd', 'kasha.todd@yahoo.com', '910 Vine Street', 'Campbell', 'CA', 95008),
	('Tameka', 'Fisher', 'Tameka.fisher@aol.com', '769C Honey Creek', 'RedondoBesch', 'CA', 50278),
	('Daryl', 'Spence', 'daryl.spence@aol.com', '988 Pear Lane', 'Uniondale', 'NY', 115583),
	('John', 'Mitchell', 'john.mitchell@gmail.com', '971 Grain Creek', 'Bloomingdale', 'CA', 115583),
	('Lyndsey', 'Bean', 'lyndsey.bean@hotmail.com', '769 West Road', 'Faiport', 'NY', 14450),
	('Jecquline', 'Duncan', 'jacquline.duncan@yahoo.com', '15 Brown St.', 'Jackson Heights', 'NY', 11372),
	('Genoveva ', 'Baldwin', 'genoveva.baldwin@msn.com', '8550 Spruce Drive', 'Pot Washington', 'NY', 11050),
	('Pamelia', 'Newman', 'pamelia.newman@gmail.com', '476 Chestrut Ave', 'Monroe', 'NY', 10950);

-------------Insert Data Into DB Table Using Default Values According To Table Columns
Insert Into Customer Values	('Charolette', 'Rice', 9163816003, 'charolette.rice@msn.com', '107 River Dr.', 'Sacramento', 'CA', 14127, 'F'),
		('Latasha', 'Hayes', 7169863359, 'latasha.hayes@msn.com', '7014 Manor Station Rd.', 'Buffalo', 'NY', 14215, 'F');

--------------------------------------------------------- Updating Table
Update Customer Set Gender='M' Where Customer_Id IN (6,7,8);
Update Customer Set Gender='F' Where Customer_Id IN (4,5,9,10,11,12);

--------------------------------------- Various Ways To Access Tables And Sort Result
Select * From Sales.dbo.Customer Where State = 'CA';
Select * From Customer Where State = 'CA';
Select * From dbo.Customer Where State = 'CA';

--------------------------------------- Order By Clause
Select * From dbo.Customer Where State = 'CA' Order By First_Name;
Select * From dbo.Customer Where State = 'NY' Order By First_Name;
Select * From dbo.Customer Where Gender = 'F' Order By First_Name;
Select * From dbo.Customer Order By Zip_Code;
Select * From dbo.Customer Order By Zip_Code Desc;
SELECT * FROM Customer ORDER BY First_name ASC, Last_Name DESC;
-------------- Sort a result set by one column in ascending order
SELECT First_Name, Last_Name FROM dbo.Customer ORDER BY first_name;
-------------- Sort a result set by one column in descending order
SELECT First_Name, Last_Name FROM dbo.Customer ORDER BY first_name Desc;
-------------- Sort a result set by multiple columns
SELECT City, First_Name, Last_Name FROM dbo.Customer ORDER BY city,first_name;
-------------- Sort a result set by multiple columns and different orders
SELECT City, First_Name, Last_Name FROM dbo.Customer ORDER BY city Desc,first_name Asc;
-------------- Sort a result set by a column that is not in the select list
SELECT City, First_Name, Last_Name FROM dbo.Customer ORDER BY state Desc;
-------------- Sort a result set by an expression
SELECT First_Name, Last_Name FROM dbo.Customer ORDER BY LEN(First_Name);
-------------- Sort by ordinal positions of columns
SELECT First_Name, Last_Name FROM dbo.Customer ORDER BY 1,2;

--------------------------------------------------------- SQL OFFSET FETCH --------------------------------------------------

--------------------------------------- Group By
SELECT City, COUNT (*) FROM customer WHERE state = 'CA' GROUP BY City ORDER BY City;
SELECT State, COUNT (*) FROM customer GROUP BY State ORDER BY State DESC;
SELECT COUNT (Customer_Id) As StateCount,State FROM customer GROUP BY State ORDER BY State DESC;
SELECT Gender, COUNT (*) FROM customer GROUP BY Gender ORDER BY Gender DESC;
SELECT COUNT(Customer_Id) As CustomerCount,Gender FROM customer GROUP BY Gender ORDER BY Gender DESC;

--------------------------------------- Having Clause
SELECT COUNT (Customer_Id) As StateCount,State FROM sales.dbo.Customer GROUP BY State HAVING COUNT (*) < 5 ORDER BY state Desc;
SELECT COUNT (Customer_Id) As StateCount,State FROM sales.dbo.Customer GROUP BY State HAVING COUNT (*) > 5 ORDER BY state Desc;
