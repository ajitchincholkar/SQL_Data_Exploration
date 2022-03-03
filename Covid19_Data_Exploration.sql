# Covid-19 Data Exploration

use covid19;


# Getting overview of th data
SELECT * FROM coviddeaths;


# Getting columns we are interested in 
SELECT 
    location,
    date,
    total_cases,
    new_cases,
    total_deaths,
    population
FROM
    coviddeaths
ORDER BY 1 , 2;


# Total Cases vs Total Deaths
# Chances of dying if you contract covid in your country
SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    ROUND((total_deaths / total_cases) * 100, 2) AS death_percent
FROM
    coviddeaths
ORDER BY 1 , 2;


# Percent of population infected by Covid
SELECT 
    location,
    date,
    total_cases,
    population,
    ROUND((total_cases / population) * 100, 2) AS infected_percent
FROM
    coviddeaths
WHERE
    location = 'India'
ORDER BY 1 , 2;


# Countries with highest infection rate w.r.t population
SELECT 
    location,
    MAX(total_cases) AS total_cases,
    population,
    ROUND((MAX(total_cases) / population) * 100, 2) AS infected_percent
FROM
    coviddeaths
WHERE
    continent != ''
GROUP BY location , population
ORDER BY 4 DESC;


# Countries with highest death count w.r.t total cases
SELECT 
    location,
    MAX(total_cases) AS total_cases,
    MAX(total_deaths) AS total_deaths,
    ROUND((MAX(total_deaths) / MAX(total_cases)) * 100, 2) AS death_percent
FROM
    coviddeaths
WHERE
    continent != ''
GROUP BY location , population
ORDER BY 4 DESC;


# Countries with highest death count w.r.t population
SELECT 
    location,
    MAX(total_deaths) AS total_deaths,
    population,
    ROUND((MAX(total_deaths) / population) * 100, 2) AS death_percent
FROM
    coviddeaths
WHERE
    continent != ''
GROUP BY location , population
ORDER BY 4 DESC;


# Continents with highest infection rate
SELECT 
    location,
    MAX(total_cases) AS total_cases,
    MAX(population) AS population,
    ROUND((MAX(total_cases) / MAX(population)) * 100, 2) AS infected_percent
FROM
    coviddeaths
WHERE
    continent = ''
        AND location IN ('Asia' , 'Africa',
        'Europe',
        'North America',
        'South America',
        'Oceania')
GROUP BY location
ORDER BY 4 DESC;


# Continents with highest death percent w.r.t total cases
SELECT 
    location,
    MAX(total_cases) AS total_cases,
    MAX(total_deaths) AS total_deaths,
    ROUND((MAX(total_deaths) / MAX(total_cases)) * 100, 2) AS death_percent
FROM
    coviddeaths
WHERE
    continent = ''
        AND location IN ('Asia' , 'Africa',
        'Europe',
        'North America',
        'South America',
        'Oceania')
GROUP BY location
ORDER BY 4 DESC;


# Death percent across the whole world
SELECT 
    MAX(total_cases) AS total_cases,
    MAX(total_deaths) AS total_deaths,
    ROUND((MAX(total_deaths) / MAX(total_cases)) * 100, 2) AS death_percent
FROM
    coviddeaths
WHERE
    location = 'World';
    

# Total Vaccinations across different countries
SELECT 
    cd.continent, 
    cd.location, 
    cd.date, 
    cv.new_vaccinations,
    SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) as total_vaccinations
FROM 
	coviddeaths cd
JOIN 
	covidvaccinations cv
ON cd.location = cv.location AND
	cd.date = cv.date
WHERE 
	cd.continent != ''
ORDER BY 2,3;


# Total percent of people fully vaccinated in different countries
SELECT 
    cd.location,
    cd.population,
    MAX(cv.people_fully_vaccinated) AS people_vaccinated,
    (MAX(cv.people_fully_vaccinated) / cd.population) * 100 AS percent_vaccinated
FROM
    coviddeaths cd
        JOIN
    covidvaccinations cv ON cd.location = cv.location
        AND cd.date = cv.date
WHERE
    cd.continent != ''
GROUP BY cd.location , cd.population
ORDER BY 1;
