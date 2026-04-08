-- STEP 7 — DATA TYPE STANDARDIZATION
-- 7A — Create FINAL clean table
DROP TABLE IF EXISTS layoffs_clean_tb;

CREATE TABLE layoffs_clean_tb (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company VARCHAR(255),
    location VARCHAR(255),
    industry VARCHAR(255),
    total_laid_off INT,
    percentage_laid_off DECIMAL(5,2),
    date DATE,
    stage VARCHAR(100),
    country VARCHAR(100),
    funds_raised_millions DECIMAL(10,2)
);

-- 7B — Insert CLEANED data
INSERT INTO layoffs_clean_tb (
    company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    date,
    stage,
    country,
    funds_raised_millions
)
SELECT
    company,
    location,
    industry,
    total_laid_off,
-- SAFE percentage conversion
    CASE 
        WHEN TRIM(percentage_laid_off) REGEXP '^[0-9]+(\\.[0-9]+)?$'
        THEN CAST(TRIM(percentage_laid_off) AS DECIMAL(5,2))
        ELSE NULL
    END,
    STR_TO_DATE(Date, '%m/%d/%Y'),
    stage,
    country,
-- ONLY CAST VALID NUMBERS
    CASE 
    WHEN TRIM(funds_raised_millions) REGEXP '^[0-9]+(\\.[0-9]+)?$'
    THEN CAST(TRIM(funds_raised_millions) AS DECIMAL(10,2))
    ELSE NULL
END
FROM layoffs_staging_tb;

-- PHASE 4 — FINAL VALIDATION & DATA QUALITY HANDLING
-- STEP 8 — FINAL VALIDATION
SELECT * FROM layoffs_clean_tb
LIMIT 10;

SELECT COUNT(*) FROM layoffs_clean_tb;

SELECT 
    COUNT(*) - COUNT(date) AS missing_dates,
    COUNT(*) - COUNT(total_laid_off) AS missing_layoffs
FROM layoffs_clean_tb;

-- STEP 8A — INVESTIGATE MISSING VALUES
-- STEP 8A.1 — Inspect missing date
SELECT *
FROM layoffs_clean_tb
WHERE date IS NULL;

-- STEP 8A.2 — Inspect missing layoffs
SELECT *
FROM layoffs_clean_tb
WHERE total_laid_off IS NULL
LIMIT 20;

-- STEP 8B — DEFINE DATA HANDLING STRATEGY
-- KEEP NULLs in clean table and handle them at reporting layer (Power BI)

-- STEP 8C — DATA LIMITATIONS
-- DATA QUALITY NOTE
-- 739 records have missing total_laid_off values
-- These represent incomplete reporting from source data
-- NULL values are preserved to maintain data integrity
-- Aggregations in BI layer will account for NULL handling

-- STEP 8— PREPARE FOR BI (CONTROLLED HANDLING)
-- STEP 9A — BI-ready table
DROP TABLE IF EXISTS layoffs_export_tb;

CREATE TABLE layoffs_export_tb AS
SELECT 
    company,
    location,
    industry,
    CASE 
        WHEN total_laid_off IS NULL THEN 0
        ELSE total_laid_off
    END AS total_laid_off,
    CASE 
        WHEN total_laid_off IS NULL THEN 'Unknown'
        ELSE 'Reported'
    END AS layoffs_status,
IFNULL(percentage_laid_off, 0) AS percentage_laid_off,
    date,
    YEAR(date) AS year,
    MONTH(date) AS month,
    stage,
    country,
    IFNULL(funds_raised_millions, 0) AS funds_raised_millions
FROM layoffs_clean_tb;

