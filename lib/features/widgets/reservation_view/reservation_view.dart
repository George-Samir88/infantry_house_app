import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/screen_names.dart';
import '../../../generated/l10n.dart';
import '../general_template/general_template.dart';
import '../general_template/manager/department_cubit.dart';
import '../home_view/manager/home_cubit.dart';

class ReservationView extends StatelessWidget {
  const ReservationView({super.key, required this.screenId});

  final String screenId;

  @override
  Widget build(BuildContext context) {
    final screenName = DepartmentsTitles.reservation;
    final canManage = context.read<HomeCubit>().canManageScreen(
      screenName: screenName,
    );
    final loc = S.of(context);

    return BlocProvider(
      create: (_) => DepartmentCubit(
        departmentId: screenId,
        canManage: canManage,
        loc: loc,
      ),
      child: GeneralTemplateView(
        appBarTitle: loc.hogozat,
      ),
    );
  }
}
