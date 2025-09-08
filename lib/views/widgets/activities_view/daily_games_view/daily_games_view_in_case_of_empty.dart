import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated/l10n.dart';
import '../../../../utils/custom_edit_button.dart';
import 'daily_games_edit_screen_department_view.dart';
import 'manager/daily_games_cubit.dart';

class DailyGamesViewInCaseOfEmpty extends StatelessWidget {
  const DailyGamesViewInCaseOfEmpty({super.key, required this.cubit});

  final DailyGamesCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        image: DecorationImage(
          opacity: 0.2,
          image: AssetImage("assets/images/daily_activity_background.jpg"),
          fit: BoxFit.cover, // Cover the entire screen
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/box.png', height: 100.h, width: 100.w),
          SizedBox(height: 10.h),
          Text(S.of(context).LaYogdAksam, style: TextStyle(fontSize: 20.sp)),
          SizedBox(height: 20.h),
          CustomEditButton(
            iconColor: Colors.brown[800],
            backgroundColor: Colors.amberAccent.shade100,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => BlocProvider.value(
                        value: cubit,
                        child: DailyGamesEditScreenDepartmentView(),
                      ),
                ),
              );
            },
            icon: Icons.add,
          ),
        ],
      ),
    );
  }
}
