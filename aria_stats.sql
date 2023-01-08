-- Create the table before uploading the dataset to Postgres
CREATE TABLE arias (
	aria VARCHAR(1000),
	role VARCHAR(255),
	opera VARCHAR(1000),
	composer VARCHAR(255),
	voice_part VARCHAR(255),
	frequency NUMERIC,
	language VARCHAR(255),
	year NUMERIC,
	decade VARCHAR(255),
	century VARCHAR(255)
)

-- #1 
-- Find the most popular arias overall
SELECT 
	composer, 
	opera, 
	aria, 
	voice_part, 
	language, 
	frequency
FROM arias
ORDER BY frequency DESC

-- #1a
-- Find the most popular Bel Canto arias- these were written by Rossini, Donizetti, and Bellini
SELECT 
	composer, 
	opera, 
	aria, 
	voice_part, 
	language, 
	frequency
FROM arias
WHERE composer IN('Rossini', 'Donizetti', 'Bellini')
ORDER BY frequency DESC

-- #1b
-- Find French arias for tenors, with the rarer ones first
SELECT 
	composer, 
	opera, 
	aria, 
	voice_part, 
	language, 
	frequency
FROM arias
WHERE 
	voice_part = 'Tenor' AND 
	language = 'French'
ORDER BY frequency

-- #1c
-- Find mezzo arias written before 1750 for an early-music concert
SELECT 
	composer, 
	opera, 
	aria, 
	voice_part, 
	language, 
	frequency,
	year
FROM arias
WHERE 
	voice_part = 'Mezzo' AND 
	year < 1750
ORDER BY frequency DESC

-- #1d
-- A soprano wants to learn a role with a lot of arias in it. Find all the soprano roles that have at least 3 arias
SELECT 
	composer, 
	opera,
	role,
	language, 
	COUNT(aria) aria_count
FROM arias
WHERE voice_part = 'Soprano'
GROUP BY 
	composer,
	opera,
	role,
	language
HAVING COUNT(aria) >= 3
ORDER BY aria_count DESC

-- #1e
-- Find arias for a baritone who doesn't like singing in Italian and doesn't want to sing any romantic 19th-century music.
SELECT 
	composer, 
	opera, 
	aria, 
	voice_part, 
	language, 
	frequency,
	year
FROM arias
WHERE 
	voice_part = 'Baritone' AND 
	language != 'Italian' AND
	year NOT BETWEEN 1800 AND 1900
ORDER BY frequency DESC


-- #2
-- Find the total frequency and total aria count for each composer.
SELECT 
	s.composer,
	s.frequency_count,
	s.frequency_percent,
	c.aria_count,
	c.count_percent
FROM (
	WITH total_frequency AS (
	SELECT SUM(frequency) total_sum FROM arias
	)
	SELECT 
		t1.composer,
		SUM(t1.frequency) AS frequency_count,
		ROUND((SUM(t1.frequency) * 1.0 / t2.total_sum * 100), 2) AS frequency_percent
	FROM 
		arias t1, 
		(SELECT total_sum FROM total_frequency) t2
	GROUP BY 
		t1.composer, 
		t2.total_sum
	) s
JOIN (
	WITH total_count AS (
	SELECT COUNT(aria) total_aria_count FROM arias
	)
	SELECT 
		t1.composer,
		COUNT(t1.aria) AS aria_count,
		ROUND((COUNT(t1.aria) * 1.0 / t2.total_aria_count * 100), 2) AS count_percent
	FROM 
		arias t1, 
		(SELECT total_aria_count FROM total_count) t2
	GROUP BY 
		t1.composer, 
		t2.total_aria_count
	) c
ON s.composer = c.composer
ORDER BY 
	s.frequency_count DESC,
	c.aria_count DESC


-- #2a
-- Find the total frequency and total aria count for each opera.
SELECT 
	s.composer,
	s.opera,
	s.frequency_count,
	s.frequency_percent,
	c.aria_count,
	c.count_percent
FROM (
	WITH total_frequency AS (
	SELECT SUM(frequency) total_sum FROM arias
	)
	SELECT 
		t1.composer,
		t1.opera,
		SUM(t1.frequency) AS frequency_count,
		ROUND((SUM(t1.frequency) * 1.0 / t2.total_sum * 100), 2) AS frequency_percent
	FROM 
		arias t1, 
		(SELECT total_sum FROM total_frequency) t2
	GROUP BY 
		t1.composer,
		t1.opera,
		t2.total_sum
	) s
JOIN (
	WITH total_count AS (
	SELECT COUNT(aria) total_aria_count FROM arias
	)
	SELECT 
		t1.composer,
		t1.opera,
		COUNT(t1.aria) AS aria_count,
		ROUND((COUNT(t1.aria) * 1.0 / t2.total_aria_count * 100), 2) AS count_percent
	FROM 
		arias t1, 
		(SELECT total_aria_count FROM total_count) t2
	GROUP BY 
		t1.composer,
		t1.opera,
		t2.total_aria_count
	) c
ON 
	s.composer = c.composer AND
	s.opera = c.opera
ORDER BY 
	s.frequency_count DESC,
	c.aria_count DESC


-- #2b
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


-- #2c
-- Find the total frequency and total aria count for each voice part.
SELECT 
	s.voice_part,
	s.frequency_count,
	s.frequency_percent,
	c.aria_count,
	c.count_percent
FROM (
	WITH total_frequency AS (
	SELECT SUM(frequency) total_sum FROM arias
	)
	SELECT 
		t1.voice_part,
		SUM(t1.frequency) AS frequency_count,
		ROUND((SUM(t1.frequency) * 1.0 / t2.total_sum * 100), 2) AS frequency_percent
	FROM 
		arias t1, 
		(SELECT total_sum FROM total_frequency) t2
	GROUP BY 
		t1.voice_part, 
		t2.total_sum
	) s
JOIN (
	WITH total_count AS (
	SELECT COUNT(aria) total_aria_count FROM arias
	)
	SELECT 
		t1.voice_part,
		COUNT(t1.aria) AS aria_count,
		ROUND((COUNT(t1.aria) * 1.0 / t2.total_aria_count * 100), 2) AS count_percent
	FROM 
		arias t1, 
		(SELECT total_aria_count FROM total_count) t2
	GROUP BY 
		t1.voice_part, 
		t2.total_aria_count
	) c
ON s.voice_part = c.voice_part
ORDER BY s.frequency_percent DESC

-- #3
-- Find the number of "hit" arias per composer- the number of arias that were offered more than average
SELECT 
	composer, 
	COUNT(aria) AS hits
FROM 
	(SELECT 
	 	composer, 
	 	aria, 
	 	frequency
	FROM arias
	GROUP BY 
		composer,
		aria,
		frequency
	HAVING frequency > (SELECT AVG(frequency) 
						FROM arias)
	) sub
GROUP BY composer
ORDER BY hits DESC

-- #3a
-- Find the number of hit arias per opera
SELECT 
	composer, 
	opera,
	COUNT(aria) AS hits
FROM 
	(SELECT 
	 	composer, 
	 	opera,
	 	aria, 
	 	frequency
	FROM arias
	GROUP BY 
		composer,
	 	opera,
		aria,
		frequency
	HAVING frequency > (SELECT AVG(frequency) 
						FROM arias)
	) sub
GROUP BY 
	composer, 
	opera 
ORDER BY hits DESC

-- #4
-- Rank the composers by frequency, showing language
SELECT 
	composer, 
	language, 
	SUM(frequency) AS frequency
FROM arias
GROUP BY	
	composer, 
	language
ORDER BY frequency DESC

-- #4a
-- Find the top composer for each of the main languages (which have > 100 aria offerings total)
SELECT
	t3.composer,
	t3.language,
	t3.sum_freq
FROM 
	(SELECT 
		composer, 
		language, 
		SUM(frequency) AS sum_freq
	FROM arias
	GROUP BY 
		composer, 
		language
	) t3
JOIN (
	SELECT 
		language, 
		MAX(sum_freq) AS max_freq
	FROM (
		SELECT 
			composer, 
			language, 
			SUM(frequency) AS sum_freq
		FROM arias
		GROUP BY 
			composer, 
			language
		) t1
	GROUP BY language
	HAVING MAX(sum_freq) > 100
	) t2
ON 
	t2.max_freq = t3.sum_freq AND
	t2.language = t3.language
ORDER BY t3.sum_freq DESC

-- #5	
-- Find the most prolific decade in terms of aria frequency
SELECT 
	decade, 
	SUM(frequency) AS frequency
FROM arias
GROUP BY decade
ORDER BY frequency DESC

-- #5a
-- Find the most prolific decade in terms of aria count
SELECT 
	decade, 
	COUNT(aria) AS aria_count
FROM arias
GROUP BY decade
ORDER BY aria_count DESC

-- #5b
-- Find the most prolific century in terms of aria frequency
SELECT 
	century,
	SUM(frequency) AS frequency
FROM arias
GROUP BY century
ORDER BY frequency DESC

-- #5c
-- Find the most prolific century in terms of aria count
SELECT 
	century, 
	COUNT(aria) AS aria_count
FROM arias
GROUP BY century
ORDER BY aria_count DESC

-- #6
-- Find the most prolific composer per decade, in terms of aria frequency
SELECT
	t3.decade,
	t3.composer,
	t3.sum_freq
FROM 
	(SELECT 
		decade, 
		composer, 
		SUM(frequency) AS sum_freq
	FROM arias
	GROUP BY 
	 	decade,
		composer 
	) t3
JOIN (
	SELECT 
		decade, 
		MAX(sum_freq) AS max_freq
	FROM (
		SELECT 
			decade, 
			composer, 
			SUM(frequency) AS sum_freq
		FROM arias
		GROUP BY 
			decade,
			composer 
		) t1
	GROUP BY decade
	) t2
ON 
	t2.max_freq = t3.sum_freq AND
	t2.decade = t3.decade
ORDER BY 
	t3.decade, 
	t3.sum_freq DESC

-- #6a
-- Find the most prolific language per decade, in terms of aria frequency
SELECT
	t3.decade,
	t3.language,
	t3.sum_freq
FROM 
	(SELECT 
		decade, 
		language, 
		SUM(frequency) AS sum_freq
	FROM arias
	GROUP BY 
	 	decade,
		language 
	) t3
JOIN (
	SELECT 
		decade, 
		MAX(sum_freq) AS max_freq
	FROM (
		SELECT 
			decade, 
			language, 
			SUM(frequency) AS sum_freq
		FROM arias
		GROUP BY 
			decade,
			language 
		) t1
	GROUP BY decade
	) t2
ON 
	t2.max_freq = t3.sum_freq AND
	t2.decade = t3.decade
ORDER BY 
	t3.decade, 
	t3.sum_freq DESC

-- #6b
-- Find the most prolific opera per decade, in terms of aria frequency
SELECT
	t3.decade,
	t3.composer,
	t3.opera,
	t3.language,
	t3.sum_freq
FROM 
	(SELECT 
		decade,
	 	composer,
		opera, 
	 	language,
		SUM(frequency) AS sum_freq
	FROM arias
	GROUP BY 
	 	decade,
	 	composer,
		opera,
	 	language
	) t3
JOIN (
	SELECT 
		decade, 
		MAX(sum_freq) AS max_freq
	FROM (
		SELECT 
			decade,
			composer,
			opera, 
			language,
			SUM(frequency) AS sum_freq
		FROM arias
		GROUP BY 
			decade,
			composer,
			opera, 
			language
		) t1
	GROUP BY decade
	) t2
ON 
	t2.max_freq = t3.sum_freq AND
	t2.decade = t3.decade
ORDER BY 
	t3.decade, 
	t3.sum_freq DESC

-- #6c
-- Find the most popular aria per decade
SELECT
	t3.decade,
	t3.composer,
	t3.opera,
	t3.aria,
	t3.voice_part,
	t3.language,
	t3.sum_freq
FROM 
	(SELECT 
		decade,
	 	composer,
		opera, 
	 	aria,
	 	voice_part,
	 	language,
		SUM(frequency) AS sum_freq
	FROM arias
	GROUP BY 
	 	decade,
	 	composer,
		opera,
	 	aria,
	 	voice_part,
	 	language
	) t3
JOIN (
	SELECT 
		decade, 
		MAX(sum_freq) AS max_freq
	FROM (
		SELECT 
			decade,
			composer,
			opera, 
			aria,
			voice_part,
			language,
			SUM(frequency) AS sum_freq
		FROM arias
		GROUP BY 
			decade,
			composer,
			opera, 
			aria,
			voice_part,
			language
		) t1
	GROUP BY decade
	) t2
ON 
	t2.max_freq = t3.sum_freq AND
	t2.decade = t3.decade
ORDER BY 
	t3.decade, 
	t3.sum_freq DESC

-- #7
-- Find the most prolific composer per century, in terms of aria frequency
SELECT
	t3.century,
	t3.composer,
	t3.sum_freq
FROM 
	(SELECT 
		century, 
		composer, 
		SUM(frequency) AS sum_freq
	FROM arias
	GROUP BY 
	 	century,
		composer 
	) t3
JOIN (
	SELECT 
		century, 
		MAX(sum_freq) AS max_freq
	FROM (
		SELECT 
			century, 
			composer, 
			SUM(frequency) AS sum_freq
		FROM arias
		GROUP BY 
			century,
			composer 
		) t1
	GROUP BY century
	) t2
ON 
	t2.max_freq = t3.sum_freq AND
	t2.century = t3.century
ORDER BY 
	t3.century, 
	t3.sum_freq DESC

-- #7a
-- Find the most prolific language per century, in terms of aria frequency
SELECT
	t3.century,
	t3.language,
	t3.sum_freq
FROM 
	(SELECT 
		century, 
		language, 
		SUM(frequency) AS sum_freq
	FROM arias
	GROUP BY 
	 	century,
		language 
	) t3
JOIN (
	SELECT 
		century, 
		MAX(sum_freq) AS max_freq
	FROM (
		SELECT 
			century, 
			language, 
			SUM(frequency) AS sum_freq
		FROM arias
		GROUP BY 
			century,
			language 
		) t1
	GROUP BY century
	) t2
ON 
	t2.max_freq = t3.sum_freq AND
	t2.century = t3.century
ORDER BY 
	t3.century, 
	t3.sum_freq DESC

-- #7b
-- Find the most prolific opera per century, in terms of aria frequency
SELECT
	t3.century,
	t3.composer,
	t3.opera,
	t3.language,
	t3.sum_freq
FROM 
	(SELECT 
		century,
	 	composer,
		opera, 
	 	language,
		SUM(frequency) AS sum_freq
	FROM arias
	GROUP BY 
	 	century,
	 	composer,
		opera,
	 	language
	) t3
JOIN (
	SELECT 
		century, 
		MAX(sum_freq) AS max_freq
	FROM (
		SELECT 
			century,
			composer,
			opera, 
			language,
			SUM(frequency) AS sum_freq
		FROM arias
		GROUP BY 
			century,
			composer,
			opera, 
			language
		) t1
	GROUP BY century
	) t2
ON 
	t2.max_freq = t3.sum_freq AND
	t2.century = t3.century
ORDER BY 
	t3.century, 
	t3.sum_freq DESC

-- #7c
-- Find the most prolific aria per century
SELECT
	t3.century,
	t3.composer,
	t3.opera,
	t3.aria,
	t3.voice_part,
	t3.language,
	t3.sum_freq
FROM 
	(SELECT 
		century,
	 	composer,
		opera, 
	 	aria,
	 	voice_part,
	 	language,
		SUM(frequency) AS sum_freq
	FROM arias
	GROUP BY 
	 	century,
	 	composer,
		opera,
	 	aria,
	 	voice_part,
	 	language
	) t3
JOIN (
	SELECT 
		century, 
		MAX(sum_freq) AS max_freq
	FROM (
		SELECT 
			century,
			composer,
			opera, 
			aria,
			voice_part,
			language,
			SUM(frequency) AS sum_freq
		FROM arias
		GROUP BY 
			century,
			composer,
			opera, 
			aria,
			voice_part,
			language
		) t1
	GROUP BY century
	) t2
ON 
	t2.max_freq = t3.sum_freq AND
	t2.century = t3.century
ORDER BY 
	t3.century, 
	t3.sum_freq DESC

-- #8
-- Find the distribution of languages across time
SELECT 
	decade, 
	language, 
	SUM(frequency) AS sum_freq
FROM arias
GROUP BY 
	decade,
	language 
ORDER BY
	decade, 
	sum_freq DESC

-- #9
-- Find the number of distinct composers per decade
SELECT 
	decade, 
	COUNT(DISTINCT(composer)) AS composer_count
FROM arias
GROUP BY decade
ORDER BY decade

-- #9a
-- Find the number of distinct operas per decade
SELECT 
	decade, 
	COUNT(DISTINCT(opera)) AS opera_count
FROM arias
GROUP BY decade
ORDER BY decade

-- #9b
-- Find the number of distinct composers per century
SELECT 
	century, 
	COUNT(DISTINCT(composer)) AS composer_count
FROM arias
GROUP BY century
ORDER BY century

-- #9c
-- Find the number of distinct operas per century
SELECT 
	century, 
	COUNT(DISTINCT(opera)) AS opera_count
FROM arias
GROUP BY century
ORDER BY century

-- #10
-- Query that combines the count of composers and aria frequency count per decade
SELECT 
	t1.decade, 
	t2.composer_count, 
	t1.aria_frequency
FROM (
	SELECT 
		decade, 
		SUM(frequency) AS aria_frequency
	FROM arias
	GROUP BY decade
	) t1
JOIN (
	SELECT 
		decade, 
		COUNT(DISTINCT(composer)) AS composer_count
	FROM arias
	GROUP BY decade
	) t2
ON t1.decade = t2.decade
GROUP BY 
	t1.decade,
	t2.composer_count,
	t1.aria_frequency

-- #10a
-- Query that combines the count of operas and aria frequency count per decade
SELECT 
	t1.decade, 
	t2.opera_count, 
	t1.aria_frequency
FROM (
	SELECT 
		decade, 
		SUM(frequency) AS aria_frequency
	FROM arias
	GROUP BY decade
	) t1
JOIN (
	SELECT 
		decade, 
		COUNT(DISTINCT(opera)) AS opera_count
	FROM arias
	GROUP BY decade
	) t2
ON t1.decade = t2.decade
GROUP BY 
	t1.decade,
	t2.opera_count,
	t1.aria_frequency
