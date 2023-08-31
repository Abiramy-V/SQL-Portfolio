---- Dataset: Coronavirus (COVID-19) Deaths
---- Source: https://ourworldindata.org/covid-deaths
---- Queried using MS SQL SERVER
---- SQL skills:

-----------------------------------------------------------------------------------------------------------------------------------
---- The two tables that are used in this project are:

1.) CovidDeaths:
  
SELECT 
      location
      ,date
      ,total_cases
      ,new_cases
      ,total_deaths
      ,population
FROM 
     CovidDeaths
ORDER BY 1,2

2.) CovidVaccinations:
  
SELECT *
FROM 
     CovidVaccinations
ORDER BY 3,4

-----------------------------------------------------------------------------------------------------------------------------------

---- Seeing which date had the most number of total cases in Canada

SELECT 
      TOP 1 
      date
     ,total_cases
FROM 
     CovidDeaths
WHERE 
     location = 'CANADA'
ORDER BY 
        total_cases DESC 

-----------------------------------------------------------------------------------------------------------------------------------

---- Identifying the location with the most number of covid deaths

SELECT 
      TOP 1
      location
      ,max(total_deaths) AS deathtoll
FROM 
     CovidDeaths
WHERE 
      1=1 AND 
      total_deaths IS NOT NULL
GROUP BY 
      location 
ORDER BY
      deathtoll DESC

-----------------------------------------------------------------------------------------------------------------------------------

---- Total Cases vs Total Deaths in the United Kingdom

SELECT
      Location
     ,date
     ,total_cases
    ,total_deaths
    ,(total_deaths/total_cases)*100 AS deathrate
From 
    CovidDeaths
WHERE 
     1=1  
     AND location = 'united kingdom' 
     AND total_deaths IS NOT NULL
     AND total_cases IS NOT NULL
ORDER BY 
     Total_deaths DESC

-----------------------------------------------------------------------------------------------------------------------------------


