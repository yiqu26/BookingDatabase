# 🏨 飯店訂房系統資料庫設計

## 📊 系統概述

本系統為完整的飯店訂房管理資料庫，採用SQL Server設計，包含**20個主要資料表**，涵蓋從飯店資訊、房型管理到客戶訂房的所有核心功能。此設計遵循**第三範式(3NF)**，確保資料一致性與完整性，同時減少資料冗餘。

## 📋 資料表總覽

### 🏢 飯店與房間管理

| 資料表名稱 | 主要功能 | 重要欄位 |
|------------|----------|----------|
| Hotel | 儲存飯店基本資訊 | HotelID, Name, Address, City, StarRating |
| HotelAmenity | 記錄各種飯店設施選項 | AmenityID, Name, Description |
| HotelHasAmenity | 建立飯店與設施的多對多關聯 | HotelID, AmenityID |
| HotelImage | 存放飯店相關圖片 | ImageID, HotelID, ImageURL, IsPrimary |
| RoomType | 定義飯店提供的房型 | RoomTypeID, HotelID, Name, BasePrice |
| RoomAmenity | 記錄各種房間設施選項 | AmenityID, Name, Description |
| RoomTypeHasAmenity | 建立房型與設施的多對多關聯 | RoomTypeID, AmenityID |
| RoomTypeImage | 存放房型相關圖片 | ImageID, RoomTypeID, ImageURL |
| Room | 記錄實體房間資訊 | RoomID, HotelID, RoomTypeID, RoomNumber, Status |

### 💰 價格與促銷管理

| 資料表名稱 | 主要功能 | 重要欄位 |
|------------|----------|----------|
| PricePlan | 設定房型的價格方案 | PricePlanID, RoomTypeID, Price, ValidFrom, ValidTo |
| Promotion | 管理促銷活動與折扣 | PromotionID, DiscountType, DiscountValue, ValidFrom, ValidTo |

### 👤 客戶與訂單管理

| 資料表名稱 | 主要功能 | 重要欄位 |
|------------|----------|----------|
| User | 管理所有使用者資訊 | UserID, Email, FirstName, LastName, UserType |
| Booking | 記錄訂房主要資訊 | BookingID, UserID, CheckInDate, CheckOutDate, TotalAmount |
| BookingDetail | 記錄訂房明細 | BookingDetailID, BookingID, RoomID, DateFrom, DateTo |
| Payment | 追蹤付款記錄 | PaymentID, BookingID, Amount, PaymentMethod, PaymentStatus |
| Invoice | 管理發票資訊 | InvoiceID, BookingID, InvoiceNumber, TotalAmount |
| Review | 儲存客戶評價 | ReviewID, BookingID, Rating, Content, ReviewDate |

### 👷 營運管理

| 資料表名稱 | 主要功能 | 重要欄位 |
|------------|----------|----------|
| Staff | 管理飯店員工資訊 | StaffID, HotelID, Position, Department |
| MaintenanceRecord | 追蹤房間維修記錄 | RecordID, RoomID, Issue, Status |
| CleaningRecord | 記錄房間清潔情況 | RecordID, RoomID, CleaningDate, Status |

## 💾 資料表詳細說明

### 1. 飯店資訊表 (Hotel)

存放系統中所有飯店的基本資訊，是整個系統的核心實體。

| 欄位名稱 | 資料類型 | 說明 |
|----------|----------|------|
| HotelID | INT | 主鍵，飯店唯一識別碼 |
| Name | NVARCHAR(100) | 飯店名稱 |
| Address | NVARCHAR(255) | 飯店地址 |
| City | NVARCHAR(50) | 所在城市 |
| Country | NVARCHAR(50) | 所在國家 |
| Phone | NVARCHAR(20) | 聯絡電話 |
| Email | NVARCHAR(100) | 電子郵件 |
| StarRating | DECIMAL(2,1) | 星級評分 (1-5) |
| CheckinTime | TIME | 入住時間，預設 15:00 |
| CheckoutTime | TIME | 退房時間，預設 12:00 |
| IsActive | BIT | 飯店是否營業中 |

### 2. 飯店設施表 (HotelAmenity)

記錄飯店可能提供的各種設施選項。

| 欄位名稱 | 資料類型 | 說明 |
|----------|----------|------|
| AmenityID | INT | 主鍵，設施唯一識別碼 |
| Name | NVARCHAR(100) | 設施名稱，如「游泳池」、「健身中心」 |
| Description | NVARCHAR(255) | 設施描述 |
| Icon | NVARCHAR(50) | 設施圖示名稱 |

### 3. 飯店與設施關聯表 (HotelHasAmenity)

建立飯店與設施之間的多對多關聯，記錄每個飯店擁有哪些設施。

| 欄位名稱 | 資料類型 | 說明 |
|----------|----------|------|
| HotelID | INT | 外鍵，參考 Hotel 表 |
| AmenityID | INT | 外鍵，參考 HotelAmenity 表 |

### 4. 飯店圖片表 (HotelImage)

存放飯店相關的所有圖片，包括外觀、大廳、設施等。

| 欄位名稱 | 資料類型 | 說明 |
|----------|----------|------|
| ImageID | INT | 主鍵，圖片唯一識別碼 |
| HotelID | INT | 外鍵，參考 Hotel 表 |
| ImageURL | NVARCHAR(255) | 圖片的URL路徑 |
| Caption | NVARCHAR(100) | 圖片說明文字 |
| IsPrimary | BIT | 是否為主要圖片 |
| DisplayOrder | INT | 顯示順序 |

### 5. 房型表 (RoomType)

定義飯店提供的不同房型及其基本屬性。

| 欄位名稱 | 資料類型 | 說明 |
|----------|----------|------|
| RoomTypeID | INT | 主鍵，房型唯一識別碼 |
| HotelID | INT | 外鍵，參考 Hotel 表 |
| Name | NVARCHAR(100) | 房型名稱，如「豪華單人房」 |
| Description | NVARCHAR(MAX) | 房型詳細描述 |
| BasePrice | DECIMAL(10,2) | 基本房價 |
| BaseCurrency | NVARCHAR(3) | 貨幣單位，預設 TWD |
| MaxOccupancy | INT | 最大可容納人數 |
| BedConfiguration | NVARCHAR(100) | 床型配置描述 |
| RoomSize | NVARCHAR(50) | 房間大小，如「25平方公尺」 |

### 6. 房型設施表 (RoomAmenity)

記錄房間可能配備的各種設施選項。

| 欄位名稱 | 資料類型 | 說明 |
|----------|----------|------|
| AmenityID | INT | 主鍵，設施唯一識別碼 |
| Name | NVARCHAR(100) | 設施名稱，如「電視」、「冰箱」 |
| Description | NVARCHAR(255) | 設施描述 |
| Icon | NVARCHAR(50) | 設施圖示名稱 |

### 7. 房型與設施關聯表 (RoomTypeHasAmenity)

建立房型與設施之間的多對多關聯，記錄每種房型配備哪些設施。

| 欄位名稱 | 資料類型 | 說明 |
|----------|----------|------|
| RoomTypeID | INT | 外鍵，參考 RoomType 表 |
| AmenityID | INT | 外鍵參考 RoomAmenity 表 |

### 8. 房型圖片表 (RoomTypeImage)

存放各種房型的相關圖片。

| 欄位名稱 | 資料類型 | 說明 |
|----------|----------|------|
| ImageID | INT | 主鍵，圖片唯一識別碼 |
| RoomTypeID | INT | 外鍵，參考 RoomType 表 |
| ImageURL | NVARCHAR(255) | 圖片的URL路徑 |
| Caption | NVARCHAR(100) | 圖片說明文字 |
| IsPrimary | BIT | 是否為主要圖片 |
| DisplayOrder | INT | 顯示順序 |

### 9. 客房表 (Room)

記錄飯店的實體房間資訊，每個房間都屬於特定房型。

| 欄位名稱 | 資料類型 | 說明 |
|----------|----------|------|
| RoomID | INT | 主鍵，房間唯一識別碼 |
| HotelID | INT | 外鍵，參考 Hotel 表 |
| RoomTypeID | INT | 外鍵，參考 RoomType 表 |
| RoomNumber | NVARCHAR(20) | 房間號碼 |
| Floor | NVARCHAR(10) | 所在樓層 |
| Status | NVARCHAR(20) | 房間狀態（Available, Occupied, Maintenance, Cleaning） |
| Notes | NVARCHAR(255) | 備註說明 |

### 10. 用戶表 (User)

管理所有系統使用者，包括客戶、管理員和員工。

| 欄位名稱 | 資料類型 | 說明 |
|----------|----------|------|
| UserID | INT | 主鍵，使用者唯一識別碼 |
| Email | NVARCHAR(100) | 電子郵件，唯一值 |
| PasswordHash | NVARCHAR(255) | 加密後的密碼 |
| FirstName | NVARCHAR(50) | 名字 |
| LastName | NVARCHAR(50) | 姓氏 |
| Phone | NVARCHAR(20) | 聯絡電話 |
| UserType | NVARCHAR(20) | 使用者類型（Customer, Admin, Staff） |
| RegistrationDate | DATETIME | 註冊日期 |
| IsVerified | BIT | 是否已驗證 |
| IsActive | BIT | 帳號是否啟用 |

### 11. 價格方案表 (PricePlan)

設定不同房型在特定時間範圍內的價格策略。

| 欄位名稱 | 資料類型 | 說明 |
|----------|----------|------|
| PricePlanID | INT | 主鍵，價格方案唯一識別碼 |
| RoomTypeID | INT | 外鍵，參考 RoomType 表 |
| Name | NVARCHAR(100) | 方案名稱，如「標準價」、「週末價」 |
| ValidFrom | DATE | 有效期間開始日 |
| ValidTo | DATE | 有效期間結束日 |
| DayOfWeekBitmask | INT | 一週中的適用日（位元遮罩：1=週一, 2=週二...64=週日） |
| Price | DECIMAL(10,2) | 房價 |
| IsBreakfastIncluded | BIT | 是否含早餐 |
| IsRefundable | BIT | 是否可退款 |
| MinStayLength | INT | 最少住宿天數 |

### 12. 促銷活動表 (Promotion)

管理各種折扣和促銷活動。

| 欄位名稱 | 資料類型 | 說明 |
|----------|----------|------|
| PromotionID | INT | 主鍵，促銷活動唯一識別碼 |
| Name | NVARCHAR(100) | 促銷名稱，如「早鳥優惠」 |
| DiscountType | NVARCHAR(20) | 折扣類型（Percentage, FixedAmount） |
| DiscountValue | DECIMAL(10,2) | 折扣值 |
| ValidFrom | DATETIME | 有效期間開始時間 |
| ValidTo | DATETIME | 有效期間結束時間 |
| PromotionCode | NVARCHAR(20) | 促銷代碼 |
| MinimumStay | INT | 最少住宿天數要求 |
| MaxUsageCount | INT | 最大使用次數限制 |

### 13. 預訂表 (Booking)

記錄客戶的訂房資訊，是訂房流程的核心資料表。

| 欄位名稱 | 資料類型 | 說明 |
|----------|----------|------|
| BookingID | INT | 主鍵，預訂唯一識別碼 |
| BookingReference | NVARCHAR(20) | 預訂參考編號，唯一值 |
| UserID | INT | 外鍵，參考 User 表 |
| BookingDate | DATETIME | 下訂日期時間 |
| CheckInDate | DATE | 入住日期 |
| CheckOutDate | DATE | 退房日期 |
| AdultCount | INT | 成人人數 |
| ChildCount | INT | 兒童人數 |
| TotalAmount | DECIMAL(10,2) | 訂單總金額 |
| DiscountAmount | DECIMAL(10,2) | 折扣金額 |
| FinalAmount | DECIMAL(10,2) | 最終金額 |
| BookingStatus | NVARCHAR(20) | 訂單狀態（Confirmed, Checked In, Cancelled 等） |
| PromotionID | INT | 外鍵，參考 Promotion 表 |
| PaymentStatus | NVARCHAR(20) | 付款狀態（Pending, Paid, Refunded 等） |

### 14. 預訂明細表 (BookingDetail)

記錄每筆預訂中的房間明細資訊。

| 欄位名稱 | 資料類型 | 說明 |
|----------|----------|------|
| BookingDetailID | INT | 主鍵，明細唯一識別碼 |
| BookingID | INT | 外鍵，參考 Booking 表 |
| RoomID | INT | 外鍵，參考 Room 表 |
| RoomTypeID | INT | 外鍵，參考 RoomType 表 |
| DateFrom | DATE | 此房間入住日期 |
| DateTo | DATE | 此房間退房日期 |
| DailyRate | DECIMAL(10,2) | 每日房價 |
| TotalAmount | DECIMAL(10,2) | 此房間總金額 |
| GuestFirstName | NVARCHAR(50) | 入住客人名字 |
| GuestLastName | NVARCHAR(50) | 入住客人姓氏 |
| Status | NVARCHAR(20) | 狀態（Confirmed, Cancelled） |

### 15. 付款表 (Payment)

追蹤與預訂相關的所有付款記錄。

| 欄位名稱 | 資料類型 | 說明 |
|----------|----------|------|
| PaymentID | INT | 主鍵，付款唯一識別碼 |
| BookingID | INT | 外鍵，參考 Booking 表 |
| Amount | DECIMAL(10,2) | 付款金額 |
| PaymentDate | DATETIME | 付款日期時間 |
| PaymentMethod | NVARCHAR(50) | 付款方式（CreditCard, BankTransfer 等） |
| PaymentStatus | NVARCHAR(20) | 付款狀態（Completed, Failed 等） |
| TransactionID | NVARCHAR(100) | 交易編號 |
| CardType | NVARCHAR(50) | 信用卡類型 |
| Last4Digits | NVARCHAR(4) | 信用卡末四碼 |

### 16. 發票表 (Invoice)

管理與預訂相關的發票資訊。

| 欄位名稱 | 資料類型 | 說明 |
|----------|----------|------|
| InvoiceID | INT | 主鍵，發票唯一識別碼 |
| BookingID | INT | 外鍵，參考 Booking 表 |
| InvoiceNumber | NVARCHAR(50) | 發票號碼，唯一值 |
| InvoiceDate | DATETIME | 開立日期時間 |
| Amount | DECIMAL(10,2) | 金額 |
| TaxAmount | DECIMAL(10,2) | 稅額 |
| TotalAmount | DECIMAL(10,2) | 總金額 |
| Status | NVARCHAR(20) | 發票狀態（Issued, Paid, Cancelled） |
| BillingName | NVARCHAR(100) | 帳單抬頭 |

### 17. 評價表 (Review)

儲存客戶對住宿體驗的評價。

| 欄位名稱 | 資料類型 | 說明 |
|----------|----------|------|
| ReviewID | INT | 主鍵，評價唯一識別碼 |
| BookingID | INT | 外鍵，參考 Booking 表 |
| UserID | INT | 外鍵，參考 User 表 |
| HotelID | INT | 外鍵，參考 Hotel 表 |
| Rating | DECIMAL(3,1) | 整體評分（1-5） |
| Title | NVARCHAR(100) | 評價標題 |
| Content | NVARCHAR(MAX) | 評價內容 |
| ReviewDate | DATETIME | 評價日期時間 |
| CleanlinessRating | DECIMAL(3,1) | 清潔度評分 |
| ServiceRating | DECIMAL(3,1) | 服務評分 |
| LocationRating | DECIMAL(3,1) | 位置評分 |
| ValueRating | DECIMAL(3,1) | 性價比評分 |
| IsVerified | BIT | 是否已驗證（確認真實住客） |
| IsPublished | BIT | 是否已發布公開 |

### 18. 員工表 (Staff)

管理飯店的員工資訊。

| 欄位名稱 | 資料類型 | 說明 |
|----------|----------|------|
| StaffID | INT | 主鍵，員工唯一識別碼 |
| UserID | INT | 外鍵，參考 User 表 |
| HotelID | INT | 外鍵，參考 Hotel 表 |
| FirstName | NVARCHAR(50) | 名字 |
| LastName | NVARCHAR(50) | 姓氏 |
| Position | NVARCHAR(50) | 職位 |
| Department | NVARCHAR(50) | 部門 |
| HireDate | DATE | 入職日期 |
| Email | NVARCHAR(100) | 電子郵件，唯一值 |
| IsActive | BIT | 是否在職 |

### 19. 維護記錄表 (MaintenanceRecord)

追蹤客房的維修問題與處理狀況。

| 欄位名稱 | 資料類型 | 說明 |
|----------|----------|------|
| RecordID | INT | 主鍵，記錄唯一識別碼 |
| RoomID | INT | 外鍵，參考 Room 表 |
| ReportedByStaffID | INT | 外鍵，參考 Staff 表，回報人員 |
| ReportDate | DATETIME | 回報日期時間 |
| Issue | NVARCHAR(255) | 問題描述 |
| Priority | NVARCHAR(20) | 優先程度（Low, Medium, High, Urgent） |
| Status | NVARCHAR(20) | 處理狀態（Reported, In Progress, Completed） |
| AssignedToStaffID | INT | 外鍵，參考 Staff 表，負責處理的員工 |
| CompletionDate | DATETIME | 完成日期時間 |

### 20. 清潔記錄表 (CleaningRecord)

記錄客房的清潔工作。

| 欄位名稱 | 資料類型 | 說明 |
|----------|----------|------|
| RecordID | INT | 主鍵，記錄唯一識別碼 |
| RoomID | INT | 外鍵，參考 Room 表 |
| CleanedByStaffID | INT | 外鍵，參考 Staff 表，清潔人員 |
| CleaningDate | DATETIME | 清潔日期時間 |
| Status | NVARCHAR(20) | 狀態（Scheduled, Completed, Verified） |
| VerifiedByStaffID | INT | 外鍵，參考 Staff 表，驗證人員 |
| VerificationDate | DATETIME | 驗證日期時間 |

## 🔄 資料表關聯圖

各資料表之間通過外鍵建立關聯，主要關聯包括：

- 飯店與其房型、房間、圖片、設施的一對多關聯
- 房型與其房間、圖片、設施的一對多關聯
- 用戶與預訂的一對多關聯
- 預訂與預訂明細、付款、發票的一對多關聯
- 房間與維護記錄、清潔記錄的一對多關聯

## 🚀 系統功能

此資料庫設計支援以下主要功能：

1. **飯店與房型管理**：完整記錄飯店及其提供的房型資訊
2. **房間可用性查詢**：根據日期和房型查詢可用房間
3. **彈性定價策略**：支援不同時段、不同條件的價格方案
4. **線上預訂流程**：從查詢、預訂到支付的完整流程
5. **客房狀態管理**：追蹤房間的清潔和維護狀態
6. **客戶評價系統**：收集和管理客戶對住宿體驗的評價
7. **多層級用戶管理**：區分客戶、員工和管理員權限

---

此資料庫設計旨在提供全方位的飯店訂房管理解決方案，從前台訂房到後台管理，提供流暢的使用者體驗和高效的營運支援。 