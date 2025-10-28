import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../generated/l10n.dart';

/// 🔔 Animated Notification Tile with brown theme and detail dialog.
class AnimatedNotificationTile extends StatelessWidget {
  final int index;
  final String title;
  final String body;
  final String image;
  final String topic;
  final String type;
  final String offerId;
  final String dateStr;
  final S loc;

  const AnimatedNotificationTile({
    super.key,
    required this.index,
    required this.title,
    required this.body,
    required this.image,
    required this.topic,
    required this.type,
    required this.offerId,
    required this.dateStr,
    required this.loc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: () => showDetailsDialog(context),
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.brown.shade200.withValues(alpha: 0.2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: Theme.of(context).brightness == Brightness.dark
                  ? [Colors.brown.shade800, Colors.brown.shade700]
                  : [Colors.brown.shade100, Colors.brown.shade200],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.brown.shade800.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              // Animated glowing icon
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 1200),
                tween: Tween(begin: 0.8, end: 1.2),
                curve: Curves.easeInOut,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.brown.shade400.withValues(alpha: 0.3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.brown.shade400.withValues(alpha: 0.6),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        Icons.notifications_active_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.isEmpty ? loc.notifications_noTitle : title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.brown.shade50
                            : Colors.brown.shade800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      body,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.brown.shade200
                            : Colors.brown.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Arrow with fade animation
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  key: ValueKey(index),
                  size: 18,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.brown.shade100
                      : Colors.brown.shade800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.brown.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (image.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          image,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, _, __) => const SizedBox(),
                        ),
                      ),
                    const SizedBox(height: 10),
                    Text(
                      title.isEmpty ? loc.notifications_noTitle : title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                        color: Colors.brown.shade800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      body,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.brown.shade700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildInfoRow(context, loc.notifications_topic, topic),
                    buildInfoRow(context, loc.notifications_type, type),
                    buildInfoRow(context, loc.notifications_offer, offerId),
                    if (dateStr.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          dateStr,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.brown.shade400,
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          loc.Close,
                          style: TextStyle(
                            color: Colors.brown.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Widget buildInfoRow(BuildContext context, String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        '$label: $value',
        style: TextStyle(color: Colors.brown.shade500, fontSize: 13.sp),
      ),
    );
  }
}
