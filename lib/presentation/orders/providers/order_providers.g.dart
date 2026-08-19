// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userOrdersStream)
final userOrdersStreamProvider = UserOrdersStreamProvider._();

final class UserOrdersStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<OrderEntity>>,
          List<OrderEntity>,
          Stream<List<OrderEntity>>
        >
    with
        $FutureModifier<List<OrderEntity>>,
        $StreamProvider<List<OrderEntity>> {
  UserOrdersStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userOrdersStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userOrdersStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<OrderEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<OrderEntity>> create(Ref ref) {
    return userOrdersStream(ref);
  }
}

String _$userOrdersStreamHash() => r'1b1e4e08187482c5b4081d62e29e7bf357c52b4d';

@ProviderFor(orderDetailStream)
final orderDetailStreamProvider = OrderDetailStreamFamily._();

final class OrderDetailStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<OrderEntity?>,
          OrderEntity?,
          Stream<OrderEntity?>
        >
    with $FutureModifier<OrderEntity?>, $StreamProvider<OrderEntity?> {
  OrderDetailStreamProvider._({
    required OrderDetailStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'orderDetailStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$orderDetailStreamHash();

  @override
  String toString() {
    return r'orderDetailStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<OrderEntity?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<OrderEntity?> create(Ref ref) {
    final argument = this.argument as String;
    return orderDetailStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderDetailStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$orderDetailStreamHash() => r'3ae111dca143f5581bc291c0d66ea80069fd8680';

final class OrderDetailStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<OrderEntity?>, String> {
  OrderDetailStreamFamily._()
    : super(
        retry: null,
        name: r'orderDetailStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  OrderDetailStreamProvider call(String orderId) =>
      OrderDetailStreamProvider._(argument: orderId, from: this);

  @override
  String toString() => r'orderDetailStreamProvider';
}

@ProviderFor(OrderFilterIndex)
final orderFilterIndexProvider = OrderFilterIndexProvider._();

final class OrderFilterIndexProvider
    extends $NotifierProvider<OrderFilterIndex, int> {
  OrderFilterIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderFilterIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderFilterIndexHash();

  @$internal
  @override
  OrderFilterIndex create() => OrderFilterIndex();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$orderFilterIndexHash() => r'026496abfe6e94e679fb6e2d7022dea4eba8bc3d';

abstract class _$OrderFilterIndex extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(OrderActionNotifier)
final orderActionProvider = OrderActionNotifierProvider._();

final class OrderActionNotifierProvider
    extends $NotifierProvider<OrderActionNotifier, OrderActionState> {
  OrderActionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderActionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderActionNotifierHash();

  @$internal
  @override
  OrderActionNotifier create() => OrderActionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrderActionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrderActionState>(value),
    );
  }
}

String _$orderActionNotifierHash() =>
    r'4fa518317d7329b1f7ed203af6904817e06d66b7';

abstract class _$OrderActionNotifier extends $Notifier<OrderActionState> {
  OrderActionState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<OrderActionState, OrderActionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OrderActionState, OrderActionState>,
              OrderActionState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
