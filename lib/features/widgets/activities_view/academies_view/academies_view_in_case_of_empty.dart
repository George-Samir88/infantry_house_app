import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated/l10n.dart';
import '../../../../utils/custom_edit_button.dart';
import 'academies_edit_academy_view.dart';
import 'manager/academies_cubit.dart';

class AcademiesViewInCaseOfEmpty extends StatelessWidget {
  const AcademiesViewInCaseOfEmpty({super.key, required this.cubit});

  final AcademiesCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        image: DecorationImage(
          opacity: 0.2,
          image: AssetImage("assets/images/academies_background.jpg"),
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
                        child: AcademiesEditAcademyView(),
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
