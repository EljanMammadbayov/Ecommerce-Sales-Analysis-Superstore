SELECT *
FROM Sample_Superstore;

--Let's find out total units of products sold, total revenue and total profit per state (2014-2017)
--2017 is the current year in this dataset;

SELECT State, SUM(Quantity) AS Total_Units_Sold, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit
FROM Sample_Superstore
GROUP BY State
ORDER BY Total_Sales DESC;

--California($457687.63) and New York($310876.27) generate the most sales revenue.
--Texas, which comes 3rd in terms of revenue has a negative profit of -25729.36 USD.

--What are the most profitable states?

SELECT State, SUM(Quantity) AS Total_Units_Sold, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit
FROM Sample_Superstore
GROUP BY State
ORDER BY Total_Profit DESC;

--The state of California is the most profitable ($76381.39) and New York comes as a close second ($74038.55)
--The profit gap between New York (2nd) and Washington (3rd, $33402.65) is over 40K dollars.
--Texas is the least profitable state (has the biggest money loss compared to other states)

--What state has generated the highest profit margin (%)?

WITH Profit_Margin_state_CTE AS
(SELECT State, SUM(Quantity) AS Total_Units_Sold, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit
FROM Sample_Superstore
GROUP BY State)

SELECT State, Total_Units_Sold, Total_Sales, Total_Profit, 
ROUND(Total_Profit/Total_Sales*100, 2) AS Profit_Margin_prc
FROM Profit_Margin_state_CTE
ORDER BY Profit_Margin_prc DESC;

--TOP 3 Profit Margin states are Columbia(36.98%), Delaware(36.34%), and Minnesota(36.24%). California is only 37th with 16.69%
--But we have to keep in mind that California is Superstore's hottest shopping state with 7667 units of products sold compared to Columbia's mere 40
--Ohio state with the negative profit of -16971.38 has the lowest profit margin (-21.69%)

--We can look at TOP 3 Profit Margin states that meet a certain Total Sales threshold to conduct a more meaningful assessment.
--I will choose 30K USD as a Sales threshold for Profit Margin evaluation.

WITH Profit_Margin_state_CTE AS
(SELECT State, SUM(Quantity) AS Total_Units_Sold, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit
FROM Sample_Superstore
GROUP BY State)

SELECT State, Total_Units_Sold, Total_Sales, Total_Profit, 
ROUND(Total_Profit/Total_Sales*100, 2) AS Profit_Margin_prc
FROM Profit_Margin_state_CTE
WHERE Total_Sales >= 30000
ORDER BY Profit_Margin_prc DESC;

--The result is different as none of the states mentioned in the initial profit margin assessment passes the Sales threshold of $30K
--TOP 3 states by Profit Margin, having a revenue of >=30K dollars, are Indiana (34.33%), Georgia (33.1%), and Michigan (32.07%)


--What region brings the most revenue?

WITH Profit_Margin_region_CTE AS
(SELECT Region, SUM(Quantity) AS Total_Units_Sold, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit
FROM Sample_Superstore
GROUP BY Region)

SELECT Region, Total_Units_Sold, Total_Sales, Total_Profit, 
ROUND(Total_Profit/Total_Sales*100, 2) AS Profit_Margin_prc
FROM Profit_Margin_region_CTE
ORDER BY Total_Sales DESC;

--West Region not only generates the most sales revenue but also has the highest profit and highest profit margin.

--The most profitable product category?

SELECT Category, SUM(Quantity) AS Total_Units_Sold, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit
FROM Sample_Superstore
GROUP BY Category
ORDER BY Total_Profit DESC;

--Technology ($145454.95) and Office Supplies ($122490.80) products bring substantially more profit than Furniture items ($18871.27)

WITH Profit_Margin_cgry_CTE AS
(SELECT Category, SUM(Quantity) AS Total_Units_Sold, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit
FROM Sample_Superstore
GROUP BY Category)

SELECT Category, Total_Units_Sold, Total_Sales, Total_Profit, 
ROUND(Total_Profit/Total_Sales*100, 2) AS Profit_Margin_prc
FROM Profit_Margin_cgry_CTE
ORDER BY Profit_Margin_prc DESC;

--Not only do they bring much more profit, their profit margins are way higher (17.4% and 17.04% vs 2.54%)

--Let's break this down by sub-categories to see a more detailed picture

WITH Profit_Margin_subcgry_CTE AS
(SELECT Category, Sub_Category, SUM(Quantity) AS Total_Units_Sold, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit
FROM Sample_Superstore
GROUP BY Category, Sub_Category)

SELECT Category, Sub_Category, Total_Units_Sold, Total_Sales, Total_Profit, 
ROUND(Total_Profit/Total_Sales*100, 2) AS Profit_Margin_prc
FROM Profit_Margin_subcgry_CTE
ORDER BY Total_Profit DESC;

--It is visible that Technology's profit stats are carried by Copiers, Phones, Accessories.
--They are TOP 3 profit-generating sub-categories in the whole dataset.
--Office Supplies are doing well thanks to Paper and Binders sales.
--The losses are concentrated in Supplies (Office Supplies), Bookcases (Furniture), and Tables (Furniture).
--2 out of 4 Furniture sub-categories brought losses, with Tables being the biggest financial burden in the dataset.
--TOP 3 sub-categories with the highest profitability ratios are Labels, Paper, and Envelopes, all belonging to Office Supplies.

--Let's see if the high discounts affected profitability.
--First on a State level.

WITH Discount_state_CTE AS
(SELECT State, SUM(Quantity) AS Total_Units_Sold, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit,
AVG(Discount) AS Avg_Discount
FROM Sample_Superstore
GROUP BY State)

SELECT State, Total_Units_Sold, Total_Sales, Total_Profit,
ROUND(Total_Profit/Total_Sales*100, 2) AS Profit_Margin_prc, Avg_Discount
FROM Discount_state_CTE
ORDER BY Avg_Discount DESC;

--And yes, the pattern is definitely noticable. TOP 10 states providing the highest average discount all generated losses (negative profits, lowest profit margins).
--When the average discount numbers drop considerably, Profit Margins go visibly higher.
--Average discounts up to 7% tend to generate Profit Margins >= 20%
--Meanwhile, average discounts from approximately 29-39% result in negative profits and profitabilities.

--Let's observe average discount impact on category profits and profitabilities too.

WITH Discount_cgry_CTE AS
(SELECT Category, SUM(Quantity) AS Total_Units_Sold, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit,
AVG(Discount) AS Avg_Discount
FROM Sample_Superstore
GROUP BY Category)

SELECT Category, Total_Units_Sold, Total_Sales, Total_Profit,
Total_Profit/Total_Sales*100 AS Profit_Margin_prc, Avg_Discount
FROM Discount_cgry_CTE
ORDER BY Avg_Discount DESC;

--Average discounts are not substantially different in terms of categories. 
--We could expand to sub-categories to see if there are attention-worthy patterns.

WITH Discount_subcgry_CTE AS
(SELECT Category, Sub_Category, SUM(Quantity) AS Total_Units_Sold, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit,
AVG(Discount) AS Avg_Discount
FROM Sample_Superstore
GROUP BY Category, Sub_Category)

SELECT Category, Sub_Category, Total_Units_Sold, Total_Sales, Total_Profit,
ROUND(Total_Profit/Total_Sales*100, 2) AS Profit_Margin_prc, Avg_Discount
FROM Discount_subcgry_CTE
ORDER BY Avg_Discount DESC;

--The results are rather random, no direct pattern visible. 
--A remark can be made though that Labels (Office Supplies) produce the highest profit margin, having the lowest average discount.

--What is the most profitable category in California?

WITH Profit_Margin_state_cgry_CTE AS
(SELECT State, Category, SUM(Quantity) AS Total_Units_Sold, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit
FROM Sample_Superstore
GROUP BY State, Category)

SELECT State, Category, Total_Units_Sold, Total_Sales, Total_Profit, 
ROUND(Total_Profit/Total_Sales*100, 2) AS Profit_Margin_prc
FROM Profit_Margin_state_cgry_CTE
WHERE State = 'California'
ORDER BY Total_Profit DESC;

--Office Supplies category is the most profitable in California. It also comes with the highest profit margin.

--Let's look at category performances per each state.

WITH Stats_state_cgry_CTE AS
(SELECT State, Category, SUM(Quantity) AS Total_Units_Sold, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit
FROM Sample_Superstore
GROUP BY State, Category)

SELECT State, Category, Total_Units_Sold, Total_Sales, Total_Profit,
ROUND(Total_Profit/Total_Sales*100, 2) AS Profit_Margin_prc
FROM Stats_state_cgry_CTE
ORDER BY Total_Profit DESC;

--Technology is the bestselling category in California and New York (highest sales revenues).
--New York's Technology sales produce the most profit among category sales in all other states.
--On the other hand, Texas loses the most money on Office Supplies.

--Let's look at each state's Total Sales and Total Profit per year

SELECT State, DATEPART(YEAR, Order_Date) AS Order_Year, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit
FROM Sample_Superstore
GROUP BY State, DATEPART(YEAR, Order_Date)
ORDER BY Total_Sales DESC;

--Let's find out YoY growth % in Total Sales for each state

WITH Yearly_Sales AS (
  SELECT 
      State,
      DATEPART(YEAR, Order_Date) AS Order_Year,
      SUM(Sales) AS Total_Sales
  FROM Sample_Superstore
  GROUP BY State, DATEPART(YEAR, Order_Date)
)

SELECT 
    State,
    Order_Year,
    Total_Sales,
    LAG(Total_Sales) OVER (PARTITION BY State ORDER BY Order_Year) AS Prev_Year_Sales,
    ROUND(
      (Total_Sales - LAG(Total_Sales) OVER (PARTITION BY State ORDER BY Order_Year)) 
      / NULLIF(LAG(Total_Sales) OVER (PARTITION BY State ORDER BY Order_Year),0) * 100, 2
    ) AS YoY_Sales_Growth_prc
FROM Yearly_Sales
ORDER BY YoY_Sales_Growth_prc DESC;

--The state of New Mexico has experienced a massive 4298.5% YoY Sales growth this year.
--It is followed by Louisiana with the growth of 1993.75% this year.
--South Dakota is 3rd this year with the 611.32% rise in Sales revenue.

--What states had negative YoY Sales growth this and other years?

WITH Yearly_Sales AS (
  SELECT 
      State,
      DATEPART(YEAR, Order_Date) AS Order_Year,
      SUM(Sales) AS Total_Sales
  FROM Sample_Superstore
  GROUP BY State, DATEPART(YEAR, Order_Date)
)

SELECT 
    State,
    Order_Year,
    Total_Sales,
    LAG(Total_Sales) OVER (PARTITION BY State ORDER BY Order_Year) AS Prev_Year_Sales,
    ROUND(
      (Total_Sales - LAG(Total_Sales) OVER (PARTITION BY State ORDER BY Order_Year)) 
      / NULLIF(LAG(Total_Sales) OVER (PARTITION BY State ORDER BY Order_Year),0) * 100, 2
    ) AS YoY_Sales_Growth_prc
FROM Yearly_Sales
ORDER BY YoY_Sales_Growth_prc;

--This year Alabama (-76.11%), Rhode Island (-73.81%), Vermont (-71.61%), and Virginia (-71.53%) have taken the biggest blows in Sales numbers

--Let's find out YoY growth % in Total Profit for each state

WITH Yearly_Profit AS (
  SELECT 
      State,
      DATEPART(YEAR, Order_Date) AS Order_Year,
      SUM(Profit) AS Total_Profit
  FROM Sample_Superstore
  GROUP BY State, DATEPART(YEAR, Order_Date)
)

SELECT 
    State,
    Order_Year,
    Total_Profit,
    LAG(Total_Profit) OVER (PARTITION BY State ORDER BY Order_Year) AS Prev_Year_Profit,
    ROUND(
      (Total_Profit - LAG(Total_Profit) OVER (PARTITION BY State ORDER BY Order_Year)) 
      / NULLIF(LAG(Total_Profit) OVER (PARTITION BY State ORDER BY Order_Year),0) * 100, 2
    ) AS YoY_Profit_Growth_prc
FROM Yearly_Profit
ORDER BY YoY_Profit_Growth_prc DESC;

--The Rhode Island state experienced a huge 5375.57% YoY Profit growth in 2016.
--Current year's TOP YoY profit growths belong to New Mexico (3215.93%), Tennessee (1923.4%), and Louisiana (1274.12%)

--What states took the biggest hits in terms of YoY Profit Change%?

WITH Yearly_Profit AS (
  SELECT 
      State,
      DATEPART(YEAR, Order_Date) AS Order_Year,
      SUM(Profit) AS Total_Profit
  FROM Sample_Superstore
  GROUP BY State, DATEPART(YEAR, Order_Date)
)

SELECT 
    State,
    Order_Year,
    Total_Profit,
    LAG(Total_Profit) OVER (PARTITION BY State ORDER BY Order_Year) AS Prev_Year_Profit,
    ROUND(
      (Total_Profit - LAG(Total_Profit) OVER (PARTITION BY State ORDER BY Order_Year)) 
      / NULLIF(LAG(Total_Profit) OVER (PARTITION BY State ORDER BY Order_Year),0) * 100, 2
    ) AS YoY_Profit_Growth_prc
FROM Yearly_Profit
ORDER BY YoY_Profit_Growth_prc;

--North Carolina's profits shrank by shocking 2050.82% compared to last year.
--Florida (-240.74%) and Rhode Island (-90.94%) conclude TOP 3 in terms of Profit decrease vs last year.


--Who are TOP customers in terms of Total Sales and Total Profit?

SELECT Customer_ID, Customer_Name, SUM(Quantity) AS Total_Units_Sold, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit
FROM Sample_Superstore
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Sales DESC;

SELECT Customer_ID, Customer_Name, SUM(Quantity) AS Total_Units_Sold, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit
FROM Sample_Superstore
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Profit DESC;

--The most revenue comes from Sean Miller (25043.05 USD). Tamara Chand (2nd, $19052.22) and Raymond Buch ($15117.34) conclude TOP 3
--Tamara Chand brings the most profit (8981.32 USD) to Superstore. Raymond Buch is 2nd ($6976.10), Sanjit Chand is 3rd ($5757.42)

--Are TOP customers concentrated by region or category?

SELECT Region, Customer_ID, Customer_Name, SUM(Quantity) AS Total_Units_Sold, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit
FROM Sample_Superstore
GROUP BY Region, Customer_ID, Customer_Name
ORDER BY Total_Sales DESC;

SELECT Category, Customer_ID, Customer_Name, SUM(Quantity) AS Total_Units_Sold, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit
FROM Sample_Superstore
GROUP BY Category, Customer_ID, Customer_Name
ORDER BY Total_Sales DESC;

SELECT Region, Customer_ID, Customer_Name, SUM(Quantity) AS Total_Units_Sold, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit
FROM Sample_Superstore
GROUP BY Region, Customer_ID, Customer_Name
ORDER BY Total_Profit DESC;

SELECT Category, Customer_ID, Customer_Name, SUM(Quantity) AS Total_Units_Sold, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit
FROM Sample_Superstore
GROUP BY Category, Customer_ID, Customer_Name
ORDER BY Total_Profit DESC;

--TOP 4 customers in terms of sales revenue are concentrated by Category (all Technology). The regions are all different.
--In terms of profit it is less one-sided or straightforward. Regional concentration leans towards Central Region, while Category Concentration mostly involves Technology.


--Where is delivery (on average) fastest? Let me add a column named "Delivery_Time" for that

ALTER TABLE Sample_Superstore
ADD Delivery_Time int;

UPDATE Sample_Superstore
SET Delivery_Time = DATEDIFF(DAY, Order_Date, Ship_Date);

--Now let's check

SELECT State, SUM(Quantity) AS Total_Units_Sold, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit, 
AVG(Delivery_Time) AS Avg_Delivery_Time
FROM Sample_Superstore
GROUP BY State
ORDER BY Avg_Delivery_Time;

--North Dakota state has (on average) the fastest shipping [2 days]. 
--3 states with the slowest shipping are Maine, Wyorning, and Columbia [5 days]

WITH Ship_mode_efficiency AS
(SELECT 
    Ship_Mode,
    ROUND(AVG(Delivery_Time), 2) AS Avg_Delivery_Days,
    ROUND(AVG(Sales), 2) AS Avg_Sales_Per_Order,
    ROUND(AVG(Profit), 2) AS Avg_Profit_Per_Order
FROM Sample_Superstore
GROUP BY Ship_Mode)

SELECT Ship_Mode, Avg_Delivery_Days, Avg_Sales_Per_Order, Avg_Profit_Per_Order,
ROUND(Avg_Profit_Per_Order/Avg_Sales_Per_Order*100, 2) AS Avg_Profit_Margin_prc
FROM Ship_mode_efficiency
ORDER BY Avg_Delivery_Days;

--We can see that shipping on the same day generates (on average) most sales revenue.
--However, out of 4 shipping modes, it comes with the 3rd-best Average Profit Margin (12.38%) due to higher costs.
--The highest Average Profit Margin is generated via the First Class Superstore shipping (13.93%), taking an average of 2 days for delivery.
--First Class is therefore likely the best delivery option for Superstore, being fast and bringing the most profit.
