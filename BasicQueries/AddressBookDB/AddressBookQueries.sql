------------------------------Welcome To The AddressBook Service DataBase---------------------------------

---------------------------------Creating The Database AddressBook(UC1)----------------------------------
Create Database AddressBookDB;
Use AddressBookDB;

---------------------------------Creating The AddressBook Table (UC2)------------------------------------
Create Table AddressBook(
	FirstName varchar(50) not null,
	LastName varchar(50),
	Address varchar(255),
	City varchar(50),
	StateName varchar(50),
	ZipCode int,
	PhoneNum bigint,
	EmailId varchar(50)
);

---------------------------------------Inserting Value Into The AddressBook Table (UC3)-----------------------------------------------
Insert Into AddressBook Values('Raj', 'Verma', 'Ghansoli', 'NaviMumbai', 'Maharashtra', 456123, 9517534561, 'abc123@gmail.com'),
						('Mansi', 'Verma', 'Vashi', 'NaviMumbai', 'Maharashtra', 789456, 9874561230, 'abc456@gmail.com'),	
						('Ajay', 'Matkar', 'Chembur', 'Mumbai', 'Maharashtra', 965874, 7412589631, 'abc789@gmail.com'),	
						('Omkar', 'Bhatt', 'Andheri', 'Mumbai', 'Maharashtra', 412563, 9852364170, 'abc852@gmail.com'),	
						('Aman', 'Nikam', 'Borivali', 'Mumbai', 'Maharashtra', 456123, 9852741630, 'abc741@gmail.com');
Select * From AddressBook;

---------------------------------------Edit Existing AddressBook Table Using Update(UC4)-----------------------------------------------
Update AddressBook Set EmailId='mansi@yahoo.com' Where FirstName='Mansi';
Update AddressBook Set Address='Sec-40', City = 'Noida', StateName = 'Delhi' Where FirstName='Raj';
Update AddressBook Set Phonenum=7415986320 Where FirstName='Ajay';
Update AddressBook Set LastName='Kondvilkar' Where FirstName='Omkar';
Select * From AddressBook;

---------------------------------------Delete Existing Contact From Table(UC5)-----------------------------------------------
Delete From AddressBook Where FirstName='Mansi' And LastName = 'Verma';
Select * From AddressBook;

--------------------------------Retrieve Person Record From Table By City Or State(UC6)---------------------------------------
Select * From AddressBook Where City='Mumbai' Or StateName='Maharshtra';

----------------------Ability To Get The Size Of AddressBook By City And State Using Count(UC7)---------------------------------
Select Count(*) As Count,StateName,City From AddressBook Group By StateName,City;

--------------------------------------Retrive Sorted Persons Records By City(UC8)------------------------------------------------
Select * From AddressBook Where City = 'Mumbai' Order By FirstName;		

----------------------------------------Add AddressBookName And Type Column(UC9)--------------------------------------------------
Alter Table AddressBook Add AddressBookName varchar(50), AddressBookType varchar(50);

------------------Inserting Data Into The AddressBook Table For Freinds And Profession
Insert Into AddressBook(FirstName,LastName,Address,City,StateName,ZipCode,PhoneNum,EmailId) 
					Values('Amit', 'Pawar', 'Govandi', 'Mumbai', 'Maharashtra', 789123, 9823434561, 'abc012@gmail.com'),
						('Appurva', 'Rasal', 'Vashi', 'NaviMumbai', 'Maharashtra', 741258, 7419632580, 'abc320@gmail.com'),	
						('Vaibhav', 'Patil', 'Ka;yan', 'Mumbai', 'Maharashtra', 965874, 7412589631, 'abc475@gmail.com'),	
						('Mansi', 'Verma', 'Vashi', 'NaviMumbai', 'Maharashtra', 789456, 9874561230, 'abc456@gmail.com'),	
						('Yash', 'Verma', 'Ghansoli', 'NaviMumbai', 'Maharashtra', 985263, 7456981230, 'abc786@gmail.com');
------------------Updating The DataBase With New Coulmn Values
Update AddressBook Set AddressBookName='FreindsAddressBook',AddressBookType='Freinds' Where FirstName ='Ajay' Or FirstName='Omkar' Or FirstName = 'Aman';
Update AddressBook Set AddressBookName='FamilyAddressBook',AddressBookType='Family' Where FirstName ='Raj' Or FirstName='Mansi' Or FirstName = 'Yash';
Update AddressBook Set AddressBookName='ProfesionAddressBook',AddressBookType='Profession' Where FirstName ='Appurva' Or FirstName='Vaibhav' Or FirstName = 'Amit';
Select * From AddressBook Order By FirstName;

-----------------------------Ability To Get Number Of Contact Persons i.e. Count By Type And Name(UC9)-----------------------------
Select Count(*) As CountABType,AddressBookType From AddressBook Group By AddressBookType;
Select Count(*) As CountABNames,AddressBookName  From AddressBook Group By AddressBookName;

-----------------------------Adding Same Person In Different AddressBookType(UC11)-----------------------------
Insert into AddressBook values ('Ajay', 'Matkar', 'Chembur', 'Mumbai', 'Maharashtra', 965874, 7412589631, 'abc789@gmail.com','FamilyAddressBook','Family');
Select * From AddressBook Order By FirstName;

--------------------------------------------Creating Tables Using ER Diagram(UC12)--------------------------------------------------
---------------Creating Address_Book Table
Create Table Address_Book(
	AddressBookId Int Identity(1,1) Primary Key,
	AddressBookName varchar(50)
);

---------------Creating Persons_Details Table
Create Table Persons_Details(
	PersonId Int Identity(1,1) Primary Key,
	AddressBookId Int Foreign Key References Address_Book(AddressBookId),
	FirstName varchar(50),
	LastName varchar(50),
	Address varchar(255),
	City varchar(50),
	StateName varchar(50),
	ZipCode int,
	PhoneNum bigint,
	EmailId varchar(50)
);

---------------Creating Person_Types Table
CREATE TABLE Person_Types(
	PersonTypeId Int Identity(1,1) Primary Key,
	PersonType varchar(50),
);

---------------Creating Persons_Details_Type Table
CREATE TABLE Persons_Details_Type(
	PersonId Int Foreign Key References Persons_Details(PersonId),
	PersonTypeId Int Foreign Key References Person_Types(PersonTypeId)
);

--------------------------------------------Inserting Values Into The New Table Structure------------------------------------------------------

---------------Inserting Values Into AddressBook Table
Insert Into Address_Book Values ('Home'),('Office'),('College');
Select * From Address_Book;

---------------Inserting Values Into PersonTypes Table
Insert Into Person_Types Values ('Family'),('Profession'),('Freinds');
Select * From Person_Types;

---------------Inserting Values Into PersonsDetails Table
Insert Into Persons_Details Values(1,'Raj', 'Verma', 'Ghansoli', 'NaviMumbai', 'Maharashtra', 456123, 9517534561, 'abc123@gmail.com'),
						(3,'Ajay', 'Matkar', 'Chembur', 'Mumbai', 'Maharashtra', 965874, 7412589631, 'abc789@gmail.com'),	
						(3,'Omkar', 'Bhatt', 'Andheri', 'Mumbai', 'Maharashtra', 412563, 9852364170, 'abc852@gmail.com'),	
						(3,'Aman', 'Nikam', 'Borivali', 'Mumbai', 'Maharashtra', 456123, 9852741630, 'abc741@gmail.com'),
						(2,'Amit', 'Pawar', 'Govandi', 'Mumbai', 'Maharashtra', 789123, 9823434561, 'abc012@gmail.com'),
						(2,'Appurva', 'Rasal', 'Vashi', 'NaviMumbai', 'Maharashtra', 741258, 7419632580, 'abc320@gmail.com'),	
						(2,'Vaibhav', 'Patil', 'Ka;yan', 'Mumbai', 'Maharashtra', 965874, 7412589631, 'abc475@gmail.com'),	
						(1,'Mansi', 'Verma', 'Vashi', 'NaviMumbai', 'Maharashtra', 789456, 9874561230, 'abc456@gmail.com'),	
						(1,'Yash', 'Verma', 'Ghansoli', 'NaviMumbai', 'Maharashtra', 985263, 7456981230, 'abc786@gmail.com');
Select * From Persons_Details;

---------------Inserting Values Into PersonsDetailsType Table
Insert Into Persons_Details_Type VALUES (1,1),(2,3),(3,3),(4,3),(5,2),(6,2),(7,2),(8,1),(9,1);
SELECT * FROM Persons_Details_Type;

--------------Ensuring To Check All RetrieveQueries From UC 6 To UC 8 And UC10 Are Working With New Table Structure----------------------------------

---------------Retrieve All Records By Persons City Or State(UC6)
SELECT ab.AddressBookId,ab.AddressBookName,pd.PersonId,pd.FirstName,pd.LastName,pd.Address,pd.City,pd.StateName,pd.ZipCode,
pd.PhoneNum,pd.EmailId,pt.PersonType,pt.PersonTypeId FROM
Address_Book AS ab 
INNER JOIN Persons_Details AS pd ON ab.AddressBookId = pd.AddressBookId AND (pd.City='Mumbai' OR pd.StateName='Maharshtra')
INNER JOIN Persons_Details_Type as ptm On ptm.PersonId = pd.PersonId
INNER JOIN Person_Types AS pt ON pt.PersonTypeId = ptm.PersonTypeId;

---------------Count Based On City And State(UC7)
Select Count(*) As Count,StateName,City from Persons_Details Group By StateName,City;

---------------Sorted AddressBook Based On First Name(UC8)
SELECT ab.AddressBookId,ab.AddressBookName,pd.PersonId,pd.FirstName,pd.LastName,pd.Address,pd.City,pd.StateName,pd.ZipCode,
pd.PhoneNum,pd.EmailId,pt.PersonType,pt.PersonTypeId FROM
Address_Book AS ab 
INNER JOIN Persons_Details AS pd ON ab.AddressBookId = pd.AddressBookId And City = 'Mumbai'
INNER JOIN Persons_Details_Type as ptm On ptm.PersonId = pd.PersonId
INNER JOIN Person_Types AS pt ON pt.PersonTypeId = ptm.PersonTypeId Order By FirstName;

---------------Retreive Number Of Persons Records Based On Person Types(UC10)
Select Count(pdt.PersonTypeId) As PersonCount,Pt.PersonType From 
Persons_Details_Type As pdt 
INNER JOIN Person_Types AS pt ON pt.PersonTypeId = pdt.PersonTypeId
INNER JOIN Persons_Details AS pd ON pd.PersonId = pdt.PersonId Group By pdt.PersonTypeId,pt.PersonType;

---------------Retreive Number Of Persons Records Based On AddressBook Names(UC10)
Select Count(ab.AddressBookId) As AddressBookCount,ab.AddressBookName From 
Address_Book As ab 
INNER JOIN Persons_Details AS pd ON pd.AddressBookId = ab.AddressBookId Group By ab.AddressBookName,pd.AddressBookId;