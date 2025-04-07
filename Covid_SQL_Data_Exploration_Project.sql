-- DATA EXPLORATION SQL PROJECT: COVID 19 DATA --

USE portfolio_projects;

SELECT *
FROM coviddeaths
ORDER BY 3,4;

SELECT *
FROM covidvaccinations
ORDER BY 3,4;

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM coviddeaths
ORDER BY 1,2;


-- Looking at Total Cases vs Total Deaths --

SELECT location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM coviddeaths
WHERE location like 'Pakistan'
ORDER BY 1,2;


-- Shows what percentage of population infected with Covid --

SELECT location, date, population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
FROM coviddeaths
ORDER BY 1,2;


-- Countries with Highest Infection Rate compared to Population --

SELECT location, population, MAX(total_cases) AS HighestInfectionCount,  Max((total_cases/population))*100 AS PercentPopulationInfected
FROM coviddeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;


-- Countries with Highest Death Count per Population --

SELECT location, MAX(CAST(Total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;


-- Showing contintents with the highest death count per population --

SELECT continent, MAX(CAST(Total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM coviddeaths
WHERE continent IS NOT NULL 
GROUP BY continent
ORDER BY TotalDeathCount DESC;


-- Total Deaths, Total Cases and Death Percentage Worldwide --

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS UNSIGNED)) AS total_deaths, SUM(CAST(new_deaths AS UNSIGNED))/SUM(New_Cases)*100 AS DeathPercentage
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;


-- Shows Percentage of Population that has recieved at least one Covid Vaccine --

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
FROM coviddeaths dea
JOIN covidvaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;


-- Using CTE to perform Calculation on Partition By in previous query --

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
FROM coviddeaths dea
JOIN covidvaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac;


-- Using Temp Table to perform Calculation on Partition By in previous query --

DROP TABLE IF EXISTS PercentPopulationVaccinated;

CREATE TABLE PercentPopulationVaccinated (
  continent VARCHAR(255),
  location VARCHAR(255),
  date DATE,
  population BIGINT,
  new_vaccinations BIGINT,
  RollingPeopleVaccinated BIGINT
);

INSERT INTO PercentPopulationVaccinated
SELECT
  dea.continent,
  dea.location,
  STR_TO_DATE(dea.date, '%m/%d/%Y') AS date,
  dea.population,
  CAST(NULLIF(vac.new_vaccinations, '') AS UNSIGNED),
  SUM(CAST(NULLIF(vac.new_vaccinations, '') AS UNSIGNED)) OVER (PARTITION BY dea.location 
    ORDER BY dea.location, STR_TO_DATE(dea.date, '%m/%d/%Y')) AS RollingPeopleVaccinated
FROM coviddeaths dea
JOIN covidvaccinations vac
  ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;


-- Creating View to store data for later visualizations --

CREATE VIEW PercentPopulationVaccinated_View AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
FROM coviddeaths dea
JOIN covidvaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;