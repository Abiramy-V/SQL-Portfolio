/* 
 Countries and dependent territories, 2020
 Data adapted from http://www.worldometers.info/world-population/population-by-country/
 Collected by: https://www.khanacademy.org/profile/pamelafox/programs
*/

--In this SQL code, I am querying a database that holds data about different countries and territories
--to answer questions about the data

-- 1.) How many countries are in this dataset?
SELECT COUNT(name)
FROM countries

--Answer: 201


-- 2.) What are the top 10 countries with the highest population?
SELECT TOP 10 name, population, fertility_rate
FROM countries 
ORDER BY population DESC

--Answer: China, India, United States, Indonesia, Pakistan, Brazil, Nigeria, Bangladesh, Russia, Mexico


-- 3.) What are the top 10 countries with the lowest population
SELECT TOP 10 name, population, fertility_rate
FROM countries 
ORDER BY population ASC

--Answer: Antigua and Barbuda, Seychelles, U.S. Virgin Islands, Tonga, Aruba, 
--St Vincent & Grenadines, Grenada, Micronesia, Kiribati, Curacao


-- 4.) Select the population and 'percentage of world population' for countries that begin with the letter a or b or the country name is 'Singapore'
SELECT name, population, percent_of_world_pop
FROM countries 
WHERE name LIKE '[ab]%' or name = 'Singapore'
ORDER BY percent_of_world_pop


-- 5.) What is the count of the median ages and the average median age?
SELECT median_age, COUNT(median_age) AS median_age_count,
(SELECT AVG(median_age) FROM countries) AS AvgAgeOfAll
FROM countries
GROUP BY median_age


-- 6.) Add a new column for countries, describing the median age of the countries
-- with a median age 25 or less as 'young' , between 25 and 40 as 'adult' and 41 or older as 'old'
SELECT name, median_age, 
CASE
WHEN median_age <= 25 THEN 'young'
WHEN median_age BETWEEN 25 and 40 THEN 'adult'
ELSE 'old' 
END AS age_rank
FROM countries
ORDER BY age_rank DESC


-- 7.)  Identify all the countries with a fertility rate greater than 2 or their name is Japan
SELECT name, median_age, fertility_rate
FROM countries
WHERE fertility_rate > 2.0 OR name = 'japan'
ORDER BY fertility_rate DESC


-- 8.)  Link between fertility rate and median age
-- a.) Country with the highest fertility rate and lowest median age
SELECT TOP 1 name, fertility_rate,
(SELECT TOP 1 median_age
FROM countries
ORDER BY median_age asc)
FROM countries
ORDER BY fertility_rate desc

--Answer: Niger


-- b.) Country with the lowest fertility and hihest median age
SELECT TOP 1 name, fertility_rate,
(SELECT TOP 1 median_age
FROM countries
ORDER BY median_age desc)
FROM countries
ORDER BY fertility_rate asc

--Answer: South Korea





