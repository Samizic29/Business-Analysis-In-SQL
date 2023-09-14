/*
Danny's Diner business data analysis
Skills used: Basic Aggregations, Windows Function, Sub-query, Common Table Expression (CTE), Joins, etc. was used to solve the business questions.
*/

-- Sales table
SELECT * FROM dannys_diner.sales;

-- Menu table
SELECT * FROM dannys_diner.menu;

-- Members table
SELECT * FROM dannys_diner.members;

-- Business Questions Solved:

-- 1. What is the total amount each customer spent at the restaurant?

SELECT sales.customer_id,
	   SUM(menu.price) as total_amount_spent
FROM dannys_diner.sales as sales
JOIN dannys_diner.menu as menu
ON sales.product_id = menu.product_id
GROUP BY 1
ORDER BY 1;

-- Solution
customer_id	total_amount
A			      76
B			      74
C			      36

-- Q2. How many days has each customer visited the restaurant?
SELECT sales.customer_id, COUNT(*)
FROM dannys_diner.sales as sales
GROUP BY 1
ORDER BY 1

-- Solution
customer_id		days
A			        6
B			        6
C			        3

-- Q3. What was the first item from the menu purchased by each customer?

-- CTE created
WITH item_no AS (
  SELECT sales.customer_id customer_id,
  		 sales.product_id product_id, 
  		 menu.product_name product_name,
  		 ROW_NUMBER() OVER (PARTITION BY sales.customer_id ORDER BY sales.order_date) item_num
  FROM dannys_diner.sales AS sales
  INNER JOIN dannys_diner.menu AS menu
  ON sales.product_id = menu.product_id
)

SELECT customer_id, product_id, product_name
FROM item_no
WHERE item_num = 1;

-- Solution
customer_id	product_name
A			      curry
B			      curry
C			      ramen


-- Q4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT sales.product_id, 
	   menu.product_name, 
       COUNT(*) AS item_count
FROM dannys_diner.sales AS sales
INNER JOIN dannys_diner.menu AS menu
ON sales.product_id = menu.product_id
GROUP BY 1, 2
ORDER BY 3 DESC
Limit 1

-- Solution
product_id	product_name		purchased_no
3			            ramen			8

-- Q5. Which item was the most popular for each customer?

-- CTE created
WITH items AS (
  SELECT sales.customer_id customer, 
  		 sales.product_id product_id, 
 		 menu.product_name product_name, 
 		 COUNT(*) purchase_count,
   		 RANK() OVER (PARTITION BY sales.customer_id ORDER BY COUNT(*) DESC) item_no
 FROM dannys_diner.sales AS sales
 INNER JOIN dannys_diner.menu AS menu
 ON sales.product_id = menu.product_id
 GROUP BY 1, 2, 3
)

-- Customer B as three items with the same no of purchased
SELECT customer, product_id, product_name
FROM items
WHERE item_no = 1

-- Solution
customer	product_id	product_name
A			          3			ramen
B			          3			ramen
B			          1			sushi
B			          2			curry
C			          3			ramen
  
-- Q6. Which item was purchased first by the customer after they became a member?
  
-- CTE Created
WITH orders AS (
  SELECT sales.customer_id customer_id, 
  		 sales.order_date order_date, 
  		 sales.product_id product_id,
		 ROW_NUMBER() OVER (PARTITION BY sales.customer_id ORDER BY sales.order_date) row_no
FROM dannys_diner.sales sales
INNER JOIN dannys_diner.members members
ON sales.customer_id = members.customer_id and sales.order_date > members.join_date
)

SELECT customer_id,  
  	   product_id
FROM orders
WHERE row_no = 1
  
-- Solution
customer_id	order_date	product_id
A			      2021-01-10	3
B			      2021-01-11	1


-- Q7. Which item was purchased just before the customer became a member?

-- CTE Created
WITH orders AS (
  SELECT sales.customer_id customer_id, 
  		 sales.order_date order_date, 
  		 sales.product_id product_id,
		 ROW_NUMBER() OVER (PARTITION BY sales.customer_id ORDER BY sales.order_date DESC, sales.product_id DESC) row_no
FROM dannys_diner.sales sales
INNER JOIN dannys_diner.members members
ON sales.customer_id = members.customer_id and sales.order_date < members.join_date
)

SELECT customer_id, 
  	   order_date, 
  	   product_id
FROM orders
WHERE row_no = 1

-- Solution
customer_id	order_date	product_id
A			      2021-01-01	2
B			      2021-01-04	1

-- Q8. What is the total items and amount spent for each member before they became a member?

SELECT sales.customer_id customer_id, 
  	   COUNT(*) total_items,
	   SUM(menu.price) amount_spent	 
FROM dannys_diner.sales sales
INNER JOIN dannys_diner.menu menu
ON sales.product_id = menu.product_id
INNER JOIN dannys_diner.members members
ON sales.customer_id = members.customer_id and sales.order_date < members.join_date
GROUP BY 1
ORDER BY 1;

-- Solution
customer_id	total_item	amount_spent
A			       2			    25
B			       3			    40

-- Q9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

SELECT sales.customer_id,
  	   SUM(menu.price * 
           CASE WHEN menu.product_name = 'sushi' THEN 2
           ELSE 1
           END * 10) total_points
FROM dannys_diner.sales sales
INNER JOIN dannys_diner.menu menu
ON sales.product_id = menu.product_id
GROUP BY 1
ORDER BY 1;
  
-- Solution:
customer_id	total_points
A	          860
B	          940
C	          360
  
-- Q10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
  
SELECT sales.customer_id,
  	   SUM(menu.price * 2) total_points 
FROM dannys_diner.sales sales
INNER JOIN dannys_diner.menu menu
ON sales.product_id = menu.product_id
INNER JOIN dannys_diner.members members
ON members.customer_id = sales.customer_id
WHERE sales.order_date >= members.join_date AND sales.order_date <= '2021-01-31'
GROUP BY 1
ORDER BY 1;

-- Solution:
customer_id	total_points
A	          102
B	          44

/* Creating Views to store data for later visualization */
  
-- Customer's total spent
CREATE VIEW customers_total_spent AS
SELECT sales.customer_id,
	   SUM(menu.price) as total_amount_spent
FROM dannys_diner.sales as sales
JOIN dannys_diner.menu as menu
ON sales.product_id = menu.product_id
GROUP BY 1
ORDER BY 1;
