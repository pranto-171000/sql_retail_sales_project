CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

select * from retail_sales
limit 10;

select count(*) from retail_sales ;

select * from retail_sales
where transaction_id is null;

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    

select count(*) as total_sales from retail_sales;

select count(distinct customer_id) as Total_Customer from retail_sales;


select distinct category as Total_Customer from retail_sales;


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)




-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

select *
from retail_sales
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

select * from retail_sales as r
where category ='Clothing' and TO_CHAR(sale_date,'YYYY-MM' )= '2022-11' and quantity>=4
order by r.total_sale desc ;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select category,sum(total_sale) as "Total Sales"
from retail_sales
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select ROUND(avg(age),2)
from retail_sales
where category='Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales
where total_sale > 1000
order by total_sale desc;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select distinct category,gender,count(*) as total_sales
from retail_sales
group by category,gender
order by category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

select year,month,avg_total_sale
from
(SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    AVG(total_sale) AS avg_total_sale,
    RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY EXTRACT(MONTH FROM sale_date) DESC) AS rank
FROM retail_sales
GROUP BY 1,2) as t1
where rank=1 ;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales

select customer_id,sum(total_sale),gender from retail_sales as r
group by 1,3
order by 2 desc 
limit 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select count( distinct customer_id),category
from retail_sales
group by 2;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

with hourly_sales as 
(select *, 
	CASE 
		when extract (hour from sale_time) <=12  then 'Morning'
		when extract (hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
		end as shift
from retail_sales)

select 
shift,
count(transaction_id) as total_orders
from hourly_sales
group by shift;








