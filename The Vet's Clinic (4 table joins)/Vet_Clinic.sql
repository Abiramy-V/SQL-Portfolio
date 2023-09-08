 /* The Vet's Clinic
From: https://www.superdatascience.com/pages/sql

Challenge:
You are a Data Analyst assisting a veterinarian clinic make sense of their data. Their data is dispersed
across multiple cvs files and they need you to upload all of them to a database and then perform the following analytics:
*/ 


-- The tables used for this project:
-- Pets 
CREATE TABLE Pets (
    PetID varchar(10),
    Name varchar(100),
    Kind varchar(100),
    Gender varchar(10),
    Age int,
    OwnerID varchar(10)
)

-- Owners
CREATE TABLE Owners (
    OwnerID varchar(10),
    [Name] varchar(100),
    Surname varchar(100),
    StreetAddress varchar(100),
    City varchar(100),
    [State] varchar(2),
	StateFull varchar(100),
	ZipCode varchar(10)
)

-- ProceduresDetails
CREATE TABLE ProceduresDetails (
    ProcedureType varchar(100),
    ProcedureSubCode varchar(10),
    [Description] varchar(100),
    Price float
)

-- ProceduresHistory
CREATE TABLE ProceduresHistory (
    PetID varchar(10),
    ProcedureDate date,
    ProcedureType varchar(100),
    ProcedureSubCode varchar(10)
)
-------------------------------------------------------------------------

--1.) Extract information on pet names and owners names side by side. Order 
-- alphabetically by the oweners name

SELECT Owners.name, PetID, pets.name
FROM Owners
JOIN Pets
ON Owners.OwnerID = Pets.OwnerID
ORDER BY Owners.name ASC

-- 2.) Find out How many pets had at least one procedure performed

SELECT COUNT(DISTINCT(name)) AS num_pets_with_procedures
FROM pets
JOIN ProceduresHistory
ON Pets.PetID = ProceduresHistory.PetID

--Answer: 23


-- 3.) Find out which pets from this clinic had procedures performed, and what procedures these pets had

SELECT name, ProcedureType
FROM pets
JOIN ProceduresHistory
ON Pets.PetID = ProceduresHistory.PetID
ORDER BY name


-- 4.) Find out which pet/s had the most number of procedures

SELECT name, COUNT(ProcedureType) AS number_of_procedures
FROM Pets
JOIN ProceduresHistory
ON Pets.PetID = ProceduresHistory.PetID
GROUP BY name
ORDER BY number_of_procedures DESC

-- Answer: Biscuit and Cookie had the most number of procedures (4)


-- 5.) Match all of the procedures performed on the pets to their descriptions

SELECT Name, ph.ProcedureType, Description
FROM Pets
JOIN ProceduresHistory AS ph
ON Pets.PetID = ph.PetID
JOIN ProceduresDetails AS pd
ON ph.ProcedureSubCode = pd.ProcedureSubCode
ORDER BY Name ASC

-- 6.) What was the total number of vaccinations carried out?

SELECT COUNT(ProcedureType)
FROM ProceduresHistory
WHERE ProcedureType = 'Vaccinations'

--Answer: 1447 Vaccinations performed


-- 7.) Extract a table of individual costs (procedure prices) incurred by owners of pets from the clinic.
-- This table should have owner and procedure price. 
-- Order by the Owners who have spent the most on procedures

SELECT Owners.name, SUM(price) AS total_cost_Procedures
FROM Owners
JOIN Pets
ON Owners.OwnerID = Pets.OwnerID
JOIN ProceduresHistory AS ph
ON Pets.PetID = ph.PetID
JOIN ProceduresDetails AS pd
ON ph.ProcedureSubCode = pd.ProcedureSubCode
GROUP BY Owners.name
ORDER BY total_cost_procedures DESC


-- 8.) What are the two expensive Procedure types?

SELECT TOP 2 *
FROM ProceduresDetails
ORDER BY PRICE DESC

--Answer: The two most expensive are General surgery for Intestinal Anas and general surgery for salivary cyst excision.


-- 9.) Find out which owners paid for a rabies vaccination for their pet

SELECT owners.name
FROM Owners
JOIN Pets
ON Owners.OwnerID = Pets.OwnerID
JOIN ProceduresHistory AS ph
ON Pets.PetID = ph.PetID
JOIN ProceduresDetails AS pd
ON ph.ProcedureSubCode = pd.ProcedureSubCode
WHERE Description = 'Rabies'










