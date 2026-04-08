-- STEP 9 — EXPORT LAYER

-- STEP 9A — CREATE BI-READY EXPORT TABLE
DROP TABLE IF EXISTS layoffs_export_tb;

CREATE TABLE layoffs_export_tb AS
SELECT 
    CASE 
        WHEN company IS NULL THEN 'unknown'
        ELSE company
      END AS Company,  
    CASE 
        WHEN company IS NULL THEN 'missing'
        ELSE 'Reported'
    END AS Company_Status,
    
    CASE 
        WHEN location IS NULL THEN 'unknown'
        ELSE location
	END AS location, 
    CASE 
        WHEN location IS NULL THEN 'missing'
        ELSE 'Reported'
    END AS location_Status,
    
    CASE 
        WHEN industry IS NULL THEN 'unknown'
        ELSE industry
	END AS industry,
	CASE 
        WHEN industry IS NULL THEN 'missing'
        ELSE 'Reported'
    END AS industry_Status,
    
	CASE 
        WHEN total_laid_off IS NULL THEN 0
        ELSE total_laid_off
	END AS total_laid_off,
	CASE 
        WHEN total_laid_off IS NULL THEN 'missing'
        ELSE 'Reported'
    END AS Layoff_Status,
    
	CASE 
        WHEN percentage_laid_off IS NULL THEN 0
        ELSE percentage_laid_off
	END AS percentage_laid_off,
	CASE 
        WHEN percentage_laid_off IS NULL THEN 'missing'
        ELSE 'Reported'
    END AS percentage_Status,
    
	CASE 
        WHEN date IS NULL THEN '00/00/0000'
        ELSE date
	END AS date,
	CASE 
        WHEN date IS NULL THEN 'missing'
        ELSE 'Reported'
    END AS Date_Status,
    
	CASE 
        WHEN YEAR(date) IS NULL THEN '0'
        ELSE YEAR(date)
	END AS YEAR,
	CASE 
        WHEN YEAR(date) IS NULL THEN 'missing'
        ELSE 'Reported'
    END AS Year_Status,
    
	CASE 
        WHEN Month(date) IS NULL THEN '0'
        ELSE Month(date)
	END AS Month,
	CASE 
        WHEN Month(date) IS NULL THEN 'missing'
        ELSE 'Reported'
    END AS Month_Status,

    stage,
    country,
    
    CASE 
        WHEN funds_raised_millions IS NULL THEN 0
        ELSE funds_raised_millions
	END AS funds_raised_millions,
	CASE 
        WHEN funds_raised_millions IS NULL THEN 'missing'
        ELSE 'Reported'
		END AS Funds_Status
FROM layoffs_clean_tb;


-- STEP 9B — EXPORT CSV 
SELECT 
    'company',
    'Company_Status',
    'location',
    'location_Status',
    'industry',
    'Industry_Status',
    'total_laid_off',
    'layoffs_Status',
    'percentage_laid_off',
    'Percentage_Status',
    'date',
    'Date_Status',
    'year',
    'Year_Status',
    'Month',
    'Month_Status',
    'stage',
    'country',
    'funds_raised_millions',
    'Funds_Status'
UNION ALL
SELECT *
FROM layoffs_export_tb
INTO OUTFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\PERSONAL PROJECT\\layoffs_cleaned_dataset.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';


-- STEP 9C — VALIDATE EXPORT DATA
SELECT COUNT(*) FROM layoffs_export_tb;

SELECT 
    SUM(total_laid_off) AS total_layoffs,
    COUNT(DISTINCT company) AS total_companies,
    COUNT(DISTINCT country) AS total_countries
FROM layoffs_export_tb;

-- Check status distribution
SELECT date_status, COUNT(*) 
FROM layoffs_export_tb
GROUP BY date_status;

SELECT count(*) FROM layoffs_export_tb;
SELECT * FROM layoffs_export_tb;