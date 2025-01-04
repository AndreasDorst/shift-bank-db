-- Active: 1730295105050@@127.0.0.1@5432@shift

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

  -- Погашение существующего кредитного договора
  insert into records values (16, 0, 2000, 1, to_date('01.12.2024', 'DD.MM.YYYY')); -- Погашение оставшегося долга
  update accounts
  set saldo = saldo + 2000
  where id = 1;

  -- Закрытие текущего кредитного договора
  update products
  set close_date = to_date('21.12.2024', 'DD.MM.YYYY')
  where id = 1;

  -- Создание нового кредитного договора
  insert into products values (4, 1, 'Кредитный договор с Сидоровым И.П.', 1, to_date('21.12.2024', 'DD.MM.YYYY'), null);

  -- Создание нового кредитного счета
  insert into accounts values (4, 'Кредитный счет для Сидоровым И.П.', 0, 1, to_date('21.12.2024', 'DD.MM.YYYY'), null, 4, '45502810401020000024');

  -- Выдача кредита по новому договору
  insert into records values (17, 1, 10000, 4, to_date('21.12.2024', 'DD.MM.YYYY'));
  update accounts
  set saldo = saldo - 10000
  where id = 4;

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

-- Проверка
select * from accounts;

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

-- Запрос 7: Нормализация данных остатков по счетам
DO $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN (
        SELECT a.id AS account_id,
               a.saldo AS current_saldo,
               SUM(CASE WHEN r.dt = 0 THEN r.sum ELSE -r.sum END) AS calculated_saldo
        FROM accounts a
        LEFT JOIN records r ON a.id = r.acc_ref
        GROUP BY a.id, a.saldo
        HAVING a.saldo != SUM(CASE WHEN r.dt = 0 THEN r.sum ELSE -r.sum END)
    ) LOOP
        UPDATE accounts
        SET saldo = rec.calculated_saldo
        WHERE id = rec.account_id;
    END LOOP;
END $$;

-- Запрос 8: Клиенты с полностью погашенным кредитом и новой выдачей
SELECT c.id AS client_id,
       c.name AS client_name,
       p.id AS product_id,
       p.name AS product_name
FROM clients c
JOIN products p ON c.id = p.client_ref
JOIN product_type pt ON p.product_type_id = pt.id
JOIN accounts a ON p.id = a.product_ref
JOIN records r ON a.id = r.acc_ref
WHERE pt.name = 'КРЕДИТ'
  AND NOT EXISTS (
    SELECT 1
    FROM records r_sub
    WHERE r_sub.acc_ref = a.id AND r_sub.dt = 1
  )
  AND EXISTS (
    SELECT 1
    FROM records r_sub
    WHERE r_sub.acc_ref = a.id AND r_sub.dt = 0
  );

-- Запрос 9: Закрытие продуктов типа КРЕДИТ с полным погашением и без повторной выдачи
UPDATE products
SET close_date = CURRENT_DATE
WHERE id IN (
    SELECT p.id
    FROM products p
    JOIN product_type pt ON p.product_type_id = pt.id
    JOIN accounts a ON p.id = a.product_ref
    LEFT JOIN records r ON a.id = r.acc_ref
    WHERE pt.name = 'КРЕДИТ'
      AND p.close_date IS NULL
      AND NOT EXISTS (
        SELECT 1
        FROM records r_sub
        WHERE r_sub.acc_ref = a.id AND r_sub.dt = 1
      )
);

-- Запрос 10: Закрытие типов продуктов без движений более одного месяца
UPDATE product_type
SET end_date = CURRENT_DATE
WHERE id IN (
    SELECT pt.id
    FROM product_type pt
    JOIN products p ON pt.id = p.product_type_id
    JOIN accounts a ON p.id = a.product_ref
    LEFT JOIN records r ON a.id = r.acc_ref
    WHERE r.oper_date < CURRENT_DATE - INTERVAL '1 month'
    GROUP BY pt.id
);

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

SELECT * FROM products;
