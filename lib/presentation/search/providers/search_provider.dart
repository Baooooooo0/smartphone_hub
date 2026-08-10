import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/entities/product_entity.dart';
import '../../../domain/entities/product_filter.dart';
import '../../../domain/usecases/products/product_usecases.dart';

part 'search_provider.g.dart';

const String _kSearchHistoryKey = 'search_history_items';

// ─── Search History Notifier ──────────────────────────────────────────────────
@riverpod
class SearchHistory extends _$SearchHistory {
  @override
  List<String> build() {
    _loadHistory();
    return const [];
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_kSearchHistoryKey) ?? [];
    state = history;
  }

  Future<void> addQuery(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final current = List<String>.from(state);
    current.removeWhere((item) => item.toLowerCase() == trimmed.toLowerCase());
    current.insert(0, trimmed);

    if (current.length > 10) {
      current.removeLast();
    }

    state = current;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kSearchHistoryKey, current);
  }

  Future<void> removeQuery(String query) async {
    final current = List<String>.from(state);
    current.remove(query);
    state = current;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kSearchHistoryKey, current);
  }

  Future<void> clearHistory() async {
    state = const [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kSearchHistoryKey);
  }
}

// ─── Search State & Notifier ──────────────────────────────────────────────────
class SearchState {
  final String query;
  final bool isLoading;
  final List<ProductEntity> results;
  final ProductFilter filter;
  final ProductSort sort;
  final String? errorMessage;

  const SearchState({
    this.query = '',
    this.isLoading = false,
    this.results = const [],
    this.filter = const ProductFilter(),
    this.sort = ProductSort.newest,
    this.errorMessage,
  });

  SearchState copyWith({
    String? query,
    bool? isLoading,
    List<ProductEntity>? results,
    ProductFilter? filter,
    ProductSort? sort,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SearchState(
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
      results: results ?? this.results,
      filter: filter ?? this.filter,
      sort: sort ?? this.sort,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

@riverpod
class SearchNotifier extends _$SearchNotifier {
  Timer? _debounceTimer;

  @override
  SearchState build() {
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });
    return const SearchState();
  }

  /// Khi thay đổi từ khóa nhập vào (với Debounce 300ms)
  void onQueryChanged(String newQuery) {
    state = state.copyWith(query: newQuery);

    _debounceTimer?.cancel();
    if (newQuery.trim().isEmpty) {
      state = state.copyWith(results: [], isLoading: false);
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch();
    });
  }

  /// Thực hiện tìm kiếm
  Future<void> _performSearch() async {
    final queryText = state.query.trim().toLowerCase();
    if (queryText.isEmpty) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repo = ref.read(productRepositoryProvider);
      final (items, _) = await repo.getProducts(
        filter: state.filter,
        sort: state.sort,
        pageSize: 50,
      );

      // Filter client-side theo từ khóa tên/thương hiệu/danh mục/tags
      final filteredResults = items.where((product) {
        final nameMatch = product.name.toLowerCase().contains(queryText);
        final brandMatch = product.brand.toLowerCase().contains(queryText);
        final categoryMatch = product.category.toLowerCase().contains(queryText);
        final tagMatch = product.tags.any((tag) => tag.toLowerCase().contains(queryText));
        return nameMatch || brandMatch || categoryMatch || tagMatch;
      }).toList();

      state = state.copyWith(
        results: filteredResults,
        isLoading: false,
      );

      // Thêm từ khóa vào lịch sử
      ref.read(searchHistoryProvider.notifier).addQuery(queryText);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Áp dụng bộ lọc mới
  void applyFilter(ProductFilter newFilter) {
    state = state.copyWith(filter: newFilter);
    if (state.query.isNotEmpty) {
      _performSearch();
    }
  }

  /// Áp dụng sắp xếp mới
  void applySort(ProductSort newSort) {
    state = state.copyWith(sort: newSort);
    if (state.query.isNotEmpty) {
      _performSearch();
    }
  }
}
