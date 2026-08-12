-- Câu 1: Dựa và bảng FactInternetSales 

-- Tính tổng số lượng sản phẩm (OrderQuantity) đã được bán cho mỗi khách hàng (CustomerKey). Hiển thị kết quả theo thứ tự giảm dần của tổng số lượng. 

-- Your code here 

USE AdventureWorksDW2019 

SELECT CustomerKey 

    , Sum(OrderQuantity) AS TotalQuantity 

FROM dbo.FactInternetSales 

GROUP BY CustomerKey 

ORDER BY Sum(OrderQuantity) DESC 

 

 

-- Câu 2: Dựa vào bảng FactInternetSales và DimProduct 

-- Thống kê tổng số lượng sản phẩm được bán (TotalOrderQuantity) cho mỗi sản phẩm (EnglishProductName). Hiển thị kết quả theo thứ tự giảm dần của TotalOrderQuantity. 

-- Your code here 

 

SELECT DP.EnglishProductName 

, Sum(FIS.OrderQuantity) AS TotalOrderQuantity 

FROM dbo.FactInternetSales AS FIS 

LEFT JOIN dbo.DimProduct AS DP  

ON DP.ProductKey = FIS.ProductKey 

GROUP BY DP.EnglishProductName 

ORDER BY Sum(FIS.OrderQuantity) DESC 

 

-- Câu 3: Dựa vào bảng FactInternetSales, DimCustomer, tạo ra trường FullName từ (FirstName, MiddleName, LastName và sử dụng dấu cách ' ' để ghép nối)   

- và thống kê số lượng đơn đặt hàng (OrderCount) mà họ đã thực hiện trong năm 2014. Và chỉ lấy những khách hàng có ít nhất 2 đơn đặt hàng.  

-- Your code here 

 

WITH CustomerOrders AS ( 

    SELECT  

        DC.CustomerKey, 

        DC.FirstName, 

        DC.MiddleName, 

        DC.LastName, 

        COUNT(DISTINCT FIS.SalesOrderNumber) AS OrderCount 

    FROM dbo.FactInternetSales AS FIS 

    LEFT JOIN dbo.DimCustomer AS DC  

ON FIS.CustomerKey = DC.CustomerKey 

    WHERE YEAR(FIS.OrderDate) = 2014 

    GROUP BY DC.CustomerKey, DC.FirstName, DC.MiddleName, DC.LastName) 

SELECT  

    FirstName + ISNULL(' ' + MiddleName + ' ', ' ') + LastName AS FullName, 

    OrderCount 

FROM CustomerOrders 

WHERE OrderCount >= 2 

 

 

-- Câu 4:  

-- Từ bảng DimProduct, DimProductSubCategory, DimProductCategory và FactInternetSales 

- Viết truy vấn lấy ra EnglishProductCategoryName, TotalAmount (tính theo SaleAmount) của 2 danh mục có doanh thu cao nhất trong năm 2014 

-- Your code here 

SELECT TOP 2 DPC.EnglishProductCategoryName 

    , SUM(FIS.SalesAmount) AS TotalAmount 

FROM dbo.FactInternetSales AS FIS 

LEFT JOIN dbo.DimProduct AS DP ON FIS.ProductKey = DP.ProductKey 

LEFT JOIN dbo.DimProductSubcategory AS DPS ON DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey 

LEFT JOIN dbo.DimProductCategory AS DPC ON DPS.ProductCategoryKey = DPC.ProductCategoryKey 

WHERE YEAR(FIS.OrderDate) = 2014 

GROUP BY DPC.EnglishProductCategoryName 

ORDER BY SUM(FIS.SalesAmount) DESC 

 

 

-- Câu 5: Từ bảng FactInternetSale và bảng FactResellerSale, 

-- thực hiện từ 2 nguồn bán là Internet và Reseller đưa ra tất cả tất cả các SaleOrderNumber và doanh thu của mỗi SaleOrderNumber 

-- Your code here 

 

SELECT  

    FIS.SalesOrderNumber, 

    SUM(FIS.SalesAmount) AS TotalRevenue, 

    'Internet' AS SaleSource 

FROM dbo.FactInternetSales AS FIS 

GROUP BY FIS.SalesOrderNumber 

UNION ALL 

SELECT  

    FRS.SalesOrderNumber, 

    SUM(FRS.SalesAmount) AS TotalRevenue, 

    'Reseller' AS SaleSource 

FROM dbo.FactResellerSales AS FRS 

GROUP BY FRS.SalesOrderNumber 

 

-- Câu 6: Dựa vào 2 bảng DimDepartmentGroup và bảng FactFinace, thực hiện lấy ra TotalAmount (dựa vào Amount) của DepartmentGroupName và ParentDepartmentGroupName 

-- Your code here 

 

SELECT DPG.DepartmentGroupName 

 , ParentDPG.DepartmentGroupName AS ParentDepartmentGroupName 

, SUM(FF.Amount) AS TotalAmount 

FROM dbo.FactFinance AS FF 

LEFT JOIN DimDepartmentGroup AS DPG  

ON FF.DepartmentGroupKey = DPG.DepartmentGroupKey 

LEFT JOIN DimDepartmentGroup AS ParentDPG  

ON DPG.ParentDepartmentGroupKey = ParentDPG.DepartmentGroupKey 

GROUP BY DPG.DepartmentGroupName, ParentDPG.DepartmentGroupName 