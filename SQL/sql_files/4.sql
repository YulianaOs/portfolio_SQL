--4. Запрос "Накопленная сумма продаж по каждой аптеке"

SELECT 
    pharmacy_name, 
    SUM(price * count) AS total_sales,
    SUM(SUM(price * count)) OVER (ORDER BY pharmacy_name) AS cumulative_sum
FROM 
    pharma_orders
GROUP BY 
    pharmacy_name
ORDER BY 
    pharmacy_name;