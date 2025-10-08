import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/models/menu_item_model.dart';
import 'package:infantry_house_app/utils/custom_empty_items_template.dart';
import 'package:infantry_house_app/utils/custom_error_template.dart';
import 'package:infantry_house_app/utils/no_internet_connection_template.dart';
import 'package:infantry_house_app/views/widgets/general_template/manager/rating_cubit.dart';
import 'package:infantry_house_app/views/widgets/general_template/shimmer_loader.dart';

import '../../../generated/l10n.dart';
import '../../../utils/custom_appbar_editing_view.dart';
import '../../../utils/custom_snackBar.dart';
import 'feedback_list_view.dart';

class ComplaintsView extends StatefulWidget {
  const ComplaintsView({super.key, required this.menuItemModel});

  final MenuItemModel menuItemModel;

  @override
  State<ComplaintsView> createState() => _ComplaintsViewState();
}

class _ComplaintsViewState extends State<ComplaintsView> {
  @override
  void initState() {
    super.initState();
    context.read<RatingCubit>().getComplaints(itemId: widget.menuItemModel.id);
  }

  Completer<void> _refreshCompleter = Completer<void>();

  Future<void> _handleRefresh() async {
    // reset completer
    if (_refreshCompleter.isCompleted) {
      _refreshCompleter = Completer<void>();
    }
    // trigger your functions (don’t await if you want parallel calls)
    context.read<RatingCubit>().getComplaints(itemId: widget.menuItemModel.id);
    // stop refresh after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (!_refreshCompleter.isCompleted) {
        _refreshCompleter.complete();
      }
    });

    return _refreshCompleter.future;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RatingCubit, RatingState>(
      listener: (context, state) {
        if (state is RatingGetComplaintsFailure) {
          showSnackBar(
            context: context,
            message: state.failure,
            backgroundColor: Colors.redAccent,
          );
        }
        if (state is RatingGetRatingFailure) {
          showSnackBar(
            context: context,
            message: state.failure,
            backgroundColor: Colors.redAccent,
          );
        }
      },
      builder: (context, state) {
        var cubit = context.read<RatingCubit>();
        return Scaffold(
          backgroundColor: Color(0xffF5F5F5),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.h),
            child: CustomAppBarEditingView(
              onPressed: () {
                Navigator.pop(context);
              },
              title: S.of(context).Ra2ykYhmna,
            ),
          ),
          body:
              state is RatingNoInternetConnectionState
                  ? NoInternetConnectionWidget(
                    onRetry: () {
                      cubit.getComplaints(itemId: widget.menuItemModel.id);
                    },
                  )
                  : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child:
                          state is RatingGetComplaintsFailure
                              ? CustomErrorTemplate(
                                isShowCustomEditButton: true,
                                onRetry:
                                    () async => await cubit.getComplaints(
                                      itemId: widget.menuItemModel.id,
                                    ),
                              )
                              : state is RatingGetComplaintsEmpty
                              ? CustomEmptyWidgetTemplate(
                                isShowCustomEditButton: true,
                                onRetry: () async {
                                  if (await cubit.hasInternetConnection()) {
                                    await cubit.getComplaints(
                                      itemId: widget.menuItemModel.id,
                                    );
                                  }
                                },
                              )
                              : ListView(
                                children: [
                                  SizedBox(height: 20.h),
                                  if (state is RatingGetComplaintsLoading)
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: 5, // show 5 placeholders
                                      itemBuilder:
                                          (context, index) =>
                                              const FeedbackShimmerCard(),
                                    ),
                                  if (state is RatingGetComplaintsSuccess)
                                    FeedbackList(
                                      complaints: cubit.complaintsList,
                                    ),
                                  SizedBox(height: 20.h),
                                ],
                              ),
                    ),
                  ),
        );
      },
    );
  }
}

class FeedbackShimmerCard extends StatelessWidget {
  const FeedbackShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.grey.shade400, Colors.grey.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row for avatar and name
          Row(
            children: [
              const ShimmerLoader(height: 40, width: 40, borderRadius: 50),
              const SizedBox(width: 12),
              const Expanded(
                child: ShimmerLoader(height: 16, width: double.infinity),
              ),
              const SizedBox(width: 12),
              const ShimmerLoader(height: 14, width: 60),
            ],
          ),
          const SizedBox(height: 12),
          // Chips placeholders
          Wrap(
            spacing: 8,
            children: const [
              ShimmerLoader(height: 26, width: 70, borderRadius: 20),
              ShimmerLoader(height: 26, width: 90, borderRadius: 20),
              ShimmerLoader(height: 26, width: 60, borderRadius: 20),
            ],
          ),
          const SizedBox(height: 12),
          // Text line placeholders
          const ShimmerLoader(height: 14, width: double.infinity),
          const SizedBox(height: 6),
          const ShimmerLoader(height: 14, width: 180),
        ],
      ),
    );
  }
}
