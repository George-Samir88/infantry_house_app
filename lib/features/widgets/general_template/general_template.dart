import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/features/widgets/general_template/sub_screen_template.dart';
import 'package:infantry_house_app/utils/custom_error_template.dart';
import 'package:infantry_house_app/utils/no_internet_connection_template.dart';

import '../../../utils/custom_app_bar.dart';
import '../cart_view/my_cart_view.dart';
import '../home_view/manager/home_cubit.dart';
import 'general_body_template.dart';
import 'manager/department_cubit.dart';

class GeneralTemplateView extends StatefulWidget {
  const GeneralTemplateView({super.key, required this.appBarTitle});

  final String appBarTitle;

  @override
  State<GeneralTemplateView> createState() => _GeneralTemplateViewState();
}

class _GeneralTemplateViewState extends State<GeneralTemplateView> {
  Completer<void> _refreshCompleter = Completer<void>();

  Future<void> _handleRefresh() async {
    // reset completer
    if (_refreshCompleter.isCompleted) {
      _refreshCompleter = Completer<void>();
    }

    final cubit = context.read<DepartmentCubit>();

    // trigger your functions (don’t await if you want parallel calls)
    cubit.loadAllSubScreenData();
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
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (BuildContext context, state) {
                    var homeCubit = context.read<HomeCubit>();
                    return CustomAppBar(
                      onPressedOnMenuButton: () {
                        homeCubit.scaffoldKey.currentState!.openDrawer();
                      },
                      onPressedOnMyCartButton: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyCartView()),
                        );
                      },
                      appBarTitle: widget.appBarTitle,
                    );
                  },
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: true,
                child:
                    state is DepartmentGetSubScreensNamesFailureState
                        ? CustomErrorTemplate(
                          onRetry: () async {
                            if (await context
                                .read<DepartmentCubit>()
                                .hasInternetConnection()) {
                              if (!context.mounted) return;
                              context
                                  .read<DepartmentCubit>()
                                  .listenToSubScreens();
                            }
                          },
                          isShowCustomEditButton: true,
                        )
                        : state is DepartmentNoInternetConnectionState
                        ? NoInternetConnectionWidget(
                          onRetry: () async {
                            if (await context
                                .read<DepartmentCubit>()
                                .hasInternetConnection()) {
                              if (!context.mounted) return;
                              context
                                  .read<DepartmentCubit>()
                                  .listenToSubScreens();
                            }
                          },
                        )
                        : RefreshIndicator(
                          onRefresh: _handleRefresh,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  color: const Color(0xff6F4E37),
                                  padding: EdgeInsets.only(
                                    top: 10.h,
                                    bottom: 15.h,
                                  ),
                                  child: const SubScreenTemplate(),
                                ),
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: MediaQuery.sizeOf(context).width,
                                      height: 50.h,
                                      color: const Color(0xff6F4E37),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xffF5F5F5),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: const GeneralBodyTemplateView(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
              ),
            ],
          ),
        );
      },
    );
  }
}
