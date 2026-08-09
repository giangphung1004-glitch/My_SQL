-- ĐÁP ÁN BÀI TẬP VỀ NHÀ BUỔI 4

-- 1. Learning Objectives (Mục tiêu học tập)
/*
    Hiểu sâu bản chất của JOIN và các loại JOIN
    Thực hành JOIN nhiều hơn 2 bảng
    Thực hành self join dự vào mối quan hệ parent-child tồn tại trong bảng
*/ 

-- 2. ĐÁP ÁN BÀI TẬP VỀ NHÀ BUỔI 4

/*Đề bài 1: 
Từ các bảng dbo.DimProduct, dbo.DimPromotion, dbo.FactInternetSales, 
lấy ra ProductKey, EnglishProductName của các dòng thoả mãn Discount Pct >= 20% */

SELECT 
    p.ProductKey,
    p.EnglishProductName
FROM FactInternetSales AS f
LEFT JOIN DimPromotion AS pr
    ON f.PromotionKey = pr.PromotionKey
LEFT JOIN DimProduct AS p
    ON f.ProductKey = p.ProductKey
WHERE pr.DiscountPct >= 0.20;

/*Đề bài 2: 
Từ các bảng DimProduct, DimProductSubcategory, DimProductCategory, 
lấy ra các cột Product key, EnglishProductName, EnglishProductSubCategoryName, EnglishProductCategoryName 
của sản phẩm thoả mãn điều kiện EnglishProductCategoryName là 'Clothing' */
	 
SELECT 
    p.ProductKey,
    p.EnglishProductName,
    s.EnglishProductSubCategoryName,
    c.EnglishProductCategoryName
FROM DimProduct AS p
LEFT JOIN DimProductSubcategory AS s
    ON p.ProductSubcategoryKey = s.ProductSubcategoryKey
LEFT JOIN DimProductCategory AS c
    ON s.ProductCategoryKey = c.ProductCategoryKey
WHERE c.EnglishProductCategoryName = 'Clothing';


/*Đề bài 3: 
Từ bảng FactInternetSales và DimProduct, lấy ra ProductKey, EnglishProductName, ListPrice 
của những sản phẩm chưa từng được bán. Sử dụng 2 cách: toán tử IN và phép JOIN */

-- Cách 1: Dùng NOT IN và Subquery 
SELECT 
    ProductKey,
    EnglishProductName,
    ListPrice
FROM DimProduct
WHERE ProductKey NOT IN (
    SELECT DISTINCT ProductKey
    FROM FactInternetSales
);

-- Cách 2: LEFT JOIN + WHERE IS NULL
SELECT 
    p.ProductKey,
    p.EnglishProductName,
    p.ListPrice
FROM DimProduct AS p
LEFT JOIN FactInternetSales AS f
    ON p.ProductKey = f.ProductKey
WHERE f.SalesOrderNumber IS NULL;

	
/*Đề bài 4: 
Từ bảng DimDepartmentGroup, lấy ra thông tin 
DepartmentGroupKey, DepartmentGroupName, ParentDepartmentGroupKey 
và thực hiện self-join lấy ra ParentDepartmentGroupName */

SELECT 
    child.DepartmentGroupKey,
    child.DepartmentGroupName,
    child.ParentDepartmentGroupKey,
    parent.DepartmentGroupName AS ParentDepartmentGroupName
FROM DimDepartmentGroup AS child
LEFT JOIN DimDepartmentGroup AS parent
    ON child.ParentDepartmentGroupKey = parent.DepartmentGroupKey;


/*Đề bài 5: 
Từ bảng FactFinance, DimOrganization, DimScenario, 
lấy ra OrganizationKey, OrganizationName, Parent OrganizationKey, 
và thực hiện self-join lấy ra Parent OrganizationName, Amount 
thoả mãn điều kiện ScenarioName là 'Actual'. */

SELECT 
    o.OrganizationKey,
    o.OrganizationName,
    parent.OrganizationName AS ParentOrganizationName,
    f.Amount
FROM FactFinance AS f
LEFT JOIN DimOrganization AS o
    ON f.OrganizationKey = o.OrganizationKey
LEFT JOIN DimOrganization AS parent
    ON o.ParentOrganizationKey = parent.OrganizationKey
LEFT JOIN DimScenario AS s
    ON f.ScenarioKey = s.ScenarioKey
WHERE s.ScenarioName = 'Actual';


-- 3. Các lỗi sai thường gặp và cách xử lý
/* 
- Self join sai điều kiện do không hiểu bản chất
- Chưa áp dụng được đa dạng được các loại JOIN nên không lấy ra được các sản phẩm chưa bao giờ bán ở bài 3
- Lựa chọn thứ tự JOIN chưa chính xác khi JOIN nhiều điều kiện
*/ 

