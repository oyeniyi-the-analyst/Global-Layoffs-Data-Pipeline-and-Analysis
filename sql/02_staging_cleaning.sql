-- STEP 4 — STAGING LAYER
DROP TABLE IF EXISTS layoffs_staging_tb;

CREATE TABLE layoffs_staging_tb AS
SELECT *
FROM layoffs_raw_tb;

-- STEP 5 — DATA CLEANING
-- 5A — Trim + Standardize NULLs
UPDATE layoffs_staging_tb
SET 
    company = NULLIF(TRIM(company), ''),
    location = NULLIF(TRIM(location), ''),
    industry = NULLIF(TRIM(industry), ''),
    percentage_laid_off = NULLIF(TRIM(REPLACE(percentage_laid_off, '%', '')), ''),
    date = NULLIF(TRIM(date), ''),
    stage = NULLIF(TRIM(stage), ''),
    country = NULLIF(TRIM(country), ''),
    funds_raised_millions = NULLIF(TRIM(REPLACE(funds_raised_millions, ',', '')), '');
    
    -- 5B — Normalize Bad Values
    UPDATE layoffs_staging_tb
SET 
    company = NULLIF(UPPER(company), 'NULL'),
    industry = NULLIF(UPPER(industry), 'N/A'),
    location = NULLIF(UPPER(location), 'N/A'),
    stage = NULLIF(UPPER(stage), 'N/A'),
    country = NULLIF(UPPER(country), 'N/A');
    
 -- TO AVOID POTENTIAL ERRORS IN 7B
 --  -- STEP 1 — CLEAN NUMERIC COLUMNS PROPERLY
  UPDATE layoffs_staging_tb
SET 
    funds_raised_millions = NULL
WHERE TRIM(UPPER(funds_raised_millions)) IN ('NULL', 'N/A', '');

-- STEP 2 — CLEAN PERCENTAGE COLUMN
UPDATE layoffs_staging_tb
SET 
    percentage_laid_off = NULL
WHERE TRIM(UPPER(percentage_laid_off)) IN ('NULL', 'N/A', '');

-- STEP 3 — VERIFY BEFORE INSERT in 7B
SELECT DISTINCT funds_raised_millions
FROM layoffs_staging_tb
WHERE funds_raised_millions IS NOT NULL
LIMIT 20;

-- DEBUG STEP
SELECT DISTINCT funds_raised_millions
FROM layoffs_staging_tb
WHERE TRIM(funds_raised_millions) NOT REGEXP '^[0-9]+$'
AND funds_raised_millions IS NOT NULL; 

-- Ensure consistent casing
UPDATE layoffs_staging_tb
SET company = TRIM(company),
location = TRIM(location),
industry = TRIM(industry),
total_laid_off = TRIM(total_laid_off),
percentage_laid_off = TRIM(percentage_laid_off),
date = TRIM(date),
stage = TRIM(stage),
country = TRIM(country),
funds_raised_millions = TRIM(funds_raised_millions);