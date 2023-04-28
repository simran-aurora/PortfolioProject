-- Checking data in both Tables

select * 
from PortfolioProject..covid_deaths
order by 3,4


select *
from PortfolioProject..covid_vaccination
order by 1,2


-- Checking for Total deaths as percentage of Total cases
Select location, date, cast(total_cases as float) as Cases, cast(total_deaths as float) as Deaths,
	(cast(total_deaths as float)/cast(total_cases as float))*100 as DeathsVsCases
from PortfolioProject..covid_deaths
order by 1,2


-- Total cases vs Population
Select location, date, total_cases as Cases, population, (total_cases/population)*100 as CasesVSPopulation
from PortfolioProject..covid_deaths
order by 1,2

-- Hightest infected compared to population
Select location, max(total_cases) as HighestCases, population, (max(total_cases)/population)*100 as HighestInfection
from PortfolioProject..covid_deaths
group by location, population
order by HighestInfection desc


-- Maximum number of cases by Location
Select location, max(convert(float,total_cases)) as HighestCases
from PortfolioProject..covid_deaths
group by location
order by HighestCases;

--Countries with highest deaths per population
Select location, max(cast(total_deaths as float)) as highestdeaths, population, round((max(total_deaths)/population),5)*100 as deaths_per_population
from PortfolioProject..covid_deaths
group by location, population
order by deaths_per_population desc




-- Cases and deaths Location wise

Select  location, sum(cast(total_cases as float)) as TotalCases, sum(cast(total_deaths as float)) as TotalDeaths, 
round(avg((cast(total_deaths as float)/cast(total_cases as float))),5)*100 as death_percentage
from PortfolioProject..covid_deaths
where continent is not null 
group by location
order by 1,2

--Infected vs deaths on each day
Select cast(date as date), sum(cast(total_cases as float)) as Cases, sum(cast(total_deaths as float)) as deaths, round(avg(cast(total_deaths as float)/cast(total_cases as float)),5)*100
from PortfolioProject..covid_deaths
group by cast(date as date)
order by 1,2

-- Cases and deaths Continent wise 
Select  continent, sum(cast(total_cases as float)) as Cases, sum(cast(total_deaths as float)) as deaths, 
round(avg((cast(total_deaths as float)/cast(total_cases as float))),5)*100 as death_percentage
from PortfolioProject..covid_deaths
where continent is not null 
group by continent
order by 1,2

-- Death percentage in asia and India
Select  location, sum(cast(total_cases as float)) as Cases, sum(cast(total_deaths as float)) as deaths, 
round(avg((cast(total_deaths as float)/cast(total_cases as float))),5)*100 as death_percentage
from PortfolioProject..covid_deaths
where continent is not null and location = 'India'
group by location
order by 1,2

--Global reduction in population
Select sum(population) as Global_Population, sum(cast(total_deaths as float)) as Global_Deaths, 
round(sum(cast(total_cases as float))/sum(population),5)*100 as Percent_Reduction_in_population
from PortfolioProject..covid_deaths
order by 1,2

--New cases per day across the globe
Select cast(date as date) as Date, sum(new_cases) as Total_New_Cases
from PortfolioProject..covid_deaths
group by date 

-- joining the two tables
Select dea.location, cast(dea.date as date) as Date, total_vaccinations
from PortfolioProject..covid_deaths as dea
join PortfolioProject..covid_vaccination as vac
on dea.location = vac.location
and dea.date = vac.date
--group by dea.location

-- Getting Total Vaccinations in each location
Select dea.location,  max(cast(total_vaccinations as float)) Total_vaccinations
from PortfolioProject..covid_deaths as dea
join PortfolioProject..covid_vaccination as vac
on dea.location = vac.location
where dea.continent is not null 
group by dea.location
order by Total_vaccinations desc

-- Total Vaccinations by Location
Select location,  max(cast(total_vaccinations as float)) Total_vaccinations
from PortfolioProject..covid_vaccination 
where continent is not null 
group by location
order by Total_vaccinations desc


-- Total Population vs Number of People Vaccinationed and Percentage Vaccinated
Select dea.location,  max(dea.population) as population, max(cast(people_vaccinated as float)) as peopleVaccinated, 
	round(max(cast(people_vaccinated as float))/max(dea.population),5)*100 as PopultionVsVaccinated
from PortfolioProject..covid_deaths as dea
join PortfolioProject..covid_vaccination as vac
on dea.location = vac.location
--and dea.date = vac.date
where dea.continent is not null 
group by dea.location


--Rolling count of vaccinations
select continent, location, cast(date as date) as Date, cast(new_vaccinations as float) as New_vacc, 
sum(cast(new_vaccinations as float)) over (partition by location order by date,location) as RollingVaccinations
from PortfolioProject..covid_vaccination
where continent is not null and location = 'Albania'

-- Population VS TotalVaccinations
With PopVsVac (continent, location, population, Date, New_vacc, RollingVaccinations)
as 
(
select continent, location,population, cast(date as date) as Date, cast(new_vaccinations as float) as New_vacc, 
sum(cast(new_vaccinations as float)) over (partition by location order by date,location) as RollingVaccinations
from PortfolioProject..covid_vaccination
where continent is not null
)
select * ,(RollingVaccinations/population)
from PopVsVac

-- Using Temp table 
DROP TABLE IF exists #popTemp
create table #popTemp (continent nvarchar(255)
, location nvarchar(255), population numeric, 
	Date datetime, New_vacc numeric, RollingVaccinations numeric)
insert into #popTemp
select continent, location,population, cast(date as date) as Date, cast(new_vaccinations as float) as New_vacc, 
sum(cast(new_vaccinations as float)) over (partition by location order by date,location) as RollingVaccinations
from PortfolioProject..covid_vaccination
select * ,(RollingVaccinations/population)
from #popTemp

-- Create View
 
create view TotalcasesVSDeaths 
as
Select continent,location, sum(cast(total_cases as float)) as Cases, sum(cast(total_deaths as float)) as deaths, 
round(avg((cast(total_deaths as float)/cast(total_cases as float))),5)*100 as death_percentage
from PortfolioProject..covid_deaths
where continent is not null 
group by continent,location

select *
from TotalcasesVSDeaths 