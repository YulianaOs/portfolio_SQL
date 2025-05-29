--7 Запрос "Накопленная сумма по клиентам"
	--Соединить таблицы заказов и клиентов
	--Соединить ФИО в одно поле
	--Рассчитать накопленную сумму по каждому клиенту

WITH combined_data AS (
    -- 1. Соединяем таблицы заказов и клиентов
    SELECT 
        c.customer_id,
        -- Используем функцию CONCAT для объединения имени, фамилии и отчества в одно поле
        CONCAT(c.first_name, ' ', c.last_name, ' ', c.second_name) AS full_name,
        -- Используем SUM для расчета общей суммы заказов по каждому клиенту
        SUM(o.price * o.count) AS total_amount
    FROM 
        pharma_orders o
    JOIN 
        customers c ON o.customer_id = c.customer_id  -- Соединение таблиц по customer_id
    GROUP BY 
        c.customer_id, c.first_name, c.last_name, c.second_name  -- Группируем по клиенту и его ФИО
),
cumulative_data AS (
    -- 2. Рассчитываем накопленную сумму по каждому клиенту
    SELECT 
        customer_id,
        full_name,
        -- Используем оконную функцию SUM() OVER для расчета накопленной суммы
        SUM(total_amount) OVER (ORDER BY customer_id) AS cumulative_amount
    FROM 
        combined_data  -- Используем данные из предыдущего CTE
)
-- Выводим результаты с сортировкой по накопленной сумме в порядке возрастания
SELECT 
    customer_id,
    full_name,
    cumulative_amount
FROM 
    cumulative_data  -- Используем данные из второго CTE
ORDER BY 
    cumulative_amount;  -- Сортируем результаты по накопленной сумме в порядке возрастания