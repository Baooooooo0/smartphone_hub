import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
<<<<<<< HEAD
import 'firebase_options.dart';
=======
>>>>>>> 8dff0fc (feat: initialize project architecture with Riverpod, GoRouter, core utilities, and Firebase configuration)
import 'core/theme/app_theme.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

<<<<<<< HEAD
  // ─── Firebase ──────────────────────────────────────────────
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Crashlytics: bắt lỗi Flutter framework
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // Bắt lỗi ngoài Flutter framework (async zone)
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // ─── Chỉ cho phép Portrait mode ────────────────────────────
=======
  // Chỉ cho phép Portrait mode
>>>>>>> 8dff0fc (feat: initialize project architecture with Riverpod, GoRouter, core utilities, and Firebase configuration)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

<<<<<<< HEAD
  // Status bar trong suốt
=======
  // Status bar style
>>>>>>> 8dff0fc (feat: initialize project architecture with Riverpod, GoRouter, core utilities, and Firebase configuration)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

<<<<<<< HEAD
=======
  // TODO (Task 1.1.2): Uncomment sau khi cấu hình Firebase
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

>>>>>>> 8dff0fc (feat: initialize project architecture with Riverpod, GoRouter, core utilities, and Firebase configuration)
  runApp(
    const ProviderScope(
      child: SmartphoneHubApp(),
    ),
  );
}

class SmartphoneHubApp extends ConsumerWidget {
  const SmartphoneHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'SmartphoneHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
