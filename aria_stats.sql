-- Create the table before uploading the dataset to Postgres
CREATE TABLE arias (
	aria VARCHAR(1000),
	role VARCHAR(255),
	opera VARCHAR(1000),
	composer VARCHAR(255),
	voice_part VARCHAR(255),
	frequency NUMERIC,
	language VARCHAR(255)
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
-- Find the most popular Bel Canto operas- these were written by Rossini, Donizetti, and Bellini
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
	voice_part = 'Tenor' AND language = 'French'
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
WHERE voice_part = 'Mezzo' AND year < 1750
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
-- A baritone doesn't like singing in Italian and doesn't want to sing any romantic 19th-century music.
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


-- #1
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


-- #2
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

-- Find the number of "hit" arias per composer- the number of arias that was offered more than average
SELECT 
	composer, 
	composer_nationality,
	COUNT(work) hits
FROM 
	(SELECT 
	 	composer, 
	 	composer_nationality,
	 	work, 
	 	SUM(performances) AS sum_perf
	FROM opera_stats
	GROUP BY 1, 2, 3
	HAVING SUM(performances) > 
		(SELECT AVG(sum_perf)
		FROM
			(SELECT 
				composer,
			 	work, 
			 	SUM(performances) AS sum_perf
			FROM opera_stats
			GROUP BY 1, 2) t1) 
		) t2
GROUP BY 
	composer, 
	composer_nationality
ORDER BY hits DESC

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
GROUP BY composer, opera 
ORDER BY hits DESC

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
	
-- Find the most prolific decade in terms of aria frequency
SELECT 
	decade, 
	SUM(frequency) AS frequency
FROM arias
GROUP BY decade
ORDER BY frequency desc

-- Find the most prolific decade in terms of aria count
SELECT 
	decade, 
	COUNT(aria) AS aria_count
FROM arias
GROUP BY decade
ORDER BY aria_count desc

-- Find the most prolific century in terms of aria frequency
SELECT 
	century,
	SUM(frequency) AS frequency
FROM arias
GROUP BY century
ORDER BY frequency desc

-- Find the most prolific century in terms of aria count
SELECT 
	century, 
	COUNT(aria) AS aria_count
FROM arias
GROUP BY century
ORDER BY aria_count desc

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
ORDER BY t3.decade, t3.sum_freq DESC

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
ORDER BY t3.decade, t3.sum_freq DESC

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
ORDER BY t3.decade, t3.sum_freq DESC

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
ORDER BY t3.decade, t3.sum_freq DESC

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
ORDER BY t3.century, t3.sum_freq DESC

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
ORDER BY t3.century, t3.sum_freq DESC

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
ORDER BY t3.century, t3.sum_freq DESC

-- Find the most prolific aria per century
