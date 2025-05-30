#EXPLORATORY DATA ANALYSIS (eda)

select * from layoffs_stagging2;

select max(total_laid_off),max(percentage_laid_off) from layoffs_stagging2  ;

select * 
from layoffs_stagging2 
where percentage_laid_off=1
order by funds_raised_millions DESC;# this means they had a 100% lay off so its over for the business

SELECT COMPANY, SUM(TOTAL_LAID_OFF) AS TOTAL_LAID
FROM layoffs_stagging2
GROUP BY COMPANY
ORDER BY TOTAL_LAID DESC;
 
SELECT MIN(`date`),MAX(`date`) #WE USE BACK TICK ` NOT 	QUOTATIONS ' TO IDENTIFY COLUMNS,TABLE NAMES AND OR DATABASES ESPECIALLY IF THEY ARE SQL KEYWORDS OR CONTAIN SPACES
FROM LAYOFFS_STAGGING2; #based on the result of this query we can deduce that these high percentage laid offs are due to covid -19 

SELECT country, SUM(TOTAL_LAID_OFF) AS TOTAL_LAID
FROM layoffs_stagging2
GROUP BY country
order by total_laid desc; 

SELECT industry, SUM(TOTAL_LAID_OFF) AS TOTAL_LAID
FROM layoffs_stagging2
GROUP BY industry #remember when you use a aggregated function you need to use group by
order by total_laid desc;  #makes sense that the consumer and retail industries were hit the hardest because they are in the hardlock down did force people to stay at home

SELECT YEAR(`date`), SUM(TOTAL_LAID_OFF) AS TOTAL_LAID
FROM layoffs_stagging2
GROUP BY YEAR(`date`) #remember when you use a aggregated function you need to use group by
order by 1 desc; # WE CAN SEE 2020 HAS THE MOST LAID OFF BY FAR COULD BE BY COVID

SELECT SUBSTRING(`DATE`,1,7) as `month`, sum(total_laid_off)
FROM LAYOFFS_STAGGING2
where SUBSTRING(`DATE`,1,7)																																																														 is not null
group by `month`
order by 1 asc;

#creating arolling total use a cte a rolling total for my understand is basically like a cummlulative column
#ROLLING TOTAL ARE BASICALLY ANOTHER WAY OF DOING WHAT SUB QUERIES DO

with rolling_total as 
(
select substring(`date`,1,7) as `MONTH`, SUM(TOTAL_LAID_OFF) as sum_total_off
from layoffs_stagging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc
)

select `month`, substring(`month`,6,2) as only_month, sum_total_off, sum(sum_total_off) over(order by `month`) as rolling_total #this the part which creates creates the the cummulative aka rolling total column field sum(sum_total_off)
from rolling_total;
#the rolling total will happy you identify trends and outliers in your data e.g when your data jumps or decreases 
#FOR EXAMPLE WE CAN SEE THE INCREASE IN THE ROLLING ROLLING TOTAL SHOWING US THE IMPACT OF COVID OVER TIME
# ALSO NOTICED A SIGNIFICANT TREND WHERE THE LAYOFFS JUMP IN DECEMBER TO JANUARY IN 2021 AND 2022


WITH COMPANY_ROLLING_TOTAL AS 
(
SELECT COMPANY,total_laid_off,`date`, SUM(TOTAL_LAID_OFF) AS TOTAL_LAID
FROM layoffs_stagging2
GROUP BY COMPANY,`date`,total_laid_off #note to self key thing to to note when normal fields are included in the select statement with other fields which have functions like sum,avg you need to add them to the group by section otherwise you will get an error
ORDER BY company DESC
)

select *, dense_rank() OVER(partition by year(`DATE`) ORDER BY TOTAL_LAID_OFF DESC)
from COMPANY_ROLLING_TOTAL
order by total_laid desc
;

#AS EXPECTED BIG COMPANIES LIKE GOOGLE AND META LAID OFF THE MOST WORKERS
