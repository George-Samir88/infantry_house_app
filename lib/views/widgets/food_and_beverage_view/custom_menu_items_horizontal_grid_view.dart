import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/models/menu_item_model.dart';
import 'package:infantry_house_app/views/widgets_2/food_and_beverage_view/rating_view.dart';

import '../../../generated/l10n.dart';
import '../../../global_variables.dart';
import '../../../utils/custom_snackBar.dart';
import '../../widgets_2/food_and_beverage_view/manager/cart_cubit/cart_cubit.dart';

class CustomMenuItemsHorizontalGridView extends StatelessWidget {
  const CustomMenuItemsHorizontalGridView({
    super.key,
    required this.menuItemModel,
  });

  final List<MenuItemModel> menuItemModel;

  Widget _buildCircularImage(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return CircleAvatar(
        radius: GlobalData().isTabletLayout ? 52.r : 31.r,
        backgroundColor: Colors.white, // Prevents image cropping
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.r),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: GlobalData().isTabletLayout ? 100.r : 60.r,
            height: GlobalData().isTabletLayout ? 100.r : 60.r,
          ),
        ),
      );
    } else if (File(imagePath).existsSync()) {
      return CircleAvatar(
        radius: GlobalData().isTabletLayout ? 52.r : 31.r,
        backgroundColor: Colors.white, // Prevents image cropping
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.r),
          child: Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            width: GlobalData().isTabletLayout ? 100.r : 60.r,
            height: GlobalData().isTabletLayout ? 100.r : 60.r,
          ),
        ),
      );
    }
    return Icon(Icons.broken_image, size: 40.r, color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    print("--------------------------------------------- ${menuItemModel.length}");
    return GridView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      clipBehavior: Clip.none,
      itemCount: menuItemModel.length,
      // Ensure we don't exceed list length
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: GlobalData().isTabletLayout ? 1 : 2,
        childAspectRatio: 1,
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 40.0,
        // mainAxisExtent: 120.h
      ),
      itemBuilder: (context, gridIndex) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        RatingView(menuItemModel: menuItemModel[gridIndex]),
              ),
            );
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
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
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
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
                                GlobalData().isTabletLayout ? 8.sp : 12.sp,
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
              ),
              Positioned(
                top: -20,
                right: -10,
                child: _buildCircularImage(menuItemModel[gridIndex].image),
              ),
              Positioned(
                bottom: -10,
                right: -8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '\$${menuItemModel[gridIndex].price}',
                    style: TextStyle(
                      fontSize: GlobalData().isTabletLayout ? 6.sp : 12.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -5,
                left: -5,
                child: Align(
                  // Use Align to control the position of the button
                  alignment: Alignment.centerRight, //  Align to the right
                  child: GestureDetector(
                    onTap: () {
                      context.read<CartCubit>().addToCart(
                        menuItemModel[gridIndex],
                      ); // Add to cart>
                      //  Implement your "Add to Cart" logic here!
                      print("Added ${menuItemModel[gridIndex].title} to cart");
                      showSnackBar(
                        context: context,
                        snackBarAction: SnackBarAction(
                          onPressed: () {},
                          label: '',
                        ),
                        message:
                            "${S.of(context).AddedSuccessfully} ${menuItemModel[gridIndex].title} ${S.of(context).ToCard}",
                      );
                      //  You might want to update state, show a snackbar, etc.
                    },
                    child: CircleAvatar(
                      radius: GlobalData().isTabletLayout ? 20.r : 24.r,
                      // Adjust the size
                      backgroundColor: Colors.amber,
                      // Use amber to match the price tag
                      child: Icon(
                        Icons.shopping_cart, // Use the shopping cart icon
                        color: Colors.brown[800], // Icon color
                        size:
                            GlobalData().isTabletLayout
                                ? 20.r
                                : 20.r, // Adjust icon size
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
