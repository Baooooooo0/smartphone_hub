// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AddressNotifier)
final addressProvider = AddressNotifierProvider._();

final class AddressNotifierProvider
    extends $NotifierProvider<AddressNotifier, AddressState> {
  AddressNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addressProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addressNotifierHash();

  @$internal
  @override
  AddressNotifier create() => AddressNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddressState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddressState>(value),
    );
  }
}

String _$addressNotifierHash() => r'91ceeb054d9858214f651af33bb35793579162f4';

abstract class _$AddressNotifier extends $Notifier<AddressState> {
  AddressState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AddressState, AddressState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AddressState, AddressState>,
              AddressState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
