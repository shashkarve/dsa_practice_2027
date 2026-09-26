--1
--orders
------------------------------------------------
-- order_id       INT
-- customer_id    INT
-- order_date     DATE
-- amount         DECIMAL(10,2)

-- Example:

-- order_id | customer_id | order_date | amount
-- ---------+-------------+------------+-------
-- 1        | 101         | 2026-01-10 | 100
-- 2        | 101         | 2026-01-15 | 250
-- 3        | 102         | 2026-01-12 | 300
-- 4        | 102         | 2026-01-20 | 150
-- 5        | 103         | 2026-01-11 | 500
-- 6        | 103         | 2026-01-13 | 500


-- For each customer, return their highest-value order.
SELECT ORDER_ID , CUSTOMER_ID
FROM ORDERS
WHERE CUSTOMER_ID IN(
SELECT CUSTOMER_ID, MAX(AMOUNT)
FROM ORDERS
GROUP BY CUSTOMER_ID
)



SELECT CUSTOMER_ID, ORDER_ID FROM (
SELECT CUSTOMER_ID, ORDER_ID, RANK() OVER  (PARTITION BY CUSTOMER_ID ORDER BY AMOUNT DESC ) as "rnk"
FROM ORDERS
)
WHERE rnk=1




-- Write a query to return the highest-value order for each customer, but with these rules:

-- Return exactly one order per customer.
-- If two orders have the same amount, choose the order with the most recent order_date.
-- If they also have the same order_date, choose the order with the highest order_id.

