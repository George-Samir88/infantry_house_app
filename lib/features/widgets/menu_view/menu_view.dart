import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/features/widgets/menu_view/user_tile_shimmer.dart';
import 'package:infantry_house_app/generated/l10n.dart';
import 'package:infantry_house_app/utils/custom_appbar_editing_view.dart';
import 'package:infantry_house_app/utils/custom_snackBar.dart';


import '../app_complaints_view/app_complaints_dashboard_view.dart';
import '../app_complaints_view/submit_app_complaints_view.dart';
import '../app_complaints_view/manager/app_complaints_cubit.dart';
import '../contact_us_view/contact_us_view.dart';
import '../help_view/help_view.dart';
import '../home_view/manager/home_cubit.dart';
import '../notification_view/notification_view.dart';
import '../profile_view/profile_view.dart';
import '../register_view/models/user_model.dart';
import '../setting_view/setting_view.dart';
import '../setting_view/show_about_dialog.dart';
import 'animated_grid_item.dart';
import 'manager/user_data_cubit.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  bool generalAdmin = false;

  @override
  void initState() {
    super.initState();
    final homeCubit = context.read<HomeCubit>();
    generalAdmin = homeCubit.isGeneralAdmin ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);
    return BlocProvider(
      create: (context) {
        return UserDataCubit(loc: loc);
      },
      child: Builder(
        builder: (innerContext) {
          innerContext.read<UserDataCubit>().loadUserData();
          var userDataCubit = innerContext.read<UserDataCubit>();
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60.h),
              child: CustomAppBarEditingView(
                onPressed: () => Navigator.pop(innerContext),
                title: S.of(context).MainMenu,
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF5F5F5), Color(0xFFECE0DC)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        SizedBox(height: 10.h),
                        // 🔹 Profile Section (First Letter Only)
                        BlocConsumer<UserDataCubit, UserDataState>(
                          buildWhen: (previous, current) {
                            return current is UserDataError ||
                                current is UserDataLoadedSuccess ||
                                current is UserDataUpdatedSuccess ||
                                current is UserDataLoading ||
                                current is NoInternetConnectionState;
                          },
                          listener: (context, state) {
                            if (state is UserDataError) {
                              showSnackBar(
                                context: context,
                                message: state.message,
                                backgroundColor: Colors.redAccent,
                              );
                            } else if (state is NoInternetConnectionState) {
                              showSnackBar(
                                context: context,
                                message: state.message,
                                backgroundColor: Colors.yellow[800],
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is UserDataLoading) {
                              return const UserTileShimmer();
                            } else if (state is UserDataError) {
                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.red[400],
                                  child: const Icon(
                                    Icons.error,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  state.message,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              );
                            } else if (state is UserDataLoadedSuccess) {
                              final UserModel userModel =
                                  userDataCubit.userModel;
                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.brown[800],
                                  child: Text(
                                    userModel.fullName.isNotEmpty
                                        ? userModel.fullName[0].toUpperCase()
                                        : "?",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  userModel.fullName,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                subtitle: Text(
                                  S.of(context).ViewProfile,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                  color: Colors.brown[800],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => BlocProvider.value(
                                            value: userDataCubit,
                                            child: ProfileScreen(),
                                          ),
                                    ),
                                  );
                                },
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),

                        Divider(color: Colors.grey[300]),

                        // 🔹 Grid Menu with Animation
                        Padding(
                          padding: EdgeInsets.all(12.w),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 15.h,
                            crossAxisSpacing: 15.w,
                            childAspectRatio: 1,
                            children: [
                              FadeInUp(
                                delay: const Duration(milliseconds: 100),
                                child: AnimatedGridItem(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => BlocProvider.value(
                                              value: userDataCubit,
                                              child: const SettingsView(),
                                            ),
                                      ),
                                    );
                                  },
                                  icon: Icons.settings,
                                  title: S.of(context).Settings,
                                ),
                              ),
                              FadeInUp(
                                delay: const Duration(milliseconds: 200),
                                child: AnimatedGridItem(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HelpView(),
                                      ),
                                    );
                                  },
                                  icon: Icons.help,
                                  title: S.of(context).Help,
                                ),
                              ),
                              FadeInUp(
                                delay: const Duration(milliseconds: 300),
                                child: AnimatedGridItem(
                                  onTap: () {
                                    if (generalAdmin) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => BlocProvider(
                                                create:
                                                    (context) =>
                                                        AppComplaintsCubit(
                                                          loc: loc,
                                                        ),
                                                child:
                                                    const AppComplaintsDashboardView(),
                                              ),
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => BlocProvider(
                                                create:
                                                    (context) =>
                                                        AppComplaintsCubit(
                                                          loc: loc,
                                                        ),
                                                child:
                                                    const AppComplaintsView(),
                                              ),
                                        ),
                                      );
                                    }
                                  },
                                  icon: Icons.feedback,
                                  title: S.of(context).Complaints,
                                ),
                              ),
                              FadeInUp(
                                delay: const Duration(milliseconds: 400),
                                child: AnimatedGridItem(
                                  onTap: () {
                                    showAboutAppDialogAlert(context);
                                  },
                                  icon: Icons.info,
                                  title: S.of(context).AboutApp,
                                ),
                              ),
                              FadeInUp(
                                delay: const Duration(milliseconds: 500),
                                child: AnimatedGridItem(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const AppContactUsView(),
                                      ),
                                    );
                                  },
                                  icon: Icons.contact_mail,
                                  title: S.of(context).ContactUs,
                                ),
                              ),
                              FadeInUp(
                                delay: const Duration(milliseconds: 500),
                                child: AnimatedGridItem(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const NotificationsView(),
                                      ),
                                    );
                                  },
                                  icon: Icons.notifications_active_outlined,
                                  title: S.of(context).Notifications,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Divider(color: Colors.grey[300]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
