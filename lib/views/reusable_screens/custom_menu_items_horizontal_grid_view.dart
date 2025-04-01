import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:infantry_house_app/models/menu_item_model.dart';
import 'package:infantry_house_app/views/reusable_screens/rating_view.dart';

import '../../generated/l10n.dart';
import '../../global_variables.dart';
import '../widgets_2/cart_view/manager/cart_cubit/cart_cubit.dart';
import '../../utils/custom_snackBar.dart';

class CustomMenuItemsHorizontalGridView extends StatelessWidget {
  const CustomMenuItemsHorizontalGridView({
    super.key,
    required this.menuItemModel,
  });

  final List<MenuItemModel> menuItemModel;

  Widget _buildCircularImage(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return CircleAvatar(
        radius: GlobalData().isTabletLayout ? 36.r : 31.r,
        backgroundColor: Colors.white, // Prevents image cropping
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.r),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: GlobalData().isTabletLayout ? 70.r : 60.r,
            height: GlobalData().isTabletLayout ? 70.r : 60.r,
          ),
        ),
      );
    } else if (File(imagePath).existsSync()) {
      return CircleAvatar(
        radius: GlobalData().isTabletLayout ? 36.r : 31.r,
        backgroundColor: Colors.white, // Prevents image cropping
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.r),
          child: Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            width: GlobalData().isTabletLayout ? 70.r : 60.r,
            height: GlobalData().isTabletLayout ? 70.r : 60.r,
          ),
        ),
      );
    }
    return Icon(Icons.broken_image, size: 40.r, color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
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
        itemCount: menuItemModel.length,
        itemBuilder: (context, gridIndex) {
          return AnimationConfiguration.staggeredGrid(
            position: gridIndex,
            duration: const Duration(milliseconds: 500),
            columnCount: GlobalData().isTabletLayout ? 2 : 3,
            child: ScaleAnimation(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => RatingView(
                            menuItemModel: menuItemModel[gridIndex],
                          ),
                    ),
                  );
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 12.0,
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
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              menuItemModel[gridIndex].title,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Colors.white,
                                fontSize:
                                    GlobalData().isTabletLayout ? 10.sp : 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: GlobalData().isTabletLayout ? 14.h : 10.h,
                          ),
                          Row(
                            children: List.generate(5, (starIndex) {
                              return Icon(
                                starIndex < menuItemModel[gridIndex].rating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.yellow,
                                size: GlobalData().isTabletLayout ? 16.r : 12.r,
                              );
                            }),
                          ),
                          SizedBox(
                            height: GlobalData().isTabletLayout ? 20.h : 10.h,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -20.h,
                      right: -10.w,
                      child: _buildCircularImage(
                        menuItemModel[gridIndex].image,
                      ),
                    ),
                    Positioned(
                      bottom: -10.h,
                      right: -8.w,
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
                          '\$${menuItemModel[gridIndex].price}',
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
                      left: -5.w,
                      child: GestureDetector(
                        onTap: () {
                          context.read<CartCubit>().addToCart(
                            menuItemModel[gridIndex],
                          );
                          showSnackBar(
                            context: context,
                            message:
                                "${S.of(context).AddedSuccessfully} ${menuItemModel[gridIndex].title} ${S.of(context).ToCard}",
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
  }
}
