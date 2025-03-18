--- DATA ANALYSIS AND BUSINESS PROBLEMS
---1. Write a SQL query to retrieve all columns for sales made on '2022-11-05':
select * from retail_sales 
where sale_date= '2022-11-05'

--2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select * from retail_sales 
where category='Clothing' and quantiy >=4
and extract(year from sale_date)=2022
and extract(month from sale_date)=11;

--3.Write a SQL query to calculate the total sales (total_sale) for each category.:
select category,sum(total_sale) as cateogry_sales from retail_sales
group by category

--4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
select category,round(avg(age),2) as avg_age from retail_sales
where category='Beauty'
group by 1

--5. Write a SQL query to find all transactions where the total_sale is greater than 1000
select * from retail_sales
where total_sale >1000

--6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
select category,gender, count(*)transactions_count  from retail_sales
group by 1,2
order by 1,2

--7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
with average_sales as (select extract(year from sale_date) as year,extract(month from sale_date) as month,round(avg(total_sale)::numeric,2) average
from retail_sales
group by 1,2
order by 1,2),
ranked_average as (
select year, month,average,rank() over(partition by year order by average desc) as rnk from average_sales
)
SELECT year, average, month AS highest_month
FROM ranked_average
where rnk=1;

--8.Write a SQL query to find the top 5 customers based on the highest total sales
with ranked_customers as 
(select customer_id, sum(total_sale) as sales , rank() over(order by sum(total_sale)desc)rnk 
from retail_sales
group by 1)
select customer_id, sales
from ranked_customers 
where rnk <=5

--9.Write a SQL query to find the number of unique customers who purchased items from each category
select category,count(distinct customer_id) unique_customers
from retail_sales
group by 1
order by 1

--10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
with cte as (select *,
case 
when extract(hour from sale_time)<12 then 'morning'
when extract(hour from sale_time) between 12 and 17 then 'afternoon'
else 'evening'
end as shift
from retail_sales)
select shift, count(*) order_count
from cte
group by shift

--END OF PROJECT
