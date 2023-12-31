
CREATE TABLE Store_Items (
 ID INTEGER PRIMARY KEY
,Item Varchar(50)
,Price Int
,main_colour varchar(50)
,child_category varchar(50)
,num_purchases_two_months int
)

---- Note: the column name 'num_purchase_two_months' refers to the number of purchases for each item in the past two months of July and August (2023)

INSERT INTO Store_Items VALUES
 (1, 'Toy car', 8.00, 'green', 'young child', 123)
,(2, 'cards', 2.00, 'multi', 'teenager', 400)
,(3, 'ps4', 500.00, 'black', 'teenager', 103)
,(4, 'teddybear', 3.00, 'brown', 'toddler', 230)
,(5, 'waterpistolset', 14.00, 'blue', 'young child', 17)
,(6, 'Toy car', 7.00, 'green', 'young child', 123)
,(7, 'jenga', 17.50, 'beige', 'young child', 255)
,(8, 'monopoly', 27.00, 'multi', 'teenager', 267)
,(9, 'football', 15.50, 'mono', 'young child', 23)
,(10, 'barbiedoll', 12.99, 'multi', 'young child', 129)
,(11, 'babybook', 8.99, 'multi', 'toddler', 108)
,(12, 'squishmallow', 12.99, 'pink', 'toddler', 123)
,(13, 'robot', 7.00, 'silver', 'toddler', 67)
,(14, 'bmxbike', 130.00, 'red', 'teenager', 123)
,(15, 'uno', 4.50, 'mutli', 'teenager', 360)
------------------------------------------------------------------------------------------------------------

--- 1.) Total number of items the store sells
SELECT COUNT(item) AS number_of_items
FROM Store_Items

--Answer: 15--

--- 2.) Order by the price of the item, from most to least expensive
SELECT item, price
FROM Store_Items
ORDER BY price DESC

--- 3.) What is the most expensive item?
SELECT TOP 1 item, max(price)
FROM Store_Items
GROUP BY item 
ORDER BY max(price) DESC

--Answer: PS4, £500--

--- 4) What are the top 5 most purchased item over the 2 months?
SELECT TOP 5 item, no_purchases_two_months
FROM Store_Items
ORDER BY no_purchases_two_months DESC

--Answer: Cards, Uno, monopoly, jenga, teddybear--


--- 5) What are the top 5 least purchased items over the two months?
SELECT TOP 5 item, no_purchases_two_months
FROM Store_Items
ORDER BY no_purchases_two_months ASC

--Answer: splashpad, waterballoons, waterpistolset, football, robot--


--- 6.) What is the sum of the number of items sold which are over £20?
SELECT SUM(no_purchases_two_months)
FROM Store_Items
WHERE price > 20

--Answer: 501 items--


--- 7.) What is the most popular item sold under the 'young child' category ?
SELECT TOP 1 item, no_purchases_two_months
FROM Store_Items
WHERE child_category = 'young child'
ORDER BY no_purchases_two_months DESC

--Answer: jenga, 255 items sold


--- 8.) Work out the total sales amount for each item
SELECT item, price * no_purchases_two_months AS total_sales_amount
FROM Store_Items
ORDER BY total_sales_amount DESC


--- The manager of the store said that the average number of purchases for any item over the two months (july and August) has been around 200 over the past 3 years 
--- 9.) Work out the percentage increase or decrease in number of purchases over the two months for each item compared to the average

WITH CTE_purchasepercentage AS
(SELECT item, no_purchases_two_months, (no_purchases_two_months - 200) AS purchase_change
FROM Store_Items
)
SELECT item, no_purchases_two_months, purchase_change, ROUND(purchase_change/200.0 * 100, 2) AS percentagechange
FROM CTE_purchasepercentage
ORDER BY no_purchases_two_months DESC

	
--- 10.) Categorise the items into 'most popular, semi-popular, not popular', where percentagechange greater than 10 = 'most popular', 
--- percentagechange less than 10 but greater than -80 = 'semi popular'
--- everything eles = 'not popular'

WITH CTE_purchase AS
(SELECT item, no_purchases_two_months, price, child_category, no_purchases_two_months - 200 AS purchase_change
FROM Store_Items
),

CTE_percentagechange AS (SELECT item, no_purchases_two_months, purchase_change, price, child_category, ROUND(purchase_change/200.0 * 100, 2) AS percentagechange
FROM CTE_purchase),

CTE_popularity AS (SELECT item, no_purchases_two_months, percentagechange, price, child_category,
CASE 
    WHEN percentagechange > 10 THEN 'most popular'
	WHEN percentagechange < 10 and percentagechange > -80 THEN 'semi popular'
	ELSE 'not popular' 
END AS popularity
FROM CTE_percentagechange
)

SELECT item, no_purchases_two_months, price, child_category, percentagechange, popularity
FROM CTE_popularity 
ORDER BY Percentagechange DESC
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------- CONCLUSIONS

-- The objective of this SQL project was to help a theoretical toy store manager identify which items were the 
-- most popular during the months of July and August in 2023. Additionally, the manager also wanted to identify how popular 
-- certain toys were during July and August of 2023 compared to the average number for any item sold during July and August from the past three summers (2020-2022).
-- The only items which have shown an increase in the number of purchases in 2023 compared to average are 'cards', 'uno', 'monopoly', 'jenga' and 'teddybear'.
-- The rest of the items show a decrease in the number of purchases compared to the average.
-- The most popular items are: 'cards', 'uno', 'monopoly', 'jenga' and 'teddybear',
-- while the least popular are, 'football', 'waterpistol', 'waterballoon' and 'splashpad'

-- The manager has mentioned that every summer, since he first opended, the 'least popular' items actually have the most number of sales.
-- This could be due to the fact that 2023 summer has had fewer sunny days compared to other summers, and more cloudy/rainy days. In addition, there was no 
-- heatwaves. Therefore, more people on average in 2023 summer would spend their time indoors rather than outdoors compared to previous summers. This would explain the
-- decreased sales of 'wet play' toys and increased sales of 'dry play' toys.









