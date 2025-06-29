--Qs 1. Create two Databases Name: Products

CREATE DATABASE PRODUCTS
USE PRODUCTS

--Qs 2. Create two tables in SQL Server name as ITEMS_TABLEin PRODUCT_TABLE in Products database.

CREATE TABLE Product_Table (Product_ID INT,	Country VARCHAR(max), Product VARCHAR(MAX), Units_Sold DECIMAL(6,2), Manufacturing_Price INT, Sale_Price int, Sales int, Gross_Sales INT, COGS INT, Profit INT, [DATE] DATE, Month_Number INT,	Month_Name VARCHAR(MAX), [YEAR] INT)

--3. After Creating both the tables Add records in that tables(records are available in PRODUCTS_TABLE Sheet)

INSERT INTO Product_Table VALUES(1, 'Canada','Carretera',1685.3,3,20,33706,33706,16185,16185,'01/01/2014',1,'January',2014)
INSERT INTO Product_Table VALUES(2,'Germany','Carretera',1321,3,20,26420,26420,13210,13210,'01/01/2014',1,'January',2015),
(3,'France','Carretera',2173,3,15,32595,32595,21780,21780,'06/01/2014',6,'June',2016),
(4,'Germany','Carretera',888,3,15,13320,13320,8880,8880,'06/01/2014',6,'June',2017),
(5,'Mexico','Carretera',2470,3,15,37050,37050,24700,24700,'06/01/2014',6,'June',2018),
(6,'Germany','Carretera',1513,3,350,529550,529550,393380,393380,'12/01/2014',12,'December',2019),
(7,'Germany','Montana',921,5,15,13815,13815,9210,9210,'03/01/2014',3,'March',2020),
(8,'Canada','Montana',2518,5,12,30216,30216,7554,7554,'06/01/2014',6,'June',2021)
INSERT INTO Product_Table VALUES(5,'Mexico','Carretera',2470,3,15,37050,37050,24700,24700,'06/01/2014',6,'June',2018)
INSERT INTO Product_Table VALUES(4,'Germany','Carretera',888,3,15,13320,13320,8880,8880,'06/01/2014',6,'June',2017)

SELECT*FROM Product_Table

/*--Qs 4. Delete those product having the Units Sold 1618.5 , 888 and 2470*/
DELETE Product_Table
WHERE Units_Sold IN (1618.5,888,2470)

--Qs 8. Select Unique Country from the product_sales table
SELECT distinct country from Product_Table

--Qs 9. Count the number of Countries in the product_sales table
SELECT COUNT(Country) TotalCountry FROM Product_Table

--Qs 10. How Many Countries are there which contain the sales price between 10 to 20
SELECT COUNT(DISTINCT country) TotalCountry from Product_Table WHERE Sale_Price BETWEEN 10 and 20

------------------------------------------------------------------------------------------------------------------------------------------------

--Qs 1. Find the Total Sale Price and Gross Sales

select SUM(sale_price) TotalSaelesPrice, SUM(Gross_Sales) TotalGrossSales from PRODUCT_TABLE

--Qs 2. In which year we have got the highest sales

select TOP 1 [YEAR], SUM(SALE_PRICE) TotalSaelesPrice from Product_Table
GROUP BY [YEAR]
ORDER BY TotalSaelesPrice DESC

--Qs 3. Which Product having the sales of $ 37,050.00

SELECT PRODUCT FROM Product_Table WHERE Sales = 37050

--Qs 4. Which Countries lies between profit of $ 4,605 to $ 22 , 662.00

SELECT DISTINCT COUNTRY FROM Product_Table WHERE Profit BETWEEN 4605 AND 22662

--Qs 5. Which Product Id having the sales of $ 24,700.00

SELECT Product_ID FROM Product_Table WHERE Sales = 24700

--Qs 6. Find the total Units Sold for each Country.

SELECT COUNTRY, SUM(Units_Sold) TotalUnitsSold FROM Product_Table GROUP BY COUNTRY

--Qs 7. Find the average sales for each country

SELECT COUNTRY, AVG(Sales) AverageSales FROM Product_Table GROUP by Country

--Qs 8. Retrieve all products sold in 2014

SELECT PRODUCT FROM Product_Table WHERE [YEAR] = 2014

--Qs 9. Find the maximum Profit in the product_sales table.

SELECT MAX(PROFIT) MaxProductSales from Product_Table

--Qs. 10. Retrieve the records from product_sales where Profit is greater than the average Profit of all records.

SELECT*FROM Product_Table
WHERE Profit > (
    SELECT AVG(Profit) FROM Product_Table
)

------------------------------------------------------------------------------------------------------------------------------------------------

--Qs 1. Apply INNER , FULL OUTER , LEFT JOIN types on both the table
--a) INNER JOIN
SELECT P.PRODUCT_ID,P.SALES,I.ITEM_ID,I.ITEM_DESCRIPTION
FROM PRODUCTS.dbo.Product_Table AS P
INNER JOIN BRANDS.dbo.Items_Table AS I
ON P.Product_ID = I.Item_Id

--b) LEFT JOIN
SELECT P.PRODUCT_ID,P.SALES,I.ITEM_ID,I.ITEM_DESCRIPTION
FROM PRODUCTS.dbo.Product_Table AS P
LEFT JOIN BRANDS.dbo.Items_Table AS I
ON P.Product_ID = I.Item_Id

--c) FULL OUTER JOIN
SELECT P.PRODUCT_ID,P.SALES,I.ITEM_ID,I.ITEM_DESCRIPTION
FROM PRODUCTS.dbo.Product_Table AS P
FULL OUTER JOIN BRANDS.dbo.Items_Table AS I
ON P.Product_ID = I.Item_Id

--Qs 2. Find the item_description and Product having the gross sales of 13,320.00

SELECT I.ITEM_DESCRIPTION,P.PRODUCT
FROM PRODUCTS.dbo.Product_Table AS P
INNER JOIN BRANDS.dbo.Items_Table AS I
ON P.Product_ID = I.Item_Id
WHERE Gross_Sales = 13320

-- Qs 5. Find the total Gross Sales and Profit for each Product in each

SELECT PRODUCT,COUNTRY, SUM(GROSS_SALES) AS TotalGrossSales,
SUM(PROFIT) AS TotalProfit FROM Product_Table
GROUP BY PRODUCT, Country

--7. Find the Product with the highest Profit in 2019.

SELECT TOP 1 PRODUCT,PROFIT
FROM Product_Table
WHERE [YEAR] = 2019
ORDER BY Profit DESC

--Qs 8. Retrieve the Product_Id and Country of all records where the Profit is at least twice the COGS

SELECT PRODUCT_ID, COUNTRY FROM Product_Table
WHERE Profit > 2*COGS

--Qs 9. Find the Country that had the highest total Gross Sales in 2018

SELECT TOP 1 COUNTRY,
SUM(Gross_Sales) AS TotalGrossSales
 FROM Product_Table
 WHERE [YEAR] = 2018
 GROUP BY Country
 ORDER BY TotalGrossSales DESC

--Qs 10. Calculate the total Sales for each Month Name across all years.

SELECT MONTH_NAME, SUM(SALES) AS TotalSales
FROM Product_Table
GROUP BY Month_Name
ORDER BY TotalSales DESC

/* Qs 12. Find the average Manufacturing Price for Product in each 
Country and only include those Country and Product combinations where the average is above 3 */
SELECT COUNTRY,PRODUCT,
AVG(MANUFACTURING_PRICE) AS AVG_MANUFACTURING_PRICE
FROM Product_Table
GROUP BY Country, Product
HAVING AVG([MANUFACTURING_PRICE]) > 3

------------------------------------------------------------------------------------------------------------------------------------------------

--Qs 3.Create a stored procedure to insert a new record into the product_sales table.

CREATE PROCEDURE INSERT_PRODUCT_SALE
@Product_ID INT,@Country VARCHAR(max), @Product VARCHAR(max), @Units_Sold DECIMAL(8,2), @Manufacturing_Price INT, @Sale_Price INT, 
@Sales INT, @Gross_Sales INT, @COGS INT, @Profit INT, @Date DATE, @Month_Number INT,@Month_Name VARCHAR(max), @Year INT
AS
BEGIN
INSERT INTO Product_Table (Product_ID , Country , Product , Units_Sold , Manufacturing_Price , Sale_Price,
Sales , Gross_Sales , COGS , Profit , [Date] , Month_Number ,Month_Name , [Year] )
VALUES
(@Product_ID ,@Country , @Product , @Units_Sold , @Manufacturing_Price , @Sale_Price , 
@Sales , @Gross_Sales , @COGS , @Profit , @Date , @Month_Number ,@Month_Name , @Year )
END

EXEC INSERT_PRODUCT_SALE @Product_ID = 9 ,@Country = 'INDIA' , @Product = 'BlueBerry' , @Units_Sold = 1150.50, @Manufacturing_Price = 4, @Sale_Price = 15, 
@Sales = 25000 , @Gross_Sales = 23015 , @COGS = 11500, @Profit = 11510, @Date = '2024-06-01', @Month_Number = 6 ,@Month_Name = 'June', @Year = 2024

SELECT*FROM Product_Table

--Qs 4. Create a trigger to automatically update the Gross_Sales field in the product_sales table whenever Units_Sold or Sale_Price is updated.

CREATE TRIGGER TRG_UPDATE_Gross_Sales
ON PRODUCT_TABLE
AFTER UPDATE
AS
BEGIN
UPDATE PT
SET GROSS_SALES = PT.Units_Sold * PT.SALE_PRICE
FROM Product_Table PT
INNER JOIN inserted I ON PT.Product_ID = I.Product_ID
WHERE I.Units_Sold IS NOT NULL OR I.Sale_Price IS NOT NULL
END

UPDATE Product_Table
SET Units_Sold = 600
WHERE Product_ID = 9

SELECT*FROM Product_Table

--Qs 6. Write a query to find the Country and Product where the Profit is greater than the average Profit of all products.
SELECT COUNTRY,PRODUCT,PROFIT FROM Product_Table
WHERE Profit > (
SELECT AVG(Profit) FROM Product_Table
)

--Qs 10. Write a query to calculate the number of days between the current date and the Date field for each record in the product_sales table.
SELECT PRODUCT, PRODUCT_ID, [DATE],
DATEDIFF(DAY, [DATE], GETDATE()) AS DAYS_BETWEEN_TODAY_AND_SALE
FROM Product_Table