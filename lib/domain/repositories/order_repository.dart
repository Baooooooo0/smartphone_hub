import '../entities/order_entity.dart';

abstract class OrderRepository {
  /// Tạo đơn hàng mới
  Future<String> createOrder(OrderEntity order);

  /// Lấy thông tin đơn hàng theo ID
  Future<OrderEntity?> getOrderById(String orderId);

  /// Lấy thông tin đơn hàng theo ID (realtime stream)
  Stream<OrderEntity?> watchOrderById(String orderId);

  /// Lấy danh sách đơn hàng của người dùng (realtime stream)
  Stream<List<OrderEntity>> watchUserOrders(String userId);

  /// Hủy đơn hàng (khi đang pending)
  Future<void> cancelOrder(String orderId, {String? reason});
}
