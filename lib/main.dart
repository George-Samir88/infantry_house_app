import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/views/widgets_2/cart_view/manager/cart_cubit/cart_cubit.dart';
import 'package:infantry_house_app/views/widgets_2/home_view/home_view.dart';
import 'package:infantry_house_app/views/widgets_2/home_view/manager/home_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc_observer.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  String? languageCode = prefs.getString('locale');
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

  @override
  State<InfantryHouseApp> createState() => _InfantryHouseAppState();

  //This method is a static function inside the InfantryHouseApp class
  static void setLocale(BuildContext context, Locale locale) {
    _InfantryHouseAppState? state =
        context.findAncestorStateOfType<_InfantryHouseAppState>();
    state?.setLocale(locale);
  }
}

class _InfantryHouseAppState extends State<InfantryHouseApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    if (widget.languageCode != null) {
      _locale = Locale(widget.languageCode!);
    } else {
      _locale = const Locale('ar'); // Default language
    }
  }

  //This saves the new language to SharedPreferences and updates the UI.
  void setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
    setState(() {
      _locale = locale;
    });
  }

  ///changes
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(create: (BuildContext context) => HomeCubit()),
        BlocProvider<CartCubit>(create: (BuildContext context) => CartCubit()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (context, child) {
          return MaterialApp(
            locale: _locale,
            localizationsDelegates: [
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
            home: child,
          );
        },
        child: HomeView(),
        // child: SplashView(),
      ),
    );
  }
}
