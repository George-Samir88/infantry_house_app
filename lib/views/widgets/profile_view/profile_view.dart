import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/views/widgets/menu_view/manager/user_data_cubit.dart';
import 'package:infantry_house_app/views/widgets/profile_view/edit_user_profile_view.dart';

import '../../../generated/l10n.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<UserDataCubit>();
    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFECE0DC), Color(0xFFF5F5F5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          BlocBuilder<UserDataCubit, UserDataState>(
            builder: (context, state) {
              return CustomScrollView(
                slivers: [
                  // 🔹 Collapsing AppBar
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    expandedHeight: 200.h,
                    pinned: true,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios_outlined),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: FadeInDown(
                        child: Text(
                          S.of(context).Profile,
                          style: TextStyle(
                            color: Colors.brown[800],
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      background: Hero(
                        tag: "profileAvatar",
                        child: Container(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.brown[800],
                            child: Text(
                              cubit.userModel.fullName.isNotEmpty
                                  ? cubit.userModel.fullName[0]
                                  : "?",
                              style: TextStyle(
                                fontSize: 40.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 🔹 Profile Details
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeInUp(
                            child: _buildInfoCard(
                              icon: Icons.person,
                              title: S.of(context).UserName,
                              subtitle: cubit.userModel.fullName,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          FadeInUp(
                            delay: const Duration(milliseconds: 100),
                            child: _buildInfoCard(
                              icon: Icons.email,
                              title: S.of(context).Email,
                              subtitle: cubit.userModel.email,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          FadeInUp(
                            delay: const Duration(milliseconds: 200),
                            child: _buildInfoCard(
                              icon: Icons.phone,
                              title: S.of(context).PhoneNumber,
                              subtitle: cubit.userModel.phone,
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // 🔹 Animated Action Buttons
                          FadeInUp(
                            delay: const Duration(milliseconds: 300),
                            child: _buildActionButton(
                              context,
                              icon: Icons.edit,
                              text: S.of(context).EditProfile,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => BlocProvider.value(
                                          value: cubit,
                                          child: EditProfileScreen(),
                                        ),
                                  ),
                                );
                              },
                            ),
                          ),
                          FadeInUp(
                            delay: const Duration(milliseconds: 400),
                            child: _buildActionButton(
                              context,
                              icon: Icons.lock,
                              text: S.of(context).ChangePassword,
                              onTap: () {},
                            ),
                          ),
                          FadeInUp(
                            delay: const Duration(milliseconds: 500),
                            child: _buildActionButton(
                              context,
                              icon: Icons.logout,
                              text: S.of(context).LogOut,
                              onTap: () {},
                              buttonColor: Colors.red[400],
                              textColor: Colors.white,
                              iconColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // 🔹 Profile info card
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: ListTile(
        leading: Icon(icon, color: Colors.brown[800], size: 26.sp),
        title: Text(
          title,
          style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  // 🔹 Action button card
  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? buttonColor,
    Color? textColor,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        color: buttonColor ?? Colors.brown[50],
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              Icon(icon, color: iconColor ?? Colors.brown[800], size: 22.sp),
              SizedBox(width: 12.w),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor ?? Colors.brown[800],
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
                color: iconColor ?? Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
