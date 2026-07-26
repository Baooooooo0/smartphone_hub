# 🗺️ SmartphoneHub — Development Plan

> Kế hoạch phát triển chi tiết theo từng phase, tính năng và sprint cho app SmartphoneHub.
> **Scope**: Dự án CV/Portfolio cá nhân — chạy trên Android, demo local, không publish store.

---

## Tóm Tắt Dự Án

| Mục              | Thông tin                                       |
|------------------|-------------------------------------------------|
| **App name**     | SmartphoneHub                                   |
| **Platform**     | Flutter — **Android only** (API 21+)            |
| **Backend**      | Firebase (Firestore, Auth, FCM, Storage)        |
| **Thanh toán**   | SePay (QR), MoMo (deeplink), COD                |
| **Architecture** | Clean Architecture + Riverpod + MVVM            |
| **Mục tiêu**     | Portfolio/CV demo — chạy được, trình bày được   |
| **Deployment**   | APK debug/release cài thẳng lên thiết bị        |

---

## Roadmap Tổng Quan

```
Phase 1: Core MVP             [Tuần 1–4]
Phase 2: Payment & Realtime   [Tuần 5–7]
Phase 3: Admin Screen         [Tuần 7–9]
Phase 4: Advanced Features    [Tuần 10–13]
Phase 5: Polish & Demo        [Tuần 14]
```

> ⚡ **Solo dev / CV project**: Tổng ~14 tuần, không cần store review, chỉ cần build APK chạy được để demo.

---

## Phase 1 — Core MVP (Tuần 1–4)

### 🏗️ Sprint 1.1 — Project Setup & Foundation (Tuần 1)

#### Mục tiêu
Thiết lập nền tảng kỹ thuật vững chắc trước khi code tính năng.

#### Tasks

- [ ] **1.1.1** Khởi tạo cấu trúc thư mục theo Clean Architecture
  - Tạo đầy đủ các folder: `core/`, `data/`, `domain/`, `presentation/`, `router/`
  - Tạo các file barrel (`index.dart`) cho mỗi layer

- [ ] **1.1.2** Cấu hình Firebase
  - Tạo Firebase project `smartphonehub-prod`
  - Kích hoạt: Authentication, Firestore, Storage, FCM, Analytics, Crashlytics
  - Chạy `flutterfire configure` → tạo `firebase_options.dart`
  - Cấu hình `google-services.json` (Android) & `GoogleService-Info.plist` (iOS)

- [ ] **1.1.3** Thêm tất cả dependencies vào `pubspec.yaml`
  - Firebase packages, Riverpod, go_router, freezed, dio, etc.
  - Chạy `flutter pub get`

- [ ] **1.1.4** Setup code generation
  - Cấu hình `build.yaml` cho freezed & riverpod
  - Test `dart run build_runner build`

- [ ] **1.1.5** Thiết kế Design System
  - `AppColors`: primary (tech blue `#0057FF`), secondary, background, surface, error
  - `AppTypography`: Google Fonts (Outfit cho heading, Inter cho body)
  - `AppTheme`: ThemeData light (+ dark nếu có thời gian)
  - `AppSizes`: padding, radius, icon sizes chuẩn hóa

- [ ] **1.1.6** Cấu hình `go_router`
  - Định nghĩa tất cả named routes
  - Setup redirect guard (auth + admin role)
  - Setup deep link handler

- [ ] **1.1.7** Khởi tạo Firestore với dữ liệu seed
  - Tạo script seed: 20+ sản phẩm, categories, banners, 1 admin account
  - Upload ảnh sản phẩm mẫu lên Firebase Storage

**Deliverable:** App chạy được, kết nối Firebase, có design system + navigation skeleton.

---

### 👤 Sprint 1.2 — Authentication (Tuần 2, phần đầu)

#### Tasks

- [ ] **1.2.1** Firebase Auth integration
  - Tạo `AuthRepository` interface + implementation
  - Provider: `authStateProvider` (stream Firebase Auth state)

- [ ] **1.2.2** Login Screen
  - Email + Password login
  - Google Sign-In
  - Form validation (email format, password min 6 ký tự)
  - Loading state, error handling

- [ ] **1.2.3** Register Screen
  - Email + Password + Confirm Password + Display Name
  - Tự động tạo document `/users/{uid}` khi đăng ký
  - Validation đầy đủ

- [ ] **1.2.4** Forgot Password Screen
  - Gửi email reset password

- [ ] **1.2.5** Phone OTP (tùy chọn)
  - `firebase_auth` phone verification
  - OTP input screen

- [ ] **1.2.6** Auto login
  - Kiểm tra auth state khi app khởi động
  - Navigate đến Home nếu đã đăng nhập

**Deliverable:** Đăng nhập / đăng ký / đăng xuất hoạt động đầy đủ.

---

### 🏠 Sprint 1.3 — Home & Product Listing (Tuần 2, phần cuối – Tuần 3)

#### Tasks

- [ ] **1.3.1** Home Screen
  - Banner Carousel (carousel_slider + smooth_page_indicator)
  - Categories horizontal scroll
  - Featured Products section
  - Best Sellers section
  - Bottom Navigation Bar (Home, Search, Cart, Orders, Profile)

- [ ] **1.3.2** Product Repository & UseCase
  - `getProducts(filter, sort, pagination)` — Firestore query với startAfter
  - `getFeaturedProducts()`
  - `getBestSellers()`
  - `getProductsByCategory(categoryId)`

- [ ] **1.3.3** Product List Screen
  - Grid view (2 columns) với pagination (load more khi scroll đến cuối)
  - ProductCard widget: ảnh, tên, giá, giá gốc (gạch ngang), rating stars
  - Shimmer loading
  - Empty state widget

- [ ] **1.3.4** Search Screen
  - Search bar với debounce (300ms)
  - Filter bottom sheet: brand, price range, rating
  - Sort options: giá thấp→cao, cao→thấp, rating, mới nhất
  - Search history (local SharedPreferences)

- [ ] **1.3.5** Product Detail Screen
  - Image gallery (PageView + indicator)
  - Tên, brand, giá, rating summary
  - Chọn màu sắc
  - Tabs: Mô tả | Thông số kỹ thuật | Đánh giá
  - "Thêm vào giỏ" + "Mua ngay"
  - Sticky bottom bar

**Deliverable:** Duyệt sản phẩm, tìm kiếm, xem chi tiết hoạt động.

---

### 🛒 Sprint 1.4 — Cart & Order (Tuần 3 – Tuần 4)

#### Tasks

- [ ] **1.4.1** Cart
  - CartRepository: CRUD trên Firestore `/carts/{userId}`
  - Realtime sync (stream)
  - Cart Screen: danh sách items, tăng/giảm số lượng, xóa item
  - Badge số lượng trên icon cart
  - Subtotal tính realtime

- [ ] **1.4.2** Checkout Screen
  - Hiển thị order summary (items, subtotal, shipping fee, total)
  - Chọn địa chỉ giao hàng (từ danh sách hoặc thêm mới)
  - Chọn phương thức thanh toán (COD trước, SePay/MoMo sau)
  - Input ghi chú đơn hàng
  - Nút "Đặt hàng" → tạo order trên Firestore

- [ ] **1.4.3** Order Management (User)
  - Order List Screen: danh sách đơn hàng theo tab status
  - Order Detail Screen: items, status timeline, địa chỉ, thanh toán
  - Cancel order (nếu status = "pending")

- [ ] **1.4.4** Address Management
  - Profile → Quản lý địa chỉ
  - Thêm/sửa/xóa/set default địa chỉ
  - Model: `{ label, recipientName, phone, street, ward, district, province }`

- [ ] **1.4.5** Profile Screen
  - Hiển thị thông tin user (avatar, tên, email, phone)
  - Chỉnh sửa thông tin, upload avatar
  - Menu: Orders, Addresses, Notifications, Reviews, Vouchers, Logout

**Deliverable:** Hoàn chỉnh user flow: duyệt → thêm giỏ → checkout → xem đơn hàng.

---

## Phase 2 — Payment & Realtime Notifications (Tuần 5–7)

### 💳 Sprint 2.1 — SePay Integration (Tuần 5)

- [ ] **2.1.1** Tạo `SepayService` (dio HTTP client)
  - Hàm `generateQRUrl()` — tạo URL QR code động
  - Hàm `checkTransactionStatus(orderId)` — polling fallback

- [ ] **2.1.2** SePay Payment Screen
  - Hiển thị QR code (`qr_flutter`) 
  - Hiển thị thông tin: STK, tên ngân hàng, số tiền, nội dung chuyển khoản
  - Countdown timer (15 phút)
  - Lắng nghe Firestore realtime → tự động chuyển khi thanh toán thành công

- [ ] **2.1.3** Cloud Function: `sepayWebhook`
  - Endpoint nhận webhook từ SePay
  - Verify signature
  - Parse orderId từ nội dung chuyển khoản
  - Cập nhật order trong Firestore
  - Gửi FCM notification

- [ ] **2.1.4** Test end-to-end SePay flow với Firebase Emulator

---

### 💜 Sprint 2.2 — MoMo Integration (Tuần 6)

- [ ] **2.2.1** Cloud Function: `createMomoPayment`
  - Nhận orderId + amount từ Flutter app
  - Tạo HMAC-SHA256 signature
  - Gọi MoMo API `/v2/gateway/api/create`
  - Return deeplink/payUrl

- [ ] **2.2.2** Cloud Function: `momoIPN`
  - Nhận IPN callback từ MoMo
  - Verify signature
  - Cập nhật order status

- [ ] **2.2.3** MoMo Payment Flow trong App
  - Gọi Cloud Function → nhận deeplink
  - Mở MoMo app via `url_launcher`
  - Xử lý return URL (deep link `smartphonehub://payment/return`)
  - Fetch lại order status sau khi return

- [ ] **2.2.4** Test MoMo flow (MoMo sandbox)

---

### 🔔 Sprint 2.3 — FCM & Realtime Notifications (Tuần 7)

- [ ] **2.3.1** `NotificationService` setup
  - Request permission
  - Get + lưu FCM token vào Firestore
  - Xử lý 3 trạng thái: foreground, background, terminated

- [ ] **2.3.2** `flutter_local_notifications` cho foreground
  - Cấu hình notification channel (Android)
  - Hiển thị notification khi app foreground

- [ ] **2.3.3** Notification → Navigate
  - Parse `data` payload từ notification
  - Navigate đến đúng screen (order detail, product, etc.)

- [ ] **2.3.4** Notification List Screen
  - Stream `/notifications/{userId}/items` realtime
  - Đánh dấu đã đọc khi tap
  - Badge unread count trên icon (BottomNav)
  - Swipe to delete

- [ ] **2.3.5** Cloud Functions `sendNotificationToUser()`
  - Helper function dùng chung cho mọi trigger
  - Lưu vào Firestore + gửi FCM

- [ ] **2.3.6** Trigger notification khi admin cập nhật order status
  - Firestore trigger: `onDocumentUpdated` orders → gửi FCM

---

## Phase 3 — Admin Screen (Tuần 7–9)

### 🛠️ Sprint 3.1 — Admin Foundation + Dashboard (Tuần 7–8)

- [ ] **3.1.1** Admin role guard
  - Kiểm tra role trong Firestore trước khi render Admin route
  - Firestore Rules bảo vệ write operations

- [ ] **3.1.2** Admin Navigation
  - Admin-only bottom nav hoặc Drawer
  - AdminDashboardScreen là home

- [ ] **3.1.3** Dashboard Screen
  - Cards: Tổng doanh thu, đơn hôm nay, sản phẩm active, users
  - Biểu đồ doanh thu 7 ngày (LineChart - fl_chart)
  - Biểu đồ đơn hàng theo status (PieChart)
  - Top 5 sản phẩm bán chạy

---

### 📦 Sprint 3.2 — Product & Order Management (Tuần 8)

- [ ] **3.2.1** Admin Product List
  - DataTable hoặc list với search, filter, sort
  - Toggle isActive, isFeatured
  - Quick stock update

- [ ] **3.2.2** Add / Edit Product Screen
  - Multi-image upload (image_picker → Firebase Storage)
  - Form đầy đủ: tên, brand, category, mô tả, giá, giá KM, màu sắc, specs, tồn kho
  - Preview trước khi lưu

- [ ] **3.2.3** Admin Order List
  - List với filter theo status và search theo orderId/user
  - Realtime stream

- [ ] **3.2.4** Admin Order Detail
  - Xem đầy đủ thông tin đơn
  - Dropdown thay đổi status (confirmed → shipping → delivered)
  - Gửi FCM notification khi thay đổi status
  - Ghi chú cho từng cập nhật

---

### 👥 Sprint 3.3 — User, Banner & Broadcast (Tuần 9)

- [ ] **3.3.1** User Management
  - Danh sách users với search
  - Xem profile user (đơn hàng, review)
  - Block/unblock user
  - Cấp quyền admin (cẩn thận!)

- [ ] **3.3.2** Banner Management
  - Upload/edit/delete banner
  - Drag-to-reorder thứ tự hiển thị
  - Set target (product / category / URL)

- [ ] **3.3.3** Notification Broadcast
  - Form: tiêu đề, nội dung, loại (tất cả / nhóm / user cụ thể)
  - Cloud Function: query fcmTokens của nhóm target, gửi batch FCM

**Deliverable:** Admin có thể quản lý toàn bộ hệ thống.

---

## Phase 4 — Advanced Features (Tuần 10–14)

### 🎟️ Sprint 4.1 — Voucher System (Tuần 10–11)

- [ ] **4.1.1** Voucher data model & Firestore schema
- [ ] **4.1.2** Admin Voucher Management Screen
  - Tạo/sửa/xóa voucher (form đầy đủ)
  - Bảng thống kê sử dụng
- [ ] **4.1.3** `ValidateVoucherUseCase` (validate client-side)
- [ ] **4.1.4** Voucher input trong Checkout Screen
  - Input code → validate → hiển thị discount
  - Apply voucher vào order total
- [ ] **4.1.5** Cloud Function `createOrder` với atomic voucher apply
  - Transaction: check + increment usedCount atomically
- [ ] **4.1.6** My Vouchers Screen (User)
  - Danh sách voucher đang active
  - Nút copy code

---

### ⭐ Sprint 4.2 — Review & Rating (Tuần 11–12)

- [ ] **4.2.1** Review data model & Firestore subcollection
- [ ] **4.2.2** Check điều kiện được phép review
  - Query orders của user có productId + status "delivered"
- [ ] **4.2.3** Write Review Screen
  - Star rating widget (flutter_rating_bar)
  - Text comment (required, min 10 ký tự)
  - Upload ảnh (tối đa 3, image_picker → Storage)
- [ ] **4.2.4** Review List trong Product Detail
  - Phân trang, sắp xếp (mới nhất / rating cao nhất)
  - Badge "Đã mua hàng"
  - Rating breakdown chart (5★→1★)
- [ ] **4.2.5** Cloud Function `recalculateRating`
  - Trigger onDocumentWritten reviews
  - Cập nhật product.rating + product.reviewCount
- [ ] **4.2.6** Admin Review Management
  - Xem tất cả reviews
  - Toggle isHidden (ẩn review vi phạm)
  - Phản hồi review (comment từ admin)
- [ ] **4.2.7** Notification khi review được phản hồi

---

### 🤖 Sprint 4.3 — Recommendation System (Tuần 13–14)

#### Phase 1 — Rule-based

- [ ] **4.3.1** "Sản phẩm tương tự" trong Product Detail
  - Query: same brand + category, sort by rating, exclude current
- [ ] **4.3.2** "Xem gần đây"
  - Lưu danh sách productId vào Firestore (tối đa 20 sản phẩm)
  - Hiển thị trong Home screen & Profile
- [ ] **4.3.3** "Bán chạy trong tuần" trên Home
  - Query: sort by sold DESC, limit 10
- [ ] **4.3.4** "Gợi ý theo tầm giá"
  - Khi xem sản phẩm: gợi ý SP trong khoảng ±30% giá
- [ ] **4.3.5** "Khách hàng cũng mua" (co-purchase)
  - Query orders chứa productId → lấy các productId khác → aggregate

#### Phase 2 — ML-based (Tùy chọn nâng cao)

- [ ] **4.3.6** Tích hợp Firebase Extensions: "Recommend with Vertex AI"
  - Setup BigQuery export
  - Train collaborative filtering model
  - Import results về Firestore `/recommendations/{userId}`

---

## Phase 5 — Polish & Launch (Tuần 15–16)

### ✨ Sprint 5.1 — UX Polish (Tuần 14)

- [ ] **5.1.1** Loading states & Error states đồng nhất toàn app
- [ ] **5.1.2** Empty states với illustrations (Lottie animations)
- [ ] **5.1.3** Pull-to-refresh trên tất cả list screens
- [ ] **5.1.4** Haptic feedback trên các actions quan trọng
- [ ] **5.1.5** Micro-animations: hero transitions, fade-in sản phẩm
- [ ] **5.1.6** Offline banner (connectivity_plus)

### 🔒 Sprint 5.2 — Security & Performance (Tuần 14)

- [ ] **5.2.1** Firestore Security Rules cơ bản (admin/user guard)
- [ ] **5.2.2** Verify webhook signatures (SePay, MoMo)
- [ ] **5.2.3** Image compression trước khi upload
- [ ] **5.2.4** Firestore query optimization (composite indexes)
- [ ] **5.2.5** Enable Firestore offline persistence

### 🧪 Sprint 5.3 — Testing & Demo Build (Tuần 14)

- [ ] **5.3.1** Unit tests cho các UseCase quan trọng (Voucher, Order, Auth)
- [ ] **5.3.2** Test thanh toán trên sandbox (SePay test mode, MoMo sandbox)
- [ ] **5.3.3** Test FCM trên thiết bị Android thực tế
- [ ] **5.3.4** Seed dữ liệu demo đầy đủ (sản phẩm, đơn hàng, reviews, vouchers)
- [ ] **5.3.5** Build APK để demo:
  ```bash
  # Debug APK (cài nhanh để demo)
  flutter build apk --debug

  # Release APK (hiệu năng tốt hơn, dùng cho CV)
  flutter build apk --release
  # Output: build/app/outputs/flutter-apk/app-release.apk
  ```
- [ ] **5.3.6** Quay video demo app (30–60 giây) để đính kèm CV
- [ ] **5.3.7** Push code lên GitHub với README đẹp:
  - Mô tả tính năng, tech stack
  - Screenshots / GIF demo
  - Link download APK (GitHub Releases)
  - Hướng dẫn chạy local

---

## Ưu Tiên Tính Năng (MoSCoW)

### Must Have (MVP)
- Xác thực (Email + Google)
- Duyệt & tìm kiếm sản phẩm
- Giỏ hàng & Đặt hàng
- Thanh toán COD
- Theo dõi đơn hàng
- Admin CRUD sản phẩm & đơn hàng

### Should Have (Phase 2)
- Thanh toán SePay & MoMo
- FCM Notifications realtime
- Admin Dashboard với charts
- Quản lý địa chỉ giao hàng

### Could Have (Phase 3-4)
- Voucher / Discount code
- Review & Rating
- Recommendation system
- Phone OTP login
- Notification broadcast

### Won't Have (lần này)
- Live chat / customer support
- Multi-vendor marketplace
- Loyalty points system
- AI-powered chatbot
- Augmented Reality try-on

---

## Phụ Thuộc & Rủi Ro

| Rủi Ro | Xác suất | Tác động | Giải pháp |
|--------|----------|----------|-----------|
| SePay webhook delay | Trung bình | Cao | Polling fallback mỗi 30s, timeout 15 phút |
| MoMo API thay đổi | Thấp | Cao | Abstraction layer, dễ swap |
| Firestore hot document (cart/popular product) | Thấp | Trung bình | Sharding nếu cần |
| FCM token expired | Cao | Thấp | Refresh token khi login, cleanup cũ |
| Voucher race condition | Trung bình | Cao | Firestore transaction atomic |
| iOS FCM foreground | Trung bình | Thấp | flutter_local_notifications config |

---

## Thứ Tự Ưu Tiên (Solo Developer)

> Đây là CV project → **1 developer**, tập trung vào những gì showcase được tốt nhất.

| Ưu tiên | Task | Lý do quan trọng với CV |
|---------|------|-------------------------|
| 🔴 Bắt buộc | Auth, Home, Product, Cart, Order | Core flow không thể thiếu |
| 🔴 Bắt buộc | Admin CRUD + Dashboard | Thể hiện kỹ năng full-stack |
| 🟡 Nên có | FCM Realtime Notification | Kỹ năng realtime nổi bật |
| 🟡 Nên có | SePay Payment + Webhook | Tích hợp payment thực tế |
| 🟢 Nếu còn thời gian | MoMo Payment | Bonus điểm |
| 🟢 Nếu còn thời gian | Voucher + Review | Advanced features |
| ⬜ Có thể bỏ | Recommendation ML | Quá phức tạp cho CV scope |

---

## Mốc Thời Gian

| Mốc | Tuần | Nội dung |
|-----|------|----------|
| 🚀 **Kickoff** | W1 | Setup xong, Firebase kết nối, design system |
| 📱 **MVP Demo** | W4 | Duyệt SP, cart, order COD, auth — **demo được rồi** |
| 💳 **Payment Ready** | W7 | SePay + MoMo + FCM hoạt động |
| 🛠️ **Admin Complete** | W9 | Admin quản lý đầy đủ |
| ⭐ **Advanced** | W13 | Voucher + Review + Recommendation rule-based |
| 🎬 **CV Demo Build** | W14 | APK release, README GitHub, video demo |

---

## Tài Nguyên Tham Khảo

| Tài nguyên | Link |
|-----------|------|
| Flutter Docs | https://docs.flutter.dev |
| Firebase Docs | https://firebase.google.com/docs |
| Riverpod Docs | https://riverpod.dev |
| go_router Docs | https://pub.dev/packages/go_router |
| SePay API Docs | https://my.sepay.vn/userapi/docs |
| MoMo API Docs | https://developers.momo.vn |
| FlutterFire CLI | https://firebase.flutter.dev/docs/overview |
| Firebase Emulator | https://firebase.google.com/docs/emulator-suite |
