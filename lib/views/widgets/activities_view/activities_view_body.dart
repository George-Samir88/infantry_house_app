import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:infantry_house_app/utils/custom_app_bar.dart';
import 'package:infantry_house_app/views/widgets/activities_view/A_edit_carousel_template.dart';
import 'package:infantry_house_app/views/widgets/activities_view/subscription_view/subscriptions_view_body.dart';

import '../../../generated/l10n.dart';
import '../../../global_variables.dart';
import '../../../utils/empty_carousel_item.dart';
import '../../../utils/custom_edit_button.dart';
import '../../../utils/dots_indicator.dart';
import '../cart_view/my_cart_view.dart';
import '../home_view/manager/home_cubit.dart';
import 'custom_activity_card_item.dart';
import 'daily_games_view/daily_games_view.dart';
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
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    if (activityCubit.carouselItems.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.only(left: 10.w, right: 10.w),
                        child: CarouselSlider.builder(
                          itemCount: activityCubit.carouselItems.length,
                          itemBuilder:
                              (context, index, realIndex) =>
                                  activityCubit.carouselItems[index],
                          options: CarouselOptions(
                            onPageChanged: (index, other) {
                              activityCubit.changeCarouselIndex(index: index);
                            },
                            height: GlobalData().isTabletLayout ? 280.h : 180.h,
                            clipBehavior: Clip.none,
                            padEnds: true,
                            enlargeCenterPage: true,
                            viewportFraction: 1.2,
                            enableInfiniteScroll: true,
                            autoPlay: true,
                          ),
                        ),
                      ),
                      Positioned(
                        left: GlobalData().isArabic ? 5.w : null,
                        right: GlobalData().isArabic ? null : 5.w,
                        bottom: -20.h,
                        child: CustomEditButton(
                          iconColor: Colors.brown[800],
                          backgroundColor: Colors.amberAccent.shade100,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => BlocProvider.value(
                                      value: activityCubit,
                                      child: ActivityEditCarouselTemplateView(),
                                    ),
                              ),
                            );
                          },
                          icon: Icons.edit,
                        ),
                      ),
                    ],
                    if (activityCubit.carouselItems.isEmpty) ...[
                      Padding(
                        padding: EdgeInsets.only(left: 10.w, right: 10.w),
                        child: EmptyCarouselContainer(
                          onTab: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => BlocProvider.value(
                                      value: activityCubit,
                                      child: ActivityEditCarouselTemplateView(),
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                  child: AnimationLimiter(
                    child: Row(
                      children: List.generate(
                        2,
                        (index) => Expanded(
                          child: AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 1000),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: GestureDetector(
                                  onTap: () {
                                    index == 0
                                        ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    SubscriptionsViewBody(),
                                          ),
                                        )
                                        : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => DailyGamesView(),
                                          ),
                                        );
                                  },
                                  child: CustomActivityCardItem(
                                    activityTitle: activityTitle[index],
                                    activityImage: activityImages[index],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
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
