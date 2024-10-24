/*
What are the top three products by number of items sold? You need to provide the product names and the sales numbers for each. 
(Some transactions involve more than one item being sold...)
*/

SELECT products.title as product_name, SUM(sales.num_items) as total_num_sold
FROM products
JOIN sales on products.id = sales.product_id
GROUP BY products.title
ORDER BY total_num_sold DESC
LIMIT 3;

/*
What are the top three products by monetary value? You need to provide the product names and the total value of sales for each 
(where possible. What might cause a problem? Hint: check some records for December 2022.)
*/

SELECT products.title as product_name, ROUND(SUM(sales.num_items * products.product_cost), 2) as total_sales_value
FROM products
JOIN sales on products.id = sales.product_id
GROUP BY products.title
ORDER BY total_sales_value DESC
LIMIT 3;

/*
Which user was the top spender in December 2022? Provide their email address and phone number.
*/

SELECT users.email, users.phone_number, ROUND(SUM(sales.num_items * products.product_cost), 2) as total_spent_dec_2022
FROM users
JOIN sales ON users.id = sales.buyer_id
JOIN products ON sales.product_id = products.id
WHERE EXTRACT(MONTH from sales.transaction_ts) = 12 AND EXTRACT(YEAR from sales.transaction_ts) = 2022
GROUP BY users.id
ORDER BY total_spent_dec_2022 DESC
LIMIT 1;