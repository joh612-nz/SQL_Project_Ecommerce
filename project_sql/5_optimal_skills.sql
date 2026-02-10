/*
Answer: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), 
    offering strategic insights for career development in data analysis
*/


WITH top_paying_skills AS (
    SELECT
        skills_job_dim.skill_id,
        skills_dim.skills,
        ROUND(AVG(salary_year_avg), 0) AS avg_salary,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        salary_year_avg IS NOT NULL
        AND job_title_short = 'Data Analyst'
    GROUP BY
        skills_job_dim.skill_id,
        skills_dim.skills
    HAVING 
        COUNT(skills_job_dim.job_id) >= 1000 
    ORDER BY
        avg_salary DESC
),

top_demanded_skills AS (
    SELECT
        skills_job_dim.skill_id,
        skills_dim.skills,
        COUNT (*) AS skill_count
    FROM 
        skills_dim
    INNER JOIN skills_job_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
    WHERE
        job_title_short = 'Data Analyst'
    GROUP BY
        skills_job_dim.skill_id,
        skills_dim.skills
    ORDER BY
        skill_count DESC
)

SELECT
    top_paying_skills.skills AS high_paying_skill,
    top_paying_skills.avg_salary,
    top_paying_skills.demand_count AS high_paying_skill_demand,
    top_demanded_skills.skill_count AS high_demand_skill_count
FROM
    top_paying_skills
INNER JOIN top_demanded_skills ON top_paying_skills.skill_id = top_demanded_skills.skill_id
ORDER BY
    avg_salary DESC, high_demand_skill_count DESC;


-- More efficient way to get the same result is to start from job_postings_fact and join to skills_dim, 
--  which may be more efficient if there are many skills that are not related to data analyst jobs.
-- added filter for remote jobs and only consider skills that appear in at least 10 job postings to ensure statistical significance

SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    skills_dim.skill_id,
    skills_dim.skills
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC, 
    demand_count DESC
LIMIT 25;