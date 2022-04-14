-----------------------------Welcome To The Employee PayRoll Service DataBase---------------------------------

------------------------------------------Create DB (UC1)-----------------------------------------------------
create database PayRoll_Service;
use PayRoll_Service;

-----------------------------------------Create Table (UC2)---------------------------------------------------
CREATE TABLE Employee_Payroll (
    Id int identity(1,1) primary key,
    Name varchar(255) not null,
    Salary float,
    StartDate date,
); 

---------------------------------------Insert Data Into DB Table(UC3)-------------------------------------------
INSERT INTO Employee_Payroll(Name,Salary,StartDate) VALUES ('Raj',40000.50, getdate()); 
INSERT INTO Employee_Payroll(Name,Salary,StartDate) VALUES ('Sona',32000.50, CAST('2020-04-17' as Date)); 
INSERT INTO Employee_Payroll(Name,Salary,StartDate) VALUES ('Nidhi',35000.50, CAST('2021-02-24' as Date)); 
INSERT INTO Employee_Payroll(Name,Salary,StartDate) 
VALUES ('Mansi',28000.50, CAST('2020-07-13' as Date)),
		('Neha',38000.50, CAST('2022-01-10' as Date)); 
INSERT INTO Employee_Payroll(Name,StartDate) VALUES ('Aman', getdate()); 
INSERT INTO Employee_Payroll VALUES ('Ajay',25000.50, CAST('2021-06-18' as Date)); 
INSERT INTO Employee_Payroll VALUES ('Omkar',20000.50, CAST('2020-12-15' as Date)); 
INSERT INTO Employee_Payroll VALUES ('Yash',22500.50, getdate()); 
INSERT INTO Employee_Payroll VALUES ('Sachin',18000.50, CAST('2020-07-17' as Date)); 
INSERT INTO Employee_Payroll VALUES ('Anand',28000.50, CAST('2021-01-13' as Date)); 
INSERT INTO Employee_Payroll VALUES ('Rahul',24000.50, CAST('2021-03-24' as Date));

----------------------------------Retreive All Records Using Select(UC4)-------------------------------------------
SELECT * FROM Employee_Payroll;
SELECT * FROM Employee_Payroll WHERE Name='Raj';
SELECT * FROM Employee_Payroll WHERE Salary>22000;
SELECT * FROM Employee_Payroll WHERE StartDate>'2020-07-17'

-------------------------------Retreive Particular Records Using Select(UC5)----------------------------------
SELECT Salary FROM Employee_Payroll WHERE NAME='Raj' 
SELECT Salary,Name FROM Employee_Payroll WHERE Name LIKE 'R%';
SELECT Salary,Name FROM Employee_Payroll WHERE StartDate between CAST('2021-03-24' as Date) and getdate(); 
SELECT Salary,Name FROM Employee_Payroll WHERE Salary between 22000 and 30000; 

-----------------------------------------Alter And Update Data(UC6)--------------------------------------------
ALTER TABLE Employee_Payroll ADD Gender	char(1);
UPDATE Employee_Payroll SET Gender='M' WHERE Id IN (1,6,7,8,9,10,11,12);
UPDATE Employee_Payroll SET Gender='F' WHERE Id IN (2,3,4,5);
UPDATE Employee_Payroll SET Salary=27000 WHERE Id IN (8);
UPDATE Employee_Payroll SET Salary=42000 WHERE Name = 'Raj';
UPDATE Employee_Payroll SET Salary=33000 WHERE Name = 'Aman';

-----------------------------------------Aggregate Functions(UC7)-----------------------------------------------
SELECT SUM(Salary) as TotalSalary from Employee_Payroll;
SELECT SUM(Salary) as TotalSalary,Gender from Employee_Payroll group by Gender;
SELECT MAX(Salary) as MaxEmployeeSalary from Employee_Payroll;
SELECT MAX(Salary) as MaxSalary,Gender from Employee_Payroll group by Gender;
SELECT MIN(Salary) as MinEmployeeSalary from Employee_Payroll;
SELECT MIN(Salary) as MinSalary,Gender from Employee_Payroll group by Gender;
SELECT CAST(AVG(Salary) as decimal(10,2)) as AvgEmployeeSalary from Employee_Payroll;
SELECT CAST(AVG(Salary) as decimal(10,2)) as AvgSalary,Gender from Employee_Payroll group by Gender;
SELECT Count(Name) as NumOfEmployee from Employee_Payroll;
SELECT Count(Name) as NumOfEmployee,Gender from Employee_Payroll group by Gender;

-------------------------------Adding Phone Number, Department And Address Columns(UC8)--------------------------------
ALTER TABLE Employee_Payroll ADD Department varchar(20) not null default 'IT Developer';
ALTER TABLE Employee_Payroll ADD PhoneNumber bigint;
UPDATE Employee_Payroll SET PhoneNumber=8945125478 where name='Raj';
UPDATE Employee_Payroll SET PhoneNumber=7894561230 where name='Sona';
UPDATE Employee_Payroll SET PhoneNumber=7412589630 where name='Nidhi';
UPDATE Employee_Payroll SET PhoneNumber=8521479630 where name='Neha';
UPDATE Employee_Payroll SET PhoneNumber=3214569870 where name='Mansi';
UPDATE Employee_Payroll SET PhoneNumber=6541237890 where name='Aman';
UPDATE Employee_Payroll SET PhoneNumber=8012345679 where name='Ajay';
UPDATE Employee_Payroll SET PhoneNumber=9578461203 where name='Omkar';
UPDATE Employee_Payroll SET PhoneNumber=9156478230 where name='Yash';
UPDATE Employee_Payroll SET PhoneNumber=9187456237 where name='Sachin';
UPDATE Employee_Payroll SET PhoneNumber=9874512458 where name='Anand';
UPDATE Employee_Payroll SET PhoneNumber=9874125630 where name='Rahul';
UPDATE Employee_Payroll SET Department='HR' where Id IN (1,2);
UPDATE Employee_Payroll SET Department='Finance' where Id IN (3,4);
UPDATE Employee_Payroll SET Department='IT Developer' where Id IN (5,6,7,8);
UPDATE Employee_Payroll SET Department='Testing' where Id IN (9,10);
UPDATE Employee_Payroll SET Department='QA' where Id IN (11,12);

-------------------------------------Adding column Address With Default Value---------------------------------------------
ALTER TABLE Employee_Payroll ADD Address varchar(255) default 'NIL';
UPDATE Employee_Payroll SET Address='Mumbai' WHERE Id IN (1,3,5,7);
UPDATE Employee_Payroll SET Address='Delhi' WHERE Id IN (2,4,6,8);
UPDATE Employee_Payroll SET Address='Banglore' WHERE Id IN (9,10,11,12);

----------------------------------------To Remove Column Containing Constraint------------------------------------------------ 
ALTER TABLE Employee_Payroll DROP COLUMN Address;
ALTER TABLE Employee_Payroll DROP CONSTRAINT [DF__Employee___Addre__267ABA7A];

-----------------Extended The Table With BasicPay,Deductions,TaxablePay,IncomeTax,NetPay Columns(UC9)-------------------------- 
---------Rename The Existing Column
EXEC SP_RENAME 'Employee_Payroll.Salary','BasicPay','COLUMN';
---------Adding Mutiple Columns
SELECT * FROM Employee_Payroll;
ALTER TABLE Employee_Payroll ADD Deductions float,TaxablePay float,IncomeTax float,NetPay float;
---------Updating Deductions Coulumn
UPDATE Employee_Payroll SET Deductions=500 WHERE Id IN (1,2);
UPDATE Employee_Payroll SET Deductions=1000 WHERE Id IN (3,4);
UPDATE Employee_Payroll SET Deductions=800 WHERE Id IN (5,6,7,8);
UPDATE Employee_Payroll SET Deductions=750 WHERE Id IN (9,10,11,12);
---------Updating NetPay Coulumn
UPDATE Employee_Payroll SET NetPay=38000 WHERE Id IN (1,5);
UPDATE Employee_Payroll SET NetPay=21000 WHERE Id IN (8,9,12);
UPDATE Employee_Payroll SET NetPay=30000 WHERE Id IN (2,3,6);
UPDATE Employee_Payroll SET NetPay=25000 WHERE Id IN (5,7,11);
UPDATE Employee_Payroll SET NetPay=17000 WHERE Id IN (4,10);
UPDATE Employee_Payroll SET NetPay = TaxablePay-IncomeTax;
---------Updating IncomeTax Coulumn
UPDATE Employee_Payroll SET IncomeTax=2499.99;
---------Updating TaxablePay Coulumn
UPDATE Employee_Payroll SET TaxablePay = BasicPay-Deductions;

---------------------------------------------Creating Unnecessary Redundancy(UC10)---------------------------------------------------
INSERT INTO Employee_Payroll VALUES('Raj',45000,'2021-02-24','M','Testing',8945125478,'Mumbai',800,4999.99,2499.99,42000);
SELECT * FROM Employee_Payroll WHERE Name = 'Raj';

--------------------------------------------------Recreate Using Er Diagram(UC11)-----------------------------------------------------
---------Creating Company Table
CREATE TABLE Company(
	CompanyId INT IDENTITY(1,1) PRIMARY KEY,
	CompanyName VARCHAR(100)
	);

---------Creating Deptartment table
CREATE TABLE Department(
	DepartmentId INT IDENTITY(1,1) PRIMARY KEY,
	DepartmentName VARCHAR(50)
);

---------Creating Employee Table
CREATE TABLE Employee(
	EmployeeId INT IDENTITY(1,1) PRIMARY KEY,
	CompanyId INT FOREIGN KEY REFERENCES Company(CompanyId),
	EmployeeName VARCHAR(30),
	PhoneNumber BIGINT,
	EmployeeAddress VARCHAR(50),
	StartDate DATE,
	Gender CHAR(1)
);

---------Creating Payroll Table
CREATE TABLE Payroll(
	EmployeeId INT FOREIGN KEY REFERENCES Employee(EmployeeId),
	BasicPay FLOAT,
	TaxablePay FLOAT,
	IncomeTax FLOAT,
	NetPay FLOAT,
	Deductions FLOAT
);

---------Creating Employee Department Table
create table EmployeeDepartment(
	EmployeeId int FOREIGN KEY REFERENCES Employee(EmployeeId),
	DepartmentId int FOREIGN KEY REFERENCES Department(DepartmentId),
);

---------Inserting Value Into Company Table
INSERT INTO Company VALUES('TCS'),('INFOSYS'),('WIPRO');
SELECT * FROM Company;

---------Inserting Value Into Department Table
INSERT INTO Department VALUES('HR'),('IT Developer'),('QA'),('Testing'),('Finance');
SELECT * FROM Department;

---------Inserting Value Into Employee Table
INSERT INTO Employee VALUES(1,'Rajkumar',9820456123,'NaviMumbai','2020-02-23','M');
INSERT INTO Employee VALUES(2,'Omkar',9874185296,'Mumbai','2021-03-15','M'),
						(3,'Ajay',9745612587,'Pune','2020-01-13','M'),
						(1,'Deepak',9587463214,'Gujarat','2019-05-17','M'),
						(2,'Dibin',9845687321,'Chennai','2020-07-25','M'),
						(3,'Rahul',9685475645,'Karnataka','2021-11-27','M'),
						(1,'Nidhi',9874561230,'Delhi','2022-01-17','F'),
						(2,'Mansi',9865741230,'Haryana','2021-02-19','F');
SELECT * FROM Employee;

---------Inserting Value Into Payroll Table
INSERT INTO Payroll(EmployeeId,BasicPay,IncomeTax,Deductions) Values (1,40000,1999.99,899.99),(8,50000,1999.99,899.99),(9,30000,1999.99,899.99),(10,25000,1999.99,899.99);
INSERT INTO Payroll(EmployeeId,BasicPay,IncomeTax,Deductions) Values (10,35000,1999.99,899.99),(11,45000,1999.99,899.99),(12,55000,1999.99,899.99),(13,65000,1999.99,899.99);
UPDATE Payroll SET EmployeeId = 14 where BasicPay = 35000;
---------Updating TaxablePay Based On BasicPay - Deductions
UPDATE Payroll SET TaxablePay = BasicPay-Deductions;
---------Updating Netpay Based On Taxablepay-incometax
UPDATE Payroll SET NetPay = TaxablePay-IncomeTax;
SELECT * FROM Payroll

---------Inserting Value Into Employee Department Table
INSERT INTO EmployeeDepartment VALUES(1,1),(8,2),(9,3),(10,4),(11,5),(12,1),(13,2),(14,3);
SELECT * FROM EmployeeDepartment;

---------------------------------Ensuring To Retrieve Records Using Queries From New Table Structure(UC12)----------------------------------------------
---------Retrieving All Records(UC4)
SELECT comp.CompanyID,comp.CompanyName,emp.EmployeeId,emp.EmployeeName,emp.PhoneNumber,emp.StartDate,emp.Gender,emp.EmployeeAddress,
pay.BasicPay,pay.TaxablePay,pay.IncomeTax,pay.NetPay,pay.Deductions,dep.DepartmentId,dep.DepartmentName
FROM Company AS comp
INNER JOIN Employee AS emp ON comp.CompanyId=emp.CompanyId
INNER JOIN Payroll AS pay ON pay.EmployeeId = emp.EmployeeId	
INNER JOIN EmployeeDepartment as empDep ON empDep.EmployeeId = emp.EmployeeId
INNER JOIN Department as dep ON dep.DepartmentId = empDep.DepartmentId;

---------Retriving Using Employee Name(UC5)
SELECT comp.CompanyID,comp.CompanyName,emp.EmployeeId,emp.EmployeeName,emp.PhoneNumber,emp.StartDate,emp.Gender
FROM Company AS comp
INNER JOIN Employee AS emp ON comp.CompanyId = emp.CompanyId AND emp.EmployeeName='Rajkumar';
---------Retrieve The Data From Startdate And Now(current date)(UC5)
SELECT comp.CompanyID,comp.CompanyName,emp.EmployeeId,emp.EmployeeName,emp.PhoneNumber,emp.StartDate,emp.Gender
FROM Company AS comp 
INNER JOIN Employee AS emp 
ON comp.CompanyId = emp.CompanyId AND emp.StartDate BETWEEN ('2020-11-11') AND getdate();

---------Performing Aggregate Functions Using Group By(UC7)
---------Aggregate Function Sum
SELECT SUM(pay.BasicPay) as TotalEmpSalary,emp.Gender
FROM Employee AS emp 
INNER JOIN Payroll as pay ON emp.EmployeeId = pay.EmployeeId GROUP BY Gender ORDER BY Gender DESC;
---------Aggregate Function Avg
SELECT CAST(AVG(pay.BasicPay) as decimal(10,2)) as AverageEmpSalary,emp.Gender
FROM Employee AS emp 
INNER JOIN Payroll as pay ON emp.EmployeeId = pay.EmployeeId GROUP BY Gender ORDER BY Gender DESC;
---------Aggregate Function Min
SELECT MIN(pay.BasicPay) as MinEmpSalary,emp.Gender 
FROM Employee AS emp 
INNER JOIN Payroll as pay ON emp.EmployeeId = pay.EmployeeId GROUP BY Gender ORDER BY Gender DESC;
---------Aggregate Function Max
SELECT MAX(pay.BasicPay) as MaxEmpSalary,emp.Gender 
FROM Employee AS emp 
INNER JOIN Payroll as pay ON emp.EmployeeId = pay.EmployeeId GROUP BY Gender ORDER BY Gender DESC;
---------Aggregate Function Count
SELECT COUNT(EmployeeName) as NumOfEmployee,Gender FROM Employee GROUP BY Gender ORDER BY Gender DESC;