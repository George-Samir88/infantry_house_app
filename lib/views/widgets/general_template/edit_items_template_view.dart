import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/views/widgets/general_template/add_new_item_template_view.dart';
import 'package:infantry_house_app/views/widgets/general_template/manager/department_cubit.dart';
import 'package:infantry_house_app/views/widgets/general_template/update_existing_template_item.dart';

import 'package:lottie/lottie.dart';
import '../../../generated/l10n.dart';
import '../../../global_variables.dart';
import '../../../utils/custom_appbar_editing_view.dart';
import '../../../utils/custom_elevated_button.dart';
import '../../../utils/custom_edit_button.dart';
import '../../reusable_screens/custom_item_in_grid_edit_view.dart';

class EditItemsTemplateView extends StatefulWidget {
  const EditItemsTemplateView({
    super.key,
    required this.listIndex,
    required this.buttonTitle,
    required this.screenName,
  });

  final String screenName;
  final int listIndex;
  final String buttonTitle;

  @override
  State<EditItemsTemplateView> createState() => _EditItemsTemplateViewState();
}

class _EditItemsTemplateViewState extends State<EditItemsTemplateView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool isAnimationVisible = false;

  void _playAnimation() {
    _animationController.forward(from: 0); // Restart animation from beginning
    setState(() {
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
          body: LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = (constraints.maxWidth ~/ 280).clamp(2, 4);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: SizedBox(height: 30.h)),
                    SliverGrid.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 10,
                        childAspectRatio:
                            GlobalData().isTabletLayout
                                ? 1
                                : 1, // Ensures a balanced UI
                      ),
                      itemCount: cubit.listToBeShow.length,
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
                                menuItemModel: cubit.listToBeShow[index],
                                tabletLayout: GlobalData().isTabletLayout,
                              ),
                              Positioned(
                                left: 10,
                                top: -15,
                                child: CustomEditButton(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => BlocProvider.value(
                                              value: cubit,
                                              child:
                                                  UpdateExistingItemTemplateView(
                                                    buttonTitle:
                                                        widget.buttonTitle,
                                                    menuItemModel:
                                                        cubit
                                                            .listToBeShow[index],
                                                    listIndex: index,
                                                    screenName:
                                                        widget.screenName,
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
                                          child: AddNewItemTemplateView(
                                            listIndex: widget.listIndex,
                                            buttonTitle: widget.buttonTitle,
                                            screenName: widget.screenName,
                                          ),
                                        ),
                                  ),
                                );
                              },
                              text: S.of(context).EdaftGded,
                              tabletLayout: GlobalData().isTabletLayout,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          if (cubit.listToBeShow.isNotEmpty)
                            Expanded(
                              child: CustomElevatedButton(
                                onPressed: () {
                                  _playAnimation();
                                },
                                text: S.of(context).hefz,
                                tabletLayout: GlobalData().isTabletLayout,
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
                    SliverToBoxAdapter(child: SizedBox(height: 100.h)),
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
