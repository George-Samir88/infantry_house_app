import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'features/widgets/cart_view/manager/cart_cubit/cart_cubit.dart';
import 'features/widgets/home_view/home_view.dart';
import 'features/widgets/home_view/manager/home_cubit.dart';
import 'features/widgets/login_view/manager/autologin_cubit.dart';
import 'features/widgets/notification_view/notification_view.dart';
import 'features/widgets/splash_view/splash_view.dart';
import 'firebase_options.dart';
import 'bloc_observer.dart';
import 'generated/l10n.dart';
import 'services/notification_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point') // ✅ required annotation for background access
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ✅ Register background handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // ✅ Initialize notifications
  await NotificationService.init();

  final prefs = await SharedPreferences.getInstance();
  final languageCode = prefs.getString('locale');

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Bloc.observer = MyBlocObserver();

  runApp(InfantryHouseApp(languageCode: languageCode));
}

class InfantryHouseApp extends StatefulWidget {
  final String? languageCode;

  const InfantryHouseApp({super.key, required this.languageCode});

  static void setLocale(BuildContext context, Locale locale) {
    _InfantryHouseAppState? state =
        context.findAncestorStateOfType<_InfantryHouseAppState>();
    state?.setLocale(locale);
  }

  @override
  State<InfantryHouseApp> createState() => _InfantryHouseAppState();
}

class _InfantryHouseAppState extends State<InfantryHouseApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _locale =
        widget.languageCode != null
            ? Locale(widget.languageCode!)
            : const Locale('ar');
  }

  void setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AutoLoginCubit()),
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => CartCubit()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder:
            (context, child) => MaterialApp(
              navigatorKey: navigatorKey,
              routes: {
                '/home': (_) => const HomeView(), // your real HomeView widget
                '/notifications': (_) => const NotificationsView(),
              },
              locale: _locale,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              theme: ThemeData(
                fontFamily: 'Cairo',
                scaffoldBackgroundColor: Colors.white,
              ),
              debugShowCheckedModeBanner: false,
              home: const SplashView(),
            ),
      ),
    );
  }
}
