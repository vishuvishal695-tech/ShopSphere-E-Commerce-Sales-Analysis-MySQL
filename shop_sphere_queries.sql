--- 1. Display all customers.
SELECT customer_name
FROM customers;

--- 2. Display all unique customer cities.
SELECT DISTINCT city
FROM customers;

--- 3. Find all products belonging to the Electronics category.
SELECT * 
FROM products
WHERE category ="Electronics";

--- 4. Find products with a price greater than ₹50,000.
SELECT product_id, Product_name 
FROM products
WHERE price>50000;

--- 5. Find orders placed in March 2026.
SELECT * 
FROM orders
WHERE order_date LIKE "%2026%";

--- 6. Display the 10 most expensive products.
SELECT * 
FROM products
ORDER BY price DESC 
LIMIT 10;

--- 7. Find orders paid using UPI or Credit Card.
SELECT *
FROM orders
WHERE payment_method IN ("UPI" , "Credit card");

--- 8. Count the total number of customers.
SELECT COUNT(customer_id) AS count
FROM customers;
 
--- 9. Count the total number of orders.
SELECT COUNT(order_id)
FROM orders;

--- 10. Calculate total revenue and total profit.
SELECT SUM(o.quantity*p.price) AS total_revenue
FROM order_details o
JOIN products p ON o.product_id=p.product_id;

SELECT SUM(o.quantity *(p.price-p.cost_price)) AS total_revenue
FROM order_details o
JOIN products p ON o.product_id=p.product_id;

--- 11. Find total sales by category.
SELECT p.category ,SUM(o.quantity* p.price) AS tot_sal_catogery
FROM order_details o
JOIN products p ON o.product_id=p.product_id
GROUP BY p.category;

--- 12. Find total profit by category.
SELECT p.category ,SUM(o.quantity *(p.price-p.cost_price)) AS tot_profit_catogery
FROM order_details o
JOIN products p ON o.product_id=p.product_id
GROUP BY p.category;

--- 13. Find the number of orders handled by each sales representative.
SELECT COUNT(order_id) , sales_rep_id
FROM orders
GROUP BY sales_rep_id;

--- 14. Find the top 10 customers by revenue.
SELECT c.customer_id,c.customer_name,
	   SUM(od.quantity*p.price) AS total_revenue
FROM customers c 
JOIN orders o ON c.customer_id=o.customer_id
JOIN order_details od ON o.order_id=od.order_id
JOIN products p ON od.product_id=p.product_id
GROUP BY customer_id , customer_name
ORDER BY total_revenue DESC
limit 10;

--- 15. Find the top 10 products by revenue
SELECT p.product_id, p.product_name ,
	   SUM(od.quantity*p.price) AS revenue
FROM order_details od
JOIN products p ON od.product_id=p.product_id
GROUP BY p.product_id ,p.product_name
ORDER BY revenue DESC
LIMIT 10;

--- 16. Find the top 5 products by profit.
SELECT p.product_id , p.Product_name,
	   SUM(od.quantity*(p.price-p.cost_price)) AS profit
FROM order_details od 
JOIN products p ON od.product_id=p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY profit DESC
LIMIT 5;

--- 17. Find total sales by city.
SELECT c.city ,SUM(od.quantity*p.price) as total_sales
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN order_details od ON o.order_id=od.order_id
JOIN products p ON od.product_id=p.product_id
GROUP BY city;

--- 18. Find the city with the highest revenue.
SELECT c.city ,SUM(od.quantity*p.price) as highest_revenue
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN order_details od ON o.order_id=od.order_id
JOIN products p ON od.product_id=p.product_id
GROUP BY city
ORDER BY total_sales DESC
LIMIT 1;

--- 19. Calculate average order value.
SELECT SUM(od.quantity*p.price)/COUNT(DISTINCT order_id) AS avg_ord_val
FROM order_details od
JOIN products p ON od.product_id=p.product_id;

--- 20. Find months with total revenue greater than ₹1,000,000.
SELECT     EXTRACT( YEAR FROM o.order_date) AS order_year
		 , EXTRACT(MONTH FROM o.order_date) AS order_month
		 , SUM(od.quantity*p.price) AS revenue
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN order_details od ON o.order_id=od.order_id
JOIN products p ON od.product_id=p.product_id
GROUP BY  EXTRACT(YEAR FROM o.order_date) ,
		  EXTRACT(MONTH FROM o.order_date) 
HAVING SUM(od.quantity*p.price)>1000000
ORDER BY order_year,
	     order_month;

--- 21. Display order ID, order date, customer name, product name, quantity and sales amount.
SELECT c.customer_name,o.order_id,o.order_date,p.product_name,od.sales_amount
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN order_details od ON o.order_id=od.order_id
JOIN  products p ON od.product_id=p.product_id;

--- 22. Find customers who have placed more than 5 orders.
SELECT c.customer_id,c.customer_name , COUNT(od.quantity) AS count
FROM customers c 
JOIN orders o ON c.customer_id=o.customer_id
JOIN order_details od ON o.order_id=od.order_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(od.quantity)>5;

--- 23. Find products whose sales are above the average product sales.
WITH total_sales AS(
					SELECT product_id,SUM(sales_amount) AS tot_sales
FROM order_details
GROUP BY product_id
),
avg_sales AS (
					SELECT AVG(tot_sales) AS avg_sales
FROM total_sales
)
SELECT ts.product_id,ts.tot_sales,a.avg_sales
FROM total_sales ts
CROSS JOIN avg_sales a
WHERE ts.tot_sales>a.avg_sales
;

--- 24. Find customers whose total spending is above average customer spending.
--- spending = price* quantity
WITH customer_spending AS (
SELECT c.customer_id  , SUM(od.quantity*p.price) AS total_spending
FROM customers c 
JOIN orders o ON c.customer_id=o.customer_id
JOIN order_details od ON  o.order_id=od.order_id
JOIN products p ON od.product_id=p.product_id
GROUP BY customer_id
),
avg_spending AS(
SELECT AVG(total_spending) AS avg_spending
FROM customer_spending
)
SELECT cs.customer_id,cs.total_spending ,a.avg_spending
FROM customer_spending cs
CROSS JOIN avg_spending a 
WHERE cs.total_spending > a.avg_spending
;

--- 25. Find the highest-selling product in each category.
SELECT SUM(od.quantity*p.price) AS total_selling , p.category 
FROM order_details od
JOIN products p ON od.product_id=p.product_id 
GROUP BY p.category
ORDER BY SUM(od.quantity*p.price) DESC
LIMIT 1
;

--- 26. Find sales representatives whose revenue is above average sales-representative revenue.
WITH total_sales_revenue AS (
							SELECT sr.sales_rep_id,sr.sales_rep_name,SUM(od.quantity*p.price) AS total_rep_revenue
							FROM sales_reps sr 
							JOIN orders o ON sr.sales_rep_id=o.sales_rep_id
							JOIN order_details od ON o.order_id=od.order_id
							JOIN products p ON od.product_id=p.product_id
                            GROUP BY sr.sales_rep_id,sr.sales_rep_name
                            
),
avg_sales_revenue AS (
							SELECT AVG(total_rep_revenue) AS avg_rep_sales_revenue
                            FROM total_sales_revenue 
)
SELECT tsr.sales_rep_id,tsr.sales_rep_name,tsr.total_rep_revenue ,asr.avg_rep_sales_revenue 
FROM total_sales_revenue tsr
CROSS JOIN avg_sales_revenue asr 
WHERE tsr.total_rep_revenue>asr.avg_rep_sales_revenue
;

--- 27. Using a CTE, calculate total revenue per customer and return customers whose revenue is above average customer revenue.
WITH customers_revenue AS (
						   SELECT c.customer_id, c.customer_name ,SUM(od.sales_amount) AS total_revenue
                           FROM customers c
                           JOIN orders o ON c.customer_id=o.customer_id
                           JOIN order_details od ON o.order_id=od.order_id
                           GROUP BY c.customer_id ,c.customer_name
),
average_revenue AS (
						   SELECT AVG(total_revenue) AS average_customer_revenue
                           FROM customers_revenue
)
SELECT cr.customer_id,cr.customer_name,cr.total_revenue,ar.average_customer_revenue
FROM customers_revenue cr
CROSS JOIN average_revenue ar
WHERE cr.total_revenue>ar.average_customer_revenue
;

--- 28.Using a CTE, calculate monthly sales and identify the best-performing month.
WITH monthly_sales AS (
						SELECT EXTRACT(YEAR FROM o.order_date) AS year,
							   EXTRACT(MONTH FROM o.order_date) AS month,
							   SUM(od.sales_amount) as total_sales
						FROM orders o 
						JOIN order_details od ON od.order_id=o.order_id
						GROUP BY EXTRACT(YEAR FROM o.order_date) ,
								 EXTRACT(MONTH FROM o.order_date) 
)
SELECT month , year ,total_sales
FROM monthly_sales
ORDER BY total_sales DESC
LIMIT 1
;

--- 29. Using a CTE, calculate category revenue and profit margin, then identify the category with the highest profit margin.
WITH revenue AS (
				 SELECT p.category,
                 SUM(od.sales_amount) AS total_revenue,
                 SUM(od.sales_amount-(od.quantity*p.cost_price)) AS total_profit,
                 SUM(od.sales_amount-(od.quantity*p.cost_price))*1.0/SUM(od.sales_amount) AS profit_margin
                 FROM order_details od
                 JOIN  products p ON od.product_id=p.product_id
                 GROUP BY p.category

)
SELECT rv.total_revenue,rv.total_profit, rv.profit_margin ,rv.category
FROM revenue rv
ORDER BY rv.profit_margin 
LIMIT 1
;

--- 30. Rank products by revenue
WITH rank_revenue  AS (
               
						SELECT p.product_id, p.product_name, SUM(od.sales_amount) AS revenue 
						FROM order_details od 
						JOIN products p ON od.product_id=p.product_id
						GROUP BY p.product_id, p.product_name
)
SELECT product_id, product_name,revenue ,
	   RANK() OVER (ORDER BY revenue ) AS rnk
FROM rank_revenue 
ORDER By rnk
;

--- 31. Rank products within each category by revenue.
WITH cat_revenue AS (
					SELECT p.product_id,p.product_name ,p.category, SUM(od.sales_amount) AS category_revenue
                    FROM order_details od
                    JOIN products p ON od.product_id=p.product_id
                    GROUP BY p.category,p.product_id,p.product_name
)
SELECT product_id ,category , product_name ,category_revenue,
	   RANK () OVER (ORDER BY category_revenue) AS rank_revenue
FROM cat_revenue
ORDER BY category ,rank_revenue;

--- 32. Find the top 3 products in every category.
WITH TOP_3 AS (
				SELECT p.product_id ,p.product_name ,p.category ,SUM(od.sales_amount) AS revenue,
                RANK () OVER 
                ( PARTITION BY p.category 
                  ORDER BY SUM(od.sales_amount) 
				 ) AS rnk
                FROM order_details od
                JOIN products p ON od.product_id=p.product_id
			    GROUP BY p.product_id ,p.product_name ,p.category
)
SELECT product_id ,product_name ,category, revenue
FROM TOP_3 
WHERE rnk<=3
ORDER BY category ,rnk DESC;

--- 33. Calculate monthly revenue and previous-month revenue using LAG().
WITH revenue AS (
				SELECT EXTRACT(MONTH FROM o.order_date) AS month,
                SUM(od.sales_amount) AS total_revenue 
                FROM orders o
                JOIN order_details od ON o.order_id=od.order_id
                GROUP BY EXTRACT(MONTH FROM o.order_date)
)
SELECT month ,total_revenue,
	   LAG(total_revenue,1,0) OVER ( ORDER BY month)  AS previous_revenue
FROM revenue
;

--- 34. Calculate month-over-month revenue growth percentage.
WITH revenue AS (
				SELECT EXTRACT(MONTH FROM o.order_date) month, 
					   SUM(od.sales_amount) AS present_month_revenue
				FROM orders o
				JOIN order_details od  ON o.order_id=od.order_id
                GROUP BY EXTRACT(MONTH FROM o.order_date)
),
previous_revenue AS (
				SELECT month ,present_month_revenue,
                LAG(present_month_revenue,1,0) OVER (ORDER BY month ) AS previous_month_revenue
				FROM revenue
)
SELECT present_month_revenue , previous_month_revenue ,
	   (present_month_revenue-previous_month_revenue)*100/previous_month_revenue AS mom_revenue
FROM previous_revenue
;

--- 35. Calculate cumulative revenue by month.
WITH revenue AS (
				SELECT EXTRACT(MONTH FROM o.order_date) month, 
					   SUM(od.sales_amount) AS present_month_revenue
				FROM orders o
				JOIN order_details od  ON o.order_id=od.order_id
                GROUP BY EXTRACT(MONTH FROM o.order_date)
)
SELECT present_month_revenue ,
	   SUM(present_month_revenue) OVER (ORDER BY month) AS cumulative_revenue
FROM revenue;

--- 36. Assign customers to revenue ranks based on total spending.
WITH spending AS (
					SELECT c.customer_id, SUM(od.sales_amount) AS total_spending
					FROM customers c 
					JOIN orders o ON c.customer_id=o.customer_id
					JOIN order_details od ON o.order_id=od.order_id
					GROUP BY c.customer_id
)
SELECT customer_id  ,total_spending,
       RANK () OVER ( ORDER BY total_spending ) AS rnk_by_tot_spending
FROM spending
;

