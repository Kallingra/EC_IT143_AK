/*****************************************************************************************************************
NAME:    EC_IT143_W3.4_AKE
PURPOSE: Craft SQL statements to answer user questions using the AdventureWorks sample database.

MODIFICATION LOG:
Ver      Date        Author        Description
-----   ----------   -----------   -------------------------------------------------------------------------------
1.0     07/26/2025   KALLINGRA       1. Built this script for EC IT143


RUNTIME: 
Xm Xs

NOTES: 
This is where I talk about what this script is, why I built it, and other stuff...
 
******************************************************************************************************************/

-- Q1 Business – Marginal complexity: Which five products have the highest list price?
-- Author: Patrick Kumbani
-- A1: This query returns the top 5 most expensive products from the Product table.

SELECT TOP 5 Name, ListPrice
FROM Production.Product
ORDER BY ListPrice DESC;

-- Q2 Business – Marginal complexity: How many employees are assigned to the 'Research and Development' department?
-- Author: Kendall David Navarro Sandoya
-- A2: The number of employees assigned to the 'Research and Development' department is 4. And this Query displays the number that I have named EmployeeCount.

SELECT COUNT(*) AS EmployeeCount
FROM HumanResources.Employee AS e
JOIN HumanResources.EmployeeDepartmentHistory AS edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department AS d ON edh.DepartmentID = d.DepartmentID
WHERE d.Name = 'Research and Development' AND edh.EndDate IS NULL;

-- Q3 Business – Moderate complexity:Which sales representatives have sold more than 50 orders, and what are their total sales amounts?
-- Author: Kendall David Navarro Sandoya
-- A3: This query identifies sales representatives who have completed more than 50 sales orders. 
--     It displays 14 personnes with their full names, the number of orders they have processed, and the total sales amount they generated.

SELECT p.FirstName + ' ' + p.LastName AS SalesRepName,
       COUNT(soh.SalesOrderID) AS OrdersCount,
       SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesPerson AS sp
JOIN HumanResources.Employee AS e ON sp.BusinessEntityID = e.BusinessEntityID
JOIN Person.Person AS p ON e.BusinessEntityID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader AS soh ON sp.BusinessEntityID = soh.SalesPersonID
GROUP BY p.FirstName, p.LastName
HAVING COUNT(soh.SalesOrderID) > 50;

-- Q4 Business – Moderate complexity: Which three vendors supplied the most products in 2013, and what are their total supplied quantities?
-- Author: Patrick Kumbani
-- A4:To display the three vendors supplied the most products in 2013, I used this Query below and It displayed 3 VendorName.

SELECT TOP 3 v.Name AS VendorName,
       SUM(pod.OrderQty) AS TotalQuantity
FROM Purchasing.PurchaseOrderHeader AS poh
JOIN Purchasing.PurchaseOrderDetail AS pod ON poh.PurchaseOrderID = pod.PurchaseOrderID
JOIN Purchasing.Vendor AS v ON poh.VendorID = v.BusinessEntityID
WHERE YEAR(poh.OrderDate) = 2013
GROUP BY v.Name
ORDER BY TotalQuantity DESC;

-- Q5 Business – Increased complexity:I want to analyze where our employees are located. Can you list employees with their names, addresses, and associated regions? I want this grouped by state/province.
-- Author: Me
-- A5: This query retrieves the full names of employees along with the cities and state/provinces they are located in.
--     It joins several tables to connect employee identities with their address data and groups the results by state/province for location analysis.

SELECT sp.Name AS StateProvince,
       a.City,
       p.FirstName + ' ' + p.LastName AS FullName
FROM Person.Person AS p
JOIN HumanResources.Employee AS e ON p.BusinessEntityID = e.BusinessEntityID
JOIN Person.BusinessEntityAddress AS bea ON e.BusinessEntityID = bea.BusinessEntityID
JOIN Person.Address AS a ON bea.AddressID = a.AddressID
JOIN Person.StateProvince AS sp ON a.StateProvinceID = sp.StateProvinceID
GROUP BY sp.Name, a.City, p.FirstName, p.LastName
ORDER BY sp.Name, a.City;

-- Q6 Business – Increased complexity: I'm analyzing sales of red-colored mountain bikes during summer 2012. Can you show total units sold, average price, and estimated profit per product?
-- Author: roni rolando ñahui bolivar
-- A6: This Query is disign to display sales of red-colored mountain bikes during summer 2012.
--     But No results are returned because no red mountain bikes were sold during the summer of 2012. If the color constraint were removed, or changed to 'Silver', valid data would appear.

SELECT p.Name,
       SUM(sod.OrderQty) AS TotalUnitsSold,
       AVG(sod.UnitPrice) AS AvgPrice,
       AVG(sod.UnitPrice - p.StandardCost) AS EstimatedProfitPerUnit
FROM Production.Product AS p
JOIN Sales.SalesOrderDetail AS sod ON p.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader AS soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE p.Color = 'Red'
  AND p.ProductSubcategoryID IN (
      SELECT ProductSubcategoryID FROM Production.ProductSubcategory WHERE Name LIKE '%Mountain%'
  )
  AND soh.OrderDate BETWEEN '2012-06-01' AND '2012-08-31'
GROUP BY p.Name;

-- Q7 Metadata – INFORMATION_SCHEMA: Which tables contain a column named BusinessEntityID?
-- Author: Me
-- A7: This Query below show 31 tables which contain a column named BusinessEntityID. Sometine its about Foreign Key.

SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'BusinessEntityID'
ORDER BY TABLE_SCHEMA, TABLE_NAME;

-- Q8 Metadata – INFORMATION_SCHEMA: What are the names, data types, and nullability of columns in the table "Person.Person"?
-- Author: roni rolando ñahui bolivar
-- A8: This Query displayed the names, data types, and nullability of columns in the table "Person.Person"

SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Person'
  AND TABLE_SCHEMA = 'Person';

SELECT GETDATE() AS my_date;