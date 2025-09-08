import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/utils/custom_app_bar.dart';

import '../../../generated/l10n.dart';
import '../../../utils/dots_indicator.dart';
import '../cart_view/my_cart_view.dart';
import '../home_view/manager/home_cubit.dart';
import 'custom_carousel_slider.dart';
import 'horizontal_list_of_activities_types.dart';
import 'manager/activity_cubit.dart';

class ActivitiesViewBody extends StatefulWidget {
  const ActivitiesViewBody({super.key});

  @override
  State<ActivitiesViewBody> createState() => _ActivitiesViewBodyState();
}

class _ActivitiesViewBodyState extends State<ActivitiesViewBody> {
  List<String> activityTitle = [];
  List<String> activityImages = [];

  @override
  void didChangeDependencies() {
    activityTitle = [S.of(context).Subscriptions, S.of(context).DailyGames];
    activityImages = [
      "assets/images/time-management.png",
      "assets/images/exercise.png",
    ];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActivityCubit(),
      child: BlocBuilder<ActivityCubit, ActivityState>(
        builder: (context, state) {
          var activityCubit = context.read<ActivityCubit>();
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (BuildContext context, state) {
                    var homeCubit = context.read<HomeCubit>();
                    return CustomAppBar(
                      onPressedOnMenuButton: () {
                        homeCubit.scaffoldKey.currentState!.openDrawer();
                      },
                      onPressedOnMyCartButton: () {
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyCartView(),
                            ),
                          );
                        }
                      },
                      appBarTitle: S.of(context).anshta,
                    );
                  },
                ),
                SizedBox(height: 40.h),
                CustomCarouselSlider(activityCubit: activityCubit),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DotsIndicator(
                      currentIndex: activityCubit.currentCarouselIndex,
                      itemCount: activityCubit.carouselItems.length,
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                HorizontalListOfActivitiesTypes(
                  activityTitle: activityTitle,
                  activityImages: activityImages,
                ),
                SizedBox(height: 20.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
