/*
Question: What are the most in-demand skills for data analysts?
- Join job postings to inner join table smiliar to query 2
- Identify the top 5 in-demand skills for a data analyst.
- Focus on all job postings.
- Why? Retrieves the top 5 skills with the highest demand in the job market,
    providing insights into the most valuable skills for job seekers.
*/

-- This query identifies the top 5 most in-demand skills for data analysts by counting the occurrences of each skill in job postings for data analyst roles. 
-- The results are ordered by the count of each skill, showing which skills are most frequently required in the job market.

SELECT
    skills,
    COUNT (*) AS skill_count
FROM 
    skills_dim
INNER JOIN skills_job_dim ON skills_dim.skill_id = skills_job_dim.skill_id
INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    skill_count DESC
LIMIT 5;

-- Another way to drive the same result is to start from job_postings_fact and join to skills_dim, 
--  which may be more efficient if there are many skills that are not related to data analyst jobs.

SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
