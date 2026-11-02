-- 1. Learning Objectives (Mục tiêu học tập)
/*
    Hiểu bản chất JOIN: INNER / LEFT / RIGHT / FULL.
    Thực hành JOIN nhiều bảng theo quan hệ PK–FK.
    Sử dụng CASE WHEN, IIF, phân loại theo điều kiện.
    Sử dụng UNION và UNION ALL, phân biệt khác nhau.
    Kết hợp JOIN + điều kiện lọc + logic để truy vấn đa bảng.
*/ 

-- 2. ĐÁP ÁN BÀI TẬP VỀ NHÀ BUỔI 3

/*Đề bài 1:
Từ bảng dbo.FactInternetSales và dbo.DimSalesTerritory
, lấy ra thông tin SalesOrderNumber, SalesOrderLineNumber, ProductKey, SalesTerritoryCountry 
của các bản ghi có SalesAmount trên 1000
*/

SELECT 
    f.SalesOrderNumber,
    f.SalesOrderLineNumber,
    f.ProductKey,
    t.SalesTerritoryCountry
FROM FactInternetSales AS f
LEFT JOIN DimSalesTerritory AS t
    ON f.SalesTerritoryKey = t.SalesTerritoryKey
WHERE f.SalesAmount > 1000;

/*Đề bài 2: 
Từ bảng dbo.DimProduct và dbo.DimProductSubcategory.
Lấy ra ProductKey, EnglishProductName và Color của các sản phẩm thoả mãn 
EnglishProductSubCategoryName chứa chữ 'Bikes' và ListPrice có phần nguyên là 3399
*/
SELECT 
    p.ProductKey,
    p.EnglishProductName,
    p.Color
FROM DimProduct AS p
LEFT JOIN DimProductSubcategory AS s
    ON p.ProductSubcategoryKey = s.ProductSubcategoryKey
WHERE s.EnglishProductSubCategoryName LIKE '%Bikes%'
  AND p.ListPrice >= 3399 AND ListPrice < 3400
--AND FLOOR(p.ListPrice) = 3399;
-- Hàm FLOOR(Number) giúp làm tròn xuống đối với số thập phân

/* Đề bài 3: 
Từ bảng dbo.DimPromotion, dbo.FactInternetSales, 
lấy ra ProductKey, SalesOrderNumber, SalesAmount từ các bản ghi thoả mãn DiscountPct >= 20% */

SELECT 
    f.ProductKey,
    f.SalesOrderNumber,
    f.SalesAmount
FROM FactInternetSales AS f
LEFT JOIN DimPromotion AS p
    ON f.PromotionKey = p.PromotionKey
WHERE p.DiscountPct >= 0.20;

/* Đề bài 4: 
Từ bảng dbo.DimCustomer, dbo.DimGeography, 
lấy ra cột Phone, FullName (kết hợp FirstName, MiddleName, LastName kèm khoảng cách ở giữa) 
và City của các khách hàng có YearlyInCome > 150000 và và đến từ CountryRegion là United States*/

SELECT 
    DC.Phone,
    DC.CustomerKey, 
    CONCAT_WS(' ', FirstName, Middle, LastName) as FullName
FROM dbo.DimCustomer AS DC 
LEFT JOIN dbo.DimGeography AS DG 
ON DC.GeographyKey = DG.GeographyKey
WHERE DC.YearlyIncome > 150000 AND DG.EnglishCountryRegionName = 'United States'
 

/* Đề bài 5: 
Từ bảng dbo.DimCustomer, lấy ra CustomerKey và thực hiện các yêu cầu sau: 
a. Tạo cột mới đặt tên là YearlyInComeRange từ các điều kiện sau: 
- Nếu YearlyIncome từ 0 đến 50000 thì gán giá trị "Low Income" 
- Nếu YearlyIncome từ 50001 đến 90000 thì gán giá trị "Middle Income" 
- Nếu YearlyIncome từ  90001 trở lên thì gán giá trị "High Income" 
b. Tạo cột mới đặt tên là AgeRange từ các điều kiện sau: 
- Nếu tuổi của Khách hàng tính đến 31/12/2019 đến 39 tuổi thì gán giá trị "Young Adults" 
- Nếu tuổi của Khách hàng tính đến 31/12/2019 từ 40 đến 59 tuổi thì gán giá trị "Middle-Aged Adults" 
- Nếu tuổi của Khách hàng tính đến 31/12/2019 lớn hơn 60 tuổi thì gán giá trị "Old Adults" 
 */

SELECT 
    CustomerKey,
    -- a. YearlyIncomeRange
    CASE 
        WHEN YearlyIncome BETWEEN 0 AND 50000 THEN 'Low Income'
        WHEN YearlyIncome BETWEEN 50001 AND 90000 THEN 'Middle Income'
        WHEN YearlyIncome >= 90001 THEN 'High Income'
    END AS YearlyIncomeRange,
    -- b. AgeRange
    CASE 
        WHEN DATEDIFF(year, BirthDate, '2019-12-31') BETWEEN 18 AND 39 THEN 'Young Adults'
        WHEN DATEDIFF(year, BirthDate, '2019-12-31') BETWEEN 40 AND 59 THEN 'Middle-Aged Adults'
        WHEN DATEDIFF(year, BirthDate, '2019-12-31') >= 60 THEN 'Old Adults'
    END AS AgeRange
FROM DimCustomer;

/* Đề bài 6: Từ bảng FactInternetSales, FactResellerSale và DimProduct. 
Tìm tất cả SalesOrderNumber có EnglishProductName chứa từ 'Road' và có màu vàng (Yellow) */

-- Cách 1
-- Internet Sales
SELECT 
    f.SalesOrderNumber
FROM FactInternetSales AS f
LEFT JOIN DimProduct AS p
    ON f.ProductKey = p.ProductKey
WHERE p.EnglishProductName LIKE '%Road%'
  AND p.Color = 'Yellow'

UNION

-- Reseller Sales
SELECT 
    r.SalesOrderNumber
FROM FactResellerSales AS r
LEFT JOIN DimProduct AS p
    ON r.ProductKey = p.ProductKey
WHERE p.EnglishProductName LIKE '%Road%'
  AND p.Color = 'Yellow';

-- Cách 2: 
-- UNION trước giữa 2 bảng Fact để gom tất cả order
WITH all_sales AS (
    SELECT SalesOrderNumber, ProductKey
    FROM FactInternetSales
    UNION
    SELECT SalesOrderNumber, ProductKey
    FROM FactResellerSales
)
-- JOIN 1 lần với DimProduct sau khi đã union
SELECT 
    a.SalesOrderNumber
FROM all_sales AS a
LEFT JOIN DimProduct AS p
    ON a.ProductKey = p.ProductKey
WHERE p.EnglishProductName LIKE '%Road%'
  AND p.Color = 'Yellow';



-- 3. Các lỗi sai thường gặp và cách xử lý
/* 
- Sai khi lấy phần nguyên ListPrice → phải dùng FLOOR(ListPrice) hoặc CAST(ListPrice AS INT).
- Dùng DiscountPct = 20 thay vì 0.20 → điều kiện sai đơn vị.
- Không dùng CONCAT_WS trong FullName khi MiddleName NULL → kết quả ra NULL.
- Quên UNION yêu cầu số lượng và kiểu dữ liệu các cột phải khớp.
- Nhầm UNION và UNION ALL (UNION loại duplicate row).
*/ 

