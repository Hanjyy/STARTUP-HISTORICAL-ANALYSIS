USE startup_db;
SELECT * FROM funding_rounds
WHERE raised_amount_usd > 0;

/*Number of startup acquired and total money spent on them. */
SELECT acquiring_object_id, COUNT(acquiring_object_id) AS total_startup_acquired, SUM(price_amount) AS total_money_spent
FROM acquisitions
GROUP BY acquiring_object_id
ORDER BY total_money_spent DESC;

/*Acquisition per year*/
SELECT 
FORMAT(acquired_at, 'yyyy') AS acquisition_year,
COUNT(acquiring_object_id) AS no_of_acquisition,
SUM(price_amount) AS total_acquisition_value 
FROM dbo.acquisitions
GROUP BY FORMAT(acquired_at, 'yyyy')
ORDER BY FORMAT(acquired_at, 'yyyy') ASC;

/*Country with the most startup*/
SELECT country_code, COUNT(country_code) AS no_of_startups, SUM(funding_total_usd) AS total_fund_recieved
FROM [dbo].[objects]
WHERE entity_type = 'Company'
GROUP BY country_code
ORDER BY no_of_startups DESC;

/*Total no. of startups in each country*/
SELECT co.name AS country, COUNT(ob.name) AS no_of_startups, SUM(ob.funding_total_usd) AS total_fund_received
FROM  countries co
JOIN  objects ob
ON co.country_code = ob.country_code
GROUP BY co.name
ORDER BY no_of_startups DESC;

/* Total no of startups in each continent*/

SELECT co.region AS continent, COUNT(ob.name) AS no_of_startups, SUM(ob.funding_total_usd) AS total_fund_received
FROM countries co
JOIN objects ob
ON co.country_code = ob.country_code
GROUP BY co.region
ORDER BY no_of_startups DESC;

/* Top investment in Africa startups*/
SELECT 
	ob.normalized_name,
	co.name AS country,
	ob.funding_total_usd
FROM 
	countries co
JOIN 
	objects ob
ON co.country_code = ob.country_code
WHERE co.region = 'Africa'
ORDER BY funding_total_usd DESC;

/* What university did the founder that has the most funded startup*/
SELECT 
	CONCAT(pe.first_name,' ', pe.last_name) AS full_name,
	pe.affiliation_name,
	de.degree_type,
	de.institution,
	re.title,
	fr.raised_amount_usd
FROM people pe
JOIN degrees de
ON pe.object_id = de.object_id
JOIN relationships re
ON de.object_id = re.person_object_id
JOIN funding_rounds fr
ON re.relationship_object_id = fr.object_id
WHERE re.title  LIKE '%Founder%' 
ORDER BY raised_amount_usd DESC;

/*DEGREES INFLUENCE ON FUNDING FOR STARTUPS*/
SELECT * 
FROM degrees de
JOIN relationships re
ON de.object_id = re.person_object_id
JOIN objects ob
ON re.relationship_object_id = ob.object_id;

SELECT * 
FROM degrees de
JOIN objects ob
ON de.object_id = ob.object_id;

/*INVESTMENT COMPANIES AND STARTUPS THEY INVESTED IN*/
SELECT fu.name AS investment_company, COUNT(ob.name) AS no_of_investments
FROM funds fu
JOIN investments iv
ON fu.object_id = iv.investor_object_id
JOIN objects ob
ON iv.funded_object_id = ob.object_id
GROUP BY fu.name
ORDER BY no_of_investments DESC;

/*NO OF PERSONNEL EACH STARTUP HAS*/
SELECT ob.name AS startup, COUNT(CONCAT(pe.first_name, ' ', pe.last_name)) AS no_of_personnel
FROM people pe
JOIN relationships re
ON pe.object_id = re.person_object_id
JOIN objects ob
ON re.relationship_object_id = ob.object_id
GROUP BY ob.name
ORDER BY no_of_personnel DESC;


/*FOUNDER'S NAME WITH THE HIGHEST FUNDING ROUND*/
SELECT CONCAT(pe.first_name, ' ', pe.last_name) AS name, re.title, ob.name AS startup, ob.funding_rounds, ob.funding_total_usd
FROM people pe
JOIN relationships re
ON pe.object_id = re.person_object_id
JOIN objects ob
ON re.relationship_object_id = ob.object_id;