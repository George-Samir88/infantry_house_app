import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/utils/app_loader.dart';
import 'package:infantry_house_app/utils/map_firebase_error.dart';
import 'package:infantry_house_app/views/widgets/general_template/item_feedback_view.dart';
import 'package:lottie/lottie.dart';

import '../../../generated/l10n.dart';
import '../../../global_variables.dart';
import '../../../models/menu_item_model.dart';
import '../../../utils/custom_appbar_editing_view.dart';
import '../../../utils/custom_elevated_button.dart';
import '../../../utils/custom_snackBar.dart';
import '../cart_view/manager/cart_cubit/cart_cubit.dart';
import 'manager/rating_cubit.dart';

class RatingView extends StatefulWidget {
  const RatingView({
    super.key,
    required this.menuItemModel,
    required this.departmentId,
    required this.subScreenId,
  });

  final MenuItemModel menuItemModel;
  final String departmentId;
  final String subScreenId;

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

  Widget _buildCircularImage(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return CircleAvatar(
        radius: 31.r,
        backgroundColor: Colors.white, // Prevents image cropping
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.r),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: 60.r,
            height: 60.r,
          ),
        ),
      );
    } else if (File(imagePath).existsSync()) {
      return CircleAvatar(
        radius: 31.r,
        backgroundColor: Colors.white, // Prevents image cropping
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.r),
          child: Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            width: 60.r,
            height: 60.r,
          ),
        ),
      );
    }
    return Icon(Icons.broken_image, size: 40.r, color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RatingCubit(),
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.h),

                    ///card Item section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Container with responsive width and height
                          Container(
                            width: 160.w,
                            // Set width responsively
                            height: 140.h,
                            // Set height responsively
                            padding: EdgeInsets.symmetric(
                              vertical: 16.0.h,
                              horizontal: 12.0.w,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.brown[400],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade400,
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(16.0.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 8.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      widget.menuItemModel.title,
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    children: List.generate(5, (starIndex) {
                                      return Icon(
                                        starIndex <
                                                widget
                                                    .menuItemModel
                                                    .averageRating
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.yellow,
                                        size: 12.r,
                                      );
                                    }),
                                  ),
                                  SizedBox(height: 10.h),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: -20,
                            right: GlobalData().isArabic ? -10 : null,
                            left: GlobalData().isArabic ? null : -10,
                            child: _buildCircularImage(
                              widget.menuItemModel.image,
                            ),
                          ),
                          Positioned(
                            bottom: -10.h,
                            right: GlobalData().isArabic ? -8.w : null,
                            left: GlobalData().isArabic ? null : -8.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 4.h,
                                horizontal: 8.w,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '\$${widget.menuItemModel.price}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -5,
                            left: GlobalData().isArabic ? -5 : null,
                            right: GlobalData().isArabic ? null : -5,
                            child: GestureDetector(
                              onTap: () {
                                context.read<CartCubit>().addToCart(
                                  widget.menuItemModel,
                                ); // Add to cart>
                                showSnackBar(
                                  context: context,
                                  snackBarAction: SnackBarAction(
                                    onPressed: () {},
                                    label: '',
                                  ),
                                  message:
                                      "${S.of(context).AddedSuccessfully} ${widget.menuItemModel.title} ${S.of(context).ToCard}",
                                );
                                //  You might want to update state, show a snackbar, etc.
                              },
                              child: CircleAvatar(
                                radius: 24.r,
                                // Adjust the size
                                backgroundColor: Colors.amber,
                                // Use amber to match the price tag
                                child: Icon(
                                  Icons.shopping_cart,
                                  // Use the shopping cart icon
                                  color: Colors.brown[800], // Icon color
                                  size: 20.r, // Adjust icon size
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Divider(thickness: 2),

                    ///rating section
                    Text(
                      S.of(context).RateYourExperience,
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RatingBar.builder(
                          initialRating: menuItemRating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 1.0.w),
                          itemSize: 40.r,
                          itemBuilder:
                              (context, _) =>
                                  Icon(Icons.star, color: Colors.amber),
                          onRatingUpdate: (rating) {
                            setState(() {
                              menuItemRating = rating;
                            });
                          },
                        ),
                      ],
                    ),

                    ///send button
                    SizedBox(height: 10.h),
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
                                          (context) => BlocProvider.value(
                                            value: cubit,
                                            child: ItemFeedBackView(
                                              itemId: widget.menuItemModel.id,
                                              departmentId: widget.departmentId,
                                              subScreenId: widget.subScreenId,
                                              buttonId:
                                                  widget
                                                      .menuItemModel
                                                      .menuButtonId,
                                            ),
                                          ),
                                    ),
                                  );
                                },
                                text: S.of(context).ComplaintsAndSuggestions,
                                textColor: Color(0xFF6D3A2D),
                                backGroundColor: Colors.grey[300],
                                tabletLayout: GlobalData().isTabletLayout,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: CustomElevatedButton(
                                onPressed: () {
                                  cubit.submitRating(
                                    departmentId: widget.departmentId,
                                    subScreenId: widget.subScreenId,
                                    buttonId: widget.menuItemModel.menuButtonId,
                                    menuItemId: widget.menuItemModel.id,
                                    stars: menuItemRating.toInt(),
                                  );
                                },
                                text: S.of(context).Send,
                                tabletLayout: GlobalData().isTabletLayout,
                              ),
                            ),
                          ],
                        ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: isAnimationVisible,
                          child: SizedBox(
                            height: 100.h,
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
                      ],
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
