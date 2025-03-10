import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/views/widgets/editing_items_view/presentation/custom_menu_item_in_grid_edit_view.dart';
import 'package:infantry_house_app/views/widgets/editing_items_view/presentation/update_existing_item.dart';
import 'package:lottie/lottie.dart';

import '../../../../generated/l10n.dart';
import '../../../../global_variables.dart';
import '../../../../models/menu_item_model.dart';
import '../../../../utils/custom_appbar_editing_view.dart';
import '../../../../utils/custom_elevated_button.dart';
import '../../../widgets_2/food_and_beverage_view/manager/food_and_beverage/food_and_beverage_cubit.dart';
import '../../food_and_beverage_view/custom_edit_button.dart';
import 'add_new_item_view.dart';

class EditingItemsView extends StatefulWidget {
  const EditingItemsView({
    super.key,
    required this.menuItemsModelList,
    required this.listIndex,
    required this.buttonTitle,
    required this.screenName,
  });

  final String screenName;
  final List<MenuItemModel> menuItemsModelList;
  final int listIndex;
  final String buttonTitle;

  @override
  State<EditingItemsView> createState() => _EditingItemsViewState();
}

class _EditingItemsViewState extends State<EditingItemsView>
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
    return BlocBuilder<FoodAndBeverageCubit, FoodAndBeverageState>(
      builder: (context, state) {
        var cubit = context.read<FoodAndBeverageCubit>();
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
                    SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                    SliverGrid.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 10,
                        childAspectRatio:
                            GlobalData().isTabletLayout
                                ? 1.2
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
                              CustomMenuItemInGridEditView(
                                menuItemModel: cubit.listToBeShow[index],
                                tabletLayout: GlobalData().isTabletLayout,
                              ),
                              Positioned(
                                left: 10,
                                top: -15,
                                child: Row(
                                  children: [
                                    CustomEditButton(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => BlocProvider.value(
                                                  value: cubit,
                                                  child: UpdateExistingItemView(
                                                    buttonTitle:
                                                        widget.buttonTitle,
                                                    menuItemModel:
                                                        widget
                                                            .menuItemsModelList[index],
                                                    listIndex: index,
                                                    screenName:
                                                        widget.screenName,
                                                  ),
                                                ),
                                          ),
                                        );
                                      },
                                      height:
                                          GlobalData().isTabletLayout
                                              ? 44.h
                                              : null,
                                      width:
                                          GlobalData().isTabletLayout
                                              ? 25.w
                                              : null,
                                      iconSize:
                                          GlobalData().isTabletLayout
                                              ? 30.r
                                              : null,
                                      icon: Icons.edit,
                                      iconColor: Colors.black,
                                      backgroundColor: Colors.grey.shade200,
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: 10,
                                bottom: -15,
                                child: Row(
                                  children: [
                                    CustomEditButton(
                                      onTap: () {
                                        cubit.removeItem(
                                          screenName: widget.screenName,
                                          buttonTitle: widget.buttonTitle,
                                          indexOfItemInList: index,
                                        );
                                      },
                                      height:
                                          GlobalData().isTabletLayout
                                              ? 30.h
                                              : 25.h,
                                      width:
                                          GlobalData().isTabletLayout
                                              ? 15.w
                                              : 35.w,
                                      iconSize:
                                          GlobalData().isTabletLayout
                                              ? 24.r
                                              : 20.r,
                                      icon: Icons.cancel,
                                      iconColor: Colors.white,
                                      backgroundColor: Colors.red,
                                    ),
                                  ],
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
                                          child: AddNewItemView(
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
