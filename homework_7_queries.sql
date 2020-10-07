-- Query code to isolate (or group) the transactions of each cardholder:
CREATE VIEW transactions_per_card AS
SELECT name, b.card, COUNT(b.card) AS card_transaction_count
FROM card_holder AS a
LEFT JOIN credit_card AS b ON a.id=b.id_card_holder
LEFT JOIN transaction AS c ON b.card=c.card
GROUP BY name, b.card
ORDER BY COUNT(b.card) DESC;

-- Can also use code below if only the id_card_holder is wanted rather
-- than the name.
CREATE VIEW id_card_holder_transactions AS
SELECT id_card_holder, a.card, COUNT(a.card)
FROM credit_card AS a
LEFT JOIN transaction AS b ON a.card=b.card
GROUP BY id_card_holder, a.card
ORDER BY COUNT(a.card) DESC;

-- Query for highest 100 transactions between 7:00 AM and 9:00 AM:
CREATE VIEW timed_transactions AS
SELECT amount, CAST(date AS TIME) 
FROM transaction
WHERE CAST(date AS TIME) BETWEEN ('07:00'::time) AND ('09:00'::time)
ORDER BY amount DESC
LIMIT (100);
-- The transactions with exact dollar amounts seem somewhat suspicious and
-- could be fraud.  There are 9 total in this time range that are exact
-- dollar amounts, which does not seem likely.  Fraud is possible here. 

-- Query to count transactions that are less than $2.00 per cardholder: 
CREATE VIEW less_than_2_group AS
SELECT name, amount, COUNT(*) as count_column
FROM transaction AS a
INNER JOIN credit_card AS b ON a.card=b.card
INNER JOIN card_holder AS c ON b.id_card_holder=c.id
GROUP BY name, a.amount

CREATE VIEW final_less_than_2_group AS 
SELECT name, SUM(count_column)
FROM less_than_2_group
WHERE amount < 2.00
GROUP BY name;
-- There is evidence to suggest that a credit card has been hacked.  
-- Several individuals have a total of 20+ transactions that are less than $2.00. 
-- I would say all individuals with over 15 transactions of less than $2.00 
-- are at risk that their card has been hacked.  That would be a total of 
-- 13 of the 25 individuals listed (between all cards). 

-- QUERY of top 5 merchants prone to being hacked using small transactions: 
CREATE VIEW merchant_group AS
SELECT name, amount, COUNT(*) as column_count
FROM merchant AS a 
INNER JOIN transaction as b ON a.id=b.id_merchant
GROUP BY name, amount;

CREATE VIEW final_merchant_group AS
SELECT name, SUM(column_count)
FROM merchant_group
WHERE amount < 2.00
GROUP BY name
ORDER BY sum DESC
LIMIT(5);
-- Top 5 merchants prone to being hacked using small transactions are as follows: 
-- Wood-Ramirez / Hood-Phillips / Baker Inc. / McDaniel, Hines and McFarland / 
-- Hamilton-McFarland
-- 
-- 
-- PLOTTING ANALYSIS INFO BELOW 
-- Queries used to find ALL transactions of cardholders 2 and 18:
CREATE VIEW client_list AS
SELECT id_card_holder, b.date, COUNT(b.date) AS date_transaction_count
FROM credit_card AS a
LEFT JOIN transaction AS b ON a.card=b.card
GROUP BY id_card_holder, b.date
ORDER BY COUNT(b.date) DESC;
SELECT id_card_holder, DATE_TRUNC('month', date), SUM(date_transaction_count)
FROM client_list
WHERE id_card_holder = 2
GROUP BY id_card_holder, DATE_TRUNC('month', date)
ORDER BY 2;

SELECT id_card_holder, DATE_TRUNC('month', date), SUM(date_transaction_count)
FROM client_list
WHERE id_card_holder = 18
GROUP BY id_card_holder, DATE_TRUNC('month', date)
ORDER BY 2;

-- Queries used to find transactions less than $2.00 for cardholders 2 & 18: 
CREATE VIEW client_list_updated AS
SELECT id_card_holder, amount, b.date, COUNT(b.date) AS date_transaction_count
FROM credit_card AS a
LEFT JOIN transaction AS b ON a.card=b.card
GROUP BY id_card_holder, b.date, amount
ORDER BY COUNT(b.date) DESC;

SELECT id_card_holder, DATE_TRUNC('month', date), SUM(date_transaction_count)
FROM client_list_updated
WHERE id_card_holder = 2
AND amount < 2.00
GROUP BY id_card_holder, DATE_TRUNC('month', date)
ORDER BY 2 ASC;

SELECT id_card_holder, DATE_TRUNC('month', date), SUM(date_transaction_count)
FROM client_list_updated
WHERE id_card_holder = 18
AND amount < 2.00
GROUP BY id_card_holder, DATE_TRUNC('month', date)
ORDER BY 2 ASC;


-- Queries for Question #2 from Jupyter Notebook File: 
-- Creating a View to pull cardholder id, date, and amount info
CREATE VIEW final AS
SELECT id_card_holder, b.date, amount, COUNT(b.date) AS date_transaction_count
FROM credit_card AS a
LEFT JOIN transaction AS b ON a.card=b.card
GROUP BY id_card_holder, b.date, amount
ORDER BY COUNT(b.date) DESC;

-- Query that will pull all data needed for entire January-June date range. 
SELECT id_card_holder, amount, CAST(date AS DATE), SUM(date_transaction_count)
FROM final
WHERE id_card_holder = 25
AND date BETWEEN ('2018-01-01'::date) AND ('2018-06-30'::date)
GROUP BY id_card_holder, amount, CAST(date AS DATE)
ORDER BY 3 ASC;

-- Query for January only data. 
CREATE VIEW January AS
SELECT id_card_holder, amount, CAST(date AS DATE), SUM(date_transaction_count)
FROM final
WHERE id_card_holder = 25
AND date BETWEEN ('2018-01-01'::date) AND ('2018-01-31'::date)
GROUP BY id_card_holder, amount, CAST(date AS DATE)
ORDER BY 3 ASC;

-- Query for February only data. 
CREATE VIEW February AS
SELECT id_card_holder, amount, CAST(date AS DATE), SUM(date_transaction_count)
FROM final
WHERE id_card_holder = 25
AND date BETWEEN ('2018-02-01'::date) AND ('2018-02-28'::date)
GROUP BY id_card_holder, amount, CAST(date AS DATE)
ORDER BY 3 ASC;

--Query for March only data. 
CREATE VIEW March AS
SELECT id_card_holder, amount, CAST(date AS DATE), SUM(date_transaction_count)
FROM final
WHERE id_card_holder = 25
AND date BETWEEN ('2018-03-01'::date) AND ('2018-03-31'::date)
GROUP BY id_card_holder, amount, CAST(date AS DATE)
ORDER BY 3 ASC;

-- Query for APril only data. 
CREATE VIEW April AS
SELECT id_card_holder, amount, CAST(date AS DATE), SUM(date_transaction_count)
FROM final
WHERE id_card_holder = 25
AND date BETWEEN ('2018-04-01'::date) AND ('2018-04-30'::date)
GROUP BY id_card_holder, amount, CAST(date AS DATE)
ORDER BY 3 ASC;

-- Query for May only data. 
CREATE VIEW May AS
SELECT id_card_holder, amount, CAST(date AS DATE), SUM(date_transaction_count)
FROM final
WHERE id_card_holder = 25
AND date BETWEEN ('2018-05-01'::date) AND ('2018-05-31'::date)
GROUP BY id_card_holder, amount, CAST(date AS DATE)
ORDER BY 3 ASC;

-- Query for June only data.
CREATE VIEW June AS
SELECT id_card_holder, amount, CAST(date AS DATE), SUM(date_transaction_count)
FROM final
WHERE id_card_holder = 25
AND date BETWEEN ('2018-06-01'::date) AND ('2018-06-30'::date)
GROUP BY id_card_holder, amount, CAST(date AS DATE)
ORDER BY 3 ASC;

-- Queries used to pull only amount info from given month, and name column as month. 
-- Same format used for all months (January - June).  Columns were then 
-- concatenated in Pandas DF to make box plotting simpler (hopefully).
SELECT amount AS January 
FROM January;