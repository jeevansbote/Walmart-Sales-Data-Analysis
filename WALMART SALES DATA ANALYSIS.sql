-- Create database
CREATE DATABASE IF NOT EXISTS saleswalmartdata;


-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);
-------------------------------------
#DATA CLEANING
-------------------------------------
SELECT TIME FROM SALES;

SELECT TIME , 
(CASE
		WHEN `TIME` BETWEEN '00:00:00' AND '12:00:00' THEN 'MORNING'
        WHEN `TIME` BETWEEN '12:01:00' AND '16:00:00' THEN 'AFTERNOON'
        ELSE 'EVENING'
 END       
)AS TIME_OF_DAY 
FROM SALES;

ALTER TABLE SALES
ADD COLUMN TIME_OF_DAY VARCHAR(50);


SELECT * FROM SALES;

UPDATE SALES
SET TIME_OF_DAY = 
(CASE
		WHEN `TIME` BETWEEN '00:00:00' AND '12:00:00' THEN 'MORNING'
		WHEN `TIME` BETWEEN '12:01:00' AND '16:00:00' THEN 'AFTERNOON'
		ELSE 'EVENING'
 END      
 );
 
 SELECT * FROM SALES;
 
 SELECT DATE FROM SALES;
 
 SELECT DATE , DAYNAME(DATE) AS DAY_NAME FROM SALES;
 
ALTER TABLE SALES
ADD COLUMN DAY_NAME VARCHAR(10);

SELECT * FROM SALES;

UPDATE SALES
SET DAY_NAME = DAYNAME(DATE);

SELECT * FROM SALES;


SELECT DATE , MONTHNAME(DATE) AS MONTH_NAME FROM SALES;

ALTER TABLE SALES
ADD COLUMN MONTH_NAME VARCHAR(10);

SELECT * FROM SALES;

UPDATE SALES
SET MONTH_NAME = MONTHNAME(DATE);


-------------------------------------------------------------------#GENERIC#------------------------------------------------------------------------------------------------------
# How many unique cities does the data have?

SELECT DISTINCT CITY FROM SALES;

#In which city is each branch?#

SELECT DISTINCT CITY , BRNACH FROM SALES;


--------------------------------------------------------------------#PRODUCT#-------------------------------------------------------------------------------------------------
# How many unique product lines does the data have?
SELECT DISTINCT(PRODUCT_LINE) FROM SALES;


#What is the most common payment method?

SELECT PAYMENT FROM SALES;

SELECT PAYMENT, COUNT(PAYMENT) AS COMMON_METHOD FROM SALES
GROUP BY PAYMENT
ORDER BY COUNT(PAYMENT) DESC;


#What is the most selling product line?

SELECT PRODUCT_LINE, COUNT(PRODUCT_LINE) AS MOST_SELL FROM SALES
GROUP BY PRODUCT_LINE
ORDER BY MOST_SELL DESC;


#What is the total revenue by month?

SELECT MONTH_NAME AS MONTH , SUM(TOTAL) AS TOTAL_REVENUE FROM SALES
GROUP BY MONTH_NAME
ORDER BY TOTAL_REVENUE DESC;


#What month had the largest COGS?

SELECT MONTH_NAME AS MONTH , SUM(COGS) AS COGS FROM SALES
GROUP BY MONTH
ORDER BY COGS DESC;

#What product line had the largest revenue?

SELECT * FROM SALES;

SELECT PRODUCT_LINE , SUM(TOTAL) AS TOTAL_REVENUE FROM SALES
GROUP BY PRODUCT_LINE 
ORDER BY TOTAL_REVENUE DESC;


# What is the city with the largest revenue?

SELECT BRANCH,CITY , SUM(TOTAL) LARGEST_REVENUE FROM SALES
GROUP BY CITY ,BRANCH
ORDER BY LARGEST_REVENUE DESC;


#What product line had the largest VAT?


SELECT PRODUCT_LINE , AVG(TAX_PCT) AS AVG_TAX FROM SALES
GROUP BY PRODUCT_LINE 
ORDER BY AVG_TAX DESC;



# Which branch sold more products than average product sold?

SELECT BRANCH ,SUM( QUANTITY) FROM SALES
GROUP BY BRANCH
HAVING SUM(QUANTITY)> (SELECT AVG(QUANTITY) FROM SALES);


# What is the most common product line by gender?

SELECT  PRODUCT_LINE,GENDER,COUNT(GENDER) AS TOTAL_COUNT FROM SALES
GROUP BY PRODUCT_LINE , GENDER
ORDER BY TOTAL_COUNT;

#What is the average rating of each product line?
SELECT PRODUCT_LINE,ROUND (AVG(RATING),2) AS AVG_RATING FROM SALES
GROUP BY PRODUCT_LINE 
ORDER BY AVG_RATING DESC;


-------------------------------------------------------------------------------# SALES # --------------------------------------------------------------------------------------

# Number of sales made in each time of the day per weekday

SELECT * FROM SALES;

SELECT TIME_OF_DAY , COUNT(*) AS TOTAL_SALES FROM SALES
WHERE DAY_NAME = 'TUESDAY'
GROUP BY TIME_OF_DAY
ORDER BY COUNT(*) DESC;

# Which of the customer types brings the most revenue?

SELECT * FROM SALES;

SELECT (CUSTOMER_TYPE) , SUM(TOTAL) AS TOTAL_REVENUE FROM SALES
GROUP BY CUSTOMER_TYPE 
ORDER BY SUM(TOTAL) DESC;


# Which city has the largest tax percent/ VAT (Value Added Tax)?

SELECT CITY , AVG(TAX_PCT) AS TAX FROM SALES
GROUP BY CITY
ORDER BY TAX DESC ;


# Which customer type pays the most in VAT?

SELECT CUSTOMER_TYPE , AVG(TAX_PCT) AS TAX FROM SALES
GROUP BY CUSTOMER_TYPE
ORDER BY TAX;



---------------------------------------------------------------# CUSTOMER # ------------------------------------------------------------------------------------------------

# How many unique customer types does the data have?

SELECT DISTINCT(CUSTOMER_TYPE) FROM SALES;


# How many unique payment methods does the data have?

SELECT DISTINCT PAYMENT FROM SALES;

# What is the most common customer type?

SELECT CUSTOMER_TYPE , SUM(QUANTITY) AS MAXQUANTITY FROM SALES
GROUP BY CUSTOMER_TYPE
ORDER BY MAXQUANTITY DESC;


# Which customer type buys the most?

SELECT  CUSTOMER_TYPE , COUNT(*) FROM SALES
GROUP BY CUSTOMER_TYPE
ORDER BY COUNT(*) DESC;


#What is the gender of most of the customers?

SELECT GENDER , COUNT(CUSTOMER_TYPE) CUSTOMERS  FROM SALES
GROUP BY GENDER
ORDER BY GENDER DESC;


# What is the gender distribution per branch?

SELECT  BRANCH ,GENDER ,COUNT(*) AS TOTAL FROM SALES
WHERE BRANCH = 'C'
GROUP BY  GENDER
ORDER BY TOTAL DESC;


# Which time of the day do customers give most ratings?

SELECT TIME_OF_DAY , AVG(RATING) AS RATINGS FROM SALES
GROUP BY TIME_OF_DAY
ORDER BY RATINGS DESC ;

# Which time of the day do customers give most ratings per branch?

SELECT TIME_OF_DAY , AVG(RATING) AS RATINGS FROM SALES
WHERE BRANCH = 'C'
GROUP BY TIME_OF_DAY
ORDER BY RATINGS DESC ;


# Which day for the week has the best avg ratings?

SELECT DAY_NAME , AVG(RATING) AS AVG_RATING FROM SALES
WHERE DAY_NAME = 'SUNDAY'
GROUP BY DAY_NAME
ORDER BY AVG_RATING DESC;


# Which day of the week has the best average ratings per branch?

SELECT BRANCH , DAY_NAME , AVG(RATING) AS AVG_RATING FROM SALES
WHERE DAY_NAME =  'TUESDAY' AND BRANCH = 'C'
GROUP BY DAY_NAME
ORDER BY AVG_RATING ;
