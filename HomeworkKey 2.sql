-- 1. Learning Objectives (Mục tiêu học tập)
/*
- Sử dụng thành thạo WHERE, AND, OR, NOT, IN, BETWEEN, LIKE, IS NULL.
- Sử dụng các hàm xử lý string, date, conversion (CAST/CONVERT).
- Lọc dữ liệu theo điều kiện dạng text, số, datetime.
- Áp dụng pattern lọc dữ liệu nhiều điều kiện kết hợp.
*/ 

-- 2. ĐÁP ÁN BÀI TẬP VỀ NHÀ BUỔI 2

/* Đề bài 1:
Từ bảng FactInternetSales, lấy tất cả bản ghi có:
    OrderDate ≥ '2011-01-01' và
    ShipDate trong năm 2011
*/ 
SELECT *
FROM FactInternetSales
WHERE OrderDate >= '2011-01-01'
  AND YEAR(ShipDate) = 2011;

/* Đề bài 2:
Từ bảng DimProduct, lấy các cột:
    ProductKey
    ProductAlternateKey
    EnglishProductName
Thỏa mãn:
ProductAlternateKey bắt đầu bằng 'BK-'
    Theo sau là 1 ký tự bất kỳ ngoại trừ T
    Kết thúc bằng 2 chữ số
    Color là ('Black', 'Red', 'White')
*/ 

SELECT 
    ProductKey,
    ProductAlternateKey,
    EnglishProductName
FROM DimProduct
WHERE ProductAlternateKey LIKE 'BK-[^T]%[0-9][0-9]'
  AND Color IN ('Black', 'Red', 'White');

/* Đề bài 3:
Từ DimProduct, lấy tất cả các sản phẩm có Color = 'Red'.
*/ 

SELECT *
FROM DimProduct
WHERE Color = 'Red';

/* 
Đề bài 4:
Từ FactInternetSales, lấy tất cả các bản ghi của các sản phẩm có Color = 'Red'.
Gợi ý: dùng IN kết hợp subquery.
*/ 

SELECT *
FROM FactInternetSales
WHERE ProductKey IN (
    SELECT ProductKey 
    FROM DimProduct
    WHERE Color = 'Red'
);

/* 
Đề bài 5:
Lấy EmployeeKey, FirstName, LastName, MiddleName của nhân viên:
    MiddleName không bị NULL
    Phone có độ dài 12 ký tự
*/ 
SELECT 
    EmployeeKey,
    FirstName,
    LastName,
    MiddleName
FROM DimEmployee
WHERE MiddleName IS NOT NULL
  AND LEN(Phone) = 12;

/* Đề bài 6: Từ bộ AdventureWorksDW2019, bảng DimEmployee, lấy ra danh sách các EmployeeKey
Sau đó lấy ra thêm các cột sau: 
a. Cột FullName được lấy ra từ kết hợp 3 trường FirstName, MiddleName và LastName, với dấu cách ngăn cách giữa các trường (sử dụng 2 cách: toán tử '+' và hàm, sau đó so sánh sự khác biệt) 
b. Cột AgeHired tính tuổi nhân viên tại thời điểm được tuyển, sử dụng cột HireDate và BirthDate
c. Cột AgeNow tính tuổi nhân viên đến thời điểm hiện tại, sử dụng cột BirthDate
d. Cột UserName được lấy ra từ phần đằng sau dấu "\" của cột LoginID 
(Ví dụ: LoginID = adventure-works\jun0, vậy Username tương ứng cần được lấy ra là jun0) 
*/ 

SELECT 
    EmployeeKey,
    FirstName,
    LastName,
    MiddleName,
    -- Ý 1: FullName với nhiều kỹ thuật
    /* Cách 1: Dùng ISNULL bao phủ trường MiddleName */
    ISNULL(FirstName + ' ' + MiddleName + ' ' + LastName, 
           FirstName + ' ' + LastName) AS FullName_isnull,
    /* Cách 2: Dùng ISNULL cho chuỗi chèn vào */
    FirstName + ISNULL(' ' + MiddleName + ' ', ' ') + LastName 
        AS FullName_Isnull,
    /* Cách 3: Dùng CONCAT_WS - tự động bỏ NULL */
    CONCAT_WS(' ', FirstName, MiddleName, LastName) AS FullName_concatws,
    HireDate,
    BirthDate,
    -- Ý 2: Age khi được tuyển
    DATEDIFF(year, BirthDate, HireDate) AS Age_hired,
    -- Ý 3: Age hiện tại
    DATEDIFF(year, BirthDate, CURRENT_TIMESTAMP) AS Age_today,
    LoginID,
    -- Ý 4: Tách Username bằng nhiều kỹ thuật
    -- Cách 1: SUBSTRING + CHARINDEX
    SUBSTRING(LoginID, CHARINDEX('\', LoginID) + 1, LEN(LoginID)) 
        AS UserName_substring_dynamic,
    -- Cách 2: RIGHT + CHARINDEX
    RIGHT(LoginID, LEN(LoginID) - CHARINDEX('\', LoginID)) 
        AS UserName_right_dynamic
FROM dbo.DimEmployee;



-- 3. Các lỗi sai thường gặp và cách xử lý
/* 
⦁	Dùng LIKE sai pattern → đặc biệt là [ ^T ] để loại trừ ký tự T.
⦁	Nhầm _ và %:
    _ thay thế đúng 1 ký tự
    % thay thế 0+ ký tự
⦁	MiddleName NULL → FullName ra NULL nếu dùng + → phải dùng ISNULL hoặc CONCAT_WS, không nên dùng CONCAT hoặc toán tử + 
⦁	Tính tuổi bằng phép trừ ngày → sai → phải dùng DATEDIFF(year, …).
⦁	Sai điều kiện lọc năm ShipDate → dùng MONTH thay vì YEAR.
⦁	Tách Username sai vì dùng SUBSTRING cố định độ dài → phải dùng CHARINDEX.
⦁	Quên Color IN ('Black','Red','White') trong Ex2.
⦁	Quên điều kiện MiddleName IS NOT NULL khiến các cách FullName bị NULL chuỗi.
*/ 

