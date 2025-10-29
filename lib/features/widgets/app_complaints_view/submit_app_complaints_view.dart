import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infantry_house_app/utils/custom_snackBar.dart';
import 'package:infantry_house_app/utils/custom_text_form_field.dart';
import '../../../generated/l10n.dart';
import '../../../global_variables.dart';
import '../../../utils/custom_appbar_editing_view.dart';
import 'build_zoom_in_floating_button.dart';
import 'manager/app_complaints_cubit.dart';

class AppComplaintsView extends StatefulWidget {
  const AppComplaintsView({super.key});

  @override
  State<AppComplaintsView> createState() => _AppComplaintsViewState();
}

class _AppComplaintsViewState extends State<AppComplaintsView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);

    return BlocConsumer<AppComplaintsCubit, AppComplaintsState>(
      listener: (context, state) {
        if (state is ComplaintsSubmitSuccess) {
          showDialog(
            context: context,
            builder:
                (_) => FadeInDown(
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    title: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 48.r,
                    ),
                    content: Text(
                      loc.ThankYou,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          loc.Close,
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      ),
                    ],
                  ),
                ),
          );

          _formKey.currentState?.reset();
          _nameController.clear();
          _phoneController.clear();
          _messageController.clear();
        } else if (state is ComplaintsSubmitError) {
          showSnackBar(
            context: context,
            message: "⚠️ ${state.error}",
            backgroundColor: Colors.redAccent,
          );
        } else if (state is ComplaintsNoInternetConnectionState) {
          showSnackBar(
            context: context,
            message: state.failure,
            backgroundColor: Colors.yellow[800],
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.h),
            child: CustomAppBarEditingView(
              onPressed: () => Navigator.pop(context),
              title: loc.Complaints,
            ),
          ),
          body: FadeInUp(
            duration: const Duration(milliseconds: 400),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      ElasticIn(
                        delay: const Duration(milliseconds: 400),
                        child: SvgPicture.asset(
                          'assets/images/customer-feedback.svg',
                          height: GlobalData().isTabletLayout ? 80.h : 100.h,
                          width: GlobalData().isTabletLayout ? 80.h : 100.w,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        loc.ComplaintsDescription,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30.h),
                      CustomTextFormField(
                        textEditingController: _nameController,
                        label: loc.Name,
                        textInputType: TextInputType.name,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? "${loc.Name} ${S.of(context).FieldCannotBeEmpty}"
                                    : null,
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Colors.brown.shade400,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      CustomTextFormField(
                        textEditingController: _phoneController,
                        label: loc.PhoneNumber,
                        textInputType: TextInputType.phone,
                        prefixIcon: Icon(
                          Icons.phone_outlined,
                          color: Colors.brown.shade400,
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? "${loc.PhoneNumber} ${S.of(context).FieldCannotBeEmpty}"
                                    : null,
                      ),
                      SizedBox(height: 16.h),
                      CustomTextFormField(
                        textEditingController: _messageController,
                        label: loc.Message,
                        maxLines: 5,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? "${loc.Message} ${S.of(context).FieldCannotBeEmpty}"
                                    : null,
                        textInputType: TextInputType.multiline,
                        prefixIcon: Icon(
                          Icons.edit_note_rounded,
                          color: Colors.brown.shade400,
                        ),
                      ),
                      SizedBox(height: 80.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: buildZoomInFloatingButton(
              isLoading: state is ComplaintsSubmitLoading,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (await context
                      .read<AppComplaintsCubit>()
                      .hasInternetConnection()) {
                    if (!context.mounted) return;
                    context.read<AppComplaintsCubit>().submitComplaint(
                      name: _nameController.text,
                      phone: _phoneController.text,
                      message: _messageController.text,
                    );
                  }
                }
              },
              context: context,
              loc: loc,
            ),
          ),
        );
      },
    );
  }
}
