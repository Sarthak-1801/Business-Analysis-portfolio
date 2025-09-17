EDA
-- Skills used: GROUP BY, ORDER BY, CTEs, SUBQUERIES, JOINS, WINDOW Functions 
----------------------------------------------------------------------------------------------

-- Top 10 customers by Sales value
SELECT c.Customer_Name, SUM(s.Sales) AS Total_Sales
FROM Sales s
JOIN Customer c ON s.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Name
ORDER BY Total_Sales DESC
LIMIT 10;

-- Categorywise Revenue and Profit
SELECT p.Category, SUM(s.Sales) AS Revenue, SUM(s.Profit) AS Profit
FROM Sales s
JOIN Product p ON s.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY Revenue DESC;

-- Regionwise Sales
SELECT c.Region, ROUND(SUM(s.Sales),2) AS Total_Sales
FROM Sales s
JOIN Customer c ON s.Customer_ID = c.Customer_ID
GROUP BY c.Region
ORDER BY Total_Sales DESC;

-- Monthly Sales Trend
SELECT DATE_FORMAT(Order_Date, '%Y-%m') AS Month, ROUND(SUM(Sales), 2) AS Monthly_Sales
FROM Sales
GROUP BY Month
ORDER BY Month;

-- Customer retention analysis
with FirstPurchase AS (
select Customer_ID, MIN(Order_Date) AS First_Order
from Sales
group by Customer_ID
),
Cohort as (
select 
f.Customer_ID,
date_format(f.First_Order, '%Y-%m') as Cohort_Month,
date_format(s.Order_Date, '%Y-%m') as Order_Month
from FirstPurchase f
join Sales s on f.Customer_ID = s.Customer_ID
)
select 
Cohort_Month,
Order_Month,
count(distinct Customer_ID) as Active_Customers
from Cohort
group by Cohort_Month, Order_Month
order by Cohort_Month, Order_Month;

-- Top 5 categorically most profitable products
SELECT Category, Product_ID, Product_Name, Total_Profit
FROM (SELECT 
p.Category,
p.Product_ID,
p.Product_Name,
SUM(s.Profit) AS Total_Profit,
ROW_NUMBER() OVER (PARTITION BY p.Category ORDER BY SUM(s.Profit) DESC) AS rnk
FROM Sales s
JOIN Product p ON s.Product_ID = p.Product_ID
GROUP BY p.Category, p.Product_ID, p.Product_Name
) ranked
WHERE rnk <= 5
ORDER BY Category, Total_Profit DESC;

-- Profit across regions
SELECT 
c.Region,
SUM(s.Sales) AS Total_Sales,
SUM(s.Profit) AS Total_Profit,
ROUND(SUM(s.Profit)/SUM(s.Sales)*100,2) AS Profit_Margin_Percent
FROM Sales s
JOIN Customer c ON s.Customer_ID = c.Customer_ID
GROUP BY c.Region
ORDER BY Profit_Margin_Percent DESC;
