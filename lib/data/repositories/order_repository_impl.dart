import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/remote/order_remote_datasource.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource _remoteDataSource;

  OrderRepositoryImpl({OrderRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? OrderRemoteDataSource();

  @override
  Future<String> createOrder(OrderEntity order) async {
    final model = OrderModel.fromEntity(order);
    return await _remoteDataSource.createOrder(model);
  }

  @override
  Future<OrderEntity?> getOrderById(String orderId) async {
    final model = await _remoteDataSource.getOrderById(orderId);
    return model?.toEntity();
  }

  @override
  Stream<List<OrderEntity>> watchUserOrders(String userId) {
    return _remoteDataSource
        .watchUserOrders(userId)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<void> cancelOrder(String orderId, {String? reason}) async {
    await _remoteDataSource.cancelOrder(orderId, reason: reason);
  }
}
