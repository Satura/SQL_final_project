-- 1 Вывод имеющихся IT-вакансий, требования к квалификации/опыту, средняя ЗП
CREATE TEMP TABLE spec_names (spec_name TEXT NOT NULL UNIQUE);

DELETE FROM spec_names;

INSERT INTO spec_names VALUES 
('QA'), ('QE'), ('Quality Assurence'), ('Quality Engineer');
--('Java'),('Python'),('Ruby'),('C++'),('C#'),('Kotlin'),('Swift'),('PHP'),
--('Database Architec'),('Database Engineer'),('Data Engineer'),
--('Mobile Develper'),('Android Developer'), ('iOS Developer'), 
--('Web Designer'),('JavaScript'),('HTML'),('CSS'),
--('Network Security Engineer'),('Software Engineer')

SELECT 
	spec_name AS spec_name_or_key_word, 
	formatted_experience_level AS exp_level, 
	COUNT(title)/2 AS vacancy_amount, 
	ROUND(AVG(normalized_salary)) AS midle_salary
FROM spec_names, job_postings jp 
WHERE INSTR(lower(title), lower(spec_name)) > 0
GROUP BY spec_name, formatted_experience_level
ORDER BY 3 DESC

-- 2 ТОП 10 компаний по опубликованным вакансиям
SELECT 
	name, 
	COUNT(job_id) AS vacancy_amount, 
	industry 
FROM job_postings jp 
GROUP BY name 
ORDER BY 2 DESC
LIMIT 10

-- 3 частота предложения бонусов
SELECT 
	b."type" AS benefit, 
	COUNT(job_id) AS vacancy_amount
FROM benefits b 
GROUP BY 1
ORDER BY 2 DESC

-- 4 ТОП-10 наиболее оплачиваемых сфер деятельности компаний
SELECT 
	industry, 
	ROUND(AVG(normalized_salary),1) AS midle_salary
FROM job_postings jp 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

-- 5 ТОП востребованных навыков
SELECT 
	skill_abr, 
	COUNT(job_id) AS vacancy_amount
FROM job_skills js 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

-- 6 ТОП компаний с наибольшим предложением ЗП
SELECT 
	name, 
	ROUND(AVG(normalized_salary)) AS midle_salary, industry 
FROM job_postings jp 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

-- 7 ТОП индустрий по опубликованным вакансиям  
SELECT 
	industry, 
	COUNT(job_id) AS vacancy_amount
FROM job_postings jp 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

-- 8 распределение по типу занятости
SELECT 
	formatted_work_type, 
	COUNT(job_id) AS vacancy_amount, 
	COUNT(remote_allowed) AS remote_vacancy_amount,
	ROUND(COUNT(remote_allowed)*100.00/COUNT(job_id),2) AS percent
FROM 
	job_postings jp
GROUP BY 1
ORDER BY 2 DESC
