import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/order_model.dart';

class OrderRemoteDataSource {
  final FirebaseFirestore _firestore;

  OrderRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _ordersRef =>
      _firestore.collection('orders');

  /// Tạo đơn hàng mới trong Firestore
  Future<String> createOrder(OrderModel orderModel) async {
    final docRef = _ordersRef.doc(orderModel.id.isNotEmpty ? orderModel.id : null);
    final id = docRef.id;

    final updatedModel = orderModel.copyWith(
      id: id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      timeline: [
        OrderEventModel(
          status: orderModel.status,
          note: 'Đơn hàng đã được khởi tạo',
          timestamp: DateTime.now(),
        ),
      ],
    );

    await docRef.set(updatedModel.toFirestore());
    return id;
  }

  /// Lấy chi tiết đơn hàng
  Future<OrderModel?> getOrderById(String orderId) async {
    final doc = await _ordersRef.doc(orderId).get();
    if (!doc.exists || doc.data() == null) return null;
    return OrderModel.fromFirestore(doc.data()!, doc.id);
  }

  /// Stream chi tiết một đơn hàng theo orderId (realtime)
  Stream<OrderModel?> watchOrderById(String orderId) {
    return _ordersRef.doc(orderId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return OrderModel.fromFirestore(doc.data()!, doc.id);
    });
  }

  /// Stream danh sách đơn hàng của người dùng theo userId
  Stream<List<OrderModel>> watchUserOrders(String userId) {
    return _ordersRef
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final orders = snapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc.data(), doc.id))
          .toList();
      // Sắp xếp đơn hàng mới nhất lên đầu trong bộ nhớ (tránh lỗi require composite index)
      orders.sort((a, b) {
        final aTime = a.createdAt ?? DateTime(0);
        final bTime = b.createdAt ?? DateTime(0);
        return bTime.compareTo(aTime);
      });
      return orders;
    });
  }

  /// Hủy đơn hàng
  Future<void> cancelOrder(String orderId, {String? reason}) async {
    final docRef = _ordersRef.doc(orderId);
    final doc = await docRef.get();
    if (!doc.exists) return;

    final existingOrder = OrderModel.fromFirestore(doc.data()!, doc.id);
    final updatedTimeline = List<OrderEventModel>.from(existingOrder.timeline)
      ..add(
        OrderEventModel(
          status: 'cancelled',
          note: reason ?? 'Người dùng đã hủy đơn hàng',
          timestamp: DateTime.now(),
        ),
      );

    await docRef.update({
      'status': 'cancelled',
      'updatedAt': FieldValue.serverTimestamp(),
      'timeline': updatedTimeline.map((e) => e.toJson()).toList(),
    });
  }
}
