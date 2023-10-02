--1,How many npi numbers appear in the prescriber table but not in the prescription table?
(SELECT npi
FROM prescriber)
EXCEPT
(SELECT npi
FROM prescription);
--4458

--2,a. Find the top five drugs (generic_name) prescribed by prescribers with the specialty of Family Practice.
SELECT DISTINCT specialty_description,generic_name
FROM prescriber
CROSS JOIN drug
WHERE specialty_description = 'Family Practice'
ORDER BY generic_name DESC
Limit 5;

--b. Find the top five drugs (generic_name) prescribed by prescribers with the specialty of Cardiology.
SELECT DISTINCT specialty_description,generic_name
FROM prescriber
CROSS JOIN drug
WHERE specialty_description = 'Cardiology'
ORDER BY generic_name DESC
Limit 5;

--c. Which drugs are in the top five prescribed by Family Practice prescribers and Cardiologists?
--Combine what you did for parts a and b into a single query to answer this question.

(SELECT DISTINCT specialty_description,generic_name
FROM prescriber
CROSS JOIN drug
WHERE specialty_description = 'Family Practice'
ORDER BY generic_name DESC
LIMIT 5)
UNION
(SELECT DISTINCT specialty_description,generic_name
FROM prescriber
CROSS JOIN drug
WHERE specialty_description = 'Cardiology'
ORDER BY generic_name DESC
LIMIT 5);

--3,Your goal in this question is to generate a list of the top prescribers in each of the major metropolitan areas of Tennessee. 
--a. First, write a query that finds the top 5 prescribers in Nashville in terms of the total number of claims (total_claim_count) across all drugs. 
--   Report the npi, the total number of claims, and include a column showing the city.
SELECT DISTINCT npi, total_claim_count,cbsaname
FROM prescription as p
CROSS JOIN cbsa as c
WHERE cbsaname LIKE '%Nashville%'
ORDER BY total_claim_count DESC
LIMIT 5;

--b. Now, report the same for Memphis.
SELECT DISTINCT npi, total_claim_count,cbsaname
FROM prescription as p
CROSS JOIN cbsa as c
WHERE cbsaname LIKE '%Memphis%'
ORDER BY total_claim_count DESC
LIMIT 5;

--c. Combine your results from a and b, along with the results for Knoxville and Chattanooga.
(SELECT DISTINCT npi, total_claim_count,cbsaname
FROM prescription as p
CROSS JOIN cbsa as c
WHERE cbsaname LIKE '%Nashville%'
ORDER BY total_claim_count DESC
LIMIT 5)
UNION
(SELECT DISTINCT npi, total_claim_count,cbsaname
FROM prescription as p
CROSS JOIN cbsa as c
WHERE cbsaname LIKE '%Memphis%' AND cbsaname LIKE '%knoxville%'AND cbsaname LIKE '%Chattanooga%'
ORDER BY total_claim_count DESC
LIMIT 5);

--4,Find all counties which had an above-average number of overdose deaths. Report the county name and number of overdose deaths.
SELECT avg(overdose_deaths)
FROM overdose_deaths;

SELECT county, COUNT (overdose_deaths)
FROM overdose_deaths as od
INNER JOIN fips_county as fc
ON od.fipscounty = fc.fipscounty::integer
WHERE overdose_deaths >(SELECT avg(overdose_deaths)
               FROM overdose_deaths)
GROUP BY county;

--5,a Write a query that finds the total population of Tennessee.
SELECT SUM(population) AS total_pop_TN
FROM population as p
INNER JOIN fips_county AS fc USING (fipscounty)
WHERE state ='TN';
--b. Build off of the query that you wrote in part a to write a query that returns for each county that county's name, its population, 
--and the percentage of the total population of Tennessee that is contained in that county.
SELECT county, population,
	 SUM(population) AS total_pop,
     SUM( CASE WHEN state='TN' THEN population END)AS TN_pop,
	 SUM( CASE WHEN state='TN' THEN population END)* 100 / SUM(population) AS num_pop
FROM population as p
INNER JOIN fips_county AS fc USING (fipscounty)
GROUP BY county,population;




SELECT*
FROM fips_county;
