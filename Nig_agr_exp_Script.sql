-- Examine the data
SELECT 
    * 
FROM 
    nigeria_agricultural_exports;

--Standardized column names ; unit_price and Profit_per_unit
EXEC sp_rename 'nigeria_agricultural_exports.unit_price', 'Unit_Price', 'COLUMN';
EXEC sp_rename 'nigeria_agricultural_exports.Profit_per_unit', 'Profit_Per_Unit', 'COLUMN';


-- Find the top selling product 
SELECT 
    Product_Name, SUM(Units_Sold) as Total_Units 
FROM 
    nigeria_agricultural_exports
GROUP BY 
    Product_Name
ORDER BY 
    Total_Units desc;

--Which company has the highest sales revenue?
SELECT 
    Company, 
    ROUND(SUM(Units_Sold * Profit_Per_Unit),2) as Total_Revenue
FROM 
    nigeria_agricultural_exports
GROUP BY 
    Company
ORDER BY 
    Total_Revenue DESC;

--How do sales vary across different countries 
-- Product sales 
SELECT 
    Export_Country, SUM(Units_Sold) AS Total_Units_Sold
FROM 
    nigeria_agricultural_exports
GROUP BY 
    Export_Country
ORDER BY 
    Total_Units_Sold DESC;

--Average revenue per country 
SELECT 
    Export_Country, ROUND(SUM(Units_Sold * unit_price),2 ) AS Total_Revenue
FROM 
    nigeria_agricultural_exports
GROUP BY 
    Export_Country
ORDER BY 
    Total_Revenue DESC;

--Total units sold
SELECT 
    SUM(Units_Sold) as Total_Units_Sold
FROM 
    nigeria_agricultural_exports

--Cost analysis 
-- What is the cost of goods sold as a percentage of revenue
SELECT
    Product_Name, (COGS/Revenue) * 100 as Percentage_cost
FROM(

SELECT
    Product_Name, 
    SUM(Unit_Price * Units_Sold) as COGS, 
    SUM((Units_Sold * Unit_Price ) + Profit_Per_Unit) AS Revenue
FROM 
    nigeria_agricultural_exports
GROUP BY 
    Product_Name
) as sub;

--How does the COGS vary across different products
SELECT
    Product_Name,
    SUM(Unit_Price * Units_Sold) as COGS
FROM
    nigeria_agricultural_exports
GROUP BY 
    Product_Name
ORDER BY 
    COGS DESC;

--Which port(s) recieve the highest volume of exports
SELECT 
    Destination_Port, 
    SUM(Units_Sold) as Total_Units_Sold
FROM 
    nigeria_agricultural_exports
GROUP BY 
    Destination_Port
ORDER BY 
    Total_Units_Sold DESC;

--Common transportation modes used for export
SELECT 
    Transportation_Mode
FROM 
    nigeria_agricultural_exports
GROUP BY 
    Transportation_Mode;

-- Rank the destination ports by their export value
SELECT 
    Destination_Port, 
    SUM(Export_Value) AS Total_Export
FROM 
    nigeria_agricultural_exports
GROUP BY 
    Destination_Port
ORDER BY 
    Total_Export DESC;

-- Top export product for each port
SELECT
    nae.Destination_Port, 
    nae.Product_Name, 
    nae.Export_Value
FROM 
    nigeria_agricultural_exports AS nae
INNER JOIN (
    SELECT 
        Destination_Port, 
        MAX(Export_Value) AS Max_Export_Value
    FROM 
        nigeria_agricultural_exports
    GROUP BY 
        Destination_Port
) AS Max_export ON nae.Destination_Port = Max_export.Destination_Port 
            AND nae.Export_Value = Max_export.Max_Export_Value;



