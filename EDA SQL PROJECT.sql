-- 	EXPLORATORY DATA ANALYSIS

SELECT *
FROM layoffs_staging2;




SELECT MAX(total_laid_off), max(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC
;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;


SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;


SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;


SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT company, AVG(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT substring(`date`, 1,7) AS MONTH, SUM(total_laid_off)
FROM layoffs_staging2
WHERE  substring(`date`, 1,7) IS NOT NULL
GROUP BY MONTH 
ORDER BY 1 ASC
;


WITH ROLLING_TOTAL AS
(SELECT substring(`date`, 1,7) AS MONTH, SUM(total_laid_off) AS TOTAL_OFF
FROM layoffs_staging2
WHERE  substring(`date`, 1,7) IS NOT NULL
GROUP BY MONTH 
ORDER BY 1 ASC
)
SELECT `MONTH`, TOTAL_OFF
,SUM(TOTAL_OFF) OVER (ORDER BY `MONTH`) AS rolling_total
FROM ROLLING_TOTAL;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT company, YEAR (`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR (`date`)
ORDER BY 3 DESC 
;



WITH company_year (company, years, total_laid_off) AS
(SELECT company, YEAR (`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company , YEAR (`date`)
), Company_Year_Rank AS
(SELECT *,
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM company_year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank 
WHERE ranking <= 5
;

