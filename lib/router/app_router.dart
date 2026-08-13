import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/entities/user_entity.dart';
import '../domain/usecases/auth/auth_usecases.dart';
import '../presentation/address/address_list_screen.dart';
import '../presentation/auth/login/login_screen.dart';
import '../presentation/auth/register/register_screen.dart';
import '../presentation/auth/forgot_password/forgot_password_screen.dart';
import '../presentation/cart/cart_screen.dart';
import '../presentation/checkout/checkout_screen.dart';
import '../presentation/home/home_screen.dart';
import '../presentation/orders/order_detail_screen.dart';
import '../presentation/orders/order_list_screen.dart';
import '../presentation/product/detail/product_detail_screen.dart';
import '../presentation/product/list/product_list_screen.dart';
import '../presentation/search/search_screen.dart';


part 'app_router.g.dart';

// ─── Route Paths ──────────────────────────────────────────────────────────────
abstract class AppRoutes {
  // Auth
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main (Customer)
  static const String home = '/home';
  static const String productList = '/products';
  static const String productDetail = '/products/:id';
  static const String search = '/search';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String sepaPayment = '/checkout/sepay';
  static const String momoPayment = '/checkout/momo';
  static const String orderList = '/orders';
  static const String orderDetail = '/orders/:id';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String addresses = '/profile/addresses';
  static const String notifications = '/notifications';
  static const String vouchers = '/vouchers';
  static const String writeReview = '/review/write';

  // Admin
  static const String adminDashboard = '/admin';
  static const String adminProducts = '/admin/products';
  static const String adminProductForm = '/admin/products/form';
  static const String adminOrders = '/admin/orders';
  static const String adminOrderDetail = '/admin/orders/:id';
  static const String adminUsers = '/admin/users';
  static const String adminVouchers = '/admin/vouchers';
  static const String adminBanners = '/admin/banners';
  static const String adminReviews = '/admin/reviews';
}

// ─── Router Notifier ──────────────────────────────────────────────────────────
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<AsyncValue<UserEntity?>>(
      authStateProvider,
      (previous, next) => notifyListeners(),
    );
  }
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

// ─── Router Provider ──────────────────────────────────────────────────────────
@riverpod
GoRouter appRouter(Ref ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    refreshListenable: notifier,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final authAsync = ref.read(authStateProvider);
      return _redirect(context, state, authAsync);
    },
    routes: [
      // ── Auth Screens ─────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const _SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // ── Main Shell (Bottom Navigation) ───────────────────
      ShellRoute(
        builder: (context, state, child) => _MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.search,
            name: 'search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: AppRoutes.cart,
            name: 'cart',
            builder: (context, state) => const CartScreen(),
          ),
          GoRoute(
            path: AppRoutes.orderList,
            name: 'orderList',
            builder: (context, state) => const OrderListScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) =>
                const _Placeholder(label: 'Profile Screen'),
          ),
        ],
      ),

      // ── Product ──────────────────────────────────────────
      GoRoute(
        path: AppRoutes.productList,
        name: 'productList',
        builder: (context, state) {
          final categoryId = state.uri.queryParameters['category'];
          final title = state.uri.queryParameters['title'];
          return ProductListScreen(
            categoryId: categoryId,
            title: title,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.productDetail,
        name: 'productDetail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProductDetailScreen(productId: id);
        },
      ),

      // ── Checkout / Payment ───────────────────────────────
      GoRoute(
        path: AppRoutes.checkout,
        name: 'checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: AppRoutes.sepaPayment,
        name: 'sepaPayment',
        builder: (context, state) =>
            const _Placeholder(label: 'SePay Payment Screen'),
      ),
      GoRoute(
        path: AppRoutes.momoPayment,
        name: 'momoPayment',
        builder: (context, state) =>
            const _Placeholder(label: 'MoMo Payment Screen'),
      ),

      // ── Orders ────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.orderDetail,
        name: 'orderDetail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return OrderDetailScreen(orderId: id);
        },
      ),

      // ── Profile & Settings ────────────────────────────────
      GoRoute(
        path: AppRoutes.editProfile,
        name: 'editProfile',
        builder: (context, state) =>
            const _Placeholder(label: 'Edit Profile Screen'),
      ),
      GoRoute(
        path: AppRoutes.addresses,
        name: 'addresses',
        builder: (context, state) => const AddressListScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        name: 'notifications',
        builder: (context, state) =>
            const _Placeholder(label: 'Notifications Screen'),
      ),
      GoRoute(
        path: AppRoutes.vouchers,
        name: 'vouchers',
        builder: (context, state) =>
            const _Placeholder(label: 'Vouchers Screen'),
      ),
      GoRoute(
        path: AppRoutes.writeReview,
        name: 'writeReview',
        builder: (context, state) =>
            const _Placeholder(label: 'Write Review Screen'),
      ),

      // ── Admin ─────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.adminDashboard,
        name: 'adminDashboard',
        builder: (context, state) =>
            const _Placeholder(label: 'Admin Dashboard'),
        routes: [
          GoRoute(
            path: 'products',
            name: 'adminProducts',
            builder: (context, state) =>
                const _Placeholder(label: 'Admin Products'),
          ),
          GoRoute(
            path: 'products/form',
            name: 'adminProductForm',
            builder: (context, state) =>
                const _Placeholder(label: 'Admin Product Form'),
          ),
          GoRoute(
            path: 'orders',
            name: 'adminOrders',
            builder: (context, state) =>
                const _Placeholder(label: 'Admin Orders'),
          ),
          GoRoute(
            path: 'orders/:id',
            name: 'adminOrderDetail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return _Placeholder(label: 'Admin Order Detail: $id');
            },
          ),
          GoRoute(
            path: 'users',
            name: 'adminUsers',
            builder: (context, state) =>
                const _Placeholder(label: 'Admin Users'),
          ),
          GoRoute(
            path: 'vouchers',
            name: 'adminVouchers',
            builder: (context, state) =>
                const _Placeholder(label: 'Admin Vouchers'),
          ),
          GoRoute(
            path: 'banners',
            name: 'adminBanners',
            builder: (context, state) =>
                const _Placeholder(label: 'Admin Banners'),
          ),
          GoRoute(
            path: 'reviews',
            name: 'adminReviews',
            builder: (context, state) =>
                const _Placeholder(label: 'Admin Reviews'),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Trang không tìm thấy: ${state.uri}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Về trang chủ'),
            ),
          ],
        ),
      ),
    ),
  );
}

// ─── Auth Redirect Guard ─────────────────────────────────────────────────────
String? _redirect(
  BuildContext context,
  GoRouterState state,
  AsyncValue<UserEntity?> authAsync,
) {
  // Đang loading → không redirect (ở lại Splash)
  if (authAsync.isLoading) return null;

  final isLoggedIn = authAsync.when(
    data: (user) => user != null,
    loading: () => false,
    error: (_, _) => false,
  );
  final location = state.uri.toString();

  // Tự động chuyển hướng từ Splash sau khi auth state đã load xong
  if (location == AppRoutes.splash) {
    return isLoggedIn ? AppRoutes.home : AppRoutes.login;
  }

  final isAuthRoute = location == AppRoutes.login ||
      location == AppRoutes.register ||
      location == AppRoutes.forgotPassword;

  if (isLoggedIn && isAuthRoute) return AppRoutes.home;
  if (!isLoggedIn && !isAuthRoute) return AppRoutes.login;

  return null;
}

// ─── Main Shell (Bottom Navigation) ──────────────────────────────────────────
class _MainShell extends StatelessWidget {
  final Widget child;
  const _MainShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Tìm kiếm',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Giỏ hàng',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Đơn hàng',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Hồ sơ',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(AppRoutes.search)) return 1;
    if (location.startsWith(AppRoutes.cart)) return 2;
    if (location.startsWith(AppRoutes.orderList)) return 3;
    if (location.startsWith(AppRoutes.profile)) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
      case 1:
        context.go(AppRoutes.search);
      case 2:
        context.go(AppRoutes.cart);
      case 3:
        context.go(AppRoutes.orderList);
      case 4:
        context.go(AppRoutes.profile);
    }
  }
}

// ─── Splash Screen ──────────────────────────────────────────────────────────────
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone_android, size: 80, color: Color(0xFF0057FF)),
            SizedBox(height: 16),
            Text(
              'SmartphoneHub',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0057FF),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Điện thoại chính hãng, giá tốt nhất',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 32),
            CircularProgressIndicator(color: Color(0xFF0057FF)),
          ],
        ),
      ),
    );
  }
}

// ─── Generic Placeholder Screen ───────────────────────────────────────────────
class _Placeholder extends StatelessWidget {
  final String label;
  const _Placeholder({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(label)),
      body: Center(
        child: Text(
          label,
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
