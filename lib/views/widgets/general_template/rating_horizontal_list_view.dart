import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../models/rating_model.dart';

class RatingsHorizontalView extends StatelessWidget {
  final List<RatingModel> ratings;

  const RatingsHorizontalView({super.key, required this.ratings});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: ratings.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final r = ratings[index];
          return _RatingCard(rating: r);
        },
      ),
    );
  }
}

class _RatingCard extends StatelessWidget {
  final RatingModel rating;
  final Color baseBrown = const Color(0xFF6D3A2D);
  final Color amber = const Color(0xFFFFA000);

  const _RatingCard({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: baseBrown.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: baseBrown.withValues(alpha: 0.25),
            blurRadius: 8.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User header
          Row(
            children: [
              CircleAvatar(
                backgroundColor: amber,
                child: Text(
                  rating.username.isNotEmpty
                      ? rating.username[0].toUpperCase()
                      : "?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: baseBrown,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  rating.username,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          // Rating stars
          RatingBarIndicator(
            rating: rating.stars,
            itemBuilder: (_, __) => Icon(Icons.star, color: amber),
            itemCount: 5,
            itemSize: 22,
            unratedColor: Colors.white30,
            direction: Axis.horizontal,
          ),

          SizedBox(height: 4.h),

          // Rating text
          Text(
            "${rating.stars.toStringAsFixed(1)} / 5",
            style: TextStyle(color: Colors.white70, fontSize: 12.sp),
          ),

          const Spacer(),

          // Timestamp
          Text(
            DateFormat('MMM d, HH:mm').format(rating.timestamp!),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
