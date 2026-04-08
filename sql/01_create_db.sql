-- STEP 1 — CREATE DATABASE

-- Reset environment (idempotent)
DROP DATABASE IF EXISTS layoffs_db;

CREATE DATABASE layoffs_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE layoffs_db;

-- STEP 2 — RAW TABLE
DROP TABLE IF EXISTS layoffs_raw_tb;

CREATE TABLE layoffs_raw_tb (
    company VARCHAR(255),
    location VARCHAR(255),
    industry VARCHAR(255),
    total_laid_off INT,
    percentage_laid_off VARCHAR(20),
    date VARCHAR(20),
    stage VARCHAR(100),
    country VARCHAR(100),
    funds_raised_millions VARCHAR(50)
);

-- STEP 3 — IMPORT CSV
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\PERSONAL PROJECT\\layoffs.csv'
INTO TABLE layoffs_raw_tb
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
