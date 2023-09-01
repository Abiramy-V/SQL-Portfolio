---- Dataset: Coronavirus (COVID-19) Deaths
---- Source: https://ourworldindata.org/covid-deaths
---- Queried using MS SQL SERVER
---- SQL skills: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

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
     location = 'canada'
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
FROM
    CovidDeaths
WHERE 
     1=1  
     AND location = 'united kingdom' 
     AND total_deaths IS NOT NULL
     AND total_cases IS NOT NULL
ORDER BY 
     Total_deaths DESC

-----------------------------------------------------------------------------------------------------------------------------------

---- Total Cases vs Population

SELECT
      Location
     ,date
     ,total_cases
    ,(total_cases/population)*100 AS covidcases_percentage
FROM
    CovidDeaths
WHERE 
     1=1  
     AND location = 'united kingdom' 
     AND total_deaths IS NOT NULL
     AND total_cases IS NOT NULL
ORDER BY 
     Total_cases DESC

-----------------------------------------------------------------------------------------------------------------------------------

---- Counries with the highest infection rate in comparison to population
  
SELECT
      Location
     ,population
     ,MAX(total_cases) AS HighestInfectionCount
     ,ROUND(max((total_cases/population))*100, 4) AS PercentPopulationInfected
FROM 
    CovidDeaths
GROUP BY 
    Location
   ,Population
ORDER BY 
    PercentPopulationInfected DESC

-----------------------------------------------------------------------------------------------------------------------------------

---- Countries with highest death count 

SELECT 
      location
     ,MAX(CAST(Total_Deaths AS bigint)) AS TotalDeathCount
FROM 
      CovidDeaths
WHERE 
      continent IS NOT NULL
GROUP BY 
      location
ORDER BY 
      TotalDeathCount DESC

  -----------------------------------------------------------------------------------------------------------------------------------

---- Continents with highest death count

SELECT 
      continent
     ,MAX(CAST(Total_Deaths AS bigint)) AS TotalDeathCount
FROM 
      CovidDeaths
WHERE 
      continent IS NOT NULL
GROUP BY 
      continent
ORDER BY 
      TotalDeathCount DESC

-----------------------------------------------------------------------------------------------------------------------------------

----  Global death percentage by day

SELECT
      date
     ,SUM(new_cases) AS total_cases
     ,SUM(CAST(new_deaths AS int)) AS total_deaths
     ,SUM(CAST(new_deaths AS int))/sum(new_cases)*100 AS GlobalDeathPercentage
FROM
     CovidDeaths
WHERE 
     continent IS NOT NULL
GROUP BY
     date
ORDER BY
      date
     ,total_cases

-----------------------------------------------------------------------------------------------------------------------------------

---- Total global death percentage

SELECT
      SUM(new_cases) AS total_cases
     ,SUM(CAST(new_deaths AS int)) AS total_deaths
     ,SUM(CAST(new_deaths AS int))/sum(new_cases)*100 AS GlobalDeathPercentage
FROM
     CovidDeaths
WHERE 
     continent IS NOT NULL
ORDER BY
     total_cases
    ,total_deaths

-----------------------------------------------------------------------------------------------------------------------------------

---- Total Population vs Vaccination using Join

SELECT
    cd.continent
   ,cd.location 
   ,cd.date
   ,cd.population
   ,cv.new_vaccinations 
FROM 
    CovidDeaths AS cd 
JOIN 
    CovidVacinations AS cv
ON 
    cd.location = cv.location 
		AND cd.date = cv.date 
WHERE 
    cv.new_vaccinations IS NOT NULL
ORDER BY
    cd.continent
   ,cd.location

-----------------------------------------------------------------------------------------------------------------------------------

---- Sum of the new vaccinations (= total vaccinations) and the rolling vaccinations by location and date

SELECT
    cd.continent
   ,cd.location 
   ,cd.date
   ,cd.population
   ,cv.new_vaccinations
   ,SUM(CAST(cv.new_vaccinations as bigint)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS rolling_vaccinations
FROM 
    CovidDeaths AS cd 
JOIN 
    CovidVaccinations AS cv
ON 
    cd.location = cv.location 
    AND cd.date = cv.date 
WHERE 
    cv.new_vaccinations IS NOT NULL
ORDER BY
    2,3

	--- order by location and date orders in alphabetical and chronological order

-----------------------------------------------------------------------------------------------------------------------------------

---- Using CTE to look at the percentage of population vaccinated. (rolling_vaccinations/population)*100

WITH cte_popvac AS (
SELECT
    cd.continent
   ,cd.location 
   ,cd.date
   ,cd.population
   ,cv.new_vaccinations
   , SUM(CAST(cv.new_vaccinations AS bigint)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS rolling_vaccinations
FROM 
    CovidDeaths AS cd 
JOIN 
    CovidVaccinations AS cv
ON 
    cd.location = cv.location 
    AND cd.date = cv.date 
WHERE 
    cv.new_vaccinations IS NOT NULL)

SELECT 
	*
	,(rolling_vaccinations/population)*100 AS percentage_pop_vaccinated
FROM 
	cte_popvac

-----------------------------------------------------------------------------------------------------------------------------------

 ---- Creating a veiw to store data for subsequent visualisation in Tableau/Power bi
	
CREATE 
	VEIW percentage_pop_vaccinated AS
SELECT 
	cd.continent 
	,cd.location 
	,cd.date 
	,cv.new_vaccinations
	,SUM(cv.new_vaccinations) OVER(PARTITION BY cv.location ORDER BY cv.location ,cv.date DESC)
	AS rolling_people_vaccinated
FROM 
	coviddeaths_csv AS cd 
JOIN 
	covidvacinations_csv AS cv
	ON cd.location = cv.location 
	AND cd.`date` = cv.`date` 
WHERE 
	cv.new_vaccinations IS NOT NULL

-----------------------------------------------------------------------------------------------------------------------------------

