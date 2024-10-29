/*
What are the top three products by number of items sold? You need to provide the product names and the sales numbers for each. 
(Some transactions involve more than one item being sold...)
*/

SELECT p.title as product_name, SUM(s.num_items) as total_num_sold
FROM products AS p
JOIN sales AS s on p.id = s.product_id
GROUP BY p.title
ORDER BY total_num_sold DESC
LIMIT 3;

/*
What are the top three products by monetary value? You need to provide the product names and the total value of sales for each 
(where possible. What might cause a problem? Hint: check some records for December 2022.)
*/

SELECT p.title as product_name, ROUND(SUM(s.num_items * p.product_cost), 2) as total_sales_value
FROM products AS p
JOIN sales AS s on p.id = s.product_id
GROUP BY p.title
ORDER BY total_sales_value DESC
LIMIT 3;

/*
Which user was the top spender in December 2022? Provide their email address and phone number.
*/

SELECT u.email, u.phone_number, ROUND(SUM(s.num_items * p.product_cost), 2) as total_spent_dec_2022
FROM users AS u
JOIN sales AS s ON u.id = s.buyer_id
JOIN products AS p ON s.product_id = p.id
WHERE EXTRACT(MONTH from s.transaction_ts) = 12 AND EXTRACT(YEAR from s.transaction_ts) = 2022
GROUP BY u.id
ORDER BY total_spent_dec_2022 DESC
LIMIT 1;