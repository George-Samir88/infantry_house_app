import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/utils/custom_carousel_item.dart';
import 'package:infantry_house_app/utils/custom_snackBar.dart';
import 'package:infantry_house_app/views/widgets/general_template/button_and_menu_template.dart';
import 'package:infantry_house_app/views/widgets/general_template/edit_carousel_view_template.dart';
import 'package:infantry_house_app/views/widgets/general_template/manager/department_cubit.dart';
import 'package:infantry_house_app/views/widgets/general_template/shimmer_body_loader.dart';

import '../../../generated/l10n.dart';
import '../../../global_variables.dart';
import '../../../utils/custom_edit_button.dart';
import '../../../utils/empty_carousel_item.dart';
import '../../../utils/dots_indicator.dart';

class GeneralBodyTemplateView extends StatefulWidget {
  const GeneralBodyTemplateView({super.key});

  @override
  State<GeneralBodyTemplateView> createState() =>
      _GeneralBodyTemplateViewState();
}

class _GeneralBodyTemplateViewState extends State<GeneralBodyTemplateView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DepartmentCubit, DepartmentState>(
      buildWhen: (previous, current) {
        return current is DepartmentLoadingAllSubScreenData ||
            current is DepartmentChangeSubScreenLoadedState ||
            current is DepartmentGetSubScreensNamesLoadingState ||
            current is DepartmentGetSubScreensNamesEmptyState ||
            current is DepartmentGetSubScreensNamesLoadingState;
      },
      builder: (context, state) {
        var cubit = context.read<DepartmentCubit>();
        if (state is DepartmentGetSubScreensNamesEmptyState ||
            state is DepartmentChangeSubScreenLoadedState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  if (cubit.carouselItemsList.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      child: CarouselSlider.builder(
                        itemCount: cubit.carouselItemsList.length,
                        itemBuilder:
                            (context, index, realIndex) => CustomCarouselItem(
                              imagePath:
                                  cubit.carouselItemsList[index].imageUrl,
                              isPickedImage: false,
                            ),
                        options: CarouselOptions(
                          onPageChanged: (index, other) {
                            cubit.changeCarouselIndex(index: index);
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
                    if (cubit.canManage)
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
                                      value: cubit,
                                      child: EditCarouselViewTemplate(),
                                    ),
                              ),
                            );
                          },
                          icon: Icons.edit,
                        ),
                      ),
                  ],
                  if (cubit.carouselItemsList.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      child: EmptyCarouselContainer(
                        onTab: () async {
                          // if (cubit.newScreensMap.isNotEmpty) {
                          if (1 > 0) {
                            // Navigzator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder:
                            //         (context) => BlocProvider.value(
                            //           value: cubit,
                            //           child: EditCarouselViewTemplate(),
                            //         ),
                            //   ),
                            // );
                          } else {
                            showSnackBar(
                              context: context,
                              message:
                                  S.of(context).PleaseAddAMainCategoryFirst,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                            );
                          }
                        },
                        canManage: cubit.canManage,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DotsIndicator(
                    currentIndex: cubit.currentCarouselIndex,
                    itemCount: cubit.carouselItemsList.length,
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              ButtonAndMenuTemplate(),
              SizedBox(height: 40.h),
            ],
          );
        } else if (state is DepartmentGetSubScreensNamesLoadingState ||
            state is DepartmentLoadingAllSubScreenData) {
          return const DepartmentBodyShimmerLoader();
        } else if (state is DepartmentGetSubScreensNamesFailureState) {
          return Container();
        }
        return SizedBox();
      },
    );
  }
}
