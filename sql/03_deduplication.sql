-- STEP 6 — CREATE DEDUPLICATION LOGIC

-- 6A — Add Row Number
WITH duplicates_cte AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY 
                company,
                location,
                industry,
                total_laid_off,
                percentage_laid_off,
                date,
                stage,
                country,
                funds_raised_millions
        ) AS row_num
    FROM layoffs_staging_tb
)
SELECT *
FROM duplicates_cte
WHERE row_num > 1;

-- 6B — DELETE DUPLICATES
-- Step 1 — Create deduplicated table
DROP TABLE IF EXISTS layoffs_deduped_tb;

CREATE TABLE layoffs_deduped_tb AS
SELECT *
FROM (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY 
                company,
                location,
                industry,
                total_laid_off,
                percentage_laid_off,
                date,
                stage,
                country,
                funds_raised_millions
        ) AS row_num
    FROM layoffs_staging_tb
) t
WHERE row_num = 1;

-- Step 2 — Verify
SELECT COUNT(*) FROM layoffs_staging_tb;
SELECT COUNT(*) FROM layoffs_deduped_tb;

-- Step 3 — Replace staging
DROP TABLE layoffs_staging_tb;

RENAME TABLE layoffs_deduped_tb TO layoffs_staging_tb;


