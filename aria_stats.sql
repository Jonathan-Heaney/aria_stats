-- Create the table before uploading the dataset to Postgres
CREATE TABLE arias (
	aria VARCHAR(1000),
	character VARCHAR(255),
	opera VARCHAR(1000),
	composer VARCHAR(255),
	voice_part VARCHAR(255),
	frequency NUMERIC,
	language VARCHAR(255)
)

-- #1
-- Find the total frequency and % of total frequency for each composer.
WITH total_frequency AS (
SELECT SUM(frequency) total_sum FROM arias
)
SELECT 
	t1.composer,
	SUM(t1.frequency) AS frequency_count,
	ROUND((SUM(t1.frequency) * 1.0 / t2.total_sum * 100), 2) AS composer_percent
FROM 
	arias t1, 
	(SELECT total_sum FROM total_frequency) t2
GROUP BY 
	t1.composer, 
	t2.total_sum
ORDER BY frequency_count DESC

-- #2
-- Find the total frequency and % total frequency for each opera.
WITH total_frequency AS (
SELECT SUM(frequency) total_sum FROM arias
)
SELECT 
	t1.composer,
	t1.opera,
	SUM(t1.frequency) AS frequency_count,
	ROUND((SUM(t1.frequency) * 1.0 / t2.total_sum * 100), 2) AS opera_percent
FROM 
	arias t1, 
	(SELECT total_sum FROM total_frequency) t2
GROUP BY 
	t1.composer, 
	t1.opera,
	t2.total_sum
ORDER BY frequency_count DESC

-- #3
-- Find the total frequency and % total frequency for each language.
WITH total_frequency AS (
SELECT SUM(frequency) total_sum FROM arias
)
SELECT 
	t1.language,
	SUM(t1.frequency) AS frequency_count,
	ROUND((SUM(t1.frequency) * 1.0 / t2.total_sum * 100), 2) AS language_percent
FROM 
	arias t1, 
	(SELECT total_sum FROM total_frequency) t2
GROUP BY 
	t1.language, 
	t2.total_sum
ORDER BY frequency_count DESC

-- #4
-- Find the total frequency and % total frequency for each voice part.
