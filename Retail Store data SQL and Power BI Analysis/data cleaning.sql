-- Data Cleaning
DELETE s1 FROM Sales s1
JOIN Sales s2 
ON s1.Order_ID = s2.Order_ID 
AND s1.Product_ID = s2.Product_ID 
AND s1.Order_Line > s2.Order_Line;

ALTER TABLE Sales MODIFY COLUMN Order_Date DATE;
ALTER TABLE Sales MODIFY COLUMN Ship_Date DATE;

UPDATE Sales
SET Sales = NULL
WHERE Sales <= 0;

UPDATE Customer
SET Customer_Name = TRIM(Customer_Name);

UPDATE Sales
SET Discount = 0
WHERE Discount < 0;
UPDATE Sales
SET Discount = 1
WHERE Discount > 1;

UPDATE Sales
SET Ship_Mode = 'Standard Class'
WHERE Ship_Mode LIKE '%Standard%';

UPDATE Product
SET Product_Name = TRIM(Product_Name);


SELECT s.*
FROM Sales s
LEFT JOIN Customer c ON s.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL;

SELECT s.*
FROM Sales s
LEFT JOIN Product p ON s.Product_ID = p.Product_ID
WHERE p.Product_ID IS NULL;
