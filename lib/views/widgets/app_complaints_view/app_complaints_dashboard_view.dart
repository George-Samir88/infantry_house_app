import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/views/widgets/app_complaints_view/app_complaints_shimmer_card.dart';
import '../../../generated/l10n.dart';
import '../../../utils/custom_empty_items_template.dart';
import '../../../utils/no_internet_connection_template.dart';
import '../../../utils/custom_appbar_editing_view.dart';
import '../../../utils/custom_snackBar.dart';
import 'app_complaints_card.dart';
import 'manager/app_complaints_cubit.dart';

class AppComplaintsDashboardView extends StatefulWidget {
  const AppComplaintsDashboardView({super.key});

  @override
  State<AppComplaintsDashboardView> createState() =>
      _AppComplaintsDashboardViewState();
}

class _AppComplaintsDashboardViewState
    extends State<AppComplaintsDashboardView> {
  Completer<void> _refreshCompleter = Completer<void>();

  Future<void> _handleRefresh() async {
    if (_refreshCompleter.isCompleted) _refreshCompleter = Completer<void>();
    context
        .read<AppComplaintsCubit>()
        .getComplaints(); // Add this method in your cubit
    Future.delayed(const Duration(seconds: 2), () {
      if (!_refreshCompleter.isCompleted) _refreshCompleter.complete();
    });
    return _refreshCompleter.future;
  }

  @override
  void initState() {
    super.initState();
    context.read<AppComplaintsCubit>().getComplaints();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppComplaintsCubit, AppComplaintsState>(
      listener: (context, state) {
        if (state is ComplaintsGetFailure) {
          showSnackBar(
            context: context,
            message: state.failure,
            backgroundColor: Colors.redAccent,
          );
        }
      },
      builder: (context, state) {
        var cubit = context.read<AppComplaintsCubit>();
        return Scaffold(
          backgroundColor: const Color(0xffF5F5F5),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.h),
            child: CustomAppBarEditingView(
              onPressed: () => Navigator.pop(context),
              title: S.of(context).Ra2ykYhmna,
            ),
          ),
          body:
              state is ComplaintsNoInternetConnectionState
                  ? NoInternetConnectionWidget(
                    onRetry: () => cubit.getComplaints(),
                  )
                  : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child:
                          state is ComplaintsGetLoading
                              ? ListView.builder(
                                padding: EdgeInsets.only(top: 20.h),
                                itemCount: 5,
                                itemBuilder:
                                    (context, index) =>
                                        const AppComplaintCardShimmer(),
                              )
                              : state is ComplaintsGetEmpty
                              ? CustomEmptyWidgetTemplate(
                                onRetry: () => cubit.getComplaints(),
                                isShowCustomEditButton: true,
                              )
                              : ListView.builder(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                itemCount: cubit.complaintsList.length,
                                itemBuilder: (context, index) {
                                  final complaint = cubit.complaintsList[index];
                                  return AppComplaintCard(complaint: complaint);
                                },
                              ),
                    ),
                  ),
        );
      },
    );
  }
}
