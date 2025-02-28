-- 1. count of stores per country
select country, count(*) as store_count 
from stores 
group by country
order by store_count desc;

-- 2. total sales per store
select s.store_name, sum(sa.quantity) as total_units_sold
from sales sa
join stores s on sa.store_id = s.store_id
group by s.store_name
order by total_units_sold desc;

-- 3. sales in december 2023
select count(*) as sales_count 
from sales 
where sale_date between '2023-12-01' and '2023-12-31';

-- 4. stores with no warranty claims
select s.store_name 
from stores s
left join sales sa on s.store_id = sa.store_id
left join warranty w on sa.sale_id = w.sale_id
where w.claim_id is null;
SELECT store_name FROM stores
WHERE store_id NOT IN (
						SELECT 
							DISTINCT store_id
						FROM sales as s
						RIGHT JOIN warranty as w
						ON s.sale_id = w.sale_id
						);

-- 5. percentage of "warranty void" claims
select (count(*) * 100.0 / (select count(*) from warranty)) as warranty_void_percentage
from warranty
where repair_status = 'Warranty Void';

-- 6. store with highest sales in last year
select s.store_name, sum(sa.quantity) as total_units_sold
from sales sa
join stores s on sa.store_id = s.store_id
where sale_date >= date_sub(curdate(), interval 1 year)
group by s.store_name
order by total_units_sold desc
limit 1;

-- 7. count of unique products sold in last year
select count(distinct product_id) as unique_products_sold
from sales
where sale_date >= date_sub(curdate(), interval 1 year);

-- 8. average product price by category
select c.category_name, avg(p.price) as avg_price
from products p
join category c on p.category_id = c.category_id
group by c.category_name;

-- 9. warranty claims filed in 2024
select count(*) as total_claims
from warranty
where year(claim_date) =2024;

-- 10. best selling day per store
with store_sales as (
    select store_id, sale_date, sum(quantity) as total_sold
    from sales
    group by store_id, sale_date
),
ranked_sales as (
    select *, rank() over (partition by store_id order by total_sold desc) as rnk
    from store_sales
)
select store_id, sale_date, total_sold
from ranked_sales
where rnk = 1;

-- 11. least selling product per country per year
with yearly_sales as (
    select st.country, year(s.sale_date) as year, p.product_name, sum(s.quantity) as total_sold
    from sales s
    join stores st on s.store_id = st.store_id
    join products p on s.product_id = p.product_id
    group by st.country, year, p.product_name
),
ranked_products as (
    select *, rank() over (partition by country, year order by total_sold asc) as rnk
    from yearly_sales
)
select country, year, product_name, total_sold
from ranked_products
where rnk = 1;

-- 12. warranty claims within 180 days of sale
select count(*) as claims_within_180_days
from warranty w
join sales s on w.sale_id = s.sale_id
where datediff(w.claim_date, s.sale_date) <= 180;

-- 13. warranty claims for recently launched products
select count(*) as claims_recent_products
from warranty w
join sales s on w.sale_id = s.sale_id
join products p on s.product_id = p.product_id
where p.launch_date >= date_sub(curdate(), interval 2 year);

-- 14. high sales months in the usa (last 3 years)
select year(sale_date) as year, month(sale_date) as month, sum(quantity) as total_sold
from sales sa
join stores st on sa.store_id = st.store_id
where st.country = 'USA' and sale_date >= date_sub(curdate(), interval 3 year)
group by year, month
having total_sold > 5000;

-- 15. most warranty claims by product category (last 2 years)
select c.category_name, count(*) as total_claims
from warranty w
join sales s on w.sale_id = s.sale_id
join products p on s.product_id = p.product_id
join category c on p.category_id = c.category_id
where w.claim_date >= date_sub(curdate(), interval 2 year)
group by c.category_name
order by total_claims desc;

-- 16. probability of warranty claims per country
SELECT st.country, 
       COUNT(w.claim_id) * 1.0 / NULLIF(COUNT(DISTINCT s.sale_id), 0) AS claim_probability
FROM sales s
JOIN stores st ON s.store_id = st.store_id
LEFT JOIN warranty w ON s.sale_id = w.sale_id
GROUP BY st.country;

-- 17. year-over-year growth analysis per store
select store_id, year(sale_date) as year, sum(quantity) as total_sales,
       lag(sum(quantity)) over (partition by store_id order by year(sale_date)) as prev_year_sales,
       (sum(quantity) - lag(sum(quantity)) over (partition by store_id order by year(sale_date))) / 
       nullif(lag(sum(quantity)) over (partition by store_id order by year(sale_date)), 0) * 100 as growth_rate
from sales
group by store_id, year;

-- 18. correlation between price and warranty claims
SELECT price_range, COUNT(*) AS claim_count
FROM (
    SELECT p.price, 
           CASE 
               WHEN p.price < 100 THEN 'Low'
               WHEN p.price BETWEEN 100 AND 500 THEN 'Medium'
               ELSE 'High'
           END AS price_range
    FROM sales s
    JOIN products p ON s.product_id = p.product_id
    LEFT JOIN warranty w ON s.sale_id = w.sale_id
    WHERE sale_date >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR) 
      AND w.claim_id IS NOT NULL  -- Ensures only sales with warranty claims are counted
) t
GROUP BY price_range;

-- 19. store with highest percentage of "paid repair" claims
SELECT s.store_name, 
       COUNT(CASE WHEN w.repair_status = 'Paid Repaired' THEN 1 END) AS paid_repair_claims,
       COUNT(*) AS total_warranty_claims,
       (COUNT(CASE WHEN w.repair_status = 'Paid Repaired' THEN 1 END) * 100.0 / COUNT(*)) AS paid_repair_percentage
FROM warranty w
JOIN sales sa ON w.sale_id = sa.sale_id
JOIN stores s ON sa.store_id = s.store_id
GROUP BY s.store_name
ORDER BY paid_repair_percentage DESC
LIMIT 1;

-- 20. monthly running total of sales per store (last 4 years)
WITH monthly_sales AS (
    SELECT 
        store_id,
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        SUM(p.price * s.quantity) AS total_revenue
    FROM sales s
    JOIN products p ON s.product_id = p.product_id
    WHERE sale_date >= DATE_SUB(CURDATE(), INTERVAL 4 YEAR)  -- Last 4 years only
    GROUP BY store_id, year, month
)
SELECT 
    store_id,
    year,
    month,
    FORMAT(total_revenue, 2) AS total_revenue,  -- Optional formatting
    FORMAT(SUM(total_revenue) OVER(PARTITION BY store_id ORDER BY year, month), 2) AS running_total
FROM monthly_sales
ORDER BY store_id, year, month;

-- 21. product sales trends over time, segmented into key periods: from launch to 6 months, 6-12 months, 12-18 months, and beyond 18 months.
SELECT 
    p.product_name,
    CASE 
        WHEN s.sale_date BETWEEN p.launch_date AND p.launch_date + INTERVAL 6 MONTH THEN '0-6 month'
        WHEN s.sale_date BETWEEN p.launch_date + INTERVAL 6 MONTH AND p.launch_date + INTERVAL 12 MONTH THEN '6-12 month' 
        WHEN s.sale_date BETWEEN p.launch_date + INTERVAL 12 MONTH AND p.launch_date + INTERVAL 18 MONTH THEN '12-18 month'
        ELSE '18+ month'
    END AS plc,
    SUM(s.quantity) AS total_qty_sale
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name, plc
ORDER BY p.product_name, total_qty_sale DESC;

-- 22. Top 3 Products Contributing to Revenue in Each Store
SELECT store_id, product_id, total_revenue
FROM (
    SELECT 
        s.store_id, 
        s.product_id, 
        SUM(s.quantity * p.price) AS total_revenue,
        RANK() OVER (PARTITION BY s.store_id ORDER BY SUM(s.quantity * p.price) DESC) AS rank_num
    FROM sales s
    JOIN products p ON s.product_id = p.product_id
    GROUP BY s.store_id, s.product_id
) ranked
WHERE rank_num <= 3
ORDER BY store_id, rank_num;

-- 23. Average Time Between Sale and Warranty Claim for Each Product
SELECT p.product_name, AVG(DATEDIFF(w.claim_date, s.sale_date)) AS avg_days_to_claim
FROM sales s
JOIN warranty w ON s.sale_id = w.sale_id
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name;

-- 24. Revenue Lost Due to "Warranty Void" Claims
SELECT SUM(p.price) AS lost_revenue
FROM warranty w
JOIN sales s ON w.sale_id = s.sale_id
JOIN products p ON s.product_id = p.product_id
WHERE w.repair_status = 'Warranty Void';

-- 25. Calculate Churn Rate (Stores That Have No Sales in the Last Year)
SELECT round((COUNT(s.store_id) * 100.0 / (SELECT COUNT(*) FROM stores)),2) AS churn_rate
FROM stores s
LEFT JOIN sales sa ON s.store_id = sa.store_id
    AND sa.sale_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
WHERE sa.sale_id IS NULL;


-- 26. Best 3 Performing Category Based on Revenue
SELECT c.category_name, SUM(s.quantity * p.price) AS total_revenue
FROM sales s
JOIN products p ON s.product_id = p.product_id
JOIN category c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_revenue DESC
LIMIT 3;
