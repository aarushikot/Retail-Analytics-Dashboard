USE mm_team04_02;

# 1. The query provides visibility into workforce distribution across stores by presenting employee counts alongside store identifiers and location details. 
# This information is instrumental in understanding staffing patterns and identifying stores with the highest employee presence, offering valuable insights for store management and resource allocation decisions in retail operations.
SELECT 
    s.STORE_ID,
    s.ZIP_CODE,
    s.STATE,
    COUNT(*) AS EMPLOYEE_COUNT
FROM 
    employee e
JOIN 
    store s ON e.STORE_ID = s.STORE_ID
GROUP BY 
    s.STORE_ID, s.ZIP_CODE, s.STATE
ORDER BY 
    EMPLOYEE_COUNT DESC;


# 2: The query fetches supplier information alongside the products they provide, establishing connections between supplier IDs in the 'supplier' table and corresponding product entries. 
# By incorporating supplier addresses, it enriches procurement analysis, offering valuable insights into supplier distribution and optimizing product sourcing strategies for retail analytics.

SELECT s.SUPPLIER_ID, s.SUPPLIER_NAME, s.ADDRESS AS SUPPLIER_ADDRESS, p.PRODUCT_NAME, p.PRODUCT_ID
FROM supplier s
JOIN product p ON s.SUPPLIER_ID = p.SUPPLIER_ID;


# 3: The SQL query extracts vital product details such as ID, name, and category, alongside store IDs and ZIP codes. By incorporating store location information, it enriches the retail analytics dashboard, providing valuable insights into product distribution across various store locations. 
# This data aids in optimizing inventory management and refining product placement strategies, ultimately enhancing sales performance analysis.
SELECT 
    p.PRODUCT_ID, 
    p.PRODUCT_NAME, 
    p.CATEGORY, 
    w.STORE_ID,
    s.ZIP_CODE
FROM 
    product p
JOIN 
    warehouse w ON p.PRODUCT_ID = w.PRODUCT_ID
JOIN 
    store s ON w.STORE_ID = s.STORE_ID;


# 4. The query aggregates key financial indicators like total sales, gross profit, expenses, and net profit per store, providing a overall view of financial performance. 
# By incorporating store identifiers, ZIP codes, and states, it offers geographical insights that can inform strategic decisions and enable performance benchmarking within the realm of retail analytics.
SELECT 
    st.STORE_ID,
    st.ZIP_CODE,
    st.STATE,
    SUM(s.TOTAL_AMOUNT) AS TOTAL_SALES_AMOUNT,
    SUM(p.GROSS_PROFIT) AS TOTAL_GROSS_PROFIT,
    SUM(p.TOTAL_EXPENSES) AS TOTAL_EXPENSES,
    SUM(p.NET_PROFIT) AS TOTAL_NET_PROFIT
FROM 
    sales s
JOIN 
    store st ON s.STORE_ID = st.STORE_ID
JOIN 
    profitability p ON p.STORE_ID = st.STORE_ID
GROUP BY 
    st.STORE_ID, st.ZIP_CODE, st.STATE;

    

# 5. The query retrieves the store IDs, ZIP codes, and states along with the highest net profit and average gross profit for each store, facilitating analysis of store performance based on profitability metrics. 
# It offers insights into the financial health of stores across different geographic locations in the retail analytics dashboard.
SELECT 
    s.STORE_ID,
    s.ZIP_CODE,
    s.STATE,
    MAX(p.NET_PROFIT) AS HIGHEST_NET_PROFIT,
    AVG(p.GROSS_PROFIT) AS AVERAGE_GROSS_PROFIT
FROM 
    profitability p
JOIN 
    store s ON p.STORE_ID = s.STORE_ID
GROUP BY 
    s.STORE_ID, s.ZIP_CODE, s.STATE
ORDER BY 
    HIGHEST_NET_PROFIT DESC;

    
# 6. The query provides insights into the distribution of products across different categories in the warehouse. 
# By calculating the total quantity and total cost of products for each category, it facilitates inventory management and analysis for retail operations. 
# This information aids in optimizing stock levels, identifying high-demand categories, and evaluating the cost-effectiveness of storing various product types. 
SELECT 
    p.CATEGORY,
    SUM(w.WAREHOUSE_QUANTITY) AS TOTAL_QUANTITY,
    SUM(w.WAREHOUSE_QUANTITY * p.COST_PRICE) AS TOTAL_COST_OF_MATERIAL_IN_WAREHOUSE
FROM
    product p
        JOIN
    warehouse w ON p.PRODUCT_ID = w.PRODUCT_ID
GROUP BY p.CATEGORY
ORDER BY TOTAL_QUANTITY DESC;

    
# 7. The SQL query retrieves information about the most senior employees in each store based on their hire dates. 
# By identifying employees with the earliest hire dates within each store, the query assists in recognizing long-standing staff members and understanding the workforce's tenure distribution across different store locations. 
# This information is valuable for assessing employee retention, recognizing experienced personnel, and identifying potential candidates for leadership roles within the organization.
SELECT 
    e.STORE_ID,
    e.EMPLOYEE_ID,
    e.EMP_NAME,
    e.POSITION,
    e.EMAIL,
    e.PHONE_NUMBER,
    e.HIRE_DATE
FROM 
    employee e
JOIN 
    (
        SELECT 
            STORE_ID,
            MIN(HIRE_DATE) AS SENIOR_DATE
        FROM 
            employee
        GROUP BY 
            STORE_ID
    ) AS t ON e.STORE_ID = t.STORE_ID AND e.HIRE_DATE = t.SENIOR_DATE;
    
# 8: The query retrieves product details along with their average ratings and the number of feedback entries, facilitating the identification of popular products based on customer feedback. 
# By sorting the results by average rating and the number of feedback entries, retail analytics can gain insights into product performance and customer satisfaction, aiding in product optimization and marketing strategies. 
SELECT 
    p.PRODUCT_ID,
    p.PRODUCT_NAME,
    p.CATEGORY,
    AVG(f.RATING) AS AVERAGE_RATING,
    COUNT(f.RATING) AS NUM_FEEDBACK
FROM 
    product p
LEFT JOIN 
    feedback f ON p.PRODUCT_ID = f.PRODUCT_ID
GROUP BY 
    p.PRODUCT_ID, p.PRODUCT_NAME, p.CATEGORY
ORDER BY 
    AVERAGE_RATING DESC, NUM_FEEDBACK DESC;

# 9. The query offers a comprehensive analysis of product performance within the retail analytics dashboard. By combining feedback count, average rating, and total quantity available for each product, retailers gain valuable insights into customer satisfaction, product popularity, and inventory management. 
# This information enables data-driven decision-making to optimize product offerings, enhance customer experience, and maximize sales potential

SELECT 
    p.PRODUCT_ID,
    p.PRODUCT_NAME,
    p.CATEGORY,
    COUNT(f.PRODUCT_ID) AS FEEDBACK_COUNT,
    AVG(f.RATING) AS AVERAGE_RATING,
    SUM(p.QUANTITY) AS TOTAL_QUANTITY_AVAILABLE
FROM 
    product p
LEFT JOIN 
    feedback f ON p.PRODUCT_ID = f.PRODUCT_ID
GROUP BY 
    p.PRODUCT_ID, p.PRODUCT_NAME, p.CATEGORY
ORDER BY 
    FEEDBACK_COUNT DESC;




# 10. The query provides a comprehensive overview of sales performance for each store in a given month within the specified time period. 
# By aggregating sales data and calculating average total sales amounts, it enables stakeholders to analyze store-level sales trends and identify potential areas for improvement or optimization in the retail analytics dashboard.

SELECT
    st.STORE_ID,
    st.ZIP_CODE,
    st.STATE,
    DATE_FORMAT(s.SALES_DATE, '%m-%Y') AS Month,
    COUNT(*) AS TotalSalesCount,
    AVG(s.TOTAL_AMOUNT) AS AvgTotalSalesAmount
FROM
    sales s
JOIN
    store st ON s.STORE_ID = st.STORE_ID
GROUP BY
    st.STORE_ID,
    st.ZIP_CODE,
    st.STATE,
    Month
ORDER BY
    st.STORE_ID,
    Month;

# Stored Procedure 
DELIMITER //

CREATE DEFINER=`mm_team04_02`@`%` PROCEDURE `GetFeedbackByCategory`(IN category_name VARCHAR(255))
BEGIN
    SELECT p.PRODUCT_NAME, AVG(f.RATING) AS AVERAGE_RATING, COUNT(f.COMMENTS) AS COMMENT_COUNT
    FROM product p
    LEFT JOIN feedback f ON p.PRODUCT_ID = f.PRODUCT_ID
    WHERE p.CATEGORY = category_name
    GROUP BY p.PRODUCT_NAME;
END//

DELIMITER ;

# Testing
CALL GetFeedbackByCategory ('Electronics');
CALL GetFeedbackByCategory ('Beverages');