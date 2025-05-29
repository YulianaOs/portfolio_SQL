--8 Запрос "Самые частые клиенты аптек Горздрав и Здравсити"
	--Сделать две временные таблицы: для аптеки горздрав и здравсити (WITH)
	--Внутри каждой соединить таблицы заказов и клиентов (JOIN)
	--Внутри каждой привести данные в формат "клиент - кол-во заказов в аптеке"
	--Внутри каждой оставить топ 10 клиентов каждой аптеки
	--Объединить клиентов с помощью UNION


WITH gorzdrav_clients AS (
    -- Временная таблица для аптеки Горздрав
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name, ' ', c.second_name) AS full_name,
        COUNT(o.order_id) AS order_count  -- Подсчет количества заказов
    FROM 
        pharma_orders o
    JOIN 
        customers c ON o.customer_id = c.customer_id  -- Соединение таблиц
    WHERE 
        o.pharmacy_name = 'Горздрав'  -- Фильтрация по аптеке
    GROUP BY 
        c.customer_id, c.first_name, c.last_name, c.second_name  -- Группировка по клиенту
    ORDER BY 
        order_count DESC  -- Сортировка по количеству заказов в порядке убывания
    LIMIT 10  -- Топ-10 клиентов
),
zdravsiti_clients AS (
    -- Временная таблица для аптеки Здравсити
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name, ' ', c.second_name) AS full_name,
        COUNT(o.order_id) AS order_count  -- Подсчет количества заказов
    FROM 
        pharma_orders o
    JOIN 
        customers c ON o.customer_id = c.customer_id  -- Соединение таблиц
    WHERE 
        o.pharmacy_name = 'Здравсити'  -- Фильтрация по аптеке
    GROUP BY 
        c.customer_id, c.first_name, c.last_name, c.second_name  -- Группировка по клиенту
    ORDER BY 
        order_count DESC  -- Сортировка по количеству заказов в порядке убывания
    LIMIT 10  -- Топ-10 клиентов
)
-- Объединяем результаты из обеих временных таблиц
SELECT 
    customer_id,
    full_name,
    order_count,
    'Горздрав' AS pharmacy  -- Указываем аптеку для клиентов из первой временной таблицы
FROM 
    gorzdrav_clients

UNION ALL

SELECT 
    customer_id,
    full_name,
    order_count,
    'Здравсити' AS pharmacy  -- Указываем аптеку для клиентов из второй временной таблицы
FROM 
    zdravsiti_clients;