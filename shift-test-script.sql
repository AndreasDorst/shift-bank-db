-- 1. DDL-скрипты для создания объектов
BEGIN;

DROP TABLE IF EXISTS
  clients,
  tarifs,
  product_type,
  products,
  accounts,
  records;

-- Создание таблиц

-- Таблица CLIENTS
CREATE TABLE clients (
  id SERIAL PRIMARY KEY,
  name VARCHAR(1000) NOT NULL,
  place_of_birth VARCHAR(1000),
  date_of_birth DATE,
  address VARCHAR(1000),
  passport VARCHAR(100)
);

-- Таблица TARIFS
CREATE TABLE tarifs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  cost NUMERIC(10, 2)
);

-- Таблица PRODUCT_TYPE
CREATE TABLE product_type (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  begin_date DATE,
  end_date DATE,
  tarif_ref INT REFERENCES tarifs(id)
);

-- Таблица PRODUCTS
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  product_type_id INT NOT NULL REFERENCES product_type(id),
  name VARCHAR(100) NOT NULL,
  client_ref INT NOT NULL REFERENCES clients(id),
  open_date DATE,
  close_date DATE
);

-- Таблица ACCOUNTS
CREATE TABLE accounts (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  saldo NUMERIC(10, 2),
  client_ref INT NOT NULL REFERENCES clients(id),
  open_date DATE,
  close_date DATE,
  product_ref INT NOT NULL REFERENCES products(id),
  acc_num VARCHAR(25)
);

-- Таблица RECORDS
CREATE TABLE records (
  id SERIAL PRIMARY KEY,
  dt INT CHECK (dt IN (0, 1)),
  sum NUMERIC(10, 2),
  acc_ref INT NOT NULL REFERENCES accounts(id),
  oper_date DATE
);

COMMIT;

END;

-- 2. Заполнение таблиц данными

begin;

insert into tarifs values (1,'Тариф за выдачу кредита', 10);
insert into tarifs values (2,'Тариф за открытие счета', 10);
insert into tarifs values (3,'Тариф за обслуживание карты', 10);

insert into product_type values (1, 'КРЕДИТ', to_date('01.01.2018','DD.MM.YYYY'), null, 1);
insert into product_type values (2, 'ДЕПОЗИТ', to_date('01.01.2018','DD.MM.YYYY'), null, 2);
insert into product_type values (3, 'КАРТА', to_date('01.01.2018','DD.MM.YYYY'), null, 3);

insert into clients values (1, 'Сидоров Иван Петрович', 'Россия, Московская облать, г. Пушкин', to_date('01.01.2001','DD.MM.YYYY'), 'Россия, Московская облать, г. Пушкин, ул. Грибоедова, д. 5', '2222 555555, выдан ОВД г. Пушкин, 10.01.2015');
insert into clients values (2, 'Иванов Петр Сидорович', 'Россия, Московская облать, г. Клин', to_date('01.01.2001','DD.MM.YYYY'), 'Россия, Московская облать, г. Клин, ул. Мясникова, д. 3', '4444 666666, выдан ОВД г. Клин, 10.01.2015');
insert into clients values (3, 'Петров Сиодр Иванович', 'Россия, Московская облать, г. Балашиха', to_date('01.01.2001','DD.MM.YYYY'), 'Россия, Московская облать, г. Балашиха, ул. Пушкина, д. 7', '4444 666666, выдан ОВД г. Клин, 10.01.2015');

insert into products values (1, 1, 'Кредитный договор с Сидоровым И.П.', 1, to_date('01.06.2015','DD.MM.YYYY'), null);
insert into products values (2, 2, 'Депозитный договор с Ивановым П.С.', 2, to_date('01.08.2017','DD.MM.YYYY'), null);
insert into products values (3, 3, 'Карточный договор с Петровым С.И.', 3, to_date('01.08.2017','DD.MM.YYYY'), null);


insert into accounts values (1, 'Кредитный счет для Сидоровым И.П.', -2000, 1, to_date('01.06.2015','DD.MM.YYYY'), null, 1, '45502810401020000022');
insert into accounts values (2, 'Депозитный счет для Ивановым П.С.', 6000, 2, to_date('01.08.2017','DD.MM.YYYY'), null, 2, '42301810400000000001');
insert into accounts values (3, 'Карточный счет для Петровым С.И.', 8000, 3, to_date('01.08.2017','DD.MM.YYYY'), null, 3, '40817810700000000001');

insert into records values (1, 1, 5000, 1, to_date('01.06.2015','DD.MM.YYYY'));
insert into records values (2, 0, 1000, 1, to_date('01.07.2015','DD.MM.YYYY'));
insert into records values (3, 0, 2000, 1, to_date('01.08.2015','DD.MM.YYYY'));
insert into records values (4, 0, 3000, 1, to_date('01.09.2015','DD.MM.YYYY'));
insert into records values (5, 1, 5000, 1, to_date('01.10.2015','DD.MM.YYYY'));
insert into records values (6, 0, 3000, 1, to_date('01.10.2015','DD.MM.YYYY'));
insert into records values (7, 0, 10000, 2, to_date('01.08.2017','DD.MM.YYYY'));
insert into records values (8, 1, 1000, 2, to_date('05.08.2017','DD.MM.YYYY'));
insert into records values (9, 1, 2000, 2, to_date('21.09.2017','DD.MM.YYYY'));
insert into records values (10, 1, 5000, 2, to_date('24.10.2017','DD.MM.YYYY'));
insert into records values (11, 0, 6000, 2, to_date('26.11.2017','DD.MM.YYYY'));
insert into records values (12, 0, 120000, 3, to_date('08.09.2017','DD.MM.YYYY'));
insert into records values (13, 1, 1000, 3, to_date('05.10.2017','DD.MM.YYYY'));
insert into records values (14, 1, 2000, 3, to_date('21.10.2017','DD.MM.YYYY'));
insert into records values (15, 1, 5000, 3, to_date('24.10.2017','DD.MM.YYYY'));

commit;

end;

-- 3. Добавление данных

DO $$
BEGIN
  -- Начало транзакции
  BEGIN

  -- Добавление новых клиентов
  INSERT INTO clients VALUES 
  (4, 'Алексеев Дмитрий Викторович', 'Россия, Москва', TO_DATE('15.07.1985', 'DD.MM.YYYY'), 'Москва, ул. Тверская, д. 12', '3333 999999, выдан ОВД г. Москва, 10.01.2010'),
  (5, 'Смирнов Алексей Иванович', 'Россия, Санкт-Петербург', TO_DATE('20.03.1990', 'DD.MM.YYYY'), 'Санкт-Петербург, Невский пр., д. 5', '4444 888888, выдан ОВД г. Санкт-Петербург, 15.02.2015'),
  (6, 'Михайлов Андрей Сергеевич', 'Россия, Казань', TO_DATE('01.09.1978', 'DD.MM.YYYY'), 'Казань, ул. Кремлевская, д. 10', '5555 777777, выдан ОВД г. Казань, 25.03.2000'),
  (7, 'Петров Николай Александрович', 'Россия, Екатеринбург', TO_DATE('12.05.1987', 'DD.MM.YYYY'), 'Екатеринбург, ул. Ленина, д. 50', '5555 111111, выдан ОВД г. Екатеринбург, 20.11.2010');

  -- Добавление нового продукта "Договор рассрочки"
  INSERT INTO product_type VALUES 
  (4, 'РАССРОЧКА', TO_DATE('01.01.2024', 'DD.MM.YYYY'), NULL, 1);

  -- Клиент 4: открытие и закрытие кредитных договоров
  INSERT INTO products VALUES 
  (4, 1, 'Кредитный договор с Алексеевым Д.В.', 4, TO_DATE('01.12.2023', 'DD.MM.YYYY'), TO_DATE('25.12.2024', 'DD.MM.YYYY')),
  (5, 1, 'Кредитный договор с Алексеевым Д.В.', 4, TO_DATE('25.12.2024', 'DD.MM.YYYY'), NULL);

  INSERT INTO accounts VALUES 
  (4, 'Кредитный счет для кредита №1 Алексеев Д.В.', 0, 4, TO_DATE('01.12.2023', 'DD.MM.YYYY'), TO_DATE('25.12.2024', 'DD.MM.YYYY'), 4, '45502810401020000024'),
  (5, 'Кредитный счет для кредита №2 Алексеев Д.В.', 0, 4, TO_DATE('25.12.2024', 'DD.MM.YYYY'), NULL, 5, '45502810401020000025');

  INSERT INTO records VALUES 
  (19, 1, 5000, 4, TO_DATE('01.12.2023', 'DD.MM.YYYY')), -- Выдача кредита
  (20, 0, 5000, 4, TO_DATE('25.12.2024', 'DD.MM.YYYY')), -- Погашение кредита
  (21, 1, 10000, 5, TO_DATE('25.12.2024', 'DD.MM.YYYY')); -- Выдача кредита

  -- Создание кредитного договора
  INSERT INTO products VALUES 
  (6, 1, 'Кредитный договор с Смирновым А.И.', 5, TO_DATE('01.08.2023', 'DD.MM.YYYY'), NULL);

  INSERT INTO accounts VALUES 
  (6, 'Кредитный счет для Смирнова А.И.', 10000, 5, TO_DATE('01.08.2023', 'DD.MM.YYYY'), NULL, 6, '45502810401020000026');

  INSERT INTO records VALUES 
  (22, 1, 10000, 6, TO_DATE('01.08.2023', 'DD.MM.YYYY')), -- Выдача кредита
  (23, 0, 10000, 6, TO_DATE('01.03.2024', 'DD.MM.YYYY')); -- Погашение кредита

  -- Создание дополнительных договоров
  INSERT INTO products VALUES 
  (7, 2, 'Депозитный договор с Михайловым А.С.', 6, TO_DATE('01.01.2024', 'DD.MM.YYYY'), NULL),
  (8, 1, 'Кредитный договор с Петровым Н.А.', 7, TO_DATE('15.03.2023', 'DD.MM.YYYY'), TO_DATE('15.12.2024', 'DD.MM.YYYY'));

  INSERT INTO accounts VALUES 
  (7, 'Депозитный счет для Михайлова А.С.', 4000, 6, TO_DATE('01.01.2024', 'DD.MM.YYYY'), NULL, 7, '42301810400000000002'),
  (8, 'Кредитный счет для Петрова Н.А.', 0, 7, TO_DATE('15.03.2023', 'DD.MM.YYYY'), TO_DATE('15.12.2024', 'DD.MM.YYYY'), 8, '45502810401020000027');

  INSERT INTO records VALUES 
  (24, 0, 6000, 7, TO_DATE('01.01.2024', 'DD.MM.YYYY')), -- Пополнение счета
  (25, 1, 1000, 7, TO_DATE('02.01.2024', 'DD.MM.YYYY')), -- Списание 1000
  (26, 1, 2000, 7, TO_DATE('03.01.2024', 'DD.MM.YYYY')), -- Списание 2000
  (27, 0, 4000, 7, TO_DATE('04.01.2024', 'DD.MM.YYYY')), -- Некорректная запись (для эмуляции сбоя)
  (28, 1, 5000, 8, TO_DATE('15.03.2023', 'DD.MM.YYYY')),  -- Выдача кредита
  (29, 0, 5000, 8, TO_DATE('15.12.2024', 'DD.MM.YYYY')),  -- Погашение кредита
  (30, 1, 7000, 8, TO_DATE('15.12.2024', 'DD.MM.YYYY'));  -- Новая выдача кредита после погашения

  EXCEPTION
    -- Обработка ошибки
    WHEN OTHERS THEN
      -- Откатываем изменения в случае ошибки
      ROLLBACK;
      RAISE EXCEPTION 'Ошибка: %', SQLERRM;
  END;

  -- Фиксируем изменения
  COMMIT;
END $$;

-- Запрос 4: Отчет по счетам типа ДЕПОЗИТ, принадлежащим клиентам без открытых продуктов типа КРЕДИТ
SELECT a.*
FROM accounts a
JOIN products p ON a.product_ref = p.id
JOIN product_type pt ON p.product_type_id = pt.id
WHERE pt.name = 'ДЕПОЗИТ'
  AND a.client_ref NOT IN (
    SELECT DISTINCT p.client_ref
    FROM products p
    JOIN product_type pt ON p.product_type_id = pt.id
    WHERE pt.name = 'КРЕДИТ' AND p.close_date IS NULL
  );

-- Запрос 5: Средние движения по счетам за один день в разрезе типа продукта
SELECT pt.name AS product_type,
  r.oper_date,
  ROUND(AVG(r.sum), 2) AS average_sum
FROM records r
JOIN accounts a ON r.acc_ref = a.id
JOIN products p ON a.product_ref = p.id
JOIN product_type pt ON p.product_type_id = pt.id
WHERE r.oper_date = '2015-06-01'
GROUP BY pt.name, r.oper_date;

-- Запрос 6: Клиенты с операциями по счетам за последний месяц
SELECT c.id AS client_id,
  c.name AS client_name,
  r.oper_date,
  SUM(r.sum) AS total_sum
FROM clients c
JOIN accounts a ON c.id = a.client_ref
JOIN records r ON a.id = r.acc_ref
WHERE r.oper_date >= CURRENT_DATE - INTERVAL '1 month'
GROUP BY c.id, c.name, r.oper_date
ORDER BY r.oper_date;

-- 7: Нормализация данных остатков по счетам
-- Запрос на сравнение текущего сальдо с ожидаемым (для проверки)
SELECT a.id AS account_id,
  a.saldo AS current_saldo,
  SUM(CASE WHEN r.dt = 0 THEN r.sum ELSE -r.sum END) AS calculated_saldo
FROM accounts a
LEFT JOIN records r ON a.id = r.acc_ref
GROUP BY a.id, a.saldo;

-- Процедура нормализации
DO $$
DECLARE
  rec RECORD; -- Объявляем переменную типа RECORD для хранения каждой строки результата
BEGIN
  -- Цикл, который проходит по всем счетам с расхождением текущего и расчетного сальдо
  FOR rec IN (
    SELECT a.id AS account_id,
      a.saldo AS current_saldo,
      SUM(CASE WHEN r.dt = 0 THEN r.sum ELSE -r.sum END) AS calculated_saldo
    FROM accounts a
    LEFT JOIN records r ON a.id = r.acc_ref
    GROUP BY a.id, a.saldo
    HAVING a.saldo != SUM(CASE WHEN r.dt = 0 THEN r.sum ELSE -r.sum END)
  ) LOOP
  -- Для каждого счета с расхождением (который попал в результат подзапроса) выполняем обновление
    UPDATE accounts
      SET saldo = rec.calculated_saldo
      WHERE id = rec.account_id;
    END LOOP;
END $$;

-- Запрос 8: Клиенты с полностью погашенным кредитом и новой выдачей (решение исходя из предпосылки, что новый кредит выдается только в случае погашения предыдущего)
-- Создание бухгалтерского представления (для наглядности)
SELECT p.id AS product_id,
  ROW_NUMBER() OVER (PARTITION BY p.id ORDER BY r.oper_date) AS row_num,
  CASE WHEN r.dt = 0 THEN r.sum ELSE null END AS debet,
  CASE WHEN r.dt = 1 THEN -r.sum ELSE null END AS credit,
  SUM(CASE WHEN r.dt = 0 THEN r.sum ELSE -r.sum END) OVER (PARTITION BY p.id ORDER BY r.oper_date) AS saldo 
FROM records r
JOIN accounts a ON r.acc_ref = a.id
JOIN products p ON a.product_ref = p.id
JOIN product_type pt ON p.product_type_id = pt.id
WHERE pt.name = 'КРЕДИТ'
ORDER BY p.id, r.oper_date;

-- Скрипт запроса с использованием CTE на основе бухгалтерского представления (можно написать проще, например как в 9 задании)
WITH product_accounting AS (
  SELECT p.id AS product_id,
    c.name,
    ROW_NUMBER() OVER (PARTITION BY p.id ORDER BY r.oper_date) AS row_num,
    CASE WHEN r.dt = 0 THEN r.sum ELSE null END AS debet,
    CASE WHEN r.dt = 1 THEN -r.sum ELSE null END AS credit
  FROM records r
  JOIN accounts a ON r.acc_ref = a.id
  JOIN products p ON a.product_ref = p.id
  JOIN clients c ON p.client_ref = c.id
  JOIN product_type pt ON p.product_type_id = pt.id
  WHERE pt.name = 'КРЕДИТ'
  ORDER BY p.id, r.oper_date
)
SELECT name, product_id
FROM product_accounting
GROUP BY name, product_id
HAVING COUNT(credit) >= 2 AND (SUM(credit) + SUM(debet)) < 0;

-- 9: Закрытие продуктов типа КРЕДИТ с полным погашением и без повторной выдачи
UPDATE products
SET close_date = CURRENT_DATE
WHERE id IN (
    SELECT p.id
    FROM records r
    JOIN accounts a ON r.acc_ref = a.id
    JOIN products p ON a.product_ref = p.id
    JOIN clients c ON p.client_ref = c.id
    JOIN product_type pt ON p.product_type_id = pt.id
    WHERE pt.name = 'КРЕДИТ'
    GROUP BY p.id 
    HAVING SUM(CASE WHEN r.dt = 0 THEN r.sum ELSE null END) + SUM(CASE WHEN r.dt = 1 THEN -r.sum ELSE null END) = 0
      AND COUNT(CASE WHEN r.dt = 1 THEN -r.sum ELSE null END) < 2
);

-- Проверка
SELECT * FROM products WHERE close_date IS NOT NULL;

-- 10: Закрытие типов продуктов без движений более одного месяца
-- Просмотр типов продуктов
SELECT * FROM product_type;

-- Непосредственно закрытие
UPDATE product_type
SET end_date = CURRENT_DATE
WHERE id NOT IN (
  SELECT pt.id
  FROM product_type pt
  JOIN products p ON pt.id = p.product_type_id
  JOIN accounts a ON p.id = a.product_ref
  LEFT JOIN records r ON a.id = r.acc_ref
  WHERE r.oper_date < CURRENT_DATE - INTERVAL '1 month'
  GROUP BY pt.id
);

-- Проверка
SELECT * FROM product_type;

-- Запрос 11: Добавление суммы договора в модель и заполнение данных
ALTER TABLE products ADD COLUMN contract_sum NUMERIC(10, 2);

UPDATE products
SET contract_sum = subquery.max_debit
FROM (
  SELECT p.id AS product_id,
          MAX(CASE WHEN pt.name = 'КРЕДИТ' THEN r.sum ELSE 0 END) AS max_debit,
          MAX(CASE WHEN pt.name IN ('ДЕПОЗИТ', 'КАРТА') THEN r.sum ELSE 0 END) AS max_credit
  FROM products p
  JOIN product_type pt ON p.product_type_id = pt.id
  JOIN accounts a ON p.id = a.product_ref
  JOIN records r ON a.id = r.acc_ref
  GROUP BY p.id, pt.name
) AS subquery
WHERE products.id = subquery.product_id
  AND (subquery.max_debit > 0 OR subquery.max_credit > 0);

-- Проверка
SELECT * FROM products;
