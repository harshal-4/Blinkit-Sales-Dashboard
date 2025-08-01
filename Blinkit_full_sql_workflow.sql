-- ==========================================================================
-- FMCG Retail Sales Dashboard - SQL Workflow
-- Author: Harshal Patil
-- Description: This script performs data cleaning and generates KPIs and 
-- segmented insights for a Tableau dashboard using a mock BLinkit dataset.
-- ==========================================================================

--  View the Raw Data
SELECT * FROM blinkit.blinkit_data;

--  Data Cleaning: Standardize 'Item_Fat_Content'
SET SQL_SAFE_UPDATES = 0;

UPDATE blinkit.blinkit_data
SET item_fat_content =
  CASE
    WHEN item_fat_content IN ('LF', 'low fat') THEN 'Low Fat'
    WHEN item_fat_content = 'reg' THEN 'Regular'
    ELSE item_fat_content
  END;

-- ==========================================================================
-- KPI Calculations
-- ==========================================================================

--  Total Sales (in Millions)
SELECT CAST(SUM(sales) / 100000 AS DECIMAL(5,2)) AS total_sales_millions
FROM blinkit.blinkit_data;

-- Average Sales per Item
SELECT CAST(AVG(sales) AS DECIMAL(5,1)) AS avg_sales
FROM blinkit.blinkit_data;

--  Total Number of Items
SELECT COUNT(*) AS total_items
FROM blinkit.blinkit_data;

--  Average Rating
SELECT CAST(AVG(rating) AS DECIMAL(2,1)) AS avg_rating
FROM blinkit.blinkit_data;

-- ==========================================================================
--  Segment Analysis
-- ==========================================================================

--  By Fat Content
SELECT 
  item_fat_content, 
  CAST(SUM(sales) / 100000 AS DECIMAL(5,2)) AS total_sales_millions,
  CAST(AVG(sales) AS DECIMAL(5,1)) AS avg_sales,
  COUNT(*) AS total_items,
  CAST(AVG(rating) AS DECIMAL(2,1)) AS avg_rating
FROM blinkit.blinkit_data
GROUP BY item_fat_content
ORDER BY total_sales_millions DESC;

--  By Item Type
SELECT 
  item_type, 
  CAST(SUM(sales) / 100000 AS DECIMAL(5,2)) AS total_sales_millions,
  CAST(AVG(sales) AS DECIMAL(5,1)) AS avg_sales,
  COUNT(*) AS total_items,
  CAST(AVG(rating) AS DECIMAL(2,1)) AS avg_rating
FROM blinkit.blinkit_data
GROUP BY item_type
ORDER BY total_sales_millions DESC;

--  By Outlet Establishment Year
SELECT 
  outlet_establishment_year,
  CAST(SUM(sales) / 100000 AS DECIMAL(5,2)) AS total_sales_millions,
  CAST(AVG(sales) AS DECIMAL(5,1)) AS avg_sales,
  COUNT(*) AS total_items,
  CAST(AVG(rating) AS DECIMAL(2,1)) AS avg_rating
FROM blinkit.blinkit_data
GROUP BY outlet_establishment_year
ORDER BY outlet_establishment_year;

-- ==========================================================================
--  Chart-Specific Queries for Tableau
-- ==========================================================================

-- Sales by Outlet Size
SELECT 
  outlet_size,
  CAST(SUM(sales) AS DECIMAL(10,2)) AS total_sales,
  CAST((SUM(sales) * 100.0 / SUM(SUM(sales)) OVER()) AS DECIMAL(10,2)) AS perc_sales
FROM blinkit.blinkit_data
GROUP BY outlet_size
ORDER BY perc_sales DESC;

-- Sales by Outlet Location Type
SELECT 
  outlet_location_type,
  CAST(SUM(sales) / 100000 AS DECIMAL(5,2)) AS total_sales_millions,
  CAST(AVG(sales) AS DECIMAL(5,1)) AS avg_sales,
  COUNT(*) AS total_items,
  CAST(AVG(rating) AS DECIMAL(2,1)) AS avg_rating
FROM blinkit.blinkit_data
GROUP BY outlet_location_type
ORDER BY outlet_location_type;

-- Repeat: Sales by Item Type (again, for chart mapping)
SELECT 
  item_type,
  CAST(SUM(sales) / 100000 AS DECIMAL(5,2)) AS total_sales_millions,
  CAST(AVG(sales) AS DECIMAL(5,1)) AS avg_sales,
  COUNT(*) AS total_items,
  CAST(AVG(rating) AS DECIMAL(2,1)) AS avg_rating
FROM blinkit.blinkit_data
GROUP BY item_type
ORDER BY total_sales_millions DESC;
