import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/generated/l10n.dart';

import 'animated_grid_item.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final String userName = "George Samir";

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            color: Color(0xFF6D3A2D),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade600,
                blurRadius: 8,
                spreadRadius: 2,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppBar(
                backgroundColor: Color(0xFF6D3A2D),
                elevation: 0,
                title: Text(
                  S.of(context).MainMenu,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
                leading: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 24.r,
                      color: Colors.white,
                    ),
                    // ripple color
                    highlightColor:
                        Colors.transparent, // remove highlight shadow
                  ),
                ),
              ),
            ],
          ),
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
            // 🔹 AppBar Section
            Expanded(
              child: ListView(
                children: [
                  SizedBox(height: 10.h),

                  // 🔹 Profile Section (First Letter Only)
                  ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.brown[800],
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : "?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      userName,
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
                      // Navigate to profile
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
                          child: AnimatedGridItem(
                            onTap: () {},
                            icon: Icons.favorite,
                            title: S.of(context).Favorites,
                          ),
                        ),
                        FadeInUp(
                          delay: const Duration(milliseconds: 100),
                          child: AnimatedGridItem(
                            onTap: () {},
                            icon: Icons.settings,
                            title: S.of(context).Settings,
                          ),
                        ),
                        FadeInUp(
                          delay: const Duration(milliseconds: 200),
                          child: AnimatedGridItem(
                            onTap: () {},
                            icon: Icons.help,
                            title: S.of(context).Help,
                          ),
                        ),
                        FadeInUp(
                          delay: const Duration(milliseconds: 300),
                          child: AnimatedGridItem(
                            onTap: () {},
                            icon: Icons.feedback,
                            title: S.of(context).Complaints,
                          ),
                        ),
                        FadeInUp(
                          delay: const Duration(milliseconds: 400),
                          child: AnimatedGridItem(
                            onTap: () {},
                            icon: Icons.info,
                            title: S.of(context).AboutApp,
                          ),
                        ),
                        FadeInUp(
                          delay: const Duration(milliseconds: 500),
                          child: AnimatedGridItem(
                            onTap: () {},
                            icon: Icons.contact_mail,
                            title: S.of(context).ContactUs,
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
  }
}
