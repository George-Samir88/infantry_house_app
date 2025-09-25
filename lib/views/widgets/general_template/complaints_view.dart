import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/models/menu_item_model.dart';
import 'package:infantry_house_app/views/widgets/general_template/manager/rating_cubit.dart';

import '../../../generated/l10n.dart';
import '../../../utils/app_loader.dart';
import '../../../utils/custom_appbar_editing_view.dart';
import '../../../utils/custom_snackBar.dart';
import '../../../utils/map_firebase_error.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RatingCubit, RatingState>(
      listener: (context, state) {
        if (state is RatingGetComplaintsFailure) {
          showSnackBar(
            context: context,
            message: localizeFirestoreError(
              context: context,
              code: state.failure,
            ),
            backgroundColor: Colors.redAccent,
          );
        }
        if (state is RatingGetRatingFailure) {
          showSnackBar(
            context: context,
            message: localizeFirestoreError(
              context: context,
              code: state.failure,
            ),
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
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            child: ListView(
              children: [
                SizedBox(height: 20.h),
                state is RatingGetComplaintsLoading
                    ? AppLoader()
                    : FeedbackList(complaints: cubit.complaintsList),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
