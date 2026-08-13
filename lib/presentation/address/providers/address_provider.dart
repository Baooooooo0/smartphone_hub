import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/auth/auth_usecases.dart';

part 'address_provider.g.dart';

class AddressState {
  final List<Address> addresses;
  final Address? selectedAddress;
  final bool isLoading;
  final String? errorMessage;

  const AddressState({
    this.addresses = const [],
    this.selectedAddress,
    this.isLoading = false,
    this.errorMessage,
  });

  AddressState copyWith({
    List<Address>? addresses,
    Address? selectedAddress,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AddressState(
      addresses: addresses ?? this.addresses,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

@riverpod
class AddressNotifier extends _$AddressNotifier {
  @override
  AddressState build() {
    final user = ref.watch(authStateProvider).asData?.value;
    final addresses = user?.addresses ?? [];
    Address? selected;

    if (addresses.isNotEmpty) {
      selected = addresses.firstWhere(
        (a) => a.isDefault,
        orElse: () => addresses.first,
      );
    }

    return AddressState(
      addresses: addresses,
      selectedAddress: selected,
    );
  }

  String get _currentUserId {
    final user = ref.read(authStateProvider).asData?.value;
    return user?.id ?? '';
  }

  /// Thêm địa chỉ mới
  Future<bool> addAddress(Address address) async {
    final uid = _currentUserId;
    if (uid.isEmpty) return false;

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final repo = ref.read(authRepositoryProvider);
      final updatedUser = await repo.addAddress(uid, address);
      
      final addresses = updatedUser.addresses;
      Address? selected = state.selectedAddress;

      if (address.isDefault || selected == null) {
        selected = addresses.firstWhere(
          (a) => a.isDefault,
          orElse: () => addresses.isNotEmpty ? addresses.first : address,
        );
      }

      state = state.copyWith(
        addresses: addresses,
        selectedAddress: selected,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Cập nhật địa chỉ
  Future<bool> updateAddress(int index, Address address) async {
    final uid = _currentUserId;
    if (uid.isEmpty) return false;

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final repo = ref.read(authRepositoryProvider);
      final updatedUser = await repo.updateAddress(uid, index, address);
      
      final addresses = updatedUser.addresses;

      state = state.copyWith(
        addresses: addresses,
        selectedAddress: address.isDefault ? address : state.selectedAddress,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Xóa địa chỉ
  Future<bool> deleteAddress(int index) async {
    final uid = _currentUserId;
    if (uid.isEmpty) return false;

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final repo = ref.read(authRepositoryProvider);
      final updatedUser = await repo.deleteAddress(uid, index);
      
      final addresses = updatedUser.addresses;

      Address? newSelected;
      if (addresses.isNotEmpty) {
        newSelected = addresses.firstWhere(
          (a) => a.isDefault,
          orElse: () => addresses.first,
        );
      }

      state = state.copyWith(
        addresses: addresses,
        selectedAddress: newSelected,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Đặt làm mặc định
  Future<bool> setDefaultAddress(int index) async {
    final uid = _currentUserId;
    if (uid.isEmpty) return false;

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final repo = ref.read(authRepositoryProvider);
      final updatedUser = await repo.setDefaultAddress(uid, index);
      
      final addresses = updatedUser.addresses;
      final defaultAddr = addresses.firstWhere((a) => a.isDefault, orElse: () => addresses[index]);

      state = state.copyWith(
        addresses: addresses,
        selectedAddress: defaultAddr,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Chọn địa chỉ cho đơn hàng
  void selectAddress(Address address) {
    state = state.copyWith(selectedAddress: address);
  }
}
