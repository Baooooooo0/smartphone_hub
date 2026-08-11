import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/cart_entity.dart';
import 'cart_item_model.dart';

part 'cart_model.freezed.dart';
part 'cart_model.g.dart';

/// CartModel — DTO cho document Firestore /carts/{userId}
@freezed
abstract class CartModel with _$CartModel {
  const factory CartModel({
    required String userId,
    @Default([]) List<CartItemModel> items,
    DateTime? updatedAt,
  }) = _CartModel;

  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);

  const CartModel._();

  factory CartModel.fromFirestore(Map<String, dynamic> data, String userId) {
    final rawItems = data['items'] as List<dynamic>? ?? [];
    final itemsList = rawItems
        .map((item) => CartItemModel.fromMap(item as Map<String, dynamic>))
        .toList();

    return CartModel(
      userId: userId,
      items: itemsList,
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as dynamic).toDate() as DateTime
          : null,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'userId': userId,
        'items': items.map((e) => e.toMap()).toList(),
        'updatedAt': updatedAt ?? DateTime.now(),
      };

  CartEntity toEntity() => CartEntity(
        userId: userId,
        items: items.map((e) => e.toEntity()).toList(),
        updatedAt: updatedAt,
      );

  factory CartModel.fromEntity(CartEntity entity) => CartModel(
        userId: entity.userId,
        items: entity.items.map((e) => CartItemModel.fromEntity(e)).toList(),
        updatedAt: entity.updatedAt,
      );
}
