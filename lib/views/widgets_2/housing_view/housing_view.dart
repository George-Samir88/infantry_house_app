import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/utils/custom_app_bar.dart';
import 'package:infantry_house_app/views/widgets_2/home_view/manager/home_cubit.dart';

import '../../../generated/l10n.dart';
import '../cart_view/my_cart_view.dart';
import 'H_custom_horizontal_list_department.dart';
import 'housing_custom_template.dart';
import 'manager/housing_cubit.dart';

class HousingViewBody extends StatelessWidget {
  const HousingViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HousingCubit>(
          create:
              (context) => HousingCubit()..initializeMapBetweenScreensAndData(),
        ),
      ],
      child: BlocBuilder<HousingCubit, HousingState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<HomeCubit, HomeState>(
                builder: (BuildContext context, state) {
                  var homeCubit = context.read<HomeCubit>();
                  return CustomAppBar(
                    onPressedOnMenuButton: () {
                      homeCubit.scaffoldKey.currentState!.openDrawer();
                    },
                    onPressedOnMyCartButton: () {
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyCartView()),
                        );
                      }
                    },
                    appBarTitle: S.of(context).eskan,
                  );
                },
              ),
              Container(
                color: const Color(0xff6F4E37),
                padding: EdgeInsets.only(top: 10.h, bottom: 15.h),
                child: HousingCustomHorizontalListDepartment(),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 50.h,
                    decoration: BoxDecoration(color: const Color(0xff6F4E37)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffF5F5F5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: HousingCustomTemplate(),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
