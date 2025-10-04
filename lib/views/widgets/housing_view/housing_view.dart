import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/screen_names.dart';
import '../../../generated/l10n.dart';
import '../general_template/general_template.dart';
import '../general_template/manager/department_cubit.dart';
import '../home_view/manager/home_cubit.dart';

class HousingView extends StatelessWidget {
  const HousingView({super.key, required this.screenId});

  final String screenId;

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context); // ✅ safe here
    final screenName = DepartmentsTitles.housing;
    final canManage = context.read<HomeCubit>().canManageScreen(
      screenName: screenName,
    );

    return BlocProvider(
      create: (_) => DepartmentCubit(
        departmentId: screenId,
        canManage: canManage,
        loc: loc, // ✅ no BuildContext passed inside Cubit
      ),
      child: GeneralTemplateView(
        appBarTitle: loc.eskan, // ✅ also safe
      ),
    );
  }
}
