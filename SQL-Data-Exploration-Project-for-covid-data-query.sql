
/* 
Database name is PortfolioProjectAlexDA having two tables.
The tables 'CovidDeaths' and 'CovidVaccinations' have data from 01-01-2020 to 30-04-2021 
*/


-- Query 1 : Finding percentage of deaths over cases registered day-wise in India

select location, date, total_cases, total_deaths, 
round((total_deaths/total_cases)*100,2) as precentageOfDeath
from PortfolioProjectAlexDA..CovidDeaths
where location = 'India'
order by 1,2


-- Query 2 : Finding percentage of cases registered over total population day-wise in India

select location, date, population, total_cases, 
round((total_cases/population)*100,2) as precentageOfCases
from PortfolioProjectAlexDA..CovidDeaths
where location = 'India'
order by 1,2


-- Query 3 : Looking at countries with highest infection rate compared to population

select location, population, max(total_cases) as MaxCases,
Max(round((total_cases/population)*100,2)) as InfectionsRate
from PortfolioProjectAlexDA..CovidDeaths
where continent is not null
group by location, population
order by InfectionsRate desc


-- Query 4 : Finding Countries with highest death count per population

select location, population, max(total_deaths) as MaxDeaths,
Max(round((total_deaths/population)*100,2)) as DeathsRate
from PortfolioProjectAlexDA..CovidDeaths
where continent is not null
group by location, population
order by DeathsRate desc


-- Query 5 : Looking at Average death per country in a continent 

select continent, avg(cast(total_deaths as int)) as avgDeath
from PortfolioProjectAlexDA..CovidDeaths
where continent  is not null
group by continent
order by avgDeath desc


-- Query 6 : daily new covid cases and new deaths worldwide

select date, sum(cast(new_cases as int)) as dailyTotalCases, 
sum(cast(new_deaths as int)) as dailyTotalDeaths
from PortfolioProjectAlexDA..CovidDeaths
where continent is not null
group by date
order by date 


-- Query 7 : Looking at vaccinations vs Population (using CTE)

with PopvVac as 
(select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
sum(cast(v.new_vaccinations as int)) over (partition by d.location order by d.location, d.date) 
as rollingVaccinations
from PortfolioProjectAlexDA..CovidVaccinations as v
join PortfolioProjectAlexDA..CovidDeaths as d
on v.location = d.location
and v.date = d.date
where d.continent is not null
)

select continent, location, date, population, new_vaccinations, rollingVaccinations, 
round((rollingVaccinations/population)*100,2) as vaccinationsRate
from PopvVac



