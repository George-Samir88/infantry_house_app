import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/utils/custom_error_template.dart';
import 'package:infantry_house_app/utils/no_internet_connection_template.dart';
import 'package:infantry_house_app/views/widgets/general_template/add_new_item_template_view.dart';
import 'package:infantry_house_app/views/widgets/general_template/manager/department_cubit.dart';
import 'package:infantry_house_app/views/widgets/general_template/update_existing_template_item.dart';

import 'package:lottie/lottie.dart';
import '../../../generated/l10n.dart';
import '../../../global_variables.dart';
import '../../../utils/custom_appbar_editing_view.dart';
import '../../../utils/custom_elevated_button.dart';
import '../../../utils/custom_edit_button.dart';
import 'custom_item_in_grid_edit_view.dart';

class EditItemsTemplateView extends StatefulWidget {
  const EditItemsTemplateView({super.key});

  @override
  State<EditItemsTemplateView> createState() => _EditItemsTemplateViewState();
}

class _EditItemsTemplateViewState extends State<EditItemsTemplateView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    _animationController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  bool isAnimationVisible = false;

  void _playAnimation() {
    _animationController.forward(from: 0); // Restart animation from beginning
    setState(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOutQuad,
        );
      });
      isAnimationVisible = true; // Show animation
    });
    _animationController.forward().whenComplete(() {
      setState(() {
        isAnimationVisible = false;
      });
    });
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DepartmentCubit, DepartmentState>(
      builder: (context, state) {
        var cubit = context.read<DepartmentCubit>();
        return Scaffold(
          backgroundColor: Color(0xffF5F5F5),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.h),
            child: CustomAppBarEditingView(
              onPressed: () {
                Navigator.pop(context);
              },
              title: S.of(context).T3delElasnaf,
            ),
          ),
          body:
              state is NoInternetConnectionWidget
                  ? NoInternetConnectionWidget(
                    onRetry: () async {
                      if (await cubit.hasInternetConnection()) {
                        cubit.listenToMenuItems();
                      }
                    },
                  )
                  : state is DepartmentGetMenuItemFailureState
                  ? CustomErrorTemplate(
                    onRetry: () async {
                      if (await cubit.hasInternetConnection()) {
                        cubit.listenToMenuItems();
                      }
                    },
                  )
                  : LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = (constraints.maxWidth ~/ 280).clamp(
                        2,
                        4,
                      );
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                        child: CustomScrollView(
                          controller: scrollController,
                          slivers: [
                            SliverToBoxAdapter(child: SizedBox(height: 30.h)),
                            SliverGrid.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    mainAxisSpacing: 10,
                                    childAspectRatio:
                                        1, // Ensures a balanced UI
                                  ),
                              itemCount: cubit.menuItemsList.length,
                              // itemCount: cubit.listToBeShow.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 30.h,
                                    left: 10.w,
                                    right: 10.w,
                                  ),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      CustomItemsInGridEditView(
                                        menuItemModel:
                                            cubit.menuItemsList[index],
                                      ),
                                      Positioned(
                                        left:
                                            GlobalData().isArabic ? 10.w : null,
                                        right:
                                            GlobalData().isArabic ? null : 10.w,
                                        top: -15.h,
                                        child: CustomEditButton(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (
                                                      context,
                                                    ) => BlocProvider.value(
                                                      value: cubit,
                                                      child: UpdateExistingItemTemplateView(
                                                        menuItemModel:
                                                            cubit
                                                                .menuItemsList[index],
                                                      ),
                                                    ),
                                              ),
                                            );
                                          },
                                          icon: Icons.edit,
                                          iconColor: Colors.black,
                                          backgroundColor: Colors.grey.shade200,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            SliverToBoxAdapter(child: SizedBox(height: 10.h)),
                            SliverToBoxAdapter(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomElevatedButton(
                                      textColor: Color(0xFF6D3A2D),
                                      backGroundColor: Colors.grey[300],
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => BlocProvider.value(
                                                  value: cubit,
                                                  child:
                                                      AddNewItemTemplateView(),
                                                ),
                                          ),
                                        );
                                      },
                                      text: S.of(context).EdaftGded,
                                      tabletLayout: GlobalData().isTabletLayout,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  if (cubit.menuItemsList.isNotEmpty)
                                    Expanded(
                                      child: CustomElevatedButton(
                                        onPressed: () {
                                          _playAnimation();
                                        },
                                        text: S.of(context).hefz,
                                        tabletLayout:
                                            GlobalData().isTabletLayout,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            SliverToBoxAdapter(child: SizedBox(height: 10.h)),
                            SliverToBoxAdapter(
                              child: Visibility(
                                visible: isAnimationVisible,
                                child: Container(
                                  // Use relative units like 10.w or any desired fixed size
                                  height: 100.h,
                                  // Same for height
                                  alignment: Alignment.center,
                                  child: Lottie.asset(
                                    controller: _animationController,
                                    onLoaded: (composition) {
                                      _animationController.duration =
                                          composition.duration;
                                    },
                                    backgroundLoading: true,
                                    alignment: Alignment.centerLeft,
                                    'assets/animation/done_lottie.json',
                                    // Local file
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                          ],
                        ),
                      );
                    },
                  ),
        );
      },
    );
  }
}
