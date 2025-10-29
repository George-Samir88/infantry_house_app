import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:infantry_house_app/features/widgets/general_template/rating_view.dart';

import '../../../generated/l10n.dart';
import '../../../global_variables.dart';
import '../../../utils/custom_snackBar.dart';
import '../cart_view/manager/cart_cubit/cart_cubit.dart';
import 'manager/department_cubit.dart';
import 'manager/rating_cubit.dart';

class CustomMenuItemsHorizontalGridView extends StatelessWidget {
  const CustomMenuItemsHorizontalGridView({super.key});

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
    return BlocBuilder<DepartmentCubit, DepartmentState>(
      builder: (context, state) {
        var cubit = context.read<DepartmentCubit>();
        return AnimationLimiter(
          child: GridView.builder(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              mainAxisSpacing: 20.0.w,
              crossAxisSpacing: 40.0.h,
            ),
            itemCount: cubit.menuItemsList.length,
            itemBuilder: (context, gridIndex) {
              return AnimationConfiguration.staggeredGrid(
                position: gridIndex,
                duration: const Duration(milliseconds: 500),
                columnCount: GlobalData().isTabletLayout ? 2 : 3,
                child: ScaleAnimation(
                  child: GestureDetector(
                    onTap: () {
                      final loc = S.of(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => BlocProvider.value(
                                value: cubit,
                                child: BlocProvider(
                                  create:
                                      (context) => RatingCubit(loc: loc)
                                        ..getRatings(
                                          menuItemId:
                                              cubit.menuItemsList[gridIndex].id,
                                        ),
                                  child: RatingView(
                                    menuItemModel:
                                        cubit.menuItemsList[gridIndex],
                                    departmentId: cubit.departmentId,
                                    subScreenId: cubit.selectedSubScreenID!,
                                    departmentCubit: cubit,
                                  ),
                                ),
                              ),
                        ),
                      );
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  GlobalData().isArabic
                                      ? cubit.menuItemsList[gridIndex].titleAr
                                      : cubit.menuItemsList[gridIndex].titleEn,
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
                                            cubit
                                                .menuItemsList[gridIndex]
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
                        Positioned(
                          top: -20.h,
                          right: GlobalData().isArabic ? -10.w : null,
                          left: GlobalData().isArabic ? null : -10.w,
                          child: _buildCircularImage(
                            cubit.menuItemsList[gridIndex].image,
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
                              '\$${cubit.menuItemsList[gridIndex].price}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -5.h,
                          left: GlobalData().isArabic ? -5.w : null,
                          right: GlobalData().isArabic ? null : -5.w,
                          child: GestureDetector(
                            onTap: () {
                              context.read<CartCubit>().addToCart(
                                cubit.menuItemsList[gridIndex],
                              );
                              showSnackBar(
                                context: context,
                                message:
                                    "${S.of(context).AddedSuccessfully} ${GlobalData().isArabic ? cubit.menuItemsList[gridIndex].titleAr : cubit.menuItemsList[gridIndex].titleEn} ${S.of(context).ToCard}",
                              );
                            },
                            child: CircleAvatar(
                              radius: 24.r,
                              backgroundColor: Colors.amber,
                              child: Icon(
                                Icons.shopping_cart,
                                color: Colors.brown[800],
                                size: 20.r,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
