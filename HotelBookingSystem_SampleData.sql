-- 飯店訂房系統示範資料（精簡版）
-- 使用SQL Server

USE HotelBookingSystem;
GO

-- 1. 插入房型資料
INSERT INTO RoomType (Name, Description, BasePrice, MaxOccupancy, BedConfiguration, RoomSize, Amenities, MainImageURL)
VALUES 
('豪華單人房', '豪華單人房，提供單人床及現代化設施', 3500.00, 1, '一張單人床', '25平方公尺', '空調,電視,冰箱,保險箱,淋浴,吹風機,熱水壺,書桌', '/images/rooms/deluxe-single.jpg'),
('豪華雙人房', '豪華雙人房，提供雙人床及現代化設施', 4500.00, 2, '一張雙人床', '30平方公尺', '空調,電視,冰箱,保險箱,浴缸,淋浴,吹風機,熱水壺,書桌', '/images/rooms/deluxe-double.jpg'),
('豪華家庭房', '豪華家庭房，適合家庭入住', 6000.00, 4, '一張雙人床及兩張單人床', '45平方公尺', '空調,電視,冰箱,保險箱,浴缸,淋浴,吹風機,熱水壺,咖啡機,書桌', '/images/rooms/family-room.jpg'),
('總統套房', '頂級總統套房，提供最高級的住宿體驗', 15000.00, 2, '一張特大雙人床', '75平方公尺', '空調,電視,冰箱,保險箱,浴缸,淋浴,吹風機,熱水壺,咖啡機,書桌,客廳,小廚房,私人按摩浴缸', '/images/rooms/presidential-suite.jpg'),
('海景單人房', '可眺望美麗海景的單人房', 3000.00, 1, '一張單人床', '22平方公尺', '空調,電視,冰箱,淋浴,吹風機,熱水壺,書桌,陽台', '/images/rooms/sea-view-single.jpg'),
('海景雙人房', '可眺望美麗海景的雙人房', 4000.00, 2, '一張雙人床', '28平方公尺', '空調,電視,冰箱,保險箱,淋浴,吹風機,熱水壺,書桌,陽台', '/images/rooms/sea-view-double.jpg'),
('標準單人房', '舒適的標準單人房', 2500.00, 1, '一張單人床', '20平方公尺', '空調,電視,淋浴,吹風機,熱水壺,書桌', '/images/rooms/standard-single.jpg'),
('標準雙人房', '舒適的標準雙人房', 3200.00, 2, '兩張單人床', '25平方公尺', '空調,電視,冰箱,淋浴,吹風機,熱水壺,書桌', '/images/rooms/standard-double.jpg');

-- 2. 插入房間資料
INSERT INTO Room (RoomTypeID, RoomNumber, Floor, Status)
VALUES 
-- 豪華單人房
(1, '301', '3', 'Available'),
(1, '302', '3', 'Available'),
-- 豪華雙人房
(2, '303', '3', 'Available'),
(2, '304', '3', 'Occupied'),
-- 豪華家庭房
(3, '501', '5', 'Available'),
(3, '502', '5', 'Maintenance'),
-- 總統套房
(4, '701', '7', 'Available'),
-- 海景單人房
(5, '201', '2', 'Available'),
(5, '202', '2', 'Available'),
-- 海景雙人房
(6, '205', '2', 'Occupied'),
(6, '206', '2', 'Available'),
-- 標準單人房
(7, '101', '1', 'Available'),
(7, '102', '1', 'Cleaning'),
-- 標準雙人房
(8, '105', '1', 'Available'),
(8, '106', '1', 'Available');

-- 3. 插入用戶資料
INSERT INTO [User] (Email, PasswordHash, FirstName, LastName, Phone, Address, City, PostalCode, UserType, IsActive)
VALUES 
('admin@example.com', 'hashed_password_1', '管理員', '王', '0911111111', '台北市中正區忠孝東路100號', '台北市', '10048', 'Admin', 1),
('staff@example.com', 'hashed_password_2', '員工', '李', '0922222222', '台北市大安區復興南路50號', '台北市', '10665', 'Staff', 1),
('user1@example.com', 'hashed_password_3', '小明', '張', '0933333333', '台北市松山區南京東路200號', '台北市', '10550', 'Customer', 1),
('user2@example.com', 'hashed_password_4', '小花', '陳', '0944444444', '台中市西區美村路100號', '台中市', '40360', 'Customer', 1),
('user3@example.com', 'hashed_password_5', '小華', '林', '0955555555', '高雄市左營區博愛路200號', '高雄市', '81368', 'Customer', 1);

-- 4. 插入價格方案資料
INSERT INTO PricePlan (RoomTypeID, Name, ValidFrom, ValidTo, DayOfWeekBitmask, Price, IsBreakfastIncluded, IsRefundable, MinStayLength)
VALUES 
-- 豪華單人房
(1, '標準價', '2023-01-01', '2023-12-31', 31, 3500.00, 1, 1, 1), -- 週一到週五
(1, '週末價', '2023-01-01', '2023-12-31', 96, 4000.00, 1, 1, 1), -- 週六、週日
-- 豪華雙人房
(2, '標準價', '2023-01-01', '2023-12-31', 31, 4500.00, 1, 1, 1), -- 週一到週五
(2, '週末價', '2023-01-01', '2023-12-31', 96, 5000.00, 1, 1, 1), -- 週六、週日
-- 豪華家庭房
(3, '標準價', '2023-01-01', '2023-12-31', 127, 6000.00, 1, 1, 1), -- 全週
-- 總統套房
(4, '標準價', '2023-01-01', '2023-12-31', 127, 15000.00, 1, 1, 1), -- 全週
-- 海景單人房
(5, '標準價', '2023-01-01', '2023-12-31', 31, 3000.00, 1, 1, 1), -- 週一到週五
(5, '週末價', '2023-01-01', '2023-12-31', 96, 3500.00, 1, 1, 1), -- 週六、週日
-- 海景雙人房
(6, '標準價', '2023-01-01', '2023-12-31', 31, 4000.00, 1, 1, 1), -- 週一到週五
(6, '週末價', '2023-01-01', '2023-12-31', 96, 4500.00, 1, 1, 1), -- 週六、週日
-- 標準單人房
(7, '標準價', '2023-01-01', '2023-12-31', 127, 2500.00, 0, 1, 1), -- 全週
-- 標準雙人房
(8, '標準價', '2023-01-01', '2023-12-31', 127, 3200.00, 0, 1, 1); -- 全週

-- 5. 插入促銷活動資料
INSERT INTO Promotion (Name, Description, DiscountType, DiscountValue, ValidFrom, ValidTo, PromotionCode, MinimumStay, IsActive)
VALUES 
('早鳥優惠', '提前30天預訂可享有85折優惠', 'Percentage', 15.00, '2023-01-01', '2023-12-31', 'EARLY', 1, 1),
('長住優惠', '連續住宿3晚以上可享有9折優惠', 'Percentage', 10.00, '2023-01-01', '2023-12-31', 'LONGSTAY', 3, 1),
('週年慶特惠', '飯店週年慶特別優惠', 'Percentage', 20.00, '2023-06-01', '2023-06-30', 'ANNIV', 1, 1),
('平日特惠', '週一至週四入住可享有定價85折', 'Percentage', 15.00, '2023-01-01', '2023-12-31', 'WEEKDAY', 1, 1);

-- 6. 插入預訂資料
INSERT INTO Booking (BookingReference, UserID, BookingDate, CheckInDate, CheckOutDate, AdultCount, ChildCount, TotalAmount, DiscountAmount, TaxAmount, FinalAmount, BookingStatus, PromotionID, PaymentStatus, PaymentMethod, PaymentDate, SpecialRequests)
VALUES 
('BK-20230501-001', 3, '2023-04-15', '2023-05-01', '2023-05-03', 1, 0, 7000.00, 700.00, 315.00, 6615.00, 'Confirmed', 2, 'Paid', 'CreditCard', '2023-04-15', '希望有安靜的房間'),
('BK-20230510-002', 4, '2023-04-20', '2023-05-10', '2023-05-12', 2, 1, 9000.00, 0.00, 450.00, 9450.00, 'Confirmed', NULL, 'Paid', 'CreditCard', '2023-04-20', '需要一個嬰兒床'),
('BK-20230605-003', 5, '2023-05-20', '2023-06-05', '2023-06-08', 2, 0, 12000.00, 2400.00, 480.00, 10080.00, 'Confirmed', 3, 'Paid', 'BankTransfer', '2023-05-20', '希望有海景房'),
('BK-20230615-004', 3, '2023-06-01', '2023-06-15', '2023-06-16', 1, 0, 2500.00, 375.00, 106.25, 2231.25, 'Confirmed', 4, 'Paid', 'CreditCard', '2023-06-01', NULL);

-- 7. 插入預訂明細資料
INSERT INTO BookingDetail (BookingID, RoomID, PricePlanID, DailyRate, TaxRate, TotalAmount, GuestName)
VALUES 
(1, 3, 3, 4500.00, 5.00, 9450.00, '張小明'),
(2, 10, 9, 4000.00, 5.00, 8400.00, '陳小花'),
(3, 11, 2, 4500.00, 5.00, 14175.00, '林小華'),
(4, 12, 11, 2500.00, 5.00, 2625.00, '張小明');

-- 8. 插入維護記錄資料
INSERT INTO RoomMaintenance (RoomID, MaintenanceType, RequestedByUserID, AssignedToUserID, RequestDate, ScheduledDate, CompletionDate, Status, Notes)
VALUES 
(6, 'Repair', 1, 2, '2023-04-10', '2023-04-10', '2023-04-11', 'Completed', '空調故障，需要修復'),
(13, 'Cleaning', 2, 2, '2023-05-15', '2023-05-15', '2023-05-15', 'Completed', '房間需要徹底清潔'),
(4, 'Inspection', 1, 2, '2023-05-03', '2023-05-03', '2023-05-03', 'Completed', '例行設施檢查');

-- 9. 插入評價資料
INSERT INTO Review (BookingID, UserID, Rating, Title, Content, ReviewDate, CleanlinessRating, ServiceRating, ValueRating, IsPublished)
VALUES 
(1, 3, 4.5, '舒適的住宿體驗', '房間很舒適，服務也很好，但價格稍高', '2023-05-04', 5.0, 4.5, 4.0, 1),
(2, 4, 5.0, '超棒的海景房', '房間的海景非常漂亮，服務人員也很親切', '2023-05-13', 5.0, 5.0, 4.5, 1),
(3, 5, 4.0, '不錯的住宿選擇', '房間寬敞，設施齊全，但有點吵', '2023-06-09', 4.5, 4.0, 3.5, 1); 