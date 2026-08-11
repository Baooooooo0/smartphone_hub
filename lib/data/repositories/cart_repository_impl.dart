import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/remote/cart_remote_datasource.dart';
import '../models/cart_item_model.dart';

/// CartRepositoryImpl — Implementation của CartRepository
class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource _remoteDataSource;

  CartRepositoryImpl({CartRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? CartRemoteDataSource();

  @override
  Future<CartEntity> getCart(String userId) async {
    final model = await _remoteDataSource.getCart(userId);
    return model.toEntity();
  }

  @override
  Stream<CartEntity> watchCart(String userId) {
    return _remoteDataSource.watchCart(userId).map((model) => model.toEntity());
  }

  @override
  Future<void> addToCart(String userId, CartItemEntity item) async {
    final itemModel = CartItemModel.fromEntity(item);
    await _remoteDataSource.addToCart(userId, itemModel);
  }

  @override
  Future<void> updateQuantity(
    String userId,
    String productId,
    String color,
    int quantity,
  ) async {
    await _remoteDataSource.updateQuantity(userId, productId, color, quantity);
  }

  @override
  Future<void> removeFromCart(
    String userId,
    String productId,
    String color,
  ) async {
    await _remoteDataSource.removeFromCart(userId, productId, color);
  }

  @override
  Future<void> clearCart(String userId) async {
    await _remoteDataSource.clearCart(userId);
  }
}
