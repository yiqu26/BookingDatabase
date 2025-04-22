# 🏨 單一飯店訂房系統資料庫設計

## 📊 系統概述

本系統為精簡的單一飯店訂房管理資料庫，採用SQL Server設計，包含**10個主要資料表**，專注於單一飯店的房型管理、預訂流程和客戶服務。此設計遵循**第三範式(3NF)**，確保資料一致性與完整性，同時減少資料冗餘。

## 📋 資料表總覽

| 資料表名稱 | 主要功能 | 重要欄位 |
|------------|----------|----------|
| RoomType | 定義飯店提供的房型 | RoomTypeID, Name, BasePrice, MaxOccupancy |
| Room | 記錄實體房間資訊 | RoomID, RoomTypeID, RoomNumber, Status |
| User | 管理所有使用者資訊 | UserID, Email, UserType |
| PricePlan | 設定房型的價格方案 | PricePlanID, RoomTypeID, Price, ValidFrom, ValidTo |
| Promotion | 管理促銷活動與折扣 | PromotionID, DiscountType, DiscountValue |
| Booking | 記錄訂房主要資訊 | BookingID, UserID, CheckInDate, CheckOutDate |
| BookingDetail | 記錄訂房明細 | BookingDetailID, BookingID, RoomID, PricePlanID |
| RoomMaintenance | 追蹤房間維護和清潔記錄 | MaintenanceID, RoomID, MaintenanceType, Status |
| Review | 儲存客戶評價 | ReviewID, BookingID, Rating |
| SystemSettings | 系統配置設定 | SettingID, SettingKey, SettingValue |

## 💾 資料表詳細說明

### 1. 房型表 (RoomType)

定義飯店提供的不同房型及其基本屬性。

| 欄位名稱 | 資料類型 | 說明 |
|----------|----------|------|
| RoomTypeID | INT | 主鍵，房型唯一識別碼 |
| Name | NVARCHAR(100) | 房型名稱，如「豪華單人房」 |
| Description | NVARCHAR(MAX) | 房型詳細描述 |
| BasePrice | DECIMAL(10,2) | 基本房價 |
| MaxOccupancy | INT | 最大可容納人數 |
| BedConfiguration | NVARCHAR(100) | 床型配置描述 |
| RoomSize | NVARCHAR(50) | 房間大小，如「25平方公尺」 |
| Amenities | NVARCHAR(500) | 逗號分隔的設施清單 |
| MainImageURL | NVARCHAR(255) | 主要圖片URL |
| IsActive | BIT | 房型是否可用 |

### 2. 房間表 (Room)

記錄飯店的實體房間資訊，每個房間都屬於特定房型。

| 欄位名稱 | 資料類型 | 說明 |
|----------|----------|------|
| RoomID | INT | 主鍵，房間唯一識別碼 |
| RoomTypeID | INT | 外鍵，參考 RoomType 表 |
| RoomNumber | NVARCHAR(20) | 房間號碼，唯一值 |
| Floor | NVARCHAR(10) | 所在樓層 |
| Status | NVARCHAR(20) | 房間狀態（Available, Occupied, Maintenance, Cleaning） |
| Notes | NVARCHAR(255) | 備註說明 |

### 3. 用戶表 (User)

管理所有系統使用者，包括客戶、管理員和員工。

| 欄位名稱 | 資料類型 | 說明 |
|----------|----------|------|
| UserID | INT | 主鍵，使用者唯一識別碼 |
| Email | NVARCHAR(100) | 電子郵件，唯一值 |
| PasswordHash | NVARCHAR(255) | 加密後的密碼 |
| FirstName | NVARCHAR(50) | 名字 |
| LastName | NVARCHAR(50) | 姓氏 |
| Phone | NVARCHAR(20) | 聯絡電話 |
| Address | NVARCHAR(255) | 地址 |
| City | NVARCHAR(50) | 城市 |
| PostalCode | NVARCHAR(20) | 郵遞區號 |
| UserType | NVARCHAR(20) | 使用者類型（Customer, Admin, Staff） |
| RegistrationDate | DATETIME | 註冊日期 |
| LastLoginDate | DATETIME | 最後登入日期 |
| IsActive | BIT | 帳號是否啟用 |

### 4. 價格方案表 (PricePlan)

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
| IsActive | BIT | 價格方案是否啟用 |

### 5. 促銷活動表 (Promotion)

管理各種折扣和促銷活動。

| 欄位名稱 | 資料類型 | 說明 |
|----------|----------|------|
| PromotionID | INT | 主鍵，促銷活動唯一識別碼 |
| Name | NVARCHAR(100) | 促銷名稱，如「早鳥優惠」 |
| Description | NVARCHAR(MAX) | 促銷描述 |
| DiscountType | NVARCHAR(20) | 折扣類型（Percentage, FixedAmount） |
| DiscountValue | DECIMAL(10,2) | 折扣值 |
| ValidFrom | DATETIME | 有效期間開始時間 |
| ValidTo | DATETIME | 有效期間結束時間 |
| PromotionCode | NVARCHAR(20) | 促銷代碼，唯一值 |
| MinimumStay | INT | 最少住宿天數要求 |
| ApplicableRoomTypes | NVARCHAR(255) | 適用的房型ID列表（逗號分隔） |
| IsActive | BIT | 促銷是否啟用 |

### 6. 預訂表 (Booking)

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
| PaymentMethod | NVARCHAR(50) | 付款方式 |
| SpecialRequests | NVARCHAR(500) | 特殊要求 |

### 7. 預訂明細表 (BookingDetail)

記錄每筆預訂中的房間明細資訊。

| 欄位名稱 | 資料類型 | 說明 |
|----------|----------|------|
| BookingDetailID | INT | 主鍵，明細唯一識別碼 |
| BookingID | INT | 外鍵，參考 Booking 表 |
| RoomID | INT | 外鍵，參考 Room 表 |
| PricePlanID | INT | 外鍵，參考 PricePlan 表 |
| DailyRate | DECIMAL(10,2) | 每日房價 |
| TaxRate | DECIMAL(5,2) | 稅率 |
| TotalAmount | DECIMAL(10,2) | 此房間總金額 |
| GuestName | NVARCHAR(100) | 入住客人姓名 |
| Status | NVARCHAR(20) | 狀態（Confirmed, Cancelled） |

### 8. 房間維護與清潔記錄表 (RoomMaintenance)

追蹤客房的維修問題與清潔工作。

| 欄位名稱 | 資料類型 | 說明 |
|----------|----------|------|
| MaintenanceID | INT | 主鍵，記錄唯一識別碼 |
| RoomID | INT | 外鍵，參考 Room 表 |
| MaintenanceType | NVARCHAR(20) | 維護類型（Cleaning, Repair, Inspection） |
| RequestedByUserID | INT | 外鍵，參考 User 表，申請人員 |
| AssignedToUserID | INT | 外鍵，參考 User 表，負責人員 |
| RequestDate | DATETIME | 申請日期時間 |
| ScheduledDate | DATETIME | 排程日期時間 |
| CompletionDate | DATETIME | 完成日期時間 |
| Status | NVARCHAR(20) | 狀態（Requested, Scheduled, In Progress, Completed, Verified） |
| Notes | NVARCHAR(500) | 備註說明 |

### 9. 評價表 (Review)

儲存客戶對住宿體驗的評價。

| 欄位名稱 | 資料類型 | 說明 |
|----------|----------|------|
| ReviewID | INT | 主鍵，評價唯一識別碼 |
| BookingID | INT | 外鍵，參考 Booking 表，唯一值 |
| UserID | INT | 外鍵，參考 User 表 |
| Rating | DECIMAL(3,1) | 整體評分（1-5） |
| Title | NVARCHAR(100) | 評價標題 |
| Content | NVARCHAR(MAX) | 評價內容 |
| ReviewDate | DATETIME | 評價日期時間 |
| CleanlinessRating | DECIMAL(3,1) | 清潔度評分 |
| ServiceRating | DECIMAL(3,1) | 服務評分 |
| ValueRating | DECIMAL(3,1) | 性價比評分 |
| IsPublished | BIT | 是否已發布公開 |

### 10. 系統設定表 (SystemSettings)

存儲飯店基本資訊和系統參數設定。

| 欄位名稱 | 資料類型 | 說明 |
|----------|----------|------|
| SettingID | INT | 主鍵，設定唯一識別碼 |
| SettingKey | NVARCHAR(50) | 設定鍵名，唯一值 |
| SettingValue | NVARCHAR(MAX) | 設定值 |
| SettingDescription | NVARCHAR(255) | 設定描述 |
| LastUpdated | DATETIME | 最後更新時間 |
| UpdatedByUserID | INT | 外鍵，參考 User 表，更新者 |

## 🔄 資料表關聯圖

```
RoomType 1──*─┐
      ▲       Room
      │       ▲
      │       │
PricePlan *──1┘       ┌───1 User
      ▲               │
      │        ┌──────┘
      │        │
BookingDetail *────1─┐
      ▲               │
      │               │
      └───* Booking 1─┘
             ▲
             │
      ┌──────┘
      │
Review 1
```

## 🚀 系統功能

此精簡版資料庫設計支援以下主要功能：

1. **房型與房間管理**：記錄並管理飯店提供的各種房型和實體房間
2. **價格方案管理**：支援不同時段、不同條件的靈活定價策略
3. **預訂處理**：完整的訂房流程，從查詢、預訂到支付
4. **用戶管理**：針對不同角色（客戶、員工、管理員）的權限控制
5. **房間狀態追蹤**：監控房間的清潔和維護狀態
6. **客戶評價**：收集和管理客戶的住宿評價
7. **飯店資訊設定**：集中管理飯店基本資訊與系統參數

## 💡 設計特點

1. **系統設定表**：將飯店相關資訊（名稱、地址、聯絡方式等）移至系統設定表中，適用於單一飯店的情境
2. **合併維護和清潔記錄**：整合為單一表格，根據維護類型區分不同操作
3. **簡化設施管理**：直接在房型表中以字串形式存儲設施列表，減少多對多關聯表的複雜性
4. **整合支付資訊**：將支付相關資訊整合至預訂表中，減少額外的資料表
5. **系統易於擴展**：保留核心功能的同時，架構易於根據未來需求擴展

此資料庫設計專為單一飯店訂房系統設計，專注於核心業務流程，提供簡化但完整的訂房管理功能。 