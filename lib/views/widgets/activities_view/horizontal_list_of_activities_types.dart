import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:infantry_house_app/views/widgets/activities_view/subscription_view/subscriptions_view_body.dart';

import 'academies_view/academies_view.dart';
import 'custom_activity_card_item.dart';

class HorizontalListOfActivitiesTypes extends StatelessWidget {
  const HorizontalListOfActivitiesTypes({
    super.key,
    required this.activityTitle,
    required this.activityImages,
  });

  final List<String> activityTitle;
  final List<String> activityImages;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
      child: AnimationLimiter(
        child: Row(
          children: List.generate(
            2,
            (index) => Expanded(
              child: AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 1000),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: GestureDetector(
                      onTap: () {
                        index == 0
                            ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubscriptionsViewBody(),
                              ),
                            )
                            : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AcademiesView(),
                              ),
                            );
                      },
                      child: CustomActivityCardItem(
                        activityTitle: activityTitle[index],
                        activityImage: activityImages[index],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
