
/*
UNION OPERATORS
    - Get the corresponding skill and skill type for each job posting in q1
    - Includes those withouy any skills, too
    - Why? Look at the skills and the type for each job in the first quarter that has a salary > $70,000
*/


WITH sk AS (
    SELECT
        skills_dim.skill_id, 
        skills_dim.skills,
        skills_dim.type,
        skills_job_dim.job_id AS job_id
    FROM
        skills_dim 
    LEFT JOIN skills_job_dim ON skills_dim.skill_id = skills_job_dim.skill_id
)

SELECT 
    jan.job_id,
    jan.job_title_short,
    jan.salary_year_avg,
    jan.job_posted_date,
    sk.skill_id,
    sk.skills,
    sk.type
FROM
    january_2023_jobs AS jan
LEFT JOIN sk ON jan.job_id = sk.job_id
WHERE 
    jan.salary_year_avg >70000

UNION ALL

SELECT 
    feb.job_id,
    feb.job_title_short,
    feb.salary_year_avg,
    feb.job_posted_date,
    sk.skill_id,
    sk.skills,
    sk.type
FROM
    february_2023_jobs AS feb
LEFT JOIN sk ON feb.job_id = sk.job_id
WHERE 
    feb.salary_year_avg >70000

UNION ALL

SELECT 
    mar.job_id,
    mar.job_title_short,
    mar.salary_year_avg,
    mar.job_posted_date,
    sk.skill_id,
    sk.skills,
    sk.type
FROM
    march_2023_jobs AS mar
LEFT JOIN sk ON mar.job_id = sk.job_id
WHERE 
    mar.salary_year_avg >70000
ORDER BY job_posted_date;

/*
PRACTICE PROBLEM 8

Find job postings from the first quarter that have a salary greater than $70k
    - combine job posting tables from the first quarter of 2023 (Jan-Mar)
    - gets job postings with an average yearly salary > $70,000
*/

SELECT 
    q1_jobs.job_title_short,
    q1_jobs.job_location,
    q1_jobs.job_via,
    q1_jobs.job_posted_date::DATE AS jp_date,
    q1_jobs.salary_year_avg
FROM (
    SELECT *
    FROM
        january_2023_jobs
    UNION ALL
    SELECT *
    FROM
        february_2023_jobs
    UNION ALL
    SELECT *
    FROM
        march_2023_jobs
) AS q1_jobs
WHERE
    salary_year_avg >70000
ORDER BY
    jp_date;