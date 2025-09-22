import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/views/widgets/general_template/sub_screen_template.dart';
import 'package:infantry_house_app/views/widgets/general_template/general_body_template.dart';
import 'package:infantry_house_app/views/widgets/general_template/manager/department_cubit.dart';

import '../../../utils/custom_app_bar.dart';
import '../cart_view/my_cart_view.dart';
import '../home_view/manager/home_cubit.dart';

class GeneralTemplateView extends StatefulWidget {
  const GeneralTemplateView({super.key, required this.appBarTitle});

  final String appBarTitle;

  @override
  State<GeneralTemplateView> createState() => _GeneralTemplateViewState();
}

class _GeneralTemplateViewState extends State<GeneralTemplateView> {
  Completer<void> _refreshCompleter = Completer<void>();
  bool loading = false;

  Future<void> _handleRefresh() async {
    // reset completer
    if (_refreshCompleter.isCompleted) {
      _refreshCompleter = Completer<void>();
    }

    final cubit = context.read<DepartmentCubit>();

    // trigger your functions (don’t await if you want parallel calls)
    cubit.listenToCarousel();
    cubit.listenToMenuTitle();
    cubit.listenToMenuButtons();

    // stop refresh after 4 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (!_refreshCompleter.isCompleted) {
        _refreshCompleter.complete();
      }
    });

    return _refreshCompleter.future;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DepartmentCubit, DepartmentState>(
      builder: (context, state) {
        return Expanded(
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: ListView(
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
                            MaterialPageRoute(
                              builder: (context) => MyCartView(),
                            ),
                          );
                        }
                      },
                      appBarTitle: widget.appBarTitle,
                    );
                  },
                ),
                Container(
                  color: const Color(0xff6F4E37),
                  padding: EdgeInsets.only(top: 10.h, bottom: 15.h),
                  child: SubScreenTemplate(),
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
                      child: GeneralBodyTemplateView(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
