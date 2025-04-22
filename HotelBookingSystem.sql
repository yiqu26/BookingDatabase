-- 飯店訂房系統資料庫設計（精簡版）
-- SQL Server版本

-- 創建資料庫
CREATE DATABASE HotelBookingSystem;
GO

USE HotelBookingSystem;
GO

-- 1. 房型表
CREATE TABLE RoomType (
    RoomTypeID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    BasePrice DECIMAL(10,2) NOT NULL,
    MaxOccupancy INT NOT NULL,
    BedConfiguration NVARCHAR(100) NOT NULL,
    RoomSize NVARCHAR(50),
    Amenities NVARCHAR(500), -- 使用逗號分隔的設施清單
    MainImageURL NVARCHAR(255),
    IsActive BIT NOT NULL DEFAULT 1
);

-- 2. 房間表
CREATE TABLE Room (
    RoomID INT PRIMARY KEY IDENTITY(1,1),
    RoomTypeID INT NOT NULL,
    RoomNumber NVARCHAR(20) NOT NULL UNIQUE,
    Floor NVARCHAR(10) NOT NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Available', -- Available, Occupied, Maintenance, Cleaning
    Notes NVARCHAR(255),
    FOREIGN KEY (RoomTypeID) REFERENCES RoomType(RoomTypeID)
);

-- 3. 用戶表
CREATE TABLE [User] (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Email NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20),
    Address NVARCHAR(255),
    City NVARCHAR(50),
    PostalCode NVARCHAR(20),
    UserType NVARCHAR(20) NOT NULL DEFAULT 'Customer', -- Customer, Admin, Staff
    RegistrationDate DATETIME NOT NULL DEFAULT GETDATE(),
    LastLoginDate DATETIME,
    IsActive BIT NOT NULL DEFAULT 1,
    CONSTRAINT UQ_User_Email UNIQUE (Email)
);

-- 4. 價格方案表
CREATE TABLE PricePlan (
    PricePlanID INT PRIMARY KEY IDENTITY(1,1),
    RoomTypeID INT NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    ValidFrom DATE NOT NULL,
    ValidTo DATE NOT NULL,
    DayOfWeekBitmask INT NOT NULL DEFAULT 127, -- 1=周一, 2=周二, 4=周三, 8=周四, 16=周五, 32=周六, 64=周日
    Price DECIMAL(10,2) NOT NULL,
    IsBreakfastIncluded BIT NOT NULL DEFAULT 0,
    IsRefundable BIT NOT NULL DEFAULT 1,
    MinStayLength INT DEFAULT 1,
    IsActive BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (RoomTypeID) REFERENCES RoomType(RoomTypeID),
    CONSTRAINT CHK_PricePlan_Dates CHECK (ValidTo >= ValidFrom)
);

-- 5. 促銷活動表
CREATE TABLE Promotion (
    PromotionID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    DiscountType NVARCHAR(20) NOT NULL, -- Percentage, FixedAmount
    DiscountValue DECIMAL(10,2) NOT NULL,
    ValidFrom DATETIME NOT NULL,
    ValidTo DATETIME NOT NULL,
    PromotionCode NVARCHAR(20) UNIQUE,
    MinimumStay INT,
    MinimumAmount DECIMAL(10,2),
    ApplicableRoomTypes NVARCHAR(255), -- CSV of RoomTypeIDs or NULL for all
    MaxUsageCount INT,
    CurrentUsageCount INT NOT NULL DEFAULT 0,
    IsActive BIT NOT NULL DEFAULT 1,
    CONSTRAINT CHK_Promotion_Dates CHECK (ValidTo >= ValidFrom)
);

-- 6. 預訂表
CREATE TABLE Booking (
    BookingID INT PRIMARY KEY IDENTITY(1,1),
    BookingReference NVARCHAR(20) NOT NULL UNIQUE,
    UserID INT NOT NULL,
    BookingDate DATETIME NOT NULL DEFAULT GETDATE(),
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    AdultCount INT NOT NULL,
    ChildCount INT NOT NULL DEFAULT 0,
    TotalAmount DECIMAL(10,2) NOT NULL,
    DiscountAmount DECIMAL(10,2) NOT NULL DEFAULT 0,
    TaxAmount DECIMAL(10,2) NOT NULL DEFAULT 0,
    FinalAmount DECIMAL(10,2) NOT NULL,
    BookingStatus NVARCHAR(20) NOT NULL DEFAULT 'Confirmed', -- Reserved, Confirmed, Checked In, Checked Out, Cancelled, No-Show
    PromotionID INT,
    PaymentStatus NVARCHAR(20) NOT NULL DEFAULT 'Pending', -- Pending, Partially Paid, Paid, Refunded
    PaymentMethod NVARCHAR(50), -- CreditCard, DebitCard, BankTransfer, Cash
    PaymentDate DATETIME,
    SpecialRequests NVARCHAR(500),
    FOREIGN KEY (UserID) REFERENCES [User](UserID),
    FOREIGN KEY (PromotionID) REFERENCES Promotion(PromotionID),
    CONSTRAINT CHK_Booking_Dates CHECK (CheckOutDate > CheckInDate)
);

-- 7. 預訂明細表
CREATE TABLE BookingDetail (
    BookingDetailID INT PRIMARY KEY IDENTITY(1,1),
    BookingID INT NOT NULL,
    RoomID INT NOT NULL,
    PricePlanID INT NOT NULL,
    DailyRate DECIMAL(10,2) NOT NULL,
    TaxRate DECIMAL(5,2) NOT NULL DEFAULT 0,
    TotalAmount DECIMAL(10,2) NOT NULL,
    GuestName NVARCHAR(100),
    Status NVARCHAR(20) NOT NULL DEFAULT 'Confirmed', -- Confirmed, Cancelled
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID),
    FOREIGN KEY (RoomID) REFERENCES Room(RoomID),
    FOREIGN KEY (PricePlanID) REFERENCES PricePlan(PricePlanID)
);

-- 8. 房間維護與清潔記錄表
CREATE TABLE RoomMaintenance (
    MaintenanceID INT PRIMARY KEY IDENTITY(1,1),
    RoomID INT NOT NULL,
    MaintenanceType NVARCHAR(20) NOT NULL, -- Cleaning, Repair, Inspection
    RequestedByUserID INT,
    AssignedToUserID INT,
    RequestDate DATETIME NOT NULL DEFAULT GETDATE(),
    ScheduledDate DATETIME,
    CompletionDate DATETIME,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Requested', -- Requested, Scheduled, In Progress, Completed, Verified
    Notes NVARCHAR(500),
    FOREIGN KEY (RoomID) REFERENCES Room(RoomID),
    FOREIGN KEY (RequestedByUserID) REFERENCES [User](UserID),
    FOREIGN KEY (AssignedToUserID) REFERENCES [User](UserID)
);

-- 9. 評價表
CREATE TABLE Review (
    ReviewID INT PRIMARY KEY IDENTITY(1,1),
    BookingID INT NOT NULL UNIQUE,
    UserID INT NOT NULL,
    Rating DECIMAL(3,1) NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Title NVARCHAR(100),
    Content NVARCHAR(MAX),
    ReviewDate DATETIME NOT NULL DEFAULT GETDATE(),
    CleanlinessRating DECIMAL(3,1) CHECK (CleanlinessRating BETWEEN 1 AND 5),
    ServiceRating DECIMAL(3,1) CHECK (ServiceRating BETWEEN 1 AND 5),
    ValueRating DECIMAL(3,1) CHECK (ValueRating BETWEEN 1 AND 5),
    IsPublished BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID),
    FOREIGN KEY (UserID) REFERENCES [User](UserID)
);

-- 10. 系統設定表
CREATE TABLE SystemSettings (
    SettingID INT PRIMARY KEY IDENTITY(1,1),
    SettingKey NVARCHAR(50) NOT NULL UNIQUE,
    SettingValue NVARCHAR(MAX),
    SettingDescription NVARCHAR(255),
    LastUpdated DATETIME NOT NULL DEFAULT GETDATE(),
    UpdatedByUserID INT,
    FOREIGN KEY (UpdatedByUserID) REFERENCES [User](UserID)
);

-- 插入基本系統設定
INSERT INTO SystemSettings (SettingKey, SettingValue, SettingDescription)
VALUES 
('HotelName', '豪華大飯店', '飯店名稱'),
('HotelAddress', '台北市中山區中山北路100號', '飯店地址'),
('HotelPhone', '02-25554444', '聯絡電話'),
('HotelEmail', 'info@luxuryhotel.com', '聯絡信箱'),
('CheckInTime', '15:00', '標準入住時間'),
('CheckOutTime', '12:00', '標準退房時間'),
('TaxRate', '5', '稅率百分比'),
('CancellationPolicy', '入住前24小時可免費取消，之後將收取一晚房費作為取消費用。', '取消政策'),
('WebsiteURL', 'www.luxuryhotel.com', '官方網站'); 