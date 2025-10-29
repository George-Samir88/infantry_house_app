import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/constants/screen_names.dart';
import 'package:infantry_house_app/utils/custom_app_bar.dart';
import 'package:infantry_house_app/utils/custom_error_template.dart';
import 'package:infantry_house_app/utils/custom_snackBar.dart';
import 'package:infantry_house_app/utils/no_internet_connection_template.dart';
import 'package:shimmer/shimmer.dart';

import '../../../generated/l10n.dart';
import '../../../global_variables.dart';
import '../../../utils/dots_indicator.dart';
import '../../../utils/empty_carousel_item.dart';
import '../cart_view/my_cart_view.dart';
import '../home_view/manager/home_cubit.dart';
import 'activities_edit_carousel_template.dart';
import 'custom_carousel_slider.dart';
import 'horizontal_list_of_activities_types.dart';
import 'manager/activity_cubit.dart';

class ActivitiesViewBody extends StatefulWidget {
  const ActivitiesViewBody({super.key, required this.screenId});

  final String screenId;

  @override
  State<ActivitiesViewBody> createState() => _ActivitiesViewBodyState();
}

class _ActivitiesViewBodyState extends State<ActivitiesViewBody> {
  List<String> activityTitle = [];
  List<String> activityImages = [];

  @override
  void didChangeDependencies() {
    activityTitle = [S.of(context).Subscriptions, S.of(context).Academies];
    activityImages = [
      "assets/images/time-management.png",
      "assets/images/exercise.png",
    ];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final screenName = DepartmentsTitles.activities;
    final canManage = context.read<HomeCubit>().canManageScreen(
      screenName: screenName,
    );
    final S loc = S.of(context);
    return BlocProvider(
      create:
          (context) => ActivityCubit(
            loc: loc,
            departmentId: widget.screenId,
            canManage: canManage,
          )..listenToCarousel(),
      child: BlocConsumer<ActivityCubit, ActivityState>(
        buildWhen: (previous, current) {
          return current is ActivityNoInternetConnectionState ||
              current is ActivityGetCarouselFailureState ||
              current is ActivityGetCarouselSuccessState ||
              current is ActivityGetCarouselLoadingState ||
              current is ActivityGetCarouselEmptyState ||
              current is ActivityChangeCarouselIndexState;
        },
        listener: (context, state) {
          if (state is ActivityGetCarouselFailureState) {
            showSnackBar(
              context: context,
              message: state.failure,
              backgroundColor: Colors.redAccent,
            );
          }
        },
        builder: (context, state) {
          var activityCubit = context.read<ActivityCubit>();
          return Expanded(
            child: ListView(
              children: [
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (BuildContext context, state) {
                    var homeCubit = context.read<HomeCubit>();
                    return Container(
                      height: 60.h,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        color: Color(0xFF6D3A2D),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade500,
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CustomAppBar(
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
                      ),
                    );
                  },
                ),
                SizedBox(height: 40.h),
                if (state is ActivityNoInternetConnectionState) ...[
                  NoInternetConnectionWidget(
                    onRetry: () async {
                      if (await activityCubit.hasInternetConnection()) {
                        activityCubit.listenToCarousel();
                      }
                    },
                  ),
                ],
                if (state is ActivityGetCarouselEmptyState) ...[
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
                      canManage: activityCubit.canManage,
                    ),
                  ),
                ],
                if (state is ActivityGetCarouselFailureState) ...[
                  CustomErrorTemplate(
                    onRetry: () async {
                      if (await activityCubit.hasInternetConnection()) {
                        activityCubit.listenToCarousel();
                      }
                    },
                    isShowCustomEditButton: true,
                  ),
                ],
                if (state is ActivityGetCarouselLoadingState) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: GlobalData().isTabletLayout ? 280.h : 180.h,
                        decoration: BoxDecoration(
                          color: const Color(0xffFAF7F0),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                    ),
                  ),
                ],
                if (state is ActivityGetCarouselSuccessState ||
                    state is ActivityChangeCarouselIndexState) ...[
                  CustomCarouselSlider(activityCubit: activityCubit),
                ],
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DotsIndicator(
                      currentIndex: activityCubit.currentCarouselIndex,
                      itemCount: activityCubit.carouselItemList.length,
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                HorizontalListOfActivitiesTypes(
                  activityTitle: activityTitle,
                  activityImages: activityImages,
                ),
                SizedBox(height: 50.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
