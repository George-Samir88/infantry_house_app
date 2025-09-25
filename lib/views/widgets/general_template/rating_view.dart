import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/utils/app_loader.dart';
import 'package:infantry_house_app/utils/map_firebase_error.dart';
import 'package:infantry_house_app/views/widgets/general_template/item_feedback_view.dart';
import 'package:infantry_house_app/views/widgets/general_template/manager/department_cubit.dart';
import 'package:infantry_house_app/views/widgets/general_template/rating_horizontal_list_view.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../generated/l10n.dart';
import '../../../global_variables.dart';
import '../../../models/menu_item_model.dart';
import '../../../utils/custom_appbar_editing_view.dart';
import '../../../utils/custom_elevated_button.dart';
import '../../../utils/custom_snackBar.dart';
import '../cart_view/manager/cart_cubit/cart_cubit.dart';
import 'complaints_view.dart';
import 'manager/rating_cubit.dart';

class RatingView extends StatefulWidget {
  const RatingView({
    super.key,
    required this.menuItemModel,
    required this.departmentId,
    required this.subScreenId,
    required this.departmentCubit,
  });

  final MenuItemModel menuItemModel;
  final String departmentId;
  final String subScreenId;
  final DepartmentCubit departmentCubit;

  @override
  State<RatingView> createState() => _RatingViewState();
}

class _RatingViewState extends State<RatingView>
    with SingleTickerProviderStateMixin {
  double menuItemRating = 0;
  bool isAnimationVisible = false;
  late AnimationController _animationController;

  @override
  void initState() {
    menuItemRating = widget.menuItemModel.averageRating;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    super.initState();
  }

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

  Widget _buildImage(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 200.h,
      );
    } else if (File(imagePath).existsSync()) {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        width: double.infinity,
        height: 200.h,
      );
    } else {
      // Fallback to network image
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 200.h,
        errorBuilder:
            (context, error, stackTrace) =>
                Container(color: Colors.grey[300], height: 200.h),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              RatingCubit()..getRatings(menuItemId: widget.menuItemModel.id),
      child: BlocConsumer<RatingCubit, RatingState>(
        listener: (context, state) {
          if (state is RatingSendRatingFailure) {
            showSnackBar(
              context: context,
              message: localizeFirestoreError(
                context: context,
                code: state.failure,
              ),
              backgroundColor: Colors.red,
            );
          }
          if (state is RatingSendRatingSuccess) {
            _playAnimation();
          }
        },
        builder: (context, state) {
          var cubit = context.read<RatingCubit>();
          return Scaffold(
            backgroundColor: Color(0xffF5F5F5),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(70.h),
              child: CustomAppBarEditingView(
                onPressed: () {
                  Navigator.pop(context);
                },
                title: S.of(context).Ra2ykYhmna,
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30.h),

                      ///card Item section
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 12,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Product Image (can be asset, file, or network)
                            Padding(
                              padding: EdgeInsets.all(16.w),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.r),
                                child: _buildImage(widget.menuItemModel.image),
                              ),
                            ),
                            SizedBox(height: 12.h),

                            /// Product Title
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text(
                                widget.menuItemModel.title,
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown[800],
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),

                            /// Price
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text(
                                "\$${widget.menuItemModel.price}",
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown[900],
                                ),
                              ),
                            ),
                            SizedBox(height: 12.h),

                            /// Read-only Rating
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Row(
                                children: [
                                  RatingBarIndicator(
                                    rating: widget.menuItemModel.averageRating,
                                    itemBuilder:
                                        (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                    itemCount: 5,
                                    itemSize: 28.r,
                                    direction: Axis.horizontal,
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    "${widget.menuItemModel.averageRating.toStringAsFixed(1)} / 5",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.brown[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),

                            /// Description
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text(
                                widget.menuItemModel.description,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.brown[600],
                                  height: 1.4,
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),

                            /// Add to Cart Button
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: SizedBox(
                                width: double.infinity,
                                height: 50.h,
                                child: ElevatedButton.icon(
                                  icon: Icon(
                                    Icons.shopping_cart_outlined,
                                    size: 24.r,
                                  ),
                                  label: Text(
                                    S.of(context).AddToCart,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber[700],
                                    foregroundColor: Colors.brown[900],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    elevation: 4,
                                    shadowColor: Colors.black26,
                                  ),
                                  onPressed: () {
                                    context.read<CartCubit>().addToCart(
                                      widget.menuItemModel,
                                    );
                                    showSnackBar(
                                      context: context,
                                      message:
                                          "${S.of(context).AddedSuccessfully} ${widget.menuItemModel.title} ${S.of(context).ToCard}",
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                          ],
                        ),
                      ),

                      ///send button
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20.h),
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            /// Title
                            Text(
                              S.of(context).Ra2ykYhmna,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown[800],
                              ),
                            ),
                            SizedBox(height: 12.h),

                            /// Stars Rating
                            RatingBar.builder(
                              initialRating: menuItemRating,
                              minRating: 1,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 36.r,
                              itemBuilder:
                                  (context, _) =>
                                      Icon(Icons.star, color: Colors.amber),
                              onRatingUpdate: (rating) {
                                setState(() {
                                  menuItemRating = rating;
                                });
                              },
                            ),
                            SizedBox(height: 16.h),

                            /// Buttons Row
                            state is RatingSendRatingLoading
                                ? AppLoader()
                                : Row(
                                  children: [
                                    Expanded(
                                      child: CustomElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (
                                                    context,
                                                  ) => BlocProvider.value(
                                                    value: cubit,
                                                    child: ItemFeedBackView(
                                                      itemId:
                                                          widget
                                                              .menuItemModel
                                                              .id,
                                                      departmentId:
                                                          widget.departmentId,
                                                      subScreenId:
                                                          widget.subScreenId,
                                                      buttonId:
                                                          widget
                                                              .menuItemModel
                                                              .menuButtonId,
                                                    ),
                                                  ),
                                            ),
                                          );
                                        },
                                        text:
                                            S
                                                .of(context)
                                                .ComplaintsAndSuggestions,
                                        textColor: Colors.brown[800],
                                        backGroundColor: Colors.grey[200],
                                        tabletLayout:
                                            GlobalData().isTabletLayout,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: CustomElevatedButton(
                                        onPressed: () async {
                                          final prefs =
                                              await SharedPreferences.getInstance();
                                          final cachedUser = prefs.getString(
                                            'user_cache',
                                          );
                                          final currentUser = jsonDecode(
                                            cachedUser!,
                                          );

                                          cubit.submitRating(
                                            departmentId: widget.departmentId,
                                            subScreenId: widget.subScreenId,
                                            buttonId:
                                                widget
                                                    .menuItemModel
                                                    .menuButtonId,
                                            menuItemId: widget.menuItemModel.id,
                                            stars: menuItemRating,
                                            userId: currentUser["uid"],
                                            userName: currentUser["fullName"],
                                          );
                                        },
                                        text: S.of(context).Send,
                                        tabletLayout:
                                            GlobalData().isTabletLayout,
                                      ),
                                    ),
                                  ],
                                ),

                            /// Animation for successful submission
                            SizedBox(height: 16.h),
                            Visibility(
                              visible: isAnimationVisible,
                              child: SizedBox(
                                height: 100.h,
                                child: Lottie.asset(
                                  'assets/animation/done_lottie.json',
                                  controller: _animationController,
                                  onLoaded: (composition) {
                                    _animationController.duration =
                                        composition.duration;
                                  },
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      RatingsHorizontalView(ratings: cubit.ratingsList),
                      SizedBox(height: 10.h),
                      if (context.read<DepartmentCubit>().canManage) ...[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Divider(endIndent: 8.w, indent: 8.w),
                            SizedBox(height: 10.h),
                            CustomElevatedButtonWithIcon(
                              label: S.of(context).GoToComplaints,
                              fontSize: 14.sp,
                              icon: Icons.arrow_back_ios_new_outlined,
                              backGroundColor: Colors.brown[400],
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return MultiBlocProvider(
                                        providers: [
                                          BlocProvider.value(
                                            value: widget.departmentCubit,
                                          ),
                                          // DepartmentCubit
                                          BlocProvider.value(value: cubit),
                                          // RatingCubit
                                        ],
                                        child: ComplaintsView(
                                          menuItemModel: widget.menuItemModel,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
