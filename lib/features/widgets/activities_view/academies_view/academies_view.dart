import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/global_variables.dart';

import '../../../../generated/l10n.dart';
import '../../../../utils/custom_appbar_editing_view.dart';
import 'academies_view_body_in_case_of_not_empty.dart';
import 'academies_view_in_case_of_empty.dart';
import 'manager/academies_cubit.dart';

class AcademiesView extends StatelessWidget {
  final S loc;
  final bool canManage;
  final String departmentId;

  const AcademiesView({
    super.key,
    required this.loc,
    required this.canManage,
    required this.departmentId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => AcademiesCubit(
            loc: loc,
            canManage: canManage,
            departmentId: departmentId,
          )..initialRotation(),
      child: Scaffold(
        backgroundColor: Color(0xffF5F5F5),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.h),
          child: CustomAppBarEditingView(
            onPressed: () {
              Navigator.pop(context);
            },
            title: S.of(context).Academies,
          ),
        ),
        body: BlocBuilder<AcademiesCubit, AcademiesState>(
          builder: (context, state) {
            var cubit = context.read<AcademiesCubit>();
            return Padding(
              padding: EdgeInsets.only(
                right: GlobalData().isArabic ? 0 : 16.w,
                left: GlobalData().isArabic ? 16.w : 0,
                top: 20.0.h,
              ),
              child:
                  // cubit.mapBetweenCategoriesAndActivities.isNotEmpty
                  //     ? AcademiesViewBodyInCaseOfNotEmpty(cubit: cubit)
                  //     :
                  AcademiesViewInCaseOfEmpty(cubit: cubit),
            );
          },
        ),
      ),
    );
  }
}
