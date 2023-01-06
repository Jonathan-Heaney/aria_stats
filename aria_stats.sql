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

-- #1a
-- Find the total aria count and % total aria count for each composer.


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

-- #2a
-- Find the total aria count and % total aria count for each opera.


-- #3
-- Find the total frequency and total aria count for each language.
SELECT 
	s.language,
	s.frequency_count,
	s.frequency_percent,
	c.aria_count,
	c.count_percent
FROM (
	WITH total_frequency AS (
	SELECT SUM(frequency) total_sum FROM arias
	)
	SELECT 
		t1.language,
		SUM(t1.frequency) AS frequency_count,
		ROUND((SUM(t1.frequency) * 1.0 / t2.total_sum * 100), 2) AS frequency_percent
	FROM 
		arias t1, 
		(SELECT total_sum FROM total_frequency) t2
	GROUP BY 
		t1.language, 
		t2.total_sum
	) s
JOIN (
	WITH total_count AS (
	SELECT COUNT(aria) total_aria_count FROM arias
	)
	SELECT 
		t1.language,
		COUNT(t1.aria) AS aria_count,
		ROUND((COUNT(t1.aria) * 1.0 / t2.total_aria_count * 100), 2) AS count_percent
	FROM 
		arias t1, 
		(SELECT total_aria_count FROM total_count) t2
	GROUP BY 
		t1.language, 
		t2.total_aria_count
	) c
ON s.language = c.language
ORDER BY s.frequency_percent DESC


-- #4
-- Find the total frequency and % total frequency for each voice part.
WITH total_frequency AS (
SELECT SUM(frequency) total_sum FROM arias
)
SELECT 
	t1.voice_part,
	SUM(t1.frequency) AS frequency_count,
	ROUND((SUM(t1.frequency) * 1.0 / t2.total_sum * 100), 2) AS voice_part_percent
FROM 
	arias t1, 
	(SELECT total_sum FROM total_frequency) t2
GROUP BY 
	t1.voice_part, 
	t2.total_sum
ORDER BY frequency_count DESC

-- #4a
-- Find the total aria count and % total aria count for each voice part.
WITH total_count AS (
SELECT COUNT(aria) total_aria_count FROM arias
)
SELECT 
	t1.voice_part,
	COUNT(t1.aria) AS aria_count,
	ROUND((COUNT(t1.aria) * 1.0 / t2.total_aria_count * 100), 2) AS voice_part_percent
FROM 
	arias t1, 
	(SELECT total_aria_count FROM total_count) t2
GROUP BY 
	t1.voice_part, 
	t2.total_aria_count
ORDER BY aria_count DESC