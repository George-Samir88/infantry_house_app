import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/generated/l10n.dart';

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
                          child: _buildGridItem(
                            Icons.favorite,
                            S.of(context).Favorites,
                          ),
                        ),
                        FadeInUp(
                          delay: const Duration(milliseconds: 100),
                          child: _buildGridItem(
                            Icons.settings,
                            S.of(context).Settings,
                          ),
                        ),
                        FadeInUp(
                          delay: const Duration(milliseconds: 200),
                          child: _buildGridItem(Icons.help, S.of(context).Help),
                        ),
                        FadeInUp(
                          delay: const Duration(milliseconds: 300),
                          child: _buildGridItem(
                            Icons.feedback,
                            S.of(context).Complaints,
                          ),
                        ),
                        FadeInUp(
                          delay: const Duration(milliseconds: 400),
                          child: _buildGridItem(
                            Icons.info,
                            S.of(context).AboutApp,
                          ),
                        ),
                        FadeInUp(
                          delay: const Duration(milliseconds: 500),
                          child: _buildGridItem(
                            Icons.contact_mail,
                            S.of(context).ContactUs,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(color: Colors.grey[300]),

                  // 🔹 Location Container
                  Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Container(
                      height: 180.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.brown.shade100, Colors.brown.shade50],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.brown.shade200,
                            blurRadius: 6,
                            offset: const Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Opacity(
                              opacity: 0.1,
                              child: Icon(
                                Icons.map,
                                size: 200,
                                color: Colors.brown[300],
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              S.of(context).LocationHere,
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.brown[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(IconData icon, String title) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.brown.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () {
          // Navigate
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40.sp, color: Colors.brown[800]),
            SizedBox(height: 10.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
