import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../generated/l10n.dart';
import '../../../global_variables.dart';
import '../../../utils/custom_app_bar.dart';
import 'package:intl/intl.dart';

import 'manager/home_cubit.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  String selectedCategory = "";
  List<String> categories = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isArabic() {
    return Intl.getCurrentLocale() == 'ar';
  }

  @override
  void initState() {
    super.initState();
    GlobalData().isArabic = isArabic();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        context.read<HomeCubit>().initializeDrawerItemsAndScreensMap(
          context: context,
        );
        selectedCategory = S.of(context).KesmElA8zyaWlma4robat;
        categories = [
          S.of(context).hogozat,
          S.of(context).eskan,
          S.of(context).KesmElA8zyaWlma4robat,
          S.of(context).m8sla,
          S.of(context).anshta,
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (context
    //     .read<CustomButtonAndMenuCubit>()
    //     .allButtonsAndItemsMap
    //     .isEmpty) {
    //   context.read<CustomButtonAndMenuCubit>().initializeMap(context);
    // }
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          GlobalData().isTabletLayout = true;
        }
        return SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Color(0xffF5F5F5),
            drawer: Drawer(
              clipBehavior: Clip.none,
              backgroundColor: Colors.transparent,
              width: GlobalData().isTabletLayout ? 50.w : 60.w,
              child: Container(
                clipBehavior: Clip.none,
                decoration: BoxDecoration(
                  color: Colors.brown[800],
                  borderRadius: BorderRadius.only(
                    topLeft:
                        GlobalData().isArabic
                            ? Radius.circular(30)
                            : Radius.circular(0),
                    bottomLeft:
                        GlobalData().isArabic
                            ? Radius.circular(30)
                            : Radius.circular(0),
                    topRight:
                        GlobalData().isArabic
                            ? Radius.circular(0)
                            : Radius.circular(30),
                    bottomRight:
                        GlobalData().isArabic
                            ? Radius.circular(0)
                            : Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10.h),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: GlobalData().isTabletLayout ? 34.r : 30.r,
                      ),
                      onPressed: () => _scaffoldKey.currentState!.closeDrawer(),
                    ),
                    SizedBox(height: 20.h),
                    Expanded(
                      child: Center(
                        child: ListView.separated(
                          clipBehavior: Clip.none,
                          shrinkWrap: true,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return buildDrawerItem(
                              categories[index],
                              context,
                              GlobalData().isTabletLayout,
                            );
                          },
                          separatorBuilder:
                              (context, index) =>
                                  SizedBox(height: 40.h), // Space between items
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 40.0,
                        left: 10,
                        right: 10,
                        top: 10,
                      ),
                      child: Icon(
                        Icons.home,
                        color: Colors.white,
                        size: GlobalData().isTabletLayout ? 34.r : 30.r,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customAppBar(
                        onPressed: () {
                          _scaffoldKey.currentState!.openDrawer();
                        },
                        context: context,
                        appBarTitle:
                            context.read<HomeCubit>().selectedAppBarTitle,
                      ),
                      SizedBox(height: 10.h),
                      context.read<HomeCubit>().selectedScreen,
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget buildDrawerItem(
    String title,
    BuildContext context,
    bool tabletLayout,
  ) {
    bool isActive = selectedCategory == title;
    return GestureDetector(
      onTap: () {
        context.read<HomeCubit>().changeSelectedScreen(
          drawerItemTitle: title,
          context: context,
        );
        setState(() {
          selectedCategory = title;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h), // Increased spacing
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            if (isActive)
              Positioned(
                left: GlobalData().isArabic ? -20.w : 0,
                right: GlobalData().isArabic ? 0 : -20.w,
                child: Container(
                  width: tabletLayout ? 150.w : 100.w,
                  height: tabletLayout ? 150.h : 100.h,
                  decoration: BoxDecoration(
                    color: Colors.brown[800],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: tabletLayout ? 8.sp : 14.sp,
                      color: isActive ? Colors.white : Colors.grey,
                      fontWeight:
                          isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                if (isActive)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Icon(
                      Icons.circle,
                      size: tabletLayout ? 10.r : 6.r,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
