--6 Запрос "Лучшие клиенты":
	--Соединить таблицы заказов и клиентов (JOIN)
	--Посчитать тотал сумму заказов для каждого клиента
	--Проранжировать клиентов по убыванию суммы заказа (row_number)
	--Оставить топ-10 клиентов


WITH ranked_customers AS (
    SELECT 
        c.first_name, 
        c.last_name, 
        c.second_name, 
        SUM(po.price * po.count) AS total_orders,
        ROW_NUMBER() OVER (ORDER BY SUM(po.price * po.count) DESC) AS rank
    FROM 
        pharma_orders po
    JOIN 
        customers c ON po.customer_id = c.customer_id
    GROUP BY 
        c.first_name, 
        c.last_name, 
        c.second_name
)
SELECT 
    first_name, 
    last_name, 
    second_name, 
    total_orders
FROM 
    ranked_customers
WHERE 
    rank <= 10;
