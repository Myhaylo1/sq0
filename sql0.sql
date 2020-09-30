INNER JOIN
---------------------

1. Извлечь самый дорогой заказ

SELECT orders.id, Sum(phones_to_orders.quantity*price) AS max_sum
FROM phones INNER JOIN orders INNER JOIN phones_to_orders ON orders.id = phones_to_orders."orderId" ON phones.id = phones_to_orders."phoneId"
GROUP BY orders.id
ORDER BY Sum(phones_to_orders.quantity*price) DESC limit 1;

2. Извлечь топ покупателя (который больше всех потратил суммарно)

SELECT users.id, users."firstName", users."lastName", Sum(phones_to_orders.quantity*price) AS max_sum
FROM users INNER JOIN phones INNER JOIN orders INNER JOIN phones_to_orders ON orders.id = phones_to_orders."orderId" ON phones.id = phones_to_orders."phoneId" ON users.id = orders."userId"
GROUP BY users.id, users."firstName", users."lastName"
ORDER BY Sum(phones_to_orders.quantity*price) DESC limit 1;

3. Извлечь среднюю стоимость заказа

SELECT avg(order_sum) AS avg_order_sum
FROM (SELECT orders.id, Sum(phones_to_orders.quantity*price) AS order_sum
      FROM phones INNER JOIN (orders INNER JOIN phones_to_orders ON orders.id = phones_to_orders."orderId") ON phones.id = phones_to_orders."phoneId"
      GROUP BY orders.id) As q;

4. Извлечь количество моделей конкретной марки

SELECT phones.brand, phones.model, Sum(phones_to_orders.quantity) AS sum_quantity
FROM phones INNER JOIN phones_to_orders ON phones.id = phones_to_orders."phoneId"
WHERE phones.brand='Samsung' AND phones.model='26 model 1'
GROUP BY phones.brand, phones.model;

5. Извлечь все позиции конкретного заказа

SELECT phones_to_orders."orderId", phones.brand, phones.model, phones_to_orders.quantity, phones.price
FROM phones INNER JOIN phones_to_orders ON phones.id = phones_to_orders."phoneId"
WHERE (((phones_to_orders."orderId")=1));

6. Извлечь покупателя, который совершил больше всех заказов

SELECT orders."userId", Count(orders.id) AS �ount_user
FROM orders
GROUP BY orders."userId"
ORDER BY Count(orders.id) DESC limit 1;

7. Извлечь все заказы и отсортировать по убыванию стоимости

SELECT orders.id, Sum(phones_to_orders.quantity*price) AS max_sum
FROM phones INNER JOIN (orders INNER JOIN phones_to_orders ON orders.id = phones_to_orders."orderId") ON phones.id = phones_to_orders."phoneId"
GROUP BY orders.id
ORDER BY Sum(phones_to_orders.quantity*price) DESC;

8. TOP 10 самых дорогих телефонов

SELECT phones.id, phones.brand, phones.model, phones.price
FROM phones
ORDER BY phones.price DESC limit 10;

9. Пользователей и количество их заказов, отсортировать по кол-ву заказов

SELECT orders."userId", Count(phones_to_orders."orderId") AS count_orderId
FROM orders INNER JOIN phones_to_orders ON orders.id = phones_to_orders."orderId"
GROUP BY orders."userId"
ORDER BY Count(phones_to_orders."orderId");

10. TOP 10 самых популярных моделей

SELECT phones_to_orders."phoneId", phones.brand, phones.model, Sum(phones_to_orders.quantity) AS Sum_quantity
FROM phones INNER JOIN phones_to_orders ON phones.id = phones_to_orders."phoneId"
GROUP BY phones_to_orders."phoneId", phones.brand, phones.model
ORDER BY Sum(phones_to_orders.quantity) DESC limit 10;

11. САМЫЙ популярный телефон у <мужчин от 15 - 25 лет | женщин от 17 - 40>

SELECT phones_to_orders."phoneId", phones.brand, phones.model, Sum(phones_to_orders.quantity)
FROM users INNER JOIN phones INNER JOIN orders INNER JOIN phones_to_orders ON orders.id = phones_to_orders."orderId" ON phones.id = phones_to_orders."phoneId" ON users.id = orders."userId"
WHERE ("isMale"=true and date_part('year',age(birthday)) between 15 and 25) or ("isMale"=false and date_part('year',age(birthday)) between 17 and 40)
GROUP BY phones_to_orders."phoneId", phones.brand, phones.model, "isMale"
ORDER BY Sum(phones_to_orders.quantity) DESC limit 1;
