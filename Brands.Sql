--Qs 1. Create two Databases Name : Brands
CREATE DATABASE BRANDS
USE BRANDS

--Qs 2. Create two tables in SQL Server name as ITEMS_TABLE in Brands database
CREATE TABLE Items_Table (Item_Id int, Item_Description varchar(max),Vendor_Nos INT,Vendor_Name varchar(max),Bottle_Size INT,Bottle_Price int)

ALTER TABLE ITEMS_TABLE 
ALTER COLUMN Bottle_Price DECIMAL(6,2)

update Items_Table
set Bottle_Price = 9.77
where Item_Id = 1

--Qs --3. After Creating both the tables Add records in that tables(records are available in ITEMS_TABLE Sheet

INSERT INTO Items_Table VALUES(1, 'Travis Hasse Apple Pie', 305, 'Mhw Ltd', 750,9.77)

INSERT INTO Items_Table VALUES(2,'Daristi Xtabentun', 391, 'Anchor Distilling (preiss Imports)',750, 14.12),
(3, 'Hiram Walker Peach Brandy', 370, 'Pernod Ricard Usa/austin Nichols', 1000,	6.5),
(4,'Oak Cross Whisky', 305, 'Mhw Ltd', 750, 25.33),(5, 'Uv Red(cherry) Vodka', 380, 'Phillips Beverage Company',200, 1.97),
(6, 'Heaven Hill Old Style White Label', 259, 'Heaven Hill Distilleries Inc.', 750, 6.37),
(7, 'Hyde Herbal Liqueur', 194, 'Fire Tail Brands Llc', 750, 6.06), 
(8, 'Dupont Calvados Fine Reserve', 403, 'Robert Kacher Selections', 750, 23.61)

--Qs 5. Select all records from the Items table.
SELECT*FROM Items_Table

--Qs 6. Select the item_description and bottle_price for all items in the Items table.
SELECT item_description,bottle_price from items_table

--Qs 7. Find the item_description and bottle_price of items where bottle_price is greater than 20.
SELECT item_description,bottle_price
from Items_Table
WHERE Bottle_Price>20

--Qs 11. Find the item_description having the bottle size of 750
SELECT ITEM_DESCRIPTION FROM Items_Table WHERE Bottle_Size = 750

--Qs 12. Find the vendor Name having the vendor_nos 305 , 380 , 391
SELECT VENDOR_NAME FROM Items_Table WHERE Vendor_Nos IN (305,380,391)

--Qs 13. What is total Bottle_price
SELECT SUM(BOTTLE_PRICE) TotalBottlePrice from Items_Table

--Qs 14. Make Primary Key to Item_id
ALTER TABLE ITEMS_TABLE
ALTER COLUMN ITEM_ID INT NOT NULL

ALTER TABLE ITEMS_TABLE
ADD CONSTRAINT PK_ITEMS PRIMARY KEY(Item_Id)

--Qs 15. Which item id having the bottle_price of $ 5.06

SELECT ITEM_ID FROM Items_Table WHERE Bottle_Price = 5.06

------------------------------------------------------------------------------------------------------------------------------------------------
SELECT*FROM Items_Table
--Qs 1. Apply INNER , FULL OUTER , LEFT JOIN types on both the table
--a) INNER JOIN
SELECT I.ITEM_ID,I.ITEM_DESCRIPTION,P.PRODUCT,P.SALES
FROM BRANDS.DBO.Items_Table AS I
INNER JOIN PRODUCTS.dbo.Product_Table AS P
ON I.ITEM_ID = P.Product_ID

--b) FULL OUTER
SELECT I.ITEM_ID,I.ITEM_DESCRIPTION, P.PRODUCT, P.SALES
FROM BRANDS.DBO.Items_Table AS I
FULL OUTER JOIN PRODUCTS.DBO.PRODUCT_TABLE AS P
ON I.ITEM_ID = P.PRODUCT_ID

--c) LEFT JOIN
SELECT I.ITEM_ID,I.ITEM_DESCRIPTION,P.PRODUCT,P.SALES
FROM BRANDS.dbo.Items_Table AS I
LEFT JOIN PRODUCTS.dbo.Product_Table AS P
ON I.ITEM_ID = P.PRODUCT_ID

--Qs 3. Split the Item_description Column into Columns Item_desc1 and Item_desc2
SELECT ITEM_ID,ITEM_DESCRIPTION,
LEFT(ITEM_DESCRIPTION, CHARINDEX(' ', ITEM_DESCRIPTION + ' ')-1) AS ITEM_DESC1,
LTRIM(SUBSTRING (ITEM_DESCRIPTION, CHARINDEX(' ',ITEM_DESCRIPTION + ' '),LEN(ITEM_DESCRIPTION))) AS Item_desc2
FROM ITEMS_TABLE

--Qs 4. Find the top 3 most expensive items in the bottle_info table.
SELECT TOP 3 BOTTLE_PRICE FROM Items_Table
ORDER BY Bottle_Price DESC

--Qs 6. Find the vendor_name and item_description of items with a bottle_size of 750 and bottle_price less than 10.
SELECT VENDOR_NAME, ITEM_DESCRIPTION FROM Items_Table 
WHERE Bottle_Size = 750 AND Bottle_Price < 10

--Qs 11. List the item_description and vendor_name for items whose vendor_nos exists more than once in the bottle_info table.
SELECT ITEM_DESCRIPTION, VENDOR_NAME
FROM Items_Table
WHERE Vendor_Nos IN (
SELECT Vendor_Nos FROM Items_Table
GROUP BY Vendor_Nos
HAVING COUNT(*) > 1
)

------------------------------------------------------------------------------------------------------------------------------------------------

--Qs 1. Find the item_description and bottle_price of items that have the same vendor_name as items with Item_Id 1.
SELECT*FROM Items_Table

SELECT ITEM_DESCRIPTION, BOTTLE_PRICE FROM Items_Table
WHERE Vendor_Name = (
    SELECT VENDOR_NAME
    FROM Items_Table
    WHERE Item_Id = 1
)

--Qs 2. Create a stored procedure to retrieve all records from the bottle_info table where bottle_price is greater than a given value

CREATE PROCEDURE Get_Bottles_Above_Price
@MinPirce DECIMAL(10,2)
AS
BEGIN
SELECT*FROM Items_Table
WHERE Bottle_Price > @MinPirce
END

EXEC Get_Bottles_Above_Price @MinPirce = 12

--Qs 5. Write a query to find all item_description in the bottle_info table that contain the word "Whisky" regardless of case.

SELECT ITEM_DESCRIPTION FROM Items_Table
WHERE LOWER(Item_Description) like'%Whisky%'

--Qs 7. Write a query to join the bottle_info and product_sales tables on a common field (e.g., vendor_nos) and select relevant fields from both tables.

SELECT I.ITEM_ID, I.ITEM_DESCRIPTION, I.BOTTLE_SIZE, I.BOTTLE_PRICE,
P.PRODUCT_ID,P.PRODUCT,P.COUNTRY,P.SALES,P.PROFIT
FROM BRANDS.dbo.Items_Table I
INNER JOIN PRODUCTS.dbo.Product_Table P
ON LOWER(I.Item_Description) = LOWER(P.Product)

/* The question suggests joining on Vendor_Nos, but in the current structure, Vendor_Nos exists only in the Items_Table (bottle_info), and not in Product_Table (product_sales).
So a direct join isn't possible unless the schema is updated or a mapping table is provided */


--Qs 8. Write a query to combine item_description and vendor_name into a single string for each record in the bottle_info table, separated by a hyphen.

SELECT ITEM_ID, ITEM_DESCRIPTION, VENDOR_NAME,
ITEM_DESCRIPTION + ' _ ' + VENDOR_NAME AS COMBINED_INFO
FROM Items_Table

--Qs 9. Write a query to display the bottle_price rounded to one decimal place for each record in the bottle_info table.

SELECT ITEM_ID, ITEM_DESCRIPTION, BOTTLE_PRICE,
ROUND(BOTTLE_PRICE,1.0) AS rounded_BOTTLE_PRICE
FROM ITEMS_TABLE

