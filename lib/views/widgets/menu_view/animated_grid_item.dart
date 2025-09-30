import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedGridItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const AnimatedGridItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  State<AnimatedGridItem> createState() => _AnimatedGridItemState();
}

class _AnimatedGridItemState extends State<AnimatedGridItem> {
  double _scale = 1.0;

  void _shrink() => setState(() => _scale = 0.95);

  void _reset() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 150),
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: widget.onTap,
        onHighlightChanged: (isPressed) {
          if (isPressed) {
            _shrink();
          } else {
            _reset();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            gradient: LinearGradient(
              colors: [Colors.brown.shade700, Colors.brown.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.brown.shade200,
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(2, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                bottom: -30,
                child: Icon(
                  widget.icon,
                  size: 100.sp,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.2),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Icon(
                        widget.icon,
                        size: 36.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
