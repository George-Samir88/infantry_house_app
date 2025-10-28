import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infantry_house_app/utils/custom_empty_items_template.dart';
import 'package:infantry_house_app/utils/custom_error_template.dart';
import 'package:infantry_house_app/utils/no_internet_connection_template.dart';
import 'package:infantry_house_app/views/widgets/notification_view/notification_shimmer.dart';
import 'package:intl/intl.dart';
import 'package:infantry_house_app/generated/l10n.dart';
import 'package:infantry_house_app/utils/custom_appbar_editing_view.dart';
import 'animated_notification_tile.dart';
import 'manager/notification_cubit.dart';

/// 🔔 Displays a list of notifications using NotificationCubit (Firestore + Cache)
class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);

    return BlocProvider(
      create: (context) => NotificationCubit(loc: loc)..getNotifications(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: CustomAppBarEditingView(
            title: loc.Notifications,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF5F5F5), Color(0xFFECE0DC)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              var notificationCubit = context.read<NotificationCubit>();
              // 🌀 Loading
              if (state is NotificationLoading) {
                return const NotificationShimmerLoader();
              }

              // ❌ No Internet
              if (state is NoInternetConnectionState) {
                return NoInternetConnectionWidget(
                  onRetry: () async {
                    if (await notificationCubit.hasInternetConnection()) {
                      notificationCubit.getNotifications();
                    }
                  },
                );
              }

              // ⚠️ Error
              if (state is NotificationError) {
                return CustomErrorTemplate(
                  isShowCustomEditButton: true,
                  onRetry: () async {
                    if (await notificationCubit.hasInternetConnection()) {
                      notificationCubit.getNotifications();
                    }
                  },
                );
              }

              // ✅ Data Loaded
              if (state is NotificationLoadedSuccess) {
                final notifications = state.notifications;

                if (notifications.isEmpty) {
                  return CustomEmptyWidgetTemplate(
                    onRetry: () async {
                      if (await notificationCubit.hasInternetConnection()) {
                        notificationCubit.getNotifications();
                      }
                    },
                    isShowCustomEditButton: true,
                  );
                }

                final localeCode = Localizations.localeOf(context).languageCode;

                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final n = notifications[index];
                    final dateStr = DateFormat(
                      'yMMMd – HH:mm',
                      localeCode,
                    ).format(n.createdAt);

                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: AnimatedNotificationTile(
                        index: index,
                        title: n.title,
                        body: n.body,
                        image: n.image,
                        topic: n.topic,
                        type: n.type,
                        offerId: n.offerId,
                        dateStr: dateStr,
                        loc: loc,
                      ),
                    );
                  },
                );
              }

              // 💤 Initial / Empty State
              return CustomEmptyWidgetTemplate(
                onRetry: () async {
                  if (await notificationCubit.hasInternetConnection()) {
                    notificationCubit.getNotifications();
                  }
                },
                isShowCustomEditButton: true,
              );
            },
          ),
        ),
      ),
    );
  }
}
