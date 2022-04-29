
Select *
From coviddeaths
WHERE continent is not null 
order by 3,4



-- shows likelihood of dying if you get COVID in your country

Select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM coviddeaths
WHERE location LIKE '%states%' AND total_cases > 1000000
ORDER BY 1,2 

-- looking at total cases vs. population 
-- Shows what percentage of population got COVID  
Select location, date, total_cases, population,(total_cases/population)*100 as percentofpopulationinfected
FROM coviddeaths
WHERE location LIKE '%states%' 
ORDER BY 1,2 

-- Looking at countries with highest infection rate compared to the population
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as 
percent_population_infected
FROM coviddeaths
-- WHERE location LIKE '%states%' (wildcard can be used for your own country)
GROUP BY location, population
ORDER BY percent_population_infected desc

-- Showing countries with Highest Death Count by Population 

Select location, MAX(cast(Total_deaths AS UNSIGNED)) as TotalDeathCount
FROM coviddeaths
-- WHERE location LIKE '%states%' (wildcard can be used for your own country)
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc

-- LET'S BREAK THINGS DOWN BY CONTINENT
-- Showing the continents witht he highest death count

Select continent, MAX(cast(Total_deaths AS UNSIGNED)) as TotalDeathCount
FROM coviddeaths
-- WHERE location LIKE '%states%' (wildcard can be used for your own country)
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc

-- GLOBAL NUMBERS (death rate) 
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths AS UNSIGNED)) as total_deaths, 
SUM(cast(new_deaths as UNSIGNED))/SUM(new_cases)*100 as DeathPercentage
FROM coviddeaths
-- WHERE location LIKE '%states%'
WHERE continent is not null 
ORDER BY 1,2

-- Looking at Total Population vs. Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as UNSIGNED)) OVER (partition by dea.location ORDER BY dea.location,dea.date) AS Rolling_people_vaccinated
, (Rolling_people_vaccinated/population)*100
FROM coviddeaths dea
JOIN covidvaccinations vac
 ON dea.location = vac.location 
 AND dea.date = vac.date 
 WHERE dea.continent is not null
 ORDER BY 2,3
 
 -- USE CTE
 with PopvsVac (continent,location,date,population,new_vaccinations, Rolling_people_vaccinated)
 as 
 (
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as UNSIGNED)) OVER (partition by dea.location ORDER BY dea.location,dea.date) AS Rolling_people_vaccinated
-- , (Rolling_people_vaccinated/population)*100
FROM coviddeaths dea
JOIN covidvaccinations vac
 ON dea.location = vac.location 
 AND dea.date = vac.date 
 WHERE dea.continent is not null
 -- ORDER BY 2,3
 )
 Select *, (Rolling_people_vaccinated / Population) * 100
 FROM PopvsVac


-- Creating View to store data for later (Visualizations)

percentpopulationvaccinatedpercentpopulationvaccinatedCREATE View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as UNSIGNED)) OVER (partition by dea.location ORDER BY dea.location,dea.date) AS Rolling_people_vaccinated
-- , (Rolling_people_vaccinated/population)*100
FROM coviddeaths dea
JOIN covidvaccinations vac
 ON dea.location = vac.location 
 AND dea.date = vac.date 
 WHERE dea.continent is not null
 
 Select *
 FROM percentpopulationvaccinated








