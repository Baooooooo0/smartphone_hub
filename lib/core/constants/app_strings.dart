/// AppStrings — Chuỗi văn bản tĩnh của app SmartphoneHub
abstract class AppStrings {
  // ─── App Info ────────────────────────────────────────────────
  static const String appName = 'SmartphoneHub';
  static const String appTagline = 'Điện thoại chính hãng, giá tốt nhất';

  // ─── Auth ────────────────────────────────────────────────────
  static const String login = 'Đăng nhập';
  static const String register = 'Đăng ký';
  static const String logout = 'Đăng xuất';
  static const String forgotPassword = 'Quên mật khẩu?';
  static const String resetPassword = 'Đặt lại mật khẩu';
  static const String email = 'Email';
  static const String password = 'Mật khẩu';
  static const String confirmPassword = 'Xác nhận mật khẩu';
  static const String displayName = 'Tên hiển thị';
  static const String loginWithGoogle = 'Đăng nhập với Google';
  static const String noAccount = 'Chưa có tài khoản?';
  static const String haveAccount = 'Đã có tài khoản?';

  // ─── Navigation ──────────────────────────────────────────────
  static const String home = 'Trang chủ';
  static const String search = 'Tìm kiếm';
  static const String cart = 'Giỏ hàng';
  static const String orders = 'Đơn hàng';
  static const String profile = 'Hồ sơ';

  // ─── Product ─────────────────────────────────────────────────
  static const String products = 'Sản phẩm';
  static const String productDetail = 'Chi tiết sản phẩm';
  static const String addToCart = 'Thêm vào giỏ';
  static const String buyNow = 'Mua ngay';
  static const String description = 'Mô tả';
  static const String specifications = 'Thông số kỹ thuật';
  static const String reviews = 'Đánh giá';
  static const String outOfStock = 'Hết hàng';
  static const String inStock = 'Còn hàng';
  static const String sold = 'đã bán';

  // ─── Cart ────────────────────────────────────────────────────
  static const String emptyCart = 'Giỏ hàng trống';
  static const String emptyCartMessage = 'Hãy thêm sản phẩm vào giỏ hàng';
  static const String checkout = 'Thanh toán';
  static const String total = 'Tổng cộng';
  static const String subtotal = 'Tạm tính';

  // ─── Order ───────────────────────────────────────────────────
  static const String orderList = 'Đơn hàng của tôi';
  static const String orderDetail = 'Chi tiết đơn hàng';
  static const String placeOrder = 'Đặt hàng';
  static const String cancelOrder = 'Hủy đơn';
  static const String orderNote = 'Ghi chú đơn hàng';
  static const String shippingAddress = 'Địa chỉ giao hàng';
  static const String paymentMethod = 'Phương thức thanh toán';
  static const String emptyOrders = 'Chưa có đơn hàng nào';
  static const String emptyOrdersMessage = 'Mua sắm ngay để có đơn hàng đầu tiên';

  // ─── Payment ─────────────────────────────────────────────────
  static const String cod = 'Thanh toán khi nhận hàng (COD)';
  static const String sepaPayment = 'Chuyển khoản SePay';
  static const String momoPayment = 'Ví MoMo';
  static const String paymentSuccess = 'Thanh toán thành công';
  static const String paymentFailed = 'Thanh toán thất bại';
  static const String transferContent = 'Nội dung chuyển khoản';

  // ─── Order Status ────────────────────────────────────────────
  static const String statusPending = 'Chờ xác nhận';
  static const String statusConfirmed = 'Đã xác nhận';
  static const String statusShipping = 'Đang giao hàng';
  static const String statusDelivered = 'Đã giao hàng';
  static const String statusCancelled = 'Đã hủy';

  // ─── Common ──────────────────────────────────────────────────
  static const String loading = 'Đang tải...';
  static const String retry = 'Thử lại';
  static const String cancel = 'Hủy';
  static const String confirm = 'Xác nhận';
  static const String save = 'Lưu';
  static const String delete = 'Xóa';
  static const String edit = 'Chỉnh sửa';
  static const String close = 'Đóng';
  static const String back = 'Quay lại';
  static const String next = 'Tiếp theo';
  static const String done = 'Xong';
  static const String seeAll = 'Xem tất cả';
  static const String noResult = 'Không tìm thấy kết quả';
  static const String somethingWentWrong = 'Đã xảy ra lỗi, vui lòng thử lại';
  static const String noInternet = 'Không có kết nối internet';

  // ─── Validation ──────────────────────────────────────────────
  static const String fieldRequired = 'Trường này không được để trống';
  static const String emailInvalid = 'Email không hợp lệ';
  static const String passwordTooShort = 'Mật khẩu tối thiểu 6 ký tự';
  static const String passwordNotMatch = 'Mật khẩu không khớp';
  static const String phoneInvalid = 'Số điện thoại không hợp lệ';
}
