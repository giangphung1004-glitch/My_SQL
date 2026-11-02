-- 1. Learning Objectives (Mục tiêu học tập)
/*
    Sử dụng các hàm tổng hợp: COUNT, SUM, AVG, MIN, MAX.
    Viết truy vấn GROUP BY theo nhiều cấp độ (Product, Date, Category).
    Lọc nhóm bằng HAVING.
*/ 

-- 2. ĐÁP ÁN BÀI TẬP VỀ NHÀ BUỔI 5

/* Đề bài 1:
Từ bảng DimEmployee, tính BaseRate trung bình của từng Title có trong công ty */ 

SELECT 
    Title,
    AVG(BaseRate) AS Avg_BaseRate
FROM dbo.DimEmployee
GROUP BY Title;

/* Đề bài 2: 
Từ bảng FactInternetSales, lấy ra cột TotalOrderQuantity, 
sử dụng cột OrderQuantity tính tổng số lượng bán ra với từng ProductKey và từng ngày OrderDate*/

SELECT 
    ProductKey,
    OrderDate,
    SUM(OrderQuantity) AS TotalOrderQuantity
FROM dbo.FactInternetSales
GROUP BY ProductKey, OrderDate;


/* Đề bài 3: 
Từ bảng DimProduct, FactInternetSales, DimProductCategory và các bảng liên quan nếu cần thiết
Lấy ra thông tin ngành hàng gồm: CategoryKey, EnglishCategoryName của các dòng thoả mãn điều kiện OrderDate trong năm 2012 và tính toán các cột sau đối với từng ngành hàng: 
- TotalRevenue sử dụng cột SalesAmount
- TotalCost sử dụng côt TotalProductCost
- TotalProfit được tính từ (TotalRevenue - TotalCost)
Chỉ hiển thị ra những bản ghi có TotalRevenue > 5000 */ 

SELECT 
    c.ProductCategoryKey,
    c.EnglishProductCategoryName,
    SUM(f.SalesAmount) AS TotalRevenue,
    SUM(f.TotalProductCost) AS TotalCost,
    SUM(f.SalesAmount - f.TotalProductCost) AS TotalProfit
FROM FactInternetSales AS f
LEFT JOIN DimProduct AS p
    ON f.ProductKey = p.ProductKey
LEFT JOIN DimProductSubcategory AS s
    ON p.ProductSubcategoryKey = s.ProductSubcategoryKey
LEFT JOIN DimProductCategory AS c
    ON s.ProductCategoryKey = c.ProductCategoryKey
WHERE YEAR(f.OrderDate) = 2012
GROUP BY 
    c.ProductCategoryKey,
    c.EnglishProductCategoryName
HAVING SUM(f.SalesAmount) > 5000;


/* Đề bài 4: 
Từ bảng FactInternetSale, DimProduct,
- Tạo ra cột Color_group từ cột Color, nếu Color là 'Black' hoặc 'Silver' 
gán giá trị 'Basic' cho cột Color_group, nếu không lấy nguyên giá trị cột Color sang
- Sau đó tính toán cột TotalRevenue từ cột SalesAmount đối với từng Color_group mới này */ 

SELECT 
    CASE 
        WHEN p.Color IN ('Black', 'Silver') THEN 'Basic'
        ELSE p.Color
    END AS Color_group,
    SUM(f.SalesAmount) AS TotalRevenue
FROM FactInternetSales AS f
JOIN DimProduct AS p
    ON f.ProductKey = p.ProductKey
GROUP BY 
    CASE 
        WHEN p.Color IN ('Black', 'Silver') THEN 'Basic'
        ELSE p.Color
    END;

/* Ex 5 (nâng cao) Từ bảng FactInternetSales, FactResellerSales và các bảng liên quan nếu cần, sử dụng cột SalesAmount tính toán doanh thu ứng với từng tháng của 2 kênh bán Internet và Reseller
Kết quả trả ra sẽ gồm các cột sau: Year, Month, InternSales, Reseller_Sales
Gợi ý: Tính doanh thu theo từng tháng ở mỗi bảng độc lập FactInternetSales và FactResllerSales bằng sử dụng CTE 
Lưu ý khi có nhiều hơn 1 CTE trong mệnh đề thì viết syntax như sau: 

WITH Name_CTE_1 AS (
SELECT statement
)
, Name_CTE_2 AS (
SELECT statement
) 

SELECT statement
*/ 

-- CTE tính doanh thu Internet theo từng tháng
WITH InternetSales AS (
    SELECT 
        YEAR(OrderDate) AS Year,
        MONTH(OrderDate) AS Month,
        SUM(SalesAmount) AS Internet_Sales
    FROM FactInternetSales
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
),
-- CTE tính doanh thu Reseller theo từng tháng
ResellerSales AS (
    SELECT 
        YEAR(OrderDate) AS Year,
        MONTH(OrderDate) AS Month,
        SUM(SalesAmount) AS Reseller_Sales
    FROM FactResellerSales
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
)

-- Gộp kết quả 2 nguồn
SELECT 
    ISNULL(i.Year, r.Year) AS Year,
    ISNULL(i.Month, r.Month) AS Month,
    i.Internet_Sales,
    r.Reseller_Sales
FROM InternetSales AS i
FULL OUTER JOIN ResellerSales AS r
    ON i.Year = r.Year AND i.Month = r.Month
ORDER BY Year, Month;



-- 3. Các lỗi sai thường gặp và cách xử lý
/* 
- Nhầm HAVING và WHERE
→ WHERE lọc dòng trước khi group và tính toán, HAVING lọc nhóm sau khi group và tính toán.
- Dùng INNER JOIN thay vì FULL JOIN trong Ex5 → mất dữ liệu ở một trong hai nguồn bán
- Tạo Color_group nhưng không GROUP BY lại chính CASE WHEN → lỗi SQL.
*/ 

