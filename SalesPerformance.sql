---Cleaning column 1 Item_Fat_Content 
UPDATE blinkit_data
SET Item_Fat_Content = 
    CASE 
        WHEN LOWER(TRIM(Item_Fat_Content)) IN ('lf', 'low fat') THEN 'Low Fat'
        WHEN LOWER(TRIM(Item_Fat_Content)) = 'reg' THEN 'Regular'
        ELSE Item_Fat_Content
    END;

---Part 1: Total sales
SELECT CAST(SUM(Total_Sales) / 1000000.0 AS DECIMAL(10,2)) AS Total_Sales_Million
FROM blinkit_data

---Average Sales
SELECT CAST(AVG(Total_sales)AS INT) AS Avg_sales
FROM blinkit_data

---Number of Items
SELECT COUNT(*) AS No_of_Orders
FROM blinkit_data

---Average Rating
SELECT CAST (AVG(Rating) AS DECIMAL(10,1)) AS Avg_Rating
FROM blinkit_data

---Part 2: Zoom in Analysis
---Total sales by Fat Content
SELECT item_fat_content, 
		CAST(SUM(Total_sales) AS DECIMAL (10,2)) AS Total_sales
FROM public.blinkit_data
GROUP BY(item_fat_content) ORDER BY Total_sales DESC

---Total Sales by Item Type
SELECT item_type,
		CAST(SUM(Total_sales) AS DECIMAL (10,2)) AS Total_sales
FROM public.blinkit_data
GROUP BY (item_type) ORDER BY Total_sales DESC

---Fat content by Outlet for Total Sales Overview
SELECT 
    outlet_location_type,
    COALESCE(SUM(total_sales) FILTER (WHERE item_fat_content = 'Low Fat'), 0) AS low_fat,
    COALESCE(SUM(total_sales) FILTER (WHERE item_fat_content = 'Regular'), 0) AS regular
FROM blinkit_data
GROUP BY outlet_location_type
ORDER BY outlet_location_type

---Fat Content by Outlet for Total Sales detail
SELECT outlet_location_type, item_fat_content,
		CAST(SUM(Total_sales) AS DECIMAL (10,2)) AS Total_sales,
		CAST(AVG(Total_sales) AS DECIMAL (10,2)) AS Avg_sales,
		COUNT (*) AS Number_of_Items,
		CAST(AVG(Rating) AS DECIMAL (3,2)) AS Avg_Rating
FROM public.blinkit_data
GROUP BY outlet_location_type,item_fat_content ORDER BY Total_sales DESC

---Total Sales by Outlet Establishment
SELECT outlet_establishment_year,
		CAST(SUM(Total_sales) AS DECIMAL (10,2)) AS Total_sales
FROM public.blinkit_data
GROUP BY outlet_establishment_year ORDER BY Total_sales DESC

---Percentage of Sales by Outlet Size
SELECT outlet_size,
		CAST(SUM(Total_sales) AS DECIMAL (10,2)) AS Total_sales,
		CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM public.blinkit_data
GROUP BY outlet_size ORDER BY Total_sales DESC

---Sales by Outlet Location
SELECT outlet_location_type,
		CAST(SUM(Total_sales) AS DECIMAL (10,2)) AS Total_sales
FROM public.blinkit_data
GROUP BY outlet_location_type ORDER BY Total_sales DESC

---All metrics by Outlet Type
SELECT Outlet_Type, 
CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
		CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS Avg_Sales,
		COUNT(*) AS No_Of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating,
		CAST(AVG(Item_Visibility) AS DECIMAL(10,2)) AS Item_Visibility
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC

---Rating Distribution
SELECT 
    CASE 
        WHEN rating >= 4 THEN 'High (4-5)'
        WHEN rating BETWEEN 3 AND 3.9 THEN 'Medium (3-3.9)'
        ELSE 'Low (0-2.9)'
    END AS Rating_Category,
    COUNT(*) AS Number_of_Orders,
    CAST(AVG(total_sales) AS DECIMAL(10,2)) AS Avg_Sales
FROM blinkit_data
GROUP BY Rating_Category
ORDER BY Rating_Category

---Rating vs Item Type 
SELECT 
    item_type,
    COUNT(*) AS Number_of_Items,
    CAST(AVG(rating) AS DECIMAL(3,2)) AS Avg_Rating,
    CAST(AVG(total_sales) AS DECIMAL(10,2)) AS Avg_Sales
FROM blinkit_data
GROUP BY item_type
ORDER BY Avg_Rating DESC

---Sales vs Rating Correlation
---To infer satisfaction-driven sales:
SELECT 
    ROUND(rating, 1) AS Rating,
    COUNT(*) AS Orders,
    CAST(AVG(total_sales) AS DECIMAL(10,2)) AS Avg_Sales
FROM blinkit_data
GROUP BY ROUND(rating, 1)
ORDER BY Rating DESC

---Low Rating Outliers
SELECT 
    item_identifier, item_type, rating, total_sales
FROM blinkit_data
WHERE rating < 2.5
ORDER BY rating ASC, total_sales DESC
LIMIT 10

----THE END
