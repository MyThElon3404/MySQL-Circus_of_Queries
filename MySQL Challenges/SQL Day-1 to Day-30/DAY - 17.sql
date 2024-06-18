-- QUESTION : 1
-- 1. Population Density - You are working on a data analysis project at Deloitte where you need to analyze a dataset containing information
--about various cities. Your task is to calculate the population density of these cities, rounded to the nearest integer, and identify the cities with the minimum and maximum densities.
--The population density should be calculated as (Population / Area).
--The output should contain 'city', 'country', 'density'.

DROP TABLE IF EXISTS cities_population;
CREATE TABLE cities_population (
    city VARCHAR(50),
    country VARCHAR(50),
    population INT,
    area FLOAT
);
INSERT INTO cities_population (city, country, population, area)
VALUES
('City1', 'Country1', 100000, 50.25),
('City2', 'Country2', 150000, 75.50),
('City3', 'Country3', 200000, 100.75),

('City4', 'Country4', 120000, 60.30),
('City5', 'Country5', 180000, 90.45),
('City6', 'Country6', 220000, 110.60),

('City7', 'Country7', 130000, 65.75),
('City8', 'Country8', 160000, 80.40),
('City9', 'Country9', 190000, 95.25),

('City10', 'Country10', 140000, 70.50),
('City11', 'Country11', 170000, 85.25),
('City12', 'Country12', 210000, 105.75);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------
-- 1. SOLUTION 1
with population_density as (
	select city, country, 
	case 
		when area <> 0 then ROUND(cast(population as float)/area, 0)
		else null
	end as density
	from cities_population
)
select city, country, density
from population_density
where density = (select min(density) from population_density where density is not null)
	or density = (select max(density) from population_density where density is not null);

-- 2. SOLUTION 2
with population_density as (
	select city, country, 
	case 
		when area <> 0 then ROUND(cast(population as float)/area, 0)
		else null
	end as density
	from cities_population
)
select city, country, density, 'min_density' as density_type
from population_density
where density = (select min(density) from population_density where density is not null)
union
select city, country, density, 'max_density' as density_type
from population_density
where density = (select max(density) from population_density where density is not null)
-- ==================================================================================================================================

-- QUESTION : 2
-- 2. 

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------


-- ==================================================================================================================================
