import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'models/app_complaints_model.dart';

class AppComplaintCard extends StatefulWidget {
  final AppComplaintsModel complaint;

  const AppComplaintCard({super.key, required this.complaint});

  @override
  State<AppComplaintCard> createState() => _AppComplaintCardState();
}

class _AppComplaintCardState extends State<AppComplaintCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatTimestamp(DateTime? dateTime) {
    if (dateTime == null) return "";
    try {
      return DateFormat('dd MMM yyyy • hh:mm a').format(dateTime);
    } catch (_) {
      return "";
    }
  }

  Color _avatarColorFromName(String name) {
    final int hash = name.hashCode;
    final List<Color> palette = [
      Colors.orangeAccent,
      Colors.teal,
      Colors.indigoAccent,
      Colors.purpleAccent,
      Colors.green,
      Colors.redAccent,
      Colors.blueAccent,
    ];
    return palette[hash % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final complaint = widget.complaint;
    final name = complaint.name.isNotEmpty ? complaint.name : 'Anonymous';
    final phone = complaint.phone;
    final message = complaint.message;
    final timestamp = complaint.timestamp;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: GestureDetector(
          onTapDown: (_) => _controller.reverse(), // subtle press animation
          onTapUp: (_) => _controller.forward(),
          onTapCancel: () => _controller.forward(),
          child: AnimatedScale(
            scale: _controller.isAnimating ? 0.98 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.h),
              padding: EdgeInsets.all(16.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 👤 Header: avatar + name + timestamp
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 22.r,
                        backgroundColor: _avatarColorFromName(name),
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : '?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                                color: Colors.brown[700],
                              ),
                            ),
                            if (timestamp != null)
                              Text(
                                _formatTimestamp(timestamp),
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12.sp,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.feedback_rounded,
                        color: Colors.brown,
                        size: 20,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // 💬 Message bubble
                  Container(
                    padding: EdgeInsets.all(12.h),
                    decoration: BoxDecoration(
                      color: Colors.brown.shade50,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Text(
                      message,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[800],
                        height: 1.4,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // ☎️ Phone
                  if (phone.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.phone_rounded,
                          size: 16.r,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          phone,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
