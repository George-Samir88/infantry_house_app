import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/views/widgets_2/food_and_beverage_view/custom_horizontal_list_department.dart';

import '../../widgets/food_and_beverage_view/manager/food_and_beverage/food_and_beverage_cubit.dart';
import 'custom_template.dart';

class FoodAndBeverageViewBody extends StatelessWidget {
  const FoodAndBeverageViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FoodAndBeverageCubit>(
          create:
              (context) =>
                  FoodAndBeverageCubit()..initializeMapBetweenScreensAndData(),
        ),
      ],
      child: BlocBuilder<FoodAndBeverageCubit, FoodAndBeverageState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              CustomHorizontalListDepartment(),
              CustomTemplate(),
            ],
          );
        },
      ),
    );
  }
}
