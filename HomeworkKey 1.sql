-- ĐÁP ÁN BÀI TẬP VỀ NHÀ BUỔI 1 

-- 1. Learning Objectives (Mục tiêu học tập)
/*
- Hiểu cấu trúc Server → Database → Schema → Table → Columns/Rows.
- Sử dụng câu lệnh SELECT để lấy dữ liệu và đặt alias.
- Dùng ORDER BY, DISTINCT, TOP để sắp xếp và giới hạn dữ liệu.
- Tạo cột mới bằng biểu thức trong SELECT.
- Làm quen với dataset AdventureWorksDW2019.
*/ 

-- 2. ĐÁP ÁN BÀI TẬP VỀ NHÀ BUỔI 1

/* Đề bài 1:
Từ bảng DimEmployee, lấy ra các cột:
    EmployeeKey
    FirstName
    LastName
    BaseRate
    VacationHours
    SickLeaveHours
Sau đó tạo thêm các cột:

a. FullName = FirstName + ' ' + LastName
b. VacationLeavePay = BaseRate * VacationHours
c. SickLeavePay = BaseRate * SickLeaveHours
d. TotalLeavePay = VacationLeavePay + SickLeavePay
*/ 

SELECT 
    EmployeeKey,
    FirstName,
    LastName,
    BaseRate,
    VacationHours,
    SickLeaveHours,
    CONCAT(FirstName, ' ', LastName) AS FullName,
    BaseRate * VacationHours AS VacationLeavePay,
    BaseRate * SickLeaveHours AS SickLeavePay,
    (BaseRate * VacationHours + BaseRate * SickLeaveHours) AS TotalLeavePay
FROM dbo.DimEmployee;

/* Đề bài 2:
Từ bảng FactInternetSales, lấy ra các cột:
    SalesOrderNumber
    ProductKey
    OrderDate
Sau đó tạo thêm các cột:
a. TotalRevenue = OrderQuantity * UnitPrice
b. TotalCost = ProductStandardCost + DiscountAmount
c. Profit = TotalRevenue - TotalCost
d. ProfitMargin = (Profit / TotalRevenue) * 100
*/ 

SELECT 
    SalesOrderNumber,
    ProductKey,
    OrderDate,
    OrderQuantity * UnitPrice AS TotalRevenue,
    ProductStandardCost + DiscountAmount AS TotalCost,
    (OrderQuantity * UnitPrice - (ProductStandardCost + DiscountAmount)) AS Profit,
    (
        (OrderQuantity * UnitPrice - (ProductStandardCost + DiscountAmount))
        / (OrderQuantity * UnitPrice)
    ) * 100 AS ProfitMargin
FROM dbo.FactInternetSales;


/* Đề bài:
Từ bảng FactProductInventory, lấy ra:
    MovementDate
    ProductKey
Tạo thêm:
a. NoProductEOD = UnitsBalance + UnitsIn - UnitsOut
b. TotalCost = NoProductEOD * UnitCost
*/ 

SELECT 
    MovementDate,
    ProductKey,
    UnitsBalance + UnitsIn - UnitsOut AS NoProductEOD,
    (UnitsBalance + UnitsIn - UnitsOut) * UnitCost AS TotalCost
FROM dbo.FactProductInventory;

/* 
Đề bài 4:
Từ bảng DimGeography, lấy các cột:
    EnglishCountryRegionName
    City
    StateProvinceName
Yêu cầu:
    Loại bỏ các dòng trùng lặp
    Sắp xếp tăng dần theo EnglishCountryRegionName
Với các dòng cùng Country → sắp xếp giảm dần theo City
*/ 

SELECT DISTINCT
    EnglishCountryRegionName,
    City,
    StateProvinceName
FROM dbo.DimGeography
ORDER BY 
    EnglishCountryRegionName ASC,
    City DESC;

/* 
Đề bài 5:
Từ bảng DimProduct, lấy ra các EnglishProductName thuộc top 10% sản phẩm 
có ListPrice cao nhất.
*/ 
SELECT TOP 10 PERCENT
    EnglishProductName,
    ListPrice
FROM dbo.DimProduct
ORDER BY ListPrice DESC;

-- 3. Các lỗi sai thường gặp và cách xử lý
/* 
    Nối chuỗi bằng + gây NULL khi FirstName hoặc LastName bị NULL → dùng CONCAT().
    Thiếu ngoặc khi tính Profit / Profit Margin, dẫn đến sai kết quả → luôn đặt ngoặc rõ ràng.
    Dùng SELECT * thay vì liệt kê cột theo yêu cầu đề.
    Nhầm TotalCost trong Ex2 (dùng UnitPrice thay vì ProductStandardCost) → đúng là ProductStandardCost + DiscountAmount.
    Quên DISTINCT trong Ex4 → dữ liệu lặp rất nhiều.
    Dùng TOP 10 thay vì TOP 10 PERCENT trong Ex5 → ra đúng 10 dòng thay vì 10%.
*/ 

