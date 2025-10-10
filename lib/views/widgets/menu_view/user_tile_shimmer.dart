import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../general_template/shimmer_loader.dart';

class UserTileShimmer extends StatelessWidget {
  const UserTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ShimmerLoader(height: 50.r, width: 50.r, borderRadius: 50),
      title: Padding(
        padding: EdgeInsets.only(bottom: 6.h),
        child: ShimmerLoader(height: 18.h, width: 120.w, borderRadius: 8),
      ),
      subtitle: ShimmerLoader(height: 14.h, width: 80.w, borderRadius: 8),
      trailing: ShimmerLoader(height: 20.h, width: 20.h, borderRadius: 8),
    );
  }
}
