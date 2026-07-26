# 📱 SmartphoneHub — Instruction Guide

> Hướng dẫn phát triển toàn diện ứng dụng bán điện thoại thông minh SmartphoneHub trên nền tảng Flutter + Firebase.
> **Scope**: CV/Portfolio project — **Android only**, không publish store.

---

## 1. Tổng Quan Dự Án

**SmartphoneHub** là ứng dụng thương mại điện tử chuyên bán điện thoại di động, hỗ trợ:
- Người dùng cuối (khách hàng) mua sắm, thanh toán, theo dõi đơn hàng
- Admin quản lý sản phẩm, đơn hàng, người dùng, voucher, đánh giá
- Thông báo realtime qua Firebase Cloud Messaging (FCM)
- Thanh toán trực tuyến qua **SePay** & **MoMo**
- Các tính năng nâng cao: Voucher, Review & Rating, Recommendation

---

## 2. Công Nghệ & Thư Viện

### 2.1 Flutter & Dart

| Công nghệ        | Phiên bản    | Mục đích                       |
|-----------------|-------------|------------------------------|
| Flutter SDK     | ≥ 3.12.x    | Framework **Android** only   |
| Dart SDK        | ≥ 3.12.x    | Ngôn ngữ lập trình           |
| flutter_riverpod| ^2.x        | State Management             |
| go_router       | ^14.x       | Navigation / Deep linking    |
| freezed         | ^2.x        | Immutable data models        |
| json_serializable| ^6.x       | JSON serialization           |

### 2.2 Firebase Services

| Service                          | Mục đích                                        |
|----------------------------------|-------------------------------------------------|
| Firebase Auth                    | Xác thực (Email, Google, Phone OTP)             |
| Cloud Firestore                  | Database chính: sản phẩm, đơn hàng, users      |
| Firebase Storage                 | Lưu trữ ảnh sản phẩm, avatar                   |
| Firebase Cloud Messaging (FCM)   | Push notification realtime                      |
| Firebase Remote Config           | A/B testing, feature flags                      |
| Firebase Analytics               | Phân tích hành vi người dùng                    |
| Firebase Crashlytics             | Theo dõi lỗi production                         |
| Firebase Cloud Functions         | Serverless logic: webhook, payment, trigger     |

### 2.3 Thanh Toán

| Cổng thanh toán | Ghi chú                                                 |
|----------------|---------------------------------------------------------|
| **SePay**      | Chuyển khoản ngân hàng tự động (QR code + webhook)      |
| **MoMo**       | Ví điện tử (deeplink + IPN callback)                    |
| **COD**        | Thanh toán khi nhận hàng (mặc định ban đầu)             |

### 2.4 Packages Phụ Trợ

```yaml
dependencies:
  # Firebase
  firebase_core: ^3.x
  firebase_auth: ^5.x
  cloud_firestore: ^5.x
  firebase_storage: ^12.x
  firebase_messaging: ^15.x
  firebase_analytics: ^11.x
  firebase_crashlytics: ^4.x
  firebase_remote_config: ^5.x
  cloud_functions: ^5.x

  # State Management
  flutter_riverpod: ^2.x
  riverpod_annotation: ^2.x

  # Navigation
  go_router: ^14.x

  # Models
  freezed_annotation: ^2.x
  json_annotation: ^4.x

  # UI
  cached_network_image: ^3.x
  flutter_svg: ^2.x
  shimmer: ^3.x
  fl_chart: ^0.x          # Charts cho admin dashboard
  carousel_slider: ^5.x
  smooth_page_indicator: ^1.x
  lottie: ^3.x
  animate_do: ^3.x
  flutter_rating_bar: ^4.x

  # Utilities
  intl: ^0.19.x
  uuid: ^4.x
  url_launcher: ^6.x
  image_picker: ^1.x
  permission_handler: ^11.x
  shared_preferences: ^2.x
  flutter_local_notifications: ^17.x
  connectivity_plus: ^6.x
  dio: ^5.x
  pretty_dio_logger: ^1.x
  qr_flutter: ^4.x        # Hiển thị QR SePay

dev_dependencies:
  build_runner: ^2.x
  freezed: ^2.x
  json_serializable: ^6.x
  riverpod_generator: ^2.x
  flutter_lints: ^6.x
  mocktail: ^1.x
```

---

## 3. Kiến Trúc Ứng Dụng

### 3.1 Mô Hình: Clean Architecture + MVVM + Riverpod

```
lib/
├── core/
│   ├── constants/          # AppColors, AppStrings, AppSizes
│   ├── errors/             # Failure classes, AppException
│   ├── extensions/         # BuildContext, String, DateTime extensions
│   ├── services/           # FCM, Analytics, Crashlytics wrappers
│   ├── theme/              # AppTheme, colors, typography
│   └── utils/              # CurrencyFormatter, Validators, Helpers
│
├── data/
│   ├── datasources/
│   │   ├── remote/         # Firestore, Firebase Auth data sources
│   │   └── local/          # SharedPreferences, cache
│   ├── models/             # Data Transfer Objects (freezed + json)
│   │   ├── product_model.dart
│   │   ├── order_model.dart
│   │   ├── user_model.dart
│   │   ├── voucher_model.dart
│   │   └── ...
│   └── repositories/       # Repository implementations
│
├── domain/
│   ├── entities/           # Business entities (thuần Dart)
│   ├── repositories/       # Abstract interfaces
│   └── usecases/
│       ├── auth/
│       ├── products/
│       ├── orders/
│       ├── cart/
│       ├── voucher/
│       ├── review/
│       └── recommendation/
│
├── presentation/
│   ├── admin/
│   │   ├── dashboard/
│   │   ├── products/
│   │   ├── orders/
│   │   ├── users/
│   │   ├── vouchers/
│   │   ├── banners/
│   │   └── reviews/
│   ├── auth/
│   │   ├── login/
│   │   ├── register/
│   │   └── forgot_password/
│   ├── cart/
│   ├── checkout/
│   │   ├── checkout_screen.dart
│   │   ├── sepay_payment_screen.dart
│   │   └── momo_payment_screen.dart
│   ├── home/
│   ├── notifications/
│   ├── orders/
│   ├── product/
│   ├── profile/
│   ├── search/
│   ├── voucher/           # [Advanced]
│   ├── review/            # [Advanced]
│   └── widgets/           # Shared widgets
│
├── router/
│   └── app_router.dart    # go_router config + guards
│
└── main.dart
```

### 3.2 State Management Pattern

```dart
// Sử dụng Riverpod với code generation
@riverpod
class ProductListNotifier extends _$ProductListNotifier {
  @override
  Future<List<Product>> build() async {
    return ref.watch(productRepositoryProvider).getProducts();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
      ref.read(productRepositoryProvider).getProducts()
    );
  }
}

// Trong Widget:
final products = ref.watch(productListNotifierProvider);
products.when(
  data: (list) => ProductGrid(products: list),
  loading: () => const ShimmerGrid(),
  error: (e, st) => ErrorWidget(error: e),
);
```

---

## 4. Cấu Trúc Dữ Liệu Firestore

### 4.1 Collections Schema

```
/users/{userId}
  id: string
  email: string
  displayName: string
  photoURL: string
  phoneNumber: string
  role: "customer" | "admin"
  addresses: List<Address>
    { label, recipientName, phone, street, ward, district, province, isDefault }
  createdAt: timestamp
  fcmTokens: List<string>        # Cập nhật mỗi lần login

/products/{productId}
  id: string
  name: string
  brand: string                  # Apple, Samsung, Xiaomi, OPPO...
  category: string               # smartphone, tablet, accessory
  description: string
  price: number
  discountPrice: number
  images: List<string>           # Firebase Storage URLs
  specs: Map<string, string>     # { cpu, ram, storage, camera, battery, screen }
  colors: List<string>           # ["Đen", "Trắng", "Xanh"]
  stock: number
  sold: number
  rating: number                 # Trung bình, cập nhật bởi Cloud Function
  reviewCount: number
  tags: List<string>             # ["flagship", "5g", "gaming"]
  isActive: boolean
  isFeatured: boolean
  createdAt: timestamp
  updatedAt: timestamp

/products/{productId}/reviews/{reviewId}
  id: string
  userId: string
  userName: string
  userAvatar: string
  rating: number                 # 1-5
  comment: string
  images: List<string>
  orderId: string                # Verify đã mua
  createdAt: timestamp
  isVerified: boolean            # Đã mua → true
  isHidden: boolean              # Admin ẩn

/orders/{orderId}
  id: string
  userId: string
  items: List<OrderItem>
    { productId, productName, productImage, color, price, quantity }
  subtotal: number
  discount: number               # Giảm từ voucher
  shippingFee: number
  total: number
  status: "pending" | "confirmed" | "shipping" | "delivered" | "cancelled"
  paymentMethod: "sepay" | "momo" | "cod"
  paymentStatus: "unpaid" | "paid" | "refunded"
  paymentRef: string             # Transaction ref từ SePay/MoMo
  shippingAddress: Address
  voucherId: string?
  voucherCode: string?
  note: string
  createdAt: timestamp
  updatedAt: timestamp
  timeline: List<OrderEvent>
    { status, note, timestamp }

/carts/{userId}
  items: List<CartItem>
    { productId, productName, productImage, price, color, quantity, addedAt }

/vouchers/{voucherId}
  id: string
  code: string                   # Unique, uppercase
  type: "percent" | "fixed"
  value: number                  # % hoặc VNĐ
  minOrderValue: number
  maxDiscount: number            # Giảm tối đa (cho percent)
  usageLimit: number             # 0 = không giới hạn
  usedCount: number
  userLimit: number              # Mỗi user dùng tối đa n lần
  startDate: timestamp
  endDate: timestamp
  isActive: boolean
  applicableProducts: List<string>?  # null = tất cả

/vouchers/{voucherId}/usages/{userId}
  userId: string
  usedCount: number
  lastUsedAt: timestamp

/notifications/{userId}/items/{notifId}
  id: string
  title: string
  body: string
  type: "order_update" | "payment" | "promotion" | "system"
  data: Map<string, dynamic>    # { orderId, productId, ... }
  isRead: boolean
  imageURL: string?
  createdAt: timestamp

/banners/{bannerId}
  id: string
  imageURL: string
  targetType: "product" | "category" | "external_url"
  targetId: string
  isActive: boolean
  order: number

/categories/{categoryId}
  id: string
  name: string
  iconURL: string
  order: number
  productCount: number

/app_config/settings
  freeShippingThreshold: number
  defaultShippingFee: number
  hotlineNumber: string
  maintenanceMode: boolean
  currentVersion: string
  forceUpdateVersion: string
```

---

## 5. Tích Hợp Thanh Toán

### 5.1 SePay — Chuyển Khoản Ngân Hàng

**Flow thanh toán:**
```
User chọn SePay
    → App tạo order (status: "pending", paymentStatus: "unpaid")
    → Sinh nội dung chuyển khoản = "SPHHUB" + orderId (viết tắt)
    → Hiển thị QR code + thông tin ngân hàng
    → User chuyển khoản trong app ngân hàng
    → SePay nhận giao dịch → Gọi webhook → Cloud Function
    → Cloud Function verify content + amount
    → Cập nhật order: paymentStatus="paid", status="confirmed"
    → Gửi FCM notification đến user
    → App lắng nghe Firestore realtime → Cập nhật UI
```

**QR Code URL SePay:**
```dart
String buildSepayQR({
  required String bankCode,      // VCB, TCB, MB...
  required String accountNumber,
  required String accountName,
  required double amount,
  required String content,       // nội dung chuyển khoản
}) {
  return 'https://qr.sepay.vn/img?acc=$accountNumber'
      '&bank=$bankCode'
      '&amount=${amount.toInt()}'
      '&des=${Uri.encodeComponent(content)}'
      '&template=compact';
}
```

**Cloud Function Webhook:**
```javascript
// functions/src/sepayWebhook.js
exports.sepayWebhook = onRequest(async (req, res) => {
  // 1. Verify SePay signature header
  // 2. Parse content → extract orderId
  // 3. Load order từ Firestore, verify amount
  // 4. Update paymentStatus = "paid", status = "confirmed"
  // 5. Ghi paymentRef = transaction ID
  // 6. Send FCM notification to user
  // 7. Return 200 OK
});
```

### 5.2 MoMo — Ví Điện Tử

**Flow thanh toán:**
```
User chọn MoMo
    → Gọi Cloud Function: createMomoPayment(orderId, amount)
    → Cloud Function gọi MoMo API /v2/gateway/api/create
    → Nhận deeplink/payUrl từ MoMo
    → App mở MoMo via url_launcher
    → User xác nhận thanh toán trong app MoMo
    → MoMo gọi IPN URL → Cloud Function momoIPN
    → Verify HMAC-SHA256 signature
    → Update order trong Firestore
    → Gửi FCM notification
    → App nhận MoMo return URL → Navigate về order detail
```

**Tạo thanh toán MoMo (Cloud Function):**
```javascript
exports.createMomoPayment = onCall(async (request) => {
  const { orderId, amount } = request.data;
  const rawSignature = `accessKey=${ACCESS_KEY}&amount=${amount}`
    + `&extraData=&ipnUrl=${IPN_URL}&orderId=${orderId}`
    + `&orderInfo=Thanh toan don hang ${orderId}`
    + `&partnerCode=${PARTNER_CODE}&redirectUrl=${RETURN_URL}`
    + `&requestId=${orderId}&requestType=payWithDeeplink`;
  const signature = crypto.createHmac('sha256', SECRET_KEY)
    .update(rawSignature).digest('hex');
  // POST to MoMo API → return deeplink
});
```

---

## 6. Thông Báo Realtime (FCM)

### 6.1 Setup & Initialization

```dart
// core/services/notification_service.dart
class NotificationService {
  static final _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  Future<void> initialize(BuildContext context) async {
    // 1. Yêu cầu quyền
    await FirebaseMessaging.instance.requestPermission(
      alert: true, badge: true, sound: true,
    );

    // 2. Lấy FCM token, lưu vào Firestore
    final token = await FirebaseMessaging.instance.getToken();
    await _saveToken(token!);

    // 3. Lắng nghe token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen(_saveToken);

    // 4. Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForeground);

    // 5. Background tap → navigate
    FirebaseMessaging.onMessageOpenedApp.listen(_handleTap);

    // 6. Terminated state tap
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) _handleTap(initial);
  }

  void _handleForeground(RemoteMessage message) {
    // Hiển thị flutter_local_notifications
  }

  void _handleTap(RemoteMessage message) {
    final type = message.data['type'];
    // Navigate dựa trên type: order → OrderDetailScreen, etc.
  }

  Future<void> _saveToken(String token) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'fcmTokens': FieldValue.arrayUnion([token]),
    });
  }
}
```

### 6.2 Bảng Loại Thông Báo

| Type             | Trigger                         | Nội dung                                   |
|------------------|---------------------------------|--------------------------------------------|
| order_confirmed  | Admin xác nhận đơn              | "Đơn hàng #XXX đã được xác nhận"           |
| order_shipping   | Admin cập nhật đang giao        | "Đơn hàng #XXX đang được giao đến bạn"     |
| order_delivered  | Giao thành công                 | "Đơn hàng #XXX đã được giao thành công"    |
| order_cancelled  | Hủy đơn (admin/user)            | "Đơn hàng #XXX đã bị hủy"                  |
| payment_success  | SePay/MoMo webhook              | "Thanh toán đơn #XXX thành công ✓"         |
| new_voucher      | Admin tạo voucher mới           | "Mã giảm giá mới: SAVE50 - Giảm 50k"       |
| promotion        | Admin broadcast                 | "Flash sale 12.12 - Giảm đến 30%"          |
| review_reply     | Admin reply review              | "Admin đã phản hồi đánh giá của bạn"       |

---

## 7. Admin Screen

### 7.1 Danh Sách Màn Hình Admin

| Screen                | Chức năng chính                                                |
|-----------------------|----------------------------------------------------------------|
| **Dashboard**         | Tổng doanh thu, đơn hàng hôm nay, top sản phẩm, biểu đồ fl_chart |
| **Product Management**| CRUD sản phẩm, upload nhiều ảnh, quản lý màu sắc & tồn kho    |
| **Order Management**  | Danh sách đơn, filter theo status, cập nhật trạng thái + gửi FCM |
| **User Management**   | Danh sách users, block, cấp quyền admin                        |
| **Voucher Management**| Tạo/sửa/xóa voucher, xem thống kê sử dụng                     |
| **Banner Management** | Upload banner, sắp xếp thứ tự, chọn target                    |
| **Review Management** | Xem review, ẩn/hiện, phản hồi                                  |
| **Broadcast Notif**   | Gửi thông báo đến tất cả user / nhóm user                     |

### 7.2 Route Guard cho Admin

```dart
// router/app_router.dart
redirect: (context, state) {
  final user = ref.read(authStateProvider).value;
  if (user == null) return '/login';

  final isAdminRoute = state.matchedLocation.startsWith('/admin');
  if (isAdminRoute) {
    final userDoc = ref.read(currentUserProvider).value;
    if (userDoc?.role != 'admin') return '/home';
  }
  return null;
},
```

### 7.3 Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function isAdmin() {
      return request.auth != null &&
        get(/databases/$(database)/documents/users/$(request.auth.uid))
          .data.role == 'admin';
    }
    function isAuth() { return request.auth != null; }
    function isOwner(uid) { return request.auth.uid == uid; }

    match /products/{productId} {
      allow read: if true;
      allow write: if isAdmin();

      match /reviews/{reviewId} {
        allow read: if true;
        allow create: if isAuth();
        allow update: if isAdmin();
        allow delete: if isAdmin() || isOwner(resource.data.userId);
      }
    }

    match /orders/{orderId} {
      allow read: if isAuth() &&
        (isOwner(resource.data.userId) || isAdmin());
      allow create: if isAuth();
      allow update: if isAdmin() ||
        (isOwner(resource.data.userId) &&
         request.resource.data.status == 'cancelled');
    }

    match /carts/{userId} {
      allow read, write: if isOwner(userId);
    }

    match /users/{userId} {
      allow read: if isOwner(userId) || isAdmin();
      allow write: if isOwner(userId);
    }

    match /vouchers/{voucherId} {
      allow read: if isAuth();
      allow write: if isAdmin();
      match /usages/{userId} {
        allow read: if isOwner(userId) || isAdmin();
        allow write: if isOwner(userId);
      }
    }

    match /notifications/{userId}/items/{notifId} {
      allow read, write: if isOwner(userId);
    }

    match /banners/{bannerId} {
      allow read: if true;
      allow write: if isAdmin();
    }

    match /categories/{categoryId} {
      allow read: if true;
      allow write: if isAdmin();
    }

    match /app_config/{doc} {
      allow read: if true;
      allow write: if isAdmin();
    }
  }
}
```

---

## 8. Advanced Features (Phát Triển Sau)

### 8.1 Voucher / Discount Code

**Validate Voucher UseCase:**
```dart
class ValidateVoucherUseCase {
  Future<Either<Failure, VoucherDiscount>> execute({
    required String code,
    required double orderSubtotal,
    required List<String> productIds,
    required String userId,
  }) async {
    final voucher = await _repo.getVoucherByCode(code);
    // Kiểm tra theo thứ tự:
    // 1. Tồn tại và isActive
    // 2. Trong thời hạn startDate ~ endDate
    // 3. orderSubtotal >= minOrderValue
    // 4. usedCount < usageLimit (nếu có giới hạn)
    // 5. User usage < userLimit
    // 6. Sản phẩm thuộc applicableProducts (nếu có)
    // → Tính discount: percent hoặc fixed, không vượt maxDiscount
  }
}
```

**Atomic apply voucher khi đặt hàng (Cloud Function):**
```javascript
exports.createOrder = onCall(async (request) => {
  return db.runTransaction(async (transaction) => {
    if (voucherCode) {
      const voucherRef = db.collection('vouchers').doc(voucherId);
      const usageRef = voucherRef.collection('usages').doc(userId);
      // Check và increment atomically
    }
    // Create order document
  });
});
```

### 8.2 Review & Rating

**Quy tắc:**
- Chỉ user có đơn hàng `delivered` chứa `productId` mới được review
- Mỗi (userId, productId, orderId) chỉ được review 1 lần
- Rating 1-5 sao + comment (bắt buộc) + ảnh (tùy chọn, tối đa 3 ảnh)
- Hiển thị badge "Đã mua hàng" cho verified reviews

**Cloud Function cập nhật rating sản phẩm:**
```javascript
exports.recalculateRating = onDocumentWritten(
  'products/{productId}/reviews/{reviewId}',
  async (event) => {
    const productRef = db.collection('products').doc(event.params.productId);
    const reviewsSnap = await productRef.collection('reviews')
      .where('isHidden', '==', false).get();
    const ratings = reviewsSnap.docs.map(d => d.data().rating);
    const avg = ratings.reduce((a, b) => a + b, 0) / ratings.length;
    await productRef.update({
      rating: Math.round(avg * 10) / 10,
      reviewCount: ratings.length,
    });
  }
);
```

### 8.3 Recommendation System

**Phase 1 — Rule-based (chỉ dùng Firestore):**

```dart
class RecommendationService {
  // "Sản phẩm tương tự"
  Future<List<Product>> getSimilarProducts(Product product) =>
    _repo.queryProducts(
      brand: product.brand,
      category: product.category,
      excludeId: product.id,
      sortBy: 'rating',
      limit: 6,
    );

  // "Sản phẩm bán chạy"
  Future<List<Product>> getBestSellers() =>
    _repo.queryProducts(sortBy: 'sold', limit: 10);

  // "Gợi ý theo giá"
  Future<List<Product>> getInPriceRange(double price) =>
    _repo.queryProducts(
      minPrice: price * 0.7,
      maxPrice: price * 1.3,
      sortBy: 'rating',
      limit: 6,
    );

  // "Xem gần đây" — từ local storage
  Future<List<Product>> getRecentlyViewed() async {
    final ids = await _localRepo.getRecentlyViewedIds();
    return _repo.getProductsByIds(ids);
  }
}
```

**Phase 2 — Collaborative Filtering (nâng cao):**
- Dùng Firebase Extensions: **"Recommend with Vertex AI"**
- Hoặc tự build: Phân tích co-purchase matrix từ orders collection
- Export sang BigQuery → chạy ML model → import results về Firestore

---

## 9. Quy Trình Phát Triển

### 9.1 Git Branching

```
main          → Production (protected, chỉ merge từ release/*)
develop       → Staging / Integration
feature/*     → Tính năng mới (VD: feature/payment-momo)
bugfix/*      → Sửa lỗi
hotfix/*      → Fix khẩn cấp trên main
release/*     → Chuẩn bị release (version bump, changelog)
```

### 9.2 Commit Convention

```
feat: thêm tính năng mới
fix: sửa bug
refactor: refactor code không thay đổi behavior
docs: cập nhật documentation
test: thêm/sửa tests
chore: cập nhật dependencies, config
```

### 9.3 Environment Setup

```bash
# 1. Cài Flutter
# https://docs.flutter.dev/get-started/install/windows

# 2. Kiểm tra chỉ chạy Android
flutter devices   # Sẽ thấy Android emulator hoặc thiết bị thực

# 3. Cài Firebase CLI & FlutterFire CLI
npm install -g firebase-tools
dart pub global activate flutterfire_cli

# 4. Login Firebase
firebase login

# 5. Cài Flutter dependencies
flutter pub get

# 6. Sinh code (freezed, riverpod, json_serializable)
dart run build_runner build --delete-conflicting-outputs

# 7. Chạy app trên Android
flutter run

# 8. Build APK để demo CV
flutter build apk --release
# APK output: build/app/outputs/flutter-apk/app-release.apk
```

### 9.4 Cloud Functions Setup

```bash
cd functions
npm install
firebase emulators:start   # Test locally
firebase deploy --only functions
```

---

## 10. Cấu Hình Bảo Mật

### 10.1 Firebase Project Setup
1. Tạo Firebase project: `smartphonehub-dev` (free Spark plan đủ dùng cho CV)
2. Enable: Authentication, Firestore, Storage, FCM, Analytics, Crashlytics
3. Tải `google-services.json` → `android/app/`
4. Chạy `flutterfire configure` → chọn **chỉ Android** → tạo `firebase_options.dart`

### 10.2 Biến Môi Trường

Tạo file `.env` (KHÔNG commit vào git — thêm vào `.gitignore`):
```env
SEPAY_API_TOKEN=
SEPAY_BANK_ACCOUNT=
SEPAY_BANK_CODE=
SEPAY_WEBHOOK_SECRET=

MOMO_PARTNER_CODE=
MOMO_ACCESS_KEY=
MOMO_SECRET_KEY=
MOMO_IPN_URL=https://us-central1-your-project.cloudfunctions.net/momoIPN
MOMO_RETURN_URL=smartphonehub://payment/return
```

Lưu secrets vào Firebase Cloud Functions:
```bash
firebase functions:secrets:set SEPAY_API_TOKEN
firebase functions:secrets:set MOMO_SECRET_KEY
```

### 10.3 Deep Link Setup (MoMo Return URL)

**Android only** — `android/app/src/main/AndroidManifest.xml`:
```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data android:scheme="smartphonehub" android:host="payment" />
</intent-filter>
```

---

## 11. Testing Strategy

| Loại Test         | Tool                          | Phạm vi                              |
|-------------------|-------------------------------|--------------------------------------|
| Unit Test         | flutter_test + mocktail       | UseCase, Repository, Service         |
| Widget Test       | flutter_test                  | Widget rendering, interaction        |
| Integration Test  | integration_test              | E2E user flows                       |
| Firebase Emulator | Firebase Local Emulator Suite | Firestore rules, Cloud Functions     |

```bash
# Chạy unit tests
flutter test

# Chạy integration tests
flutter test integration_test/

# Firebase Emulator
firebase emulators:start --only firestore,functions,auth
```

---

## 12. Performance Best Practices

1. **Pagination**: Dùng `startAfterDocument` cho danh sách sản phẩm & đơn hàng (pageSize = 20)
2. **Image Caching**: `CachedNetworkImage` với memory & disk cache
3. **Shimmer Loading**: Thay thế CircularProgressIndicator bằng Shimmer effect
4. **Firestore Offline**: Kích hoạt persistent cache
   ```dart
   FirebaseFirestore.instance.settings = const Settings(
     persistenceEnabled: true,
     cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
   );
   ```
5. **Lazy Loading**: Dùng `ListView.builder` hoặc `SliverList`
6. **Riverpod `keepAlive`**: Giữ cache provider cho data ít thay đổi (categories, banners)
7. **Firebase Indexes**: Tạo composite indexes cho các query phức tạp

---

## 13. Checklist CV Demo

### Bảo Mật (cơ bản cho CV)
- [ ] Firestore Security Rules phân biệt admin/user rõ ràng
- [ ] API keys/secrets không hardcode trong code (dùng Firebase Secrets)
- [ ] SePay webhook verify signature
- [ ] MoMo IPN verify HMAC-SHA256
- [ ] Admin routes được bảo vệ cả UI lẫn Firestore Rules

### Chức Năng
- [ ] FCM hoạt động ở cả 3 trạng thái (foreground, background, terminated) trên Android
- [ ] Thanh toán SePay: QR hiển thị đúng, webhook cập nhật đúng
- [ ] Thanh toán MoMo: deeplink hoạt động, IPN cập nhật đúng
- [ ] Voucher: validate đúng các trường hợp edge case
- [ ] Review: chỉ user đã mua mới review được
- [ ] Admin có thể CRUD sản phẩm, đơn hàng, voucher

### CV Showcase Checklist
- [ ] Seed dữ liệu demo đầy đủ (ít nhất 20 sản phẩm, 5+ đơn hàng mẫu)
- [ ] Build APK release chạy được trên Android thực
- [ ] README GitHub đẹp với screenshots và GIF/video demo
- [ ] Video demo 30–60 giây quay được luồng mua hàng + admin
- [ ] Code sạch, có comment, đúng architecture rõ ràng (quan trọng nhất!)
- [ ] Cart sync giữa nhiều thiết bị

### UX & Performance
- [ ] Error handling và empty states đầy đủ
- [ ] Offline mode hoạt động (Firestore cache)
- [ ] Image loading với placeholder và error fallback
- [ ] Pagination cho danh sách dài
- [ ] Loading states không block UI

### Monitoring
- [ ] Firebase Crashlytics kích hoạt
- [ ] Firebase Analytics events tracking
- [ ] App test trên cả Android (API 21+) và iOS (14+)
- [ ] Test trên nhiều kích thước màn hình
