import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/l10n.dart';
import '../general_template/general_template.dart';
import '../general_template/manager/department_cubit.dart';

class FoodAndBeverageView extends StatelessWidget {
  const FoodAndBeverageView({super.key, required this.screenId});

  final String screenId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DepartmentCubit(departmentId: screenId),
      child: GeneralTemplateView(
        appBarTitle: S.of(context).KesmElA8zyaWlma4robat,
      ),
    );
  }
}
