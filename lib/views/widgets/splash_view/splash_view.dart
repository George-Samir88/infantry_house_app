import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/global_variables.dart';
import 'package:infantry_house_app/utils/custom_snackBar.dart';
import 'package:infantry_house_app/views/widgets/login_view/manager/autologin_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../generated/l10n.dart';
import '../../../main.dart';
import '../home_view/home_view.dart';
import '../home_view/manager/home_cubit.dart';
import '../login_view/login_view.dart';
import '../../../utils/custom_elevated_button.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  // final Function(Locale) setLocale;

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  String selectedLanguage = 'ar'; // Default to Arabic

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  late double width;

  late double height;

  //This function loads the saved language from SharedPreferences
  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedLanguage = prefs.getString('locale');
    if (savedLanguage != null) {
      setState(() {
        selectedLanguage = savedLanguage;
      });
      GlobalData().isArabic = selectedLanguage == 'ar';
    }
    GlobalData().isArabic = selectedLanguage == 'ar';
  }

  //This function changes the language
  void _changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', languageCode);
    if (!mounted) return;
    InfantryHouseApp.setLocale(context, Locale(languageCode));
    setState(() {
      selectedLanguage = languageCode;
      GlobalData().isArabic = selectedLanguage == 'ar';
    });
  }

  bool userIsLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is HomeGetDepartmentsSuccessState && userIsLoggedIn) {
              // ✅ login success → Go Home
              Future.delayed(Duration(seconds: 2), () async {
                if (!context.mounted) return;
                await context.read<HomeCubit>().getDepartmentsNames();
              });
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomeView()),
              );
            }
            if (state is HomeGetDepartmentsFailureState) {
              showSnackBar(context: context, message: state.failure);
            }
          },
        ),
      ],
      child: BlocConsumer<AutoLoginCubit, AutoLoginState>(
        listener: (context, state) async {
          if (state is AutoLoginSuccess) {
            // ✅ login success → mark user as logged in
            userIsLoggedIn = true;
          } else if (state is AutoLoginUserNotFound) {
            // ❌ no session → go Login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginView()),
            );
          } else if (state is AutoLoginFailure) {
            showSnackBar(context: context, message: state.message);
          }
        },
        builder: (context, state) {
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              height = constraints.maxHeight;
              width = constraints.maxWidth;
              if (constraints.maxWidth > 600) {
                GlobalData().isTabletLayout = true;
              }
              return Material(
                color: Colors.white,
                child: SizedBox(
                  width: width,
                  height: height,
                  child: Stack(
                    children: [
                      // Background container
                      Container(
                        width: width,
                        height: height * 0.6,
                        decoration: BoxDecoration(
                          color: Colors.brown[800],
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(80),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/images/logo.png',
                                width: width * 0.7,
                                height: height * 0.3,
                                scale: 0.8,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            SizedBox(
                              width: width,
                              child: Center(
                                child: DefaultTextStyle(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Cairo",
                                  ),
                                  child: AnimatedTextKit(
                                    key: ValueKey(selectedLanguage),
                                    repeatForever: false,
                                    isRepeatingAnimation: false,
                                    animatedTexts: [
                                      TyperAnimatedText(
                                        S.of(context).InfantryHouse,
                                        speed: Duration(milliseconds: 100),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Bottom Section
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Stack(
                          children: [
                            Container(
                              width: width,
                              height: height * 0.4,
                              decoration: BoxDecoration(
                                color: Colors.brown[800],
                              ),
                            ),
                            Container(
                              width: width,
                              height: height * 0.4,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(80),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(height: 20.h),
                                  Text(
                                    S.of(context).WelcomeToInfantryHouse,
                                    style: TextStyle(
                                      color: Colors.brown[800],
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1,
                                      wordSpacing: 2,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.0.w,
                                    ),
                                    child:
                                        state is AutoLoginLoading
                                            ? Center(
                                              child: CircularProgressIndicator(
                                                color: const Color(0xFF6D3A2D),
                                                strokeWidth: 3,
                                              ),
                                            )
                                            : CustomElevatedButton(
                                              onPressed: () {
                                                (userIsLoggedIn &&
                                                        state
                                                            is HomeGetDepartmentsSuccessState)
                                                    ? Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                HomeView(),
                                                      ),
                                                    )
                                                    : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                LoginView(),
                                                      ),
                                                    );
                                              },
                                              text: S.of(context).GetStarted,
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width.w,
                                              tabletLayout:
                                                  GlobalData().isTabletLayout,
                                            ),
                                  ),
                                  SizedBox(height: 20.h),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Language Dropdown in the Top-Right Corner
                      Positioned(
                        top: 40.h, // Adjust the position
                        right: 20.w, // Adjust the position
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedLanguage,
                              icon: Icon(
                                Icons.language,
                                size: GlobalData().isTabletLayout ? 26.r : 20.r,
                                color: Colors.brown[800],
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: 'en',
                                  child: Text(
                                    'English',
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'ar',
                                  child: Text(
                                    'العربية',
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ),
                              ],
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  _changeLanguage(newValue);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
