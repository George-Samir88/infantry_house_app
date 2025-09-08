import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/global_variables.dart';

import '../../../../generated/l10n.dart';
import '../../../../utils/custom_appbar_editing_view.dart';
import 'daily_games_view_body_in_case_of_not_empty.dart';
import 'daily_games_view_in_case_of_empty.dart';
import 'manager/daily_games_cubit.dart';

class DailyGamesView extends StatelessWidget {
  const DailyGamesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DailyGamesCubit()..initialRotation(),
      child: Scaffold(
        backgroundColor: Color(0xffF5F5F5),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.h),
          child: CustomAppBarEditingView(
            onPressed: () {
              Navigator.pop(context);
            },
            title: S.of(context).DailyGames,
          ),
        ),
        body: BlocBuilder<DailyGamesCubit, DailyGamesState>(
          builder: (context, state) {
            var cubit = context.read<DailyGamesCubit>();
            return Padding(
              padding: EdgeInsets.only(
                right: GlobalData().isArabic ? 0 : 16.w,
                left: GlobalData().isArabic ? 16.w : 0,
                top: 20.0.h,
              ),
              child:
                  cubit.mapBetweenCategoriesAndActivities.isNotEmpty
                      ? DailyGamesViewBodyInCaseOfNotEmpty(cubit: cubit)
                      : DailyGamesViewInCaseOfEmpty(cubit: cubit),
            );
          },
        ),
      ),
    );
  }
}
